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


# Template for getting uploader statistics by country
UPLOADER_STATS_TEMPLATE = """
-- Wiki Loves {campaign_name} - Uploader Statistics for {year} in {country}
-- Returns list of uploaders with their upload counts, images used, and registration dates
-- Database: commonswiki_p
-- 
-- This query extracts:
-- - Uploader username
-- - Number of images uploaded
-- - Number of images used in wikis
-- - User registration date

SELECT 
    a.actor_name AS username,
    COUNT(DISTINCT i.img_name) AS images,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM imagelinks il 
            WHERE il.il_from = p.page_id
        ) THEN i.img_name 
    END) AS images_used,
    DATE_FORMAT(u.user_registration, '%Y-%m-%d') AS registration
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title 
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
WHERE cl.cl_type = 'file'
  AND cl.cl_to = 'Images_from_Wiki_Loves_{campaign_name}_{year}_in_{country}'
GROUP BY a.actor_name, u.user_registration
ORDER BY images DESC;
"""

def generate_all_uploaders_query(campaign_name: str, campaign_slug: str, quarry_category: str = None) -> str:
    """
    Generate a comprehensive Quarry query to get ALL uploader data for ALL years and ALL countries for a campaign.
    This is much more efficient than individual queries per country/year.
    
    Args:
        campaign_name: Full campaign name (e.g., "Wiki Loves Earth")
        campaign_slug: Campaign slug/path_segment (e.g., "earth")
        quarry_category: Optional category name for Quarry (e.g., "earth", "monuments")
    
    Returns:
        SQL query string ready to paste into Quarry
    """
    if not quarry_category:
        quarry_category = campaign_slug
    
    campaign_category = campaign_name.replace(' ', '_')
    category_capitalized = quarry_category.capitalize()
    
    query = f"""-- {campaign_name} - ALL Uploader Statistics (All Years, All Countries)
-- Copy this query into Quarry: https://quarry.wmcloud.org
-- Database: commonswiki_p
-- 
-- Campaign: {campaign_name}
-- This query fetches uploader data for ALL years and ALL countries in one go
--
-- IMPORTANT: This query may take 10-30 minutes depending on campaign size
-- After completion, download as JSON and process with:
-- python backend/scripts/process_all_uploaders.py <file.json> {campaign_slug}
--
-- Category discovery query (run this first to verify patterns):
-- SELECT DISTINCT cl.cl_to 
-- FROM categorylinks cl 
-- WHERE cl.cl_type = 'file' 
--   AND (cl.cl_to LIKE '%{campaign_category}%' OR cl.cl_to LIKE '%Wiki_Loves_{category_capitalized}%')
--   AND cl.cl_to REGEXP '[0-9]{{4}}$'
-- ORDER BY cl.cl_to;

SELECT 
    CAST(SUBSTRING_INDEX(
        CASE 
            WHEN cl.cl_to LIKE '%_in_%' THEN
                SUBSTRING_INDEX(cl.cl_to, '_in_', 1)
            ELSE cl.cl_to
        END, '_', -1) AS UNSIGNED) AS year,
    CASE 
        WHEN cl.cl_to LIKE '%_in_%' THEN
            REPLACE(SUBSTRING_INDEX(cl.cl_to, '_in_', -1), '_', ' ')
        ELSE 'Global'
    END AS country,
    a.actor_name AS username,
    COUNT(DISTINCT i.img_name) AS images,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM imagelinks il 
            WHERE il.il_from = p.page_id
        ) THEN i.img_name 
    END) AS images_used,
    DATE_FORMAT(u.user_registration, '%Y-%m-%d') AS registration
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title 
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE 'Images_from_{campaign_category}_%'
    OR cl.cl_to LIKE 'Images_from_Wiki_Loves_{category_capitalized}_%'
    OR cl.cl_to LIKE 'Wiki_Loves_{category_capitalized}_%'
  )
  AND cl.cl_to REGEXP '[0-9]{{4}}$'
  AND CAST(SUBSTRING_INDEX(
    CASE 
        WHEN cl.cl_to LIKE '%_in_%' THEN
            SUBSTRING_INDEX(cl.cl_to, '_in_', 1)
        ELSE cl.cl_to
    END, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year, country, a.actor_name, u.user_registration
ORDER BY year DESC, country, images DESC;

-- Export this as JSON with filename: {campaign_slug}_all_uploaders.json
-- Expected output: Array of objects with year, country, username, images, images_used, registration
"""
    
    return query


def generate_uploader_query(campaign_name: str, campaign_slug: str, year: int, country: str, start_date: str = None, end_date: str = None) -> str:
    """
    Generate a Quarry query to get uploader statistics for a specific campaign, year, and country.
    
    Args:
        campaign_name: Full campaign name (e.g., "Wiki Loves Earth")
        campaign_slug: Campaign slug (e.g., "earth")
        year: Campaign year (e.g., 2024)
        country: Country name (e.g., "Albania")
        start_date: Start date in YYYYMMDDHHMMSS format (optional)
        end_date: End date in YYYYMMDDHHMMSS format (optional)
    
    Returns:
        SQL query string ready to paste into Quarry
    """
    # Format campaign name for category (replace spaces with underscores)
    campaign_category = campaign_name.replace(' ', '_')
    
    # Common category patterns
    category_patterns = [
        f"Images_from_{campaign_category}_{year}_in_{country.replace(' ', '_')}",
        f"Images_from_Wiki_Loves_{campaign_slug.capitalize()}_{year}_in_{country.replace(' ', '_')}",
        f"Images_from_{campaign_category}_{year}_in_{country}",
    ]
    
    # Build WHERE clause with multiple category patterns
    category_conditions = " OR\n".join([f"  cl.cl_to = '{pattern}'" for pattern in category_patterns])
    
    query = f"""-- {campaign_name} - Uploader Statistics for {year} in {country}
-- Copy this query into Quarry: https://quarry.wmcloud.org
-- Database: commonswiki_p
-- 
-- Campaign: {campaign_name}
-- Year: {year}
-- Country: {country}
--
-- IMPORTANT: First run a category discovery query to find the exact category name!
-- Then replace the category patterns below with the actual category.
--
-- Category discovery query:
-- SELECT DISTINCT cl.cl_to 
-- FROM categorylinks cl 
-- WHERE cl.cl_type = 'file' 
--   AND cl.cl_to LIKE '%{campaign_category}%{year}%{country}%'
-- ORDER BY cl.cl_to;

SELECT 
    a.actor_name AS username,
    COUNT(DISTINCT i.img_name) AS images,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM imagelinks il 
            WHERE il.il_from = p.page_id
        ) THEN i.img_name 
    END) AS images_used,
    DATE_FORMAT(u.user_registration, '%Y-%m-%d') AS registration
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title 
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
WHERE cl.cl_type = 'file'
  AND (
{category_conditions}
  )
GROUP BY a.actor_name, u.user_registration
ORDER BY images DESC;

-- Export this as JSON with filename: {campaign_slug}_{year}_{country}_users.json
"""
    
    return query

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

