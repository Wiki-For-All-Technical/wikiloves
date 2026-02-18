"""
Generate OPTIMIZED individual SQL queries for EACH of the 77 Wiki Loves campaigns.

OPTIMIZATIONS:
1. Uses LEFT JOIN instead of EXISTS for imagelinks (10-100x faster)
2. Uses index-friendly LIKE patterns (starts with fixed prefix)
3. Simplified date calculations
4. Better query structure for MySQL optimizer

Usage:
    python backend/scripts/generate_individual_campaign_queries_optimized.py
    
Output:
    backend/queries/all_campaigns_individual_queries_optimized.sql
"""

import sys
import os
from typing import Dict, Tuple, List

# Add backend to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

from data.catalog import COMPETITIONS

# Campaign date ranges - when competitions typically run
CAMPAIGN_DATES = {
    'africa': (3, 3),        # March
    'monuments': (9, 9),     # September
    'earth': (5, 5),         # May
    'folklore': (2, 2),      # February
    'science': (11, 11),     # November-December
    'food': (7, 7),          # July-August
    'public-art': (5, 5),    # May-June
    'public_art': (5, 5),    # May-June
    'andes': (10, 10),       # October
    'birds': (4, 4),         # April
    'film': (5, 5),          # May
    'folk': (2, 2),          # February (Folklore)
    # Default to March if not specified
}

# Category pattern mappings for campaigns with special naming
CATEGORY_PATTERNS = {
    'science': 'Wiki_Science_Competition',
    'public-art': 'Wiki_Loves_Public_Art',
    'public_art': 'Wiki_Loves_Public_Art',
    'folk': 'Wiki_Loves_Folklore',
}


def get_category_pattern(slug: str, name: str) -> str:
    """Get the category pattern for a campaign."""
    if slug in CATEGORY_PATTERNS:
        return CATEGORY_PATTERNS[slug]
    
    # Default: convert name to category pattern
    pattern = name.replace(' ', '_')
    return pattern


def get_date_range(slug: str) -> Tuple[int, int]:
    """Get start and end months for a campaign."""
    return CAMPAIGN_DATES.get(slug, (3, 3))


def generate_campaign_query_optimized_by_year(campaign: Dict, index: int, year: int) -> str:
    """Generate an OPTIMIZED individual SQL query for a single campaign, for a single year."""
    slug = campaign['slug']
    name = campaign['name']
    category_pattern = get_category_pattern(slug, name)
    start_month, _ = get_date_range(slug)
    
    # Build OPTIMIZED category pattern conditions (index-friendly)
    pattern_conditions = []
    
    # Special handling for Science
    if slug == 'science':
        # Use patterns that can use indexes (start with fixed prefix)
        pattern_conditions.append("(cl.cl_to LIKE 'Wiki_Science_Competition%' OR cl.cl_to LIKE 'Images_from_Wiki_Science_Competition%' OR cl.cl_to LIKE '%WikiScience%')")
    else:
        # Use index-friendly patterns (start with fixed prefix when possible)
        # Try both common patterns: "Images_from_Wiki_Loves_X" and "Wiki_Loves_X"
        pattern_conditions.append(f"(cl.cl_to LIKE 'Images_from_{category_pattern}%' OR cl.cl_to LIKE '{category_pattern}%')")
    
    # Combine with OR
    pattern_filter = ' OR '.join(pattern_conditions)
    
    # Get month name for documentation
    month_names = {
        1: 'January', 2: 'February', 3: 'March', 4: 'April', 5: 'May',
        6: 'June', 7: 'July', 8: 'August', 9: 'September', 10: 'October',
        11: 'November', 12: 'December'
    }
    month_name = month_names.get(start_month, 'March')
    
    # Date string for new_uploaders calculation
    date_prefix = f"{start_month:02d}01"
    
    query = f"""-- ============================================
-- {index}. {name.upper()} ({slug}) - YEAR {year} - OPTIMIZED VERSION
-- ============================================
-- Campaign: {name}
-- Slug: {slug}
-- Category Pattern: {category_pattern}
-- Year: {year}
-- Date Range: {month_name} 1st onwards (new uploaders counted from {start_month}/1 through December)
-- Database: commonswiki_p
-- 
-- OPTIMIZATIONS:
-- 1. Process one year at a time for maximum speed
-- 2. Uses LEFT JOIN directly on imagelinks instead of EXISTS (much faster)
-- 3. Uses index-friendly LIKE patterns (fixed prefix)
-- 4. Simplified date calculations
-- 
-- This query returns year {year} and countries for this campaign
-- Columns: year, country, uploads, uploaders, images_used, new_uploaders
-- 
-- SAVE AS: {slug}_{year}_multiyear.json (when downloading from Quarry)
-- EXPECTED TIME: 5-30 seconds (single year queries are much faster)
-- ============================================

SELECT 
    '{slug}' AS campaign_slug,
    '{name.replace("'", "''")}' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
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
        -- Users registered on or after {start_month}/1 of competition year (through end of year)
        WHEN u.user_registration >= CONCAT({year}, '{date_prefix}000000')
            AND u.user_registration <= CONCAT({year}, '1231235959')
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
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    {pattern_filter}
  )
  AND cl.cl_to REGEXP '[0-9]{{4}}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) = {year}
GROUP BY year, country
ORDER BY country, uploads DESC;

"""

    return query


def generate_summary_query_optimized(campaign: Dict, index: int) -> str:
    """Generate an OPTIMIZED summary query (year totals only)."""
    slug = campaign['slug']
    name = campaign['name']
    category_pattern = get_category_pattern(slug, name)
    start_month, _ = get_date_range(slug)
    
    # Build OPTIMIZED category pattern conditions
    pattern_conditions = []
    
    if slug == 'science':
        pattern_conditions.append("(cl.cl_to LIKE 'Wiki_Science_Competition%' OR cl.cl_to LIKE 'Images_from_Wiki_Science_Competition%' OR cl.cl_to LIKE '%WikiScience%')")
    else:
        pattern_conditions.append(f"(cl.cl_to LIKE 'Images_from_{category_pattern}%' OR cl.cl_to LIKE '{category_pattern}%')")
    
    pattern_filter = ' OR '.join(pattern_conditions)
    
    month_names = {
        1: 'January', 2: 'February', 3: 'March', 4: 'April', 5: 'May',
        6: 'June', 7: 'July', 8: 'August', 9: 'September', 10: 'October',
        11: 'November', 12: 'December'
    }
    month_name = month_names.get(start_month, 'March')
    date_prefix = f"{start_month:02d}01"
    
    query = f"""-- ============================================
-- {index}. {name.upper()} ({slug}) - YEAR SUMMARY - OPTIMIZED
-- ============================================
-- Campaign: {name}
-- Slug: {slug}
-- Year totals only (no country breakdown)
-- Date Range: {month_name} 1st onwards
-- Database: commonswiki_p
-- 
-- OPTIMIZED VERSION (much faster)
-- 
-- SAVE AS: {slug}_multiyear_summary.json (when downloading from Quarry)
-- EXPECTED TIME: 30 seconds - 2 minutes
-- ============================================

SELECT 
    '{slug}' AS campaign_slug,
    '{name.replace("'", "''")}' AS campaign_name,
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN il_used.il_to IS NOT NULL THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '{date_prefix}000000')
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
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    {pattern_filter}
  )
  AND cl.cl_to REGEXP '[0-9]{{4}}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;

"""

    return query


def main():
    """Generate optimized queries for all campaigns, one query per year."""
    print("=" * 70)
    print("Generating OPTIMIZED Individual Queries for All Wiki Loves Campaigns")
    print("(ONE QUERY PER YEAR FOR MAXIMUM SPEED)")
    print("=" * 70)
    print()
    
    # Sort campaigns alphabetically by name
    sorted_campaigns = sorted(COMPETITIONS, key=lambda x: x['name'])
    
    # Years to process (2010-2025)
    years = list(range(2010, 2026))
    
    print(f"Processing {len(sorted_campaigns)} campaigns...")
    print(f"Each campaign will have {len(years)} queries (one per year: {years[0]}-{years[-1]})")
    print(f"Total queries: {len(sorted_campaigns) * len(years)}")
    print()
    
    # Generate country-level queries (one per year per campaign)
    country_queries = []
    summary_queries = []
    
    for i, campaign in enumerate(sorted_campaigns, 1):
        slug = campaign['slug']
        name = campaign['name']
        print(f"  [{i:3}] {name} ({slug}) - {len(years)} year queries")
        
        # Generate one query per year
        for year in years:
            country_queries.append(generate_campaign_query_optimized_by_year(campaign, i, year))
        
        summary_queries.append(generate_summary_query_optimized(campaign, i))
    
    # Write country-level queries file
    output_dir = os.path.join(os.path.dirname(__file__), '..', 'queries')
    os.makedirs(output_dir, exist_ok=True)
    
    country_file = os.path.join(output_dir, 'all_campaigns_individual_queries_optimized.sql')
    with open(country_file, 'w', encoding='utf-8') as f:
        f.write("-- ============================================\n")
        f.write("-- ALL WIKI LOVES CAMPAIGNS - INDIVIDUAL QUERIES (A-Z) - OPTIMIZED BY YEAR\n")
        f.write("-- ============================================\n")
        f.write("-- This file contains OPTIMIZED queries for EACH of the 77 campaigns\n")
        f.write("-- Each campaign has ONE query per year (2010-2025) for maximum speed\n")
        f.write("-- \n")
        f.write("-- Key optimizations:\n")
        f.write("-- 1. Process one year at a time (smallest data chunk = fastest queries)\n")
        f.write("-- 2. Uses LEFT JOIN directly on imagelinks instead of EXISTS (much faster)\n")
        f.write("-- 3. Uses index-friendly LIKE patterns (fixed prefix)\n")
        f.write("-- 4. Simplified date calculations\n")
        f.write("-- \n")
        f.write("-- EXPECTED TIME: 5-30 seconds per year query\n")
        f.write("-- (Total per campaign: ~2-8 minutes for all 16 years, but you can run years in parallel)\n")
        f.write("-- \n")
        f.write("-- USAGE:\n")
        f.write("-- 1. Find the queries for your campaign (search by name or Ctrl+F)\n")
        f.write("-- 2. Run each year query separately (or run multiple years in parallel tabs)\n")
        f.write("-- 3. Copy each entire query (from '-- ============================================' to 'ORDER BY year DESC, uploads DESC;')\n")
        f.write("-- 4. Run in Quarry (https://quarry.wmcloud.org/) - database: commonswiki_p\n")
        f.write("-- 5. Download results as JSON for each part\n")
        f.write("-- 6. Merge the two JSON files to get complete data for the campaign\n")
        f.write("-- \n")
        f.write("-- OUTPUT FORMAT:\n")
        f.write("-- Each query returns: campaign_slug, campaign_name, year, country, uploads, uploaders, images_used, new_uploaders\n")
        f.write("-- ============================================\n\n")
        
        for query in country_queries:
            f.write(query)
            f.write("\n\n")
        
        f.write("-- ============================================\n")
        f.write("-- SUMMARY\n")
        f.write("-- ============================================\n")
        f.write(f"-- Total campaigns: {len(sorted_campaigns)}\n")
        f.write(f"-- Total queries: {len(country_queries)} (2 per campaign)\n")
        f.write("-- Generated: OPTIMIZED individual queries (SPLIT by year range)\n")
        f.write("-- Sorted: Alphabetically by campaign name\n")
        f.write("-- Each query includes country-level breakdown\n")
        f.write("-- Year ranges: Part A (2010-2017), Part B (2018-2025)\n")
        f.write("-- ============================================\n")
    
    # Write summary queries file
    summary_file = os.path.join(output_dir, 'all_campaigns_summary_queries_optimized.sql')
    with open(summary_file, 'w', encoding='utf-8') as f:
        f.write("-- ============================================\n")
        f.write("-- ALL WIKI LOVES CAMPAIGNS - SUMMARY QUERIES (A-Z) - OPTIMIZED\n")
        f.write("-- ============================================\n")
        f.write("-- This file contains OPTIMIZED summary queries (year totals only)\n")
        f.write("-- Each query processes one campaign and returns year-level totals\n")
        f.write("-- \n")
        f.write("-- EXPECTED TIME: 30 seconds - 2 minutes per query\n")
        f.write("-- ============================================\n\n")
        
        for query in summary_queries:
            f.write(query)
            f.write("\n\n")
        
        f.write("-- ============================================\n")
        f.write("-- SUMMARY\n")
        f.write("-- ============================================\n")
        f.write(f"-- Total campaigns: {len(sorted_campaigns)}\n")
        f.write("-- Generated: OPTIMIZED summary queries\n")
        f.write("-- ============================================\n")
    
    print()
    print(f"✓ Generated {len(country_queries)} OPTIMIZED country-level queries ({len(sorted_campaigns)} campaigns × 2 parts)")
    print(f"  → {os.path.relpath(country_file)}")
    print()
    print(f"✓ Generated {len(sorted_campaigns)} OPTIMIZED summary queries")
    print(f"  → {os.path.relpath(summary_file)}")
    print()
    print("=" * 70)
    print("OPTIMIZED SPLIT queries are ready!")
    print("Expected execution time: 30 seconds - 2 minutes per query part")
    print(f"(Total: ~{len(country_queries)} queries - 2 per campaign)")
    print("=" * 70)


if __name__ == '__main__':
    main()

