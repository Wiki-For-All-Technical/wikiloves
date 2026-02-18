"""
Generate SQL queries A-Z for ALL Wiki Loves campaigns with correct date ranges.
This script reads from catalog.py and generates comprehensive queries that can be
run in Quarry to get accurate data for all campaigns.

Usage:
    python backend/scripts/generate_all_campaigns_queries_a_to_z.py
    
Output:
    backend/queries/all_campaigns_queries_a_to_z.sql
"""

import sys
import os
import re
from typing import Dict, Tuple, Optional

# Add backend to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

from data.catalog import COMPETITIONS

# Campaign date ranges - when competitions typically run
# Format: (start_month, end_month) where month is 1-12
# "new_uploaders" = users registered on/after start_month through end of year
CAMPAIGN_DATES = {
    'africa': (3, 3),        # March (Feb-March competition, count from March 1st)
    'monuments': (9, 9),     # September
    'earth': (5, 5),         # May
    'folklore': (2, 2),      # February
    'science': (11, 11),     # November-December
    'food': (7, 7),          # July-August
    'public-art': (5, 5),    # May-June
    'andes': (10, 10),       # October
    'birds': (4, 4),         # April
    'film': (5, 5),          # May
    # Add more campaigns as needed - defaults to March if not specified
}

# Category pattern mappings for campaigns with special naming
CATEGORY_PATTERNS = {
    'science': 'Wiki_Science_Competition',
    'public-art': 'Wiki_Loves_Public_Art',
    'public_art': 'Wiki_Loves_Public_Art',
}


def get_category_pattern(slug: str, name: str) -> str:
    """Get the category pattern for a campaign."""
    if slug in CATEGORY_PATTERNS:
        return CATEGORY_PATTERNS[slug]
    
    # Default: convert name to category pattern
    # "Wiki Loves Africa" -> "Wiki_Loves_Africa"
    pattern = name.replace(' ', '_')
    return pattern


def get_date_range(slug: str) -> Tuple[int, int]:
    """Get start and end months for a campaign."""
    return CAMPAIGN_DATES.get(slug, (3, 3))  # Default to March if unknown


def format_date(year: int, month: int, day: int = 1, hour: int = 0, minute: int = 0, second: int = 0) -> str:
    """Format date as YYYYMMDDHHMMSS string."""
    return f"{year:04d}{month:02d}{day:02d}{hour:02d}{minute:02d}{second:02d}"


def generate_multiyear_query(campaign: Dict, index: int) -> str:
    """Generate a multiyear query for a campaign."""
    slug = campaign['slug']
    name = campaign['name']
    category_pattern = get_category_pattern(slug, name)
    start_month, end_month = get_date_range(slug)
    
    # For "uploaders registered after competition start", count from start_month through end of year
    start_date_month = start_month
    end_date_month = 12
    end_date_day = 31
    
    query = f"""-- ============================================
-- {index}. {name.upper()}
-- ============================================
-- Campaign: {name}
-- Slug: {slug}
-- Date Range: Month {start_month} (new uploaders counted from month {start_date_month} through December)
-- Comprehensive multiyear query with country breakdown
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    CASE 
        WHEN cl.cl_to LIKE '%_in_%' THEN
            REPLACE(SUBSTRING_INDEX(cl.cl_to, '_in_', -1), '_', ' ')
        ELSE 'Global'
    END AS country,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after {start_month}/1 of competition year (through end of year)
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '{start_date_month:02d}01000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%{category_pattern}%'
  )
  AND cl.cl_to REGEXP '[0-9]{{4}}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year, country
ORDER BY year DESC, uploads DESC;

"""
    return query


def generate_summary_query(campaign: Dict, index: int) -> str:
    """Generate a year-only summary query for a campaign."""
    slug = campaign['slug']
    name = campaign['name']
    category_pattern = get_category_pattern(slug, name)
    start_month, end_month = get_date_range(slug)
    start_date_month = start_month
    
    query = f"""-- ============================================
-- {index}. {name.upper()} - YEAR SUMMARY
-- ============================================
-- Campaign: {name}
-- Slug: {slug}
-- Date Range: Month {start_month}
-- Year totals only (no country breakdown)
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        -- Users registered on or after {start_month}/1 of competition year
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '{start_date_month:02d}01000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%{category_pattern}%'
  )
  AND cl.cl_to REGEXP '[0-9]{{4}}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;

"""
    return query


def main():
    """Generate all queries."""
    print("=" * 70)
    print("Generating A-Z Queries for All Wiki Loves Campaigns")
    print("=" * 70)
    
    # Sort campaigns alphabetically by name
    sorted_campaigns = sorted(COMPETITIONS, key=lambda x: x['name'].lower())
    
    # Generate queries
    multiyear_queries = []
    summary_queries = []
    
    for i, campaign in enumerate(sorted_campaigns, 1):
        print(f"  [{i:3d}] {campaign['name']} ({campaign['slug']})")
        multiyear_queries.append(generate_multiyear_query(campaign, i))
        summary_queries.append(generate_summary_query(campaign, i))
    
    # Write multiyear queries file
    output_dir = os.path.join(os.path.dirname(__file__), '..', 'queries')
    os.makedirs(output_dir, exist_ok=True)
    
    multiyear_file = os.path.join(output_dir, 'all_campaigns_queries_a_to_z.sql')
    with open(multiyear_file, 'w', encoding='utf-8') as f:
        f.write("""-- ============================================
-- ALL WIKI LOVES CAMPAIGNS - COMPREHENSIVE QUERIES A-Z
-- ============================================
-- This file contains detailed statistics queries for ALL Wiki Loves campaigns
-- Each query returns: year, country, uploads, uploaders, images_used, new_uploaders
-- Queries are sorted alphabetically by campaign name
-- Database: commonswiki_p
-- 
-- USAGE:
-- 1. Find the query for your campaign (search by name or Ctrl+F)
-- 2. Copy the entire query (from '-- ============================================' to 'ORDER BY year DESC, uploads DESC;')
-- 3. Run in Quarry (https://quarry.wmcloud.org/)
--    - Select database: commonswiki_p
--    - Paste query and click "Run" (may take several minutes for large campaigns)
-- 4. Download results as JSON
-- 5. Process with: python backend/scripts/process_quarry_results.py <file.json>
-- ============================================

""")
        f.write('\n'.join(multiyear_queries))
        f.write(f"""
-- ============================================
-- SUMMARY
-- ============================================
-- Total campaigns: {len(sorted_campaigns)}
-- Generated: {len(multiyear_queries)} queries
-- Sorted: Alphabetically by campaign name
-- ============================================
""")
    
    # Write summary queries file
    summary_file = os.path.join(output_dir, 'all_campaigns_summary_queries_a_to_z.sql')
    with open(summary_file, 'w', encoding='utf-8') as f:
        f.write("""-- ============================================
-- ALL WIKI LOVES CAMPAIGNS - SUMMARY QUERIES A-Z
-- ============================================
-- This file contains YEAR-ONLY summary queries (no country breakdown)
-- Each query returns: year, uploads, uploaders, images_used, new_uploaders
-- Queries are sorted alphabetically by campaign name
-- Database: commonswiki_p
-- 
-- USAGE: Same as comprehensive queries, but returns year totals only
-- ============================================

""")
        f.write('\n'.join(summary_queries))
        f.write(f"""
-- ============================================
-- SUMMARY
-- ============================================
-- Total campaigns: {len(sorted_campaigns)}
-- Generated: {len(summary_queries)} queries
-- ============================================
""")
    
    print(f"\n✓ Generated {len(multiyear_queries)} comprehensive queries")
    print(f"  → {multiyear_file}")
    print(f"\n✓ Generated {len(summary_queries)} summary queries")
    print(f"  → {summary_file}")
    print("\n" + "=" * 70)
    print("Done! You can now run these queries in Quarry.")
    print("=" * 70)


if __name__ == '__main__':
    main()






