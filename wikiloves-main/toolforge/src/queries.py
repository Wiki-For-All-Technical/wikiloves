"""
Query generation and execution system for Wiki Loves campaigns.
Loads unified queries and generates campaign-specific queries.
"""

import os
from pathlib import Path
from typing import Optional, List, Dict, Any
import sys

from config import Config
from errors import QueryGenerationError, CampaignNotFoundError
from database import get_db

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


class QueryManager:
    """Manages SQL queries for campaign data fetching."""
    
    def __init__(self):
        self.config = Config()
        self._unified_query_cache = None
    
    def get_unified_query(self) -> str:
        """
        Load the unified query for all campaigns.
        
        Returns:
            SQL query string.
        
        Raises:
            QueryGenerationError: If query file not found or cannot be read.
        """
        if self._unified_query_cache:
            return self._unified_query_cache
        
        query_file = self.config.UNIFIED_QUERY_FILE
        
        if not query_file.exists():
            raise QueryGenerationError(
                f"Unified query file not found: {query_file}"
            )
        
        try:
            with open(query_file, 'r', encoding='utf-8') as f:
                query = f.read()
            self._unified_query_cache = query
            return query
        except Exception as e:
            raise QueryGenerationError(
                f"Error reading unified query file: {str(e)}"
            ) from e
    
    def get_campaign_query(
        self,
        campaign_slug: str,
        year: Optional[int] = None
    ) -> str:
        """
        Generate a query for a specific campaign.
        
        Args:
            campaign_slug: Campaign slug (e.g., 'earth', 'monuments').
            year: Optional year filter.
        
        Returns:
            SQL query string.
        
        Raises:
            CampaignNotFoundError: If campaign not found.
            QueryGenerationError: If query cannot be generated.
        """
        campaign = get_campaign_by_prefix(campaign_slug)
        if not campaign:
            # Try to find by slug
            for key, camp in ALL_CAMPAIGNS.items():
                if camp.get('slug') == campaign_slug or camp.get('path_segment') == campaign_slug:
                    campaign = camp
                    break
        
        if not campaign:
            raise CampaignNotFoundError(f"Campaign not found: {campaign_slug}")
        
        campaign_name = campaign.get('name', '')
        quarry_category = campaign.get('quarry_category', campaign_slug)
        
        # Get date range for this campaign
        start_month, end_month = self._get_campaign_dates(campaign_slug)
        
        # Build WHERE clause for campaign
        category_patterns = [
            f"%Wiki_Loves_{campaign_name.replace(' ', '_')}%",
            f"%{quarry_category}%",
        ]
        
        # Add year filter if specified
        year_filter = ""
        if year:
            start_date = f"{year}{start_month:02d}01000000"
            end_date = f"{year}{end_month:02d}31235959"
            year_filter = f"""
                AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) = {year}
                AND i.img_timestamp >= '{start_date}'
                AND i.img_timestamp <= '{end_date}'
            """
        
        # Generate query based on unified query structure
        query = f"""
SELECT 
    '{campaign_slug}' AS campaign_slug,
    '{campaign_name}' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    CASE 
        WHEN cl.cl_to LIKE '%_in_%' THEN 
            TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(cl.cl_to, '_in_', -1), '_', 1))
        ELSE 'Global'
    END AS country,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '{start_month:02d}', '01000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '{end_month:02d}', '31235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
LEFT JOIN actor act ON a.actor_id = act.actor_id
LEFT JOIN user u ON act.actor_user = u.user_id
WHERE cl.cl_type = 'file'
  AND (
    {' OR '.join([f"cl.cl_to LIKE '{pattern}'" for pattern in category_patterns])}
  )
  AND cl.cl_to REGEXP '[0-9]{{4}}$'
  {year_filter}
GROUP BY 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED),
    CASE 
        WHEN cl.cl_to LIKE '%_in_%' THEN 
            TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(cl.cl_to, '_in_', -1), '_', 1))
        ELSE 'Global'
    END
ORDER BY year DESC, uploads DESC;
"""
        return query
    
    def get_uploader_query(
        self,
        campaign_slug: str,
        year: int,
        country: Optional[str] = None
    ) -> str:
        """
        Generate a query for uploader statistics.
        
        Args:
            campaign_slug: Campaign slug.
            year: Campaign year.
            country: Optional country filter.
        
        Returns:
            SQL query string.
        """
        campaign = get_campaign_by_prefix(campaign_slug)
        if not campaign:
            raise CampaignNotFoundError(f"Campaign not found: {campaign_slug}")
        
        campaign_name = campaign.get('name', '')
        start_month, end_month = self._get_campaign_dates(campaign_slug)
        start_date = f"{year}{start_month:02d}01000000"
        end_date = f"{year}{end_month:02d}31235959"
        
        country_filter = ""
        if country:
            country_filter = f"AND cl.cl_to LIKE '%_in_{country.replace(' ', '_')}%'"
        
        query = f"""
SELECT 
    '{campaign_slug}' AS campaign_slug,
    {year} AS year,
    CASE 
        WHEN cl.cl_to LIKE '%_in_%' THEN 
            TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(cl.cl_to, '_in_', -1), '_', 1))
        ELSE 'Global'
    END AS country,
    a.actor_name AS username,
    COUNT(DISTINCT i.img_name) AS images,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    u.user_registration AS user_registration,
    CASE 
        WHEN u.user_registration >= '{start_date}'
            AND u.user_registration <= '{end_date}'
        THEN 1
        ELSE 0
    END AS is_new_uploader
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
LEFT JOIN actor act ON a.actor_id = act.actor_id
LEFT JOIN user u ON act.actor_user = u.user_id
WHERE cl.cl_type = 'file'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) = {year}
  AND (
    cl.cl_to LIKE '%Wiki_Loves_{campaign_name.replace(' ', '_')}%'
    OR cl.cl_to LIKE '%{campaign_slug}%'
  )
  {country_filter}
GROUP BY 
    a.actor_name,
    u.user_registration,
    CASE 
        WHEN cl.cl_to LIKE '%_in_%' THEN 
            TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(cl.cl_to, '_in_', -1), '_', 1))
        ELSE 'Global'
    END
ORDER BY images DESC;
"""
        return query
    
    def _get_campaign_dates(self, campaign_slug: str) -> tuple:
        """
        Get start and end months for a campaign.
        
        Returns:
            Tuple of (start_month, end_month) where months are 1-12.
        """
        # Campaign date ranges (start_month, end_month)
        campaign_dates = {
            'africa': (3, 3),        # March
            'monuments': (9, 9),     # September
            'earth': (5, 5),         # May
            'folklore': (2, 2),      # February
            'science': (11, 11),     # November
            'food': (7, 7),          # July
            'public-art': (5, 5),    # May
            'public_art': (5, 5),    # May
            'andes': (10, 10),       # October
        }
        
        return campaign_dates.get(campaign_slug, (3, 3))  # Default to March
    
    def execute_unified_query(self, use_analytics: bool = True) -> List[Dict[str, Any]]:
        """
        Execute the unified query for all campaigns.
        
        Args:
            use_analytics: Use analytics database for long query.
        
        Returns:
            List of result dictionaries.
        """
        query = self.get_unified_query()
        db = get_db()
        return db.execute_query(query, use_analytics=use_analytics)
    
    def execute_campaign_query(
        self,
        campaign_slug: str,
        year: Optional[int] = None,
        use_analytics: bool = True
    ) -> List[Dict[str, Any]]:
        """
        Execute a campaign-specific query.
        
        Args:
            campaign_slug: Campaign slug.
            year: Optional year filter.
            use_analytics: Use analytics database.
        
        Returns:
            List of result dictionaries.
        """
        query = self.get_campaign_query(campaign_slug, year)
        db = get_db()
        return db.execute_query(query, use_analytics=use_analytics)
    
    def execute_uploader_query(
        self,
        campaign_slug: str,
        year: int,
        country: Optional[str] = None,
        use_analytics: bool = False
    ) -> List[Dict[str, Any]]:
        """
        Execute an uploader statistics query.
        
        Args:
            campaign_slug: Campaign slug.
            year: Campaign year.
            country: Optional country filter.
            use_analytics: Use analytics database.
        
        Returns:
            List of result dictionaries.
        """
        query = self.get_uploader_query(campaign_slug, year, country)
        db = get_db()
        return db.execute_query(query, use_analytics=use_analytics)


# Global query manager instance
_query_manager: Optional[QueryManager] = None


def get_query_manager() -> QueryManager:
    """Get global query manager instance."""
    global _query_manager
    if _query_manager is None:
        _query_manager = QueryManager()
    return _query_manager
