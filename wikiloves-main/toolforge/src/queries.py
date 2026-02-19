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
        year: Optional[int] = None,
        country: Optional[str] = None
    ) -> str:
        """
        Generate a query for a specific campaign.

        Args:
            campaign_slug: Campaign slug (e.g., 'earth', 'monuments').
            year: Optional year filter.
            country: Optional country filter (category names use _in_<Country> with underscores).

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

        # Add country filter if specified (category names: ..._in_Germany, ..._in_United_Arab_Emirates)
        country_filter = ""
        if country:
            country_pattern = country.replace(" ", "_")
            country_filter = f" AND cl.cl_to LIKE '%_in_{country_pattern}%'"

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
  {country_filter}
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
ORDER BY images DESC
LIMIT 500;
"""
        return query
    
    def get_quarry_uploader_query(
        self,
        category_name: str,
        campaign_slug: str,
        year: int
    ) -> str:
        """
        Quarry-style: exact category match for uploader list.
        Fast (~20 sec) because it filters to one category.
        Returns: username, images, images_used, user_registration, is_new_uploader.
        """
        campaign = get_campaign_by_prefix(campaign_slug)
        if not campaign:
            raise CampaignNotFoundError(f"Campaign not found: {campaign_slug}")
        start_month, end_month = self._get_campaign_dates(campaign_slug)
        start_date = f"{year}{start_month:02d}01000000"
        end_date = f"{year}{end_month:02d}31235959"
        cat_escaped = category_name.replace("\\", "\\\\").replace("'", "''")
        return f"""
SELECT 
    a.actor_name AS username,
    COUNT(DISTINCT i.img_name) AS images,
    COUNT(DISTINCT CASE WHEN il_used.il_to IS NOT NULL THEN i.img_name END) AS images_used,
    u.user_registration AS user_registration,
    CASE 
        WHEN u.user_registration >= '{start_date}' AND u.user_registration <= '{end_date}'
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
  AND cl.cl_to = '{cat_escaped}'
GROUP BY a.actor_name, u.user_registration
ORDER BY images DESC
LIMIT 500
"""
    
    def _get_category_prefix(self, campaign_slug: str) -> str:
        """Get Images_from_... prefix for category discovery (e.g. Images_from_Wiki_Loves_Earth_)."""
        campaign = get_campaign_by_prefix(campaign_slug)
        if not campaign:
            return f"Images_from_{campaign_slug.replace('-', '_')}_"
        name = campaign.get('name', campaign_slug)
        # Special patterns (same as generate_unified_all_campaigns_query)
        patterns = {
            'science': 'Wiki_Science_Competition',
            'public_art': 'Wiki_Loves_Public_Art',
            'public-art': 'Wiki_Loves_Public_Art',
        }
        cat_part = patterns.get(campaign_slug, name.replace(' ', '_'))
        return f"Images_from_{cat_part}_"
    
    def get_category_discovery_query(
        self,
        campaign_slug: str,
        year: int
    ) -> str:
        """
        Quarry-style: discover category names for a campaign/year.
        Returns distinct cl_to values matching Images_from_..._{year}_in_%
        Fast: uses index on cl_to with prefix LIKE.
        """
        prefix = self._get_category_prefix(campaign_slug)
        like_pattern = f"{prefix}{year}_in_%"
        # Country categories: Images_from_Wiki_Loves_Earth_2025_in_Germany
        return f"""
SELECT DISTINCT cl.cl_to AS category_name
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6
    AND p.page_is_redirect = 0
WHERE cl.cl_type = 'file'
  AND cl.cl_to LIKE '{like_pattern}'
  AND cl.cl_to NOT LIKE '%/%'
ORDER BY cl.cl_to
"""
    
    def get_quarry_category_aggregation_query(
        self,
        category_name: str,
        campaign_slug: str,
        campaign_name: str,
        year: int
    ) -> str:
        """
        Quarry-style: exact category match, single aggregation.
        Fast (~14 sec on Quarry) because it filters to one category.
        Returns: uploads, uploaders, images_used, new_uploaders.
        """
        start_month, end_month = self._get_campaign_dates(campaign_slug)
        start_date = f"{year}{start_month:02d}01000000"
        end_date = f"{year}{end_month:02d}31235959"
        # Extract country from category: Images_from_Wiki_Loves_Earth_2025_in_Germany -> Germany
        # Use REPLACE to escape single quotes in category_name for SQL
        cat_escaped = category_name.replace("\\", "\\\\").replace("'", "''")
        return f"""
SELECT 
    '{campaign_slug}' AS campaign_slug,
    '{campaign_name}' AS campaign_name,
    {year} AS year,
    REPLACE(SUBSTRING_INDEX(cl.cl_to, '_in_', -1), '_', ' ') AS country,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE WHEN il_used.il_to IS NOT NULL THEN i.img_name END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= '{start_date}' AND u.user_registration <= '{end_date}'
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
  AND cl.cl_to = '{cat_escaped}'
"""
    
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
        country: Optional[str] = None,
        use_analytics: bool = True
    ) -> List[Dict[str, Any]]:
        """
        Execute a campaign-specific query.

        Args:
            campaign_slug: Campaign slug.
            year: Optional year filter.
            country: Optional country filter.
            use_analytics: Use analytics database.

        Returns:
            List of result dictionaries.
        """
        query = self.get_campaign_query(campaign_slug, year, country)
        db = get_db()
        return db.execute_query(query, use_analytics=use_analytics)
    
    def execute_campaign_quarry_style(
        self,
        campaign_slug: str,
        use_analytics: bool = True,
        years: Optional[List[int]] = None
    ) -> List[Dict[str, Any]]:
        """
        Quarry-style: discover categories per year, then run exact-match aggregation per category.
        Each per-category query is fast (~14 sec). Avoids unified query timeout.
        
        Args:
            campaign_slug: Campaign slug.
            use_analytics: Use analytics database.
            years: Optional list of years. If None, uses recent years (e.g. 2020-2025).
        
        Returns:
            List of rows compatible with process_campaign_data (campaign_slug, year, country, uploads, uploaders, images_used, new_uploaders).
        """
        campaign = get_campaign_by_prefix(campaign_slug)
        if not campaign:
            raise CampaignNotFoundError(f"Campaign not found: {campaign_slug}")
        campaign_name = campaign.get('name', campaign_slug)
        db = get_db()
        
        if years is None:
            from datetime import datetime
            current_year = datetime.utcnow().year
            years = list(range(current_year, current_year - 6, -1))  # 2025 down to 2020
        
        all_rows = []
        for year in years:
            try:
                discovery_query = self.get_category_discovery_query(campaign_slug, year)
                discovery_results = db.execute_query(discovery_query, use_analytics=use_analytics)
            except Exception:
                continue
            for row in discovery_results:
                cat_name = row.get('category_name')
                if not cat_name:
                    continue
                try:
                    agg_query = self.get_quarry_category_aggregation_query(
                        cat_name, campaign_slug, campaign_name, year
                    )
                    agg_results = db.execute_query(agg_query, use_analytics=use_analytics)
                    if agg_results:
                        all_rows.extend(agg_results)
                except Exception:
                    continue
        return all_rows
    
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
    
    def execute_uploader_quarry_style(
        self,
        campaign_slug: str,
        year: int,
        country: str,
        use_analytics: bool = False
    ) -> List[Dict[str, Any]]:
        """
        Quarry-style: exact category match for uploaders. Fast (~20 sec).
        Constructs category name and runs get_quarry_uploader_query.
        
        Args:
            campaign_slug: Campaign slug.
            year: Campaign year.
            country: Country display name (e.g. "Germany", "the Philippines at Cebu WikiConference 2025").
            use_analytics: Use analytics DB (default False = web replica, faster for short queries).
        
        Returns:
            List of dicts with username, images, images_used, user_registration, is_new_uploader.
        """
        campaign = get_campaign_by_prefix(campaign_slug)
        if not campaign:
            raise CampaignNotFoundError(f"Campaign not found: {campaign_slug}")
        campaign_name = campaign.get('name', campaign_slug).replace(' ', '_')
        country_underscores = country.replace(' ', '_')
        category_name = f"Images_from_{campaign_name}_{year}_in_{country_underscores}"
        query = self.get_quarry_uploader_query(category_name, campaign_slug, year)
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
