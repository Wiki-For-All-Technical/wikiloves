"""
Generate comprehensive Quarry queries for Wiki Loves Earth campaign.
This script creates SQL queries that can be run directly on https://quarry.wmcloud.org
"""

import argparse
from typing import Optional

# Wiki Loves Earth runs from May 1 to May 31 each year
EARTH_START_MONTH = "05"
EARTH_START_DAY = "01"
EARTH_END_MONTH = "05"
EARTH_END_DAY = "31"


def generate_category_discovery_query() -> str:
    """
    Generate a query to discover all Wiki Loves Earth categories.
    This should be run first to see what categories actually exist.
    """
    return """-- ============================================
-- WIKI LOVES EARTH - CATEGORY DISCOVERY
-- ============================================
-- Run this query first to discover all available categories
-- Database: commonswiki_p
-- 
-- This will show you all category names that contain "Wiki Loves Earth"
-- Copy this into Quarry: https://quarry.wmcloud.org

SELECT DISTINCT 
    cl.cl_to AS category_name,
    COUNT(DISTINCT cl.cl_from) AS file_count
FROM categorylinks cl
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves_Earth%'
    OR cl.cl_to LIKE '%Wiki_Loves_Earth_%'
    OR cl.cl_to LIKE '%Images_from_Wiki_Loves_Earth%'
    OR cl.cl_to LIKE 'Wiki_Loves_Earth_%'
  )
GROUP BY cl.cl_to
ORDER BY cl.cl_to;
"""


def generate_year_summary_query(year: int) -> str:
    """
    Generate a query to get summary statistics for a specific year.
    Returns totals across all countries.
    """
    start_date = f"{year}{EARTH_START_MONTH}{EARTH_START_DAY}000000"
    end_date = f"{year}{EARTH_END_MONTH}{EARTH_END_DAY}235959"
    
    return f"""-- ============================================
-- WIKI LOVES EARTH {year} - YEAR SUMMARY
-- ============================================
-- Gets overall statistics for {year}
-- Database: commonswiki_p
-- Date Range: {year}-{EARTH_START_MONTH}-{EARTH_START_DAY} to {year}-{EARTH_END_MONTH}-{EARTH_END_DAY}
--
-- Copy this into Quarry: https://quarry.wmcloud.org

SELECT 
    {year} AS year,
    'Global' AS country,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= '{start_date}'
            AND u.user_registration <= '{end_date}'
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
    cl.cl_to LIKE 'Images_from_Wiki_Loves_Earth_{year}%'
    OR cl.cl_to LIKE 'Wiki_Loves_Earth_{year}%'
    OR cl.cl_to = 'Images_from_Wiki_Loves_Earth_{year}'
  );
"""


def generate_country_statistics_query(year: Optional[int] = None) -> str:
    """
    Generate a query to get statistics by country for one year or all years.
    If year is None, returns all years (2013-2025).
    """
    if year:
        year_filter = f"= {year}"
        year_extract = str(year)
    else:
        year_filter = "BETWEEN 2013 AND 2025"
        year_extract = """CAST(SUBSTRING_INDEX(
        CASE 
            WHEN cl.cl_to LIKE '%_in_%' THEN
                SUBSTRING_INDEX(cl.cl_to, '_in_', 1)
            ELSE cl.cl_to
        END, '_', -1) AS UNSIGNED)"""
    
    return f"""-- ============================================
-- WIKI LOVES EARTH - COUNTRY STATISTICS
-- ============================================
-- Gets statistics broken down by country and year
-- Database: commonswiki_p
{"-- Year: " + str(year) if year else "-- Years: 2013-2025 (all years)"}
--
-- Copy this into Quarry: https://quarry.wmcloud.org

SELECT 
    {year_extract if not year else str(year)} AS year,
    CASE 
        WHEN cl.cl_to LIKE '%_in_%' THEN
            REPLACE(SUBSTRING_INDEX(cl.cl_to, '_in_', -1), '_', ' ')
        ELSE 'Global'
    END AS country,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT({year_extract if not year else str(year)}, '0501000000')
            AND u.user_registration <= CONCAT({year_extract if not year else str(year)}, '0531235959')
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
    cl.cl_to LIKE 'Images_from_Wiki_Loves_Earth_%'
    OR cl.cl_to LIKE 'Wiki_Loves_Earth_%'
  )
  AND CAST(SUBSTRING_INDEX(
    CASE 
        WHEN cl.cl_to LIKE '%_in_%' THEN
            SUBSTRING_INDEX(cl.cl_to, '_in_', 1)
        ELSE cl.cl_to
    END, '_', -1) AS UNSIGNED) {year_filter}
GROUP BY year, country
ORDER BY year DESC, uploads DESC;
"""


def generate_uploader_statistics_query(year: int, country: Optional[str] = None, category: Optional[str] = None) -> str:
    """
    Generate a query to get uploader statistics.
    
    Args:
        year: Campaign year
        country: Optional country name (if None, gets all countries)
        category: Optional exact category name (most specific)
    """
    start_date = f"{year}{EARTH_START_MONTH}{EARTH_START_DAY}000000"
    end_date = f"{year}{EARTH_END_MONTH}{EARTH_END_DAY}235959"
    
    # Build WHERE clause
    where_conditions = [
        "cl.cl_type = 'file'"
    ]
    
    if category:
        # Use exact category if provided
        where_conditions.append(f"cl.cl_to = '{category}'")
    elif country:
        # Use country-specific pattern
        country_slug = country.replace(' ', '_')
        where_conditions.append(f"(cl.cl_to LIKE 'Images_from_Wiki_Loves_Earth_{year}%_in_{country_slug}%' OR cl.cl_to LIKE 'Wiki_Loves_Earth_{year}%_in_{country_slug}%')")
    else:
        # All categories for this year
        where_conditions.append(f"(cl.cl_to LIKE 'Images_from_Wiki_Loves_Earth_{year}%' OR cl.cl_to LIKE 'Wiki_Loves_Earth_{year}%')")
    
    where_clause = " AND ".join(where_conditions)
    
    return f"""-- ============================================
-- WIKI LOVES EARTH {year} - UPLOADER STATISTICS
-- ============================================
-- Gets detailed uploader statistics
-- Database: commonswiki_p
-- Year: {year}
{"-- Country: " + country if country else "-- All Countries"}
{"-- Category: " + category if category else ""}
-- Date Range: {year}-{EARTH_START_MONTH}-{EARTH_START_DAY} to {year}-{EARTH_END_MONTH}-{EARTH_END_DAY}
--
-- Copy this into Quarry: https://quarry.wmcloud.org

SELECT 
    a.actor_name AS username,
    a.actor_user AS user_id,
    COUNT(DISTINCT i.img_name) AS files,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    MIN(LEFT(i.img_timestamp, 8)) AS first_upload_date,
    MAX(LEFT(i.img_timestamp, 8)) AS last_upload_date,
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
WHERE {where_clause}
GROUP BY a.actor_name, a.actor_user, is_new_uploader
ORDER BY files DESC;
"""


def generate_detailed_files_query(year: int, category: str) -> str:
    """
    Generate a query to get detailed file information for a specific category.
    This matches the query shown in the user's images.
    """
    return f"""-- ============================================
-- WIKI LOVES EARTH {year} - DETAILED FILES
-- ============================================
-- Gets detailed file information with upload dates
-- Database: commonswiki_p
-- Category: {category}
--
-- Copy this into Quarry: https://quarry.wmcloud.org

SELECT 
    cl.cl_from,
    cl.cl_to,
    p.page_title AS File,
    LEFT(i.img_timestamp, 8) AS imgdate,
    i.img_timestamp,
    i.img_size,
    a.actor_name
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title 
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
  AND cl.cl_to = '{category}'
ORDER BY i.img_timestamp DESC;
"""


def main():
    parser = argparse.ArgumentParser(
        description="Generate Quarry queries for Wiki Loves Earth campaign"
    )
    parser.add_argument(
        "query_type",
        choices=["discover", "summary", "countries", "uploaders", "files"],
        help="Type of query to generate"
    )
    parser.add_argument(
        "--year",
        type=int,
        help="Campaign year (2013-2025). Required for summary, uploaders, and files queries."
    )
    parser.add_argument(
        "--country",
        type=str,
        help="Country name (optional, for uploaders query)"
    )
    parser.add_argument(
        "--category",
        type=str,
        help="Exact category name (for uploaders or files query)"
    )
    parser.add_argument(
        "--output",
        type=str,
        help="Output file path (default: print to stdout)"
    )
    
    args = parser.parse_args()
    
    try:
        if args.query_type == "discover":
            query = generate_category_discovery_query()
        elif args.query_type == "summary":
            if not args.year:
                parser.error("--year is required for summary query")
            query = generate_year_summary_query(args.year)
        elif args.query_type == "countries":
            query = generate_country_statistics_query(args.year)
        elif args.query_type == "uploaders":
            if not args.year:
                parser.error("--year is required for uploaders query")
            query = generate_uploader_statistics_query(args.year, args.country, args.category)
        elif args.query_type == "files":
            if not args.year or not args.category:
                parser.error("--year and --category are required for files query")
            query = generate_detailed_files_query(args.year, args.category)
        
        if args.output:
            with open(args.output, 'w', encoding='utf-8') as f:
                f.write(query)
            print(f"Query saved to: {args.output}")
        else:
            print(query)
            
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    import sys
    main()

