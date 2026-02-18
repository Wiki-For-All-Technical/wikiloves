"""
Data processing pipeline for Wiki Loves campaigns.
Processes raw query results into structured format for catalog integration.
"""

import json
from typing import Dict, List, Optional, Any
from collections import defaultdict
import sys
from pathlib import Path

from config import Config
from errors import ProcessingError, CampaignNotFoundError

# Import campaign metadata - check src/ directory first (Toolforge deployment), then backend
try:
    # Try importing directly from src/ directory (Toolforge deployment)
    import campaigns_metadata
    ALL_CAMPAIGNS = campaigns_metadata.ALL_CAMPAIGNS
    get_campaign_by_prefix = campaigns_metadata.get_campaign_by_prefix
except ImportError:
    try:
        # Fallback: try importing from backend/data/ (local development)
        sys.path.insert(0, str(Path(__file__).parent.parent.parent / 'backend'))
        from data.campaigns_metadata import ALL_CAMPAIGNS, get_campaign_by_prefix
    except ImportError:
        # Final fallback if metadata not available
        ALL_CAMPAIGNS = {}
        def get_campaign_by_prefix(prefix: str):
            return None


class DataProcessor:
    """Processes raw query results into structured campaign data."""
    
    def __init__(self):
        self.config = Config()
    
    def process_campaign_data(
        self,
        raw_data: List[Dict[str, Any]],
        campaign_slug: Optional[str] = None
    ) -> Dict[str, Any]:
        """
        Process raw query results into structured format.
        
        Args:
            raw_data: List of dictionaries from database query.
            campaign_slug: Optional campaign slug for single-campaign processing.
        
        Returns:
            Dictionary with processed campaign data.
        
        Raises:
            ProcessingError: If processing fails.
        """
        if not raw_data:
            raise ProcessingError("No data provided for processing")
        
        # Group data by campaign and year
        campaigns_data = defaultdict(lambda: defaultdict(lambda: {
            'year': None,
            'uploads': 0,
            'uploaders': 0,
            'images_used': 0,
            'new_uploaders': 0,
            'countries': set(),
            'country_stats': defaultdict(lambda: {
                'uploads': 0,
                'uploaders': 0,
                'images_used': 0,
                'new_uploaders': 0
            })
        }))
        
        # Process each row
        for row in raw_data:
            slug = row.get('campaign_slug') or campaign_slug
            if not slug:
                continue
            
            year = int(row.get('year', 0))
            if year == 0:
                continue
            
            country = row.get('country', '').strip()
            if not country or country.lower() in ['global', 'unknown', '']:
                country = 'Global'
            
            uploads = int(row.get('uploads', 0) or 0)
            uploaders = int(row.get('uploaders', 0) or 0)
            images_used = int(row.get('images_used', 0) or 0)
            new_uploaders = int(row.get('new_uploaders', 0) or 0)
            
            year_data = campaigns_data[slug][year]
            year_data['year'] = year
            
            if country == 'Global':
                # Global totals
                year_data['uploads'] = uploads
                year_data['uploaders'] = uploaders
                year_data['images_used'] = images_used
                year_data['new_uploaders'] = new_uploaders
            else:
                # Country-specific data
                year_data['countries'].add(country)
                country_stat = year_data['country_stats'][country]
                country_stat['uploads'] += uploads
                country_stat['uploaders'] = max(country_stat['uploaders'], uploaders)
                country_stat['images_used'] += images_used
                country_stat['new_uploaders'] = max(
                    country_stat['new_uploaders'],
                    new_uploaders
                )
        
        # Convert to final format
        result = {}
        for slug, years_dict in campaigns_data.items():
            campaign = get_campaign_by_prefix(slug)
            campaign_name = campaign.get('name', slug) if campaign else slug
            
            years_list = []
            for year, year_data in sorted(years_dict.items(), reverse=True):
                # Calculate totals if not set from Global
                if year_data['uploads'] == 0 and year_data['country_stats']:
                    year_data['uploads'] = sum(
                        c['uploads'] for c in year_data['country_stats'].values()
                    )
                    year_data['uploaders'] = sum(
                        c['uploaders'] for c in year_data['country_stats'].values()
                    )
                    year_data['images_used'] = sum(
                        c['images_used'] for c in year_data['country_stats'].values()
                    )
                    year_data['new_uploaders'] = sum(
                        c['new_uploaders'] for c in year_data['country_stats'].values()
                    )
                
                # Build country stats list
                country_stats_list = []
                for country_name, stats in year_data['country_stats'].items():
                    uploads = stats['uploads']
                    uploaders = stats['uploaders']
                    images_used = stats['images_used']
                    new_uploaders = stats['new_uploaders']
                    
                    country_stats_list.append({
                        'name': country_name,
                        'uploads': uploads,
                        'uploaders': uploaders,
                        'images_used': images_used,
                        'new_uploaders': new_uploaders,
                        'rank': 0,  # Will be set after sorting
                        'images_used_pct': round(
                            (images_used / uploads * 100) if uploads > 0 else 0, 2
                        ),
                        'new_uploaders_pct': round(
                            (new_uploaders / uploaders * 100) if uploaders > 0 else 0, 2
                        )
                    })
                
                # Sort and rank countries
                country_stats_list.sort(key=lambda x: x['uploads'], reverse=True)
                for i, stat in enumerate(country_stats_list, 1):
                    stat['rank'] = i
                
                # Calculate percentages for year totals
                uploads = year_data['uploads']
                uploaders = year_data['uploaders']
                
                years_list.append({
                    'year': year,
                    'uploads': uploads,
                    'uploaders': uploaders,
                    'images_used': year_data['images_used'],
                    'new_uploaders': year_data['new_uploaders'],
                    'countries': len(year_data['countries']),
                    'images_used_pct': round(
                        (year_data['images_used'] / uploads * 100) if uploads > 0 else 0, 2
                    ),
                    'new_uploaders_pct': round(
                        (year_data['new_uploaders'] / uploaders * 100) if uploaders > 0 else 0, 2
                    ),
                    'country_stats': country_stats_list
                })
            
            result[slug] = {
                'campaign': slug,
                'campaign_name': campaign_name,
                'years': years_list
            }
        
        return result if campaign_slug is None else result.get(campaign_slug, {})
    
    def validate_data(self, processed_data: Dict[str, Any]) -> List[str]:
        """
        Validate processed data structure and values.
        
        Args:
            processed_data: Processed campaign data.
        
        Returns:
            List of validation errors (empty if valid).
        """
        errors = []
        
        if not processed_data:
            errors.append("Processed data is empty")
            return errors
        
        # Check required fields
        required_fields = ['campaign', 'campaign_name', 'years']
        for field in required_fields:
            if field not in processed_data:
                errors.append(f"Missing required field: {field}")
        
        if 'years' not in processed_data:
            return errors
        
        # Validate each year
        for year_data in processed_data.get('years', []):
            year = year_data.get('year')
            if not year:
                errors.append("Year data missing 'year' field")
                continue
            
            # Check for negative values
            for field in ['uploads', 'uploaders', 'images_used', 'new_uploaders']:
                value = year_data.get(field, 0)
                if value < 0:
                    errors.append(f"Year {year}: {field} is negative ({value})")
            
            # Check percentages
            images_used_pct = year_data.get('images_used_pct', 0)
            if images_used_pct < 0 or images_used_pct > 100:
                errors.append(
                    f"Year {year}: images_used_pct out of range ({images_used_pct})"
                )
            
            new_uploaders_pct = year_data.get('new_uploaders_pct', 0)
            if new_uploaders_pct < 0 or new_uploaders_pct > 100:
                errors.append(
                    f"Year {year}: new_uploaders_pct out of range ({new_uploaders_pct})"
                )
            
            # Validate country stats
            for country_stat in year_data.get('country_stats', []):
                country_name = country_stat.get('name')
                if not country_name:
                    errors.append(f"Year {year}: Country stat missing name")
                
                for field in ['uploads', 'uploaders', 'images_used', 'new_uploaders']:
                    value = country_stat.get(field, 0)
                    if value < 0:
                        errors.append(
                            f"Year {year}, {country_name}: {field} is negative ({value})"
                        )
        
        return errors
    
    def aggregate_statistics(self, campaign_data: Dict[str, Any]) -> Dict[str, Any]:
        """
        Aggregate statistics across all years for a campaign.
        
        Args:
            campaign_data: Processed campaign data.
        
        Returns:
            Dictionary with aggregated statistics.
        """
        years = campaign_data.get('years', [])
        if not years:
            return {}
        
        total_uploads = sum(y.get('uploads', 0) for y in years)
        total_uploaders = sum(y.get('uploaders', 0) for y in years)
        total_images_used = sum(y.get('images_used', 0) for y in years)
        total_new_uploaders = sum(y.get('new_uploaders', 0) for y in years)
        
        # Get unique countries across all years
        all_countries = set()
        for year_data in years:
            for country_stat in year_data.get('country_stats', []):
                all_countries.add(country_stat.get('name'))
        
        return {
            'total_years': len(years),
            'total_uploads': total_uploads,
            'total_uploaders': total_uploaders,
            'total_images_used': total_images_used,
            'total_new_uploaders': total_new_uploaders,
            'unique_countries': len(all_countries),
            'years_range': {
                'start': min(y.get('year') for y in years),
                'end': max(y.get('year') for y in years)
            }
        }
    
    def save_processed_data(
        self,
        data: Dict[str, Any],
        output_path: Optional[str] = None
    ) -> str:
        """
        Save processed data to file.
        
        Args:
            data: Processed campaign data.
            output_path: Output file path (optional).
        
        Returns:
            Path to saved file.
        """
        if not output_path:
            campaign_slug = data.get('campaign', 'all')
            output_path = self.config.DATA_DIR / f'{campaign_slug}_processed.json'
        
        output_path = Path(output_path)
        output_path.parent.mkdir(parents=True, exist_ok=True)
        
        try:
            with open(output_path, 'w', encoding='utf-8') as f:
                json.dump(data, f, indent=2, ensure_ascii=False)
            return str(output_path)
        except Exception as e:
            raise ProcessingError(f"Error saving processed data: {str(e)}") from e


# Global processor instance
_processor_instance: Optional[DataProcessor] = None


def get_processor() -> DataProcessor:
    """Get global data processor instance."""
    global _processor_instance
    if _processor_instance is None:
        _processor_instance = DataProcessor()
    return _processor_instance
