"""
Quarry SQL query templates for extracting Wiki Loves campaign statistics.
These queries can be run on https://quarry.wmcloud.org to extract data from Wikimedia databases.

Each query template is parameterized and can be customized for specific campaigns and years.
"""

# Template for getting upload statistics by country for a campaign
UPLOAD_STATS_BY_COUNTRY = """
-- Wiki Loves {campaign_name} - Upload Statistics by Country for {year}
-- This query extracts upload counts, uploader counts, and usage statistics
-- grouped by country for a specific campaign year.

SELECT 
    CASE 
        WHEN user_registration IS NOT NULL 
            AND user_registration >= '{start_date}' 
            AND user_registration <= '{end_date}'
        THEN 1 
        ELSE 0 
    END AS new_uploader,
    COUNT(*) AS uploads,
    COUNT(DISTINCT img_user_text) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN img_user_text IN (
            SELECT DISTINCT img_user_text 
            FROM commonswiki_p.image 
            WHERE img_timestamp >= '{start_date}' 
            AND img_timestamp <= '{end_date}'
            AND img_name LIKE '%{campaign_category}%'
        ) THEN img_user_text 
    END) AS images_used
FROM commonswiki_p.image img
LEFT JOIN commonswiki_p.user ON img.img_user = user.user_id
WHERE img.img_timestamp >= '{start_date}'
  AND img.img_timestamp <= '{end_date}'
  AND (
    img.img_name LIKE '%{campaign_category}%'
    OR img.img_description LIKE '%{campaign_category}%'
    OR EXISTS (
        SELECT 1 
        FROM commonswiki_p.categorylinks 
        WHERE cl_from = img.img_id 
        AND cl_to LIKE '%{campaign_category}%'
    )
  )
GROUP BY 
    CASE 
        WHEN user_registration IS NOT NULL 
            AND user_registration >= '{start_date}' 
            AND user_registration <= '{end_date}'
        THEN 1 
        ELSE 0 
    END
ORDER BY uploads DESC
"""

# Template for getting country-level statistics
COUNTRY_STATS_TEMPLATE = """
-- Wiki Loves {campaign_name} - Country Statistics for {year}
-- Extracts detailed statistics per country including uploads, uploaders, and usage

SELECT 
    COALESCE(
        (SELECT user_registration 
         FROM commonswiki_p.user 
         WHERE user.user_id = img.img_user),
        img.img_timestamp
    ) AS user_registration,
    COUNT(*) AS uploads,
    COUNT(DISTINCT img.img_user_text) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM commonswiki_p.imagelinks 
            WHERE il_from = img.img_id
        ) THEN img.img_id 
    END) AS images_used
FROM commonswiki_p.image img
LEFT JOIN commonswiki_p.user ON img.img_user = user.user_id
WHERE img.img_timestamp >= '{start_date}'
  AND img.img_timestamp <= '{end_date}'
  AND (
    img.img_name LIKE '%{campaign_category}%'
    OR img.img_description LIKE '%{campaign_category}%'
    OR EXISTS (
        SELECT 1 
        FROM commonswiki_p.categorylinks 
        WHERE cl_from = img.img_id 
        AND cl_to LIKE '%{campaign_category}%'
    )
  )
GROUP BY user_registration
ORDER BY uploads DESC
"""

# Template for getting overall campaign statistics
CAMPAIGN_OVERVIEW_TEMPLATE = """
-- Wiki Loves {campaign_name} - Overall Statistics for {year}
-- Returns total uploads, uploaders, countries, and usage statistics

SELECT 
    COUNT(*) AS total_uploads,
    COUNT(DISTINCT img.img_user_text) AS total_uploaders,
    COUNT(DISTINCT CASE 
        WHEN user.user_registration >= '{start_date}' 
            AND user.user_registration <= '{end_date}'
        THEN img.img_user_text 
    END) AS new_uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM commonswiki_p.imagelinks 
            WHERE il_from = img.img_id
        ) THEN img.img_id 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN img.img_name LIKE '%{campaign_category}%' 
            OR img.img_description LIKE '%{campaign_category}%'
        THEN img.img_id 
    END) AS categorized_images
FROM commonswiki_p.image img
LEFT JOIN commonswiki_p.user ON img.img_user = user.user_id
WHERE img.img_timestamp >= '{start_date}'
  AND img.img_timestamp <= '{end_date}'
  AND (
    img.img_name LIKE '%{campaign_category}%'
    OR img.img_description LIKE '%{campaign_category}%'
    OR EXISTS (
        SELECT 1 
        FROM commonswiki_p.categorylinks 
        WHERE cl_from = img.img_id 
        AND cl_to LIKE '%{campaign_category}%'
    )
  )
"""

# Template for getting upload trends over time
UPLOAD_TREND_TEMPLATE = """
-- Wiki Loves {campaign_name} - Upload Trend Analysis
-- Returns monthly upload counts for trend visualization

SELECT 
    DATE_FORMAT(img.img_timestamp, '%Y-%m') AS month,
    COUNT(*) AS uploads,
    COUNT(DISTINCT img.img_user_text) AS uploaders
FROM commonswiki_p.image img
WHERE img.img_timestamp >= '{start_date}'
  AND img.img_timestamp <= '{end_date}'
  AND (
    img.img_name LIKE '%{campaign_category}%'
    OR img.img_description LIKE '%{campaign_category}%'
    OR EXISTS (
        SELECT 1 
        FROM commonswiki_p.categorylinks 
        WHERE cl_from = img.img_id 
        AND cl_to LIKE '%{campaign_category}%'
    )
  )
GROUP BY DATE_FORMAT(img.img_timestamp, '%Y-%m')
ORDER BY month ASC
"""

# Template for category-based queries (more accurate for some campaigns)
CATEGORY_BASED_QUERY = """
-- Wiki Loves {campaign_name} - Category-Based Statistics for {year}
-- Uses Commons categories for more accurate campaign identification

SELECT 
    COUNT(*) AS uploads,
    COUNT(DISTINCT img.img_user_text) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN user.user_registration >= '{start_date}' 
            AND user.user_registration <= '{end_date}'
        THEN img.img_user_text 
    END) AS new_uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM commonswiki_p.imagelinks 
            WHERE il_from = img.img_id
        ) THEN img.img_id 
    END) AS images_used
FROM commonswiki_p.image img
INNER JOIN commonswiki_p.categorylinks cl ON img.img_id = cl.cl_from
LEFT JOIN commonswiki_p.user ON img.img_user = user.user_id
WHERE img.img_timestamp >= '{start_date}'
  AND img.img_timestamp <= '{end_date}'
  AND cl.cl_to IN (
    'Images_from_Wiki_Loves_{campaign_category}_{year}',
    'Images_from_{campaign_category}_{year}',
    'Wiki_Loves_{campaign_category}_{year}',
    '{campaign_category}_{year}'
  )
GROUP BY img.img_user_text
"""


def format_query(template: str, campaign_name: str, campaign_category: str, 
                 year: int, start_date: str = None, end_date: str = None) -> str:
    """
    Format a query template with campaign-specific parameters.
    
    Args:
        template: The SQL query template
        campaign_name: Full campaign name (e.g., "Wiki Loves Earth")
        campaign_category: Campaign category/prefix (e.g., "earth", "monuments")
        year: Campaign year
        start_date: Start date in YYYYMMDDHHMMSS format (defaults to year start)
        end_date: End date in YYYYMMDDHHMMSS format (defaults to year end)
    
    Returns:
        Formatted SQL query string
    """
    if start_date is None:
        start_date = f"{year}0101000000"
    if end_date is None:
        end_date = f"{year}1231235959"
    
    return template.format(
        campaign_name=campaign_name,
        campaign_category=campaign_category,
        year=year,
        start_date=start_date,
        end_date=end_date
    )


def get_campaign_dates(campaign_category: str, year: int) -> tuple:
    """
    Get start and end dates for a campaign.
    Different campaigns may have different date ranges.
    
    Returns:
        Tuple of (start_date, end_date) in YYYYMMDDHHMMSS format
    """
    # Default: full year
    start_date = f"{year}0101000000"
    end_date = f"{year}1231235959"
    
    # Campaign-specific date ranges can be added here
    # For example, some campaigns run for specific months
    campaign_date_ranges = {
        "monuments": (f"{year}0901000000", f"{year}0930235959"),  # September
        "earth": (f"{year}0501000000", f"{year}0531235959"),  # May
        "africa": (f"{year}0301000000", f"{year}0331235959"),  # March
        # Add more as needed
    }
    
    if campaign_category in campaign_date_ranges:
        return campaign_date_ranges[campaign_category]
    
    return (start_date, end_date)


# Example usage queries for common campaigns
EXAMPLE_QUERIES = {
    "monuments_2024": format_query(
        CATEGORY_BASED_QUERY,
        "Wiki Loves Monuments",
        "monuments",
        2024
    ),
    "earth_2024": format_query(
        CATEGORY_BASED_QUERY,
        "Wiki Loves Earth",
        "earth",
        2024
    ),
}

