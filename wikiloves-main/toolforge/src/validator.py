"""
Data validation module for comparing processed data with existing data.
"""

import json
from typing import Dict, List, Optional, Any
from pathlib import Path
import sys

from logger import get_logger
from errors import ValidationError

# Add backend to path
sys.path.insert(0, str(Path(__file__).parent.parent.parent / 'backend'))
try:
    from data.catalog import COMPETITIONS
except ImportError:
    COMPETITIONS = []


class DataValidator:
    """Validates processed data against existing catalog data."""
    
    def __init__(self):
        self.logger = get_logger('validator')
    
    def compare_with_existing(
        self,
        processed_data: Dict[str, Any],
        campaign_slug: str
    ) -> Dict[str, Any]:
        """
        Compare processed data with existing catalog data.
        
        Args:
            processed_data: Newly processed campaign data.
            campaign_slug: Campaign slug.
        
        Returns:
            Dictionary with comparison results.
        """
        # Find existing campaign in catalog
        existing_campaign = None
        for comp in COMPETITIONS:
            if comp.get('slug') == campaign_slug:
                existing_campaign = comp
                break
        
        if not existing_campaign:
            self.logger.info(f'No existing data found for {campaign_slug}')
            return {
                'has_existing': False,
                'differences': [],
                'warnings': []
            }
        
        existing_years = {y.get('year'): y for y in existing_campaign.get('years', [])}
        processed_years = {y.get('year'): y for y in processed_data.get('years', [])}
        
        differences = []
        warnings = []
        
        # Compare each year
        all_years = set(existing_years.keys()) | set(processed_years.keys())
        
        for year in sorted(all_years, reverse=True):
            existing_year = existing_years.get(year)
            processed_year = processed_years.get(year)
            
            if not existing_year:
                warnings.append(f'Year {year}: New year found in processed data')
                continue
            
            if not processed_year:
                warnings.append(f'Year {year}: Missing in processed data')
                continue
            
            # Compare statistics
            for field in ['uploads', 'uploaders', 'images_used', 'new_uploaders']:
                existing_val = existing_year.get(field, 0)
                processed_val = processed_year.get(field, 0)
                
                if existing_val != processed_val:
                    diff_pct = abs(existing_val - processed_val) / existing_val * 100 if existing_val > 0 else 0
                    differences.append({
                        'year': year,
                        'field': field,
                        'existing': existing_val,
                        'processed': processed_val,
                        'difference': processed_val - existing_val,
                        'difference_pct': round(diff_pct, 2)
                    })
            
            # Compare country counts
            existing_countries = existing_year.get('countries', 0)
            processed_countries = processed_year.get('countries', 0)
            
            if existing_countries != processed_countries:
                warnings.append(
                    f'Year {year}: Country count mismatch '
                    f'(existing: {existing_countries}, processed: {processed_countries})'
                )
        
        return {
            'has_existing': True,
            'differences': differences,
            'warnings': warnings,
            'summary': {
                'total_differences': len(differences),
                'total_warnings': len(warnings),
                'years_compared': len(all_years)
            }
        }
    
    def validate_statistics_consistency(
        self,
        processed_data: Dict[str, Any]
    ) -> List[str]:
        """
        Validate that statistics are internally consistent.
        
        Args:
            processed_data: Processed campaign data.
        
        Returns:
            List of consistency errors.
        """
        errors = []
        
        for year_data in processed_data.get('years', []):
            year = year_data.get('year')
            
            # Check that images_used <= uploads
            uploads = year_data.get('uploads', 0)
            images_used = year_data.get('images_used', 0)
            if images_used > uploads:
                errors.append(
                    f'Year {year}: images_used ({images_used}) > uploads ({uploads})'
                )
            
            # Check that new_uploaders <= uploaders
            uploaders = year_data.get('uploaders', 0)
            new_uploaders = year_data.get('new_uploaders', 0)
            if new_uploaders > uploaders:
                errors.append(
                    f'Year {year}: new_uploaders ({new_uploaders}) > uploaders ({uploaders})'
                )
            
            # Check country stats consistency
            country_stats = year_data.get('country_stats', [])
            country_uploads_sum = sum(c.get('uploads', 0) for c in country_stats)
            
            # Allow some tolerance (country stats may not sum exactly due to deduplication)
            if country_uploads_sum > uploads * 1.1:  # 10% tolerance
                errors.append(
                    f'Year {year}: Country uploads sum ({country_uploads_sum}) '
                    f'significantly exceeds total uploads ({uploads})'
                )
        
        return errors
    
    def check_missing_years_countries(
        self,
        processed_data: Dict[str, Any],
        expected_years: Optional[List[int]] = None
    ) -> Dict[str, Any]:
        """
        Check for missing years or countries.
        
        Args:
            processed_data: Processed campaign data.
            expected_years: Optional list of expected years.
        
        Returns:
            Dictionary with missing items.
        """
        result = {
            'missing_years': [],
            'years_with_no_countries': [],
            'warnings': []
        }
        
        processed_years = {y.get('year') for y in processed_data.get('years', [])}
        
        if expected_years:
            missing_years = set(expected_years) - processed_years
            result['missing_years'] = sorted(missing_years)
        
        # Check for years with no country data
        for year_data in processed_data.get('years', []):
            year = year_data.get('year')
            countries = year_data.get('countries', 0)
            
            if countries == 0:
                result['years_with_no_countries'].append(year)
                result['warnings'].append(
                    f'Year {year}: No country data found'
                )
        
        return result


# Global validator instance
_validator_instance: Optional[DataValidator] = None


def get_validator() -> DataValidator:
    """Get global validator instance."""
    global _validator_instance
    if _validator_instance is None:
        _validator_instance = DataValidator()
    return _validator_instance
