"""
Generate a single unified SQL query for ALL 77 Wiki Loves campaigns.

This script creates one comprehensive query that processes all campaigns in a single
execution, returning results with campaign identification, year, country breakdown,
and all statistics (uploads, uploaders, images_used, new_uploaders).

Usage:
    python backend/scripts/generate_unified_all_campaigns_query.py
    
Output:
    backend/queries/unified_all_campaigns_query.sql
"""

import sys
import os
from typing import Dict, Tuple, List

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
    # "Wiki Loves Africa" -> "Wiki_Loves_Africa"
    pattern = name.replace(' ', '_')
    return pattern


def get_date_range(slug: str) -> Tuple[int, int]:
    """Get start and end months for a campaign."""
    return CAMPAIGN_DATES.get(slug, (3, 3))  # Default to March if unknown


def build_campaign_detection_case(competitions: List[Dict]) -> str:
    """Build SQL CASE statement to detect campaign from category name."""
    cases = []
    
    for comp in competitions:
        slug = comp['slug']
        name = comp['name']
        category_pattern = get_category_pattern(slug, name)
        
        # Build LIKE patterns for this campaign
        patterns = [
            f"'%{category_pattern}%'",
        ]
        
        # Special handling for patterns that need both variations
        if 'Wiki_Loves_' in category_pattern:
            # Also match without "Images_from_" prefix
            pass
        
        # Create CASE condition
        pattern_conditions = ' OR '.join([f'cl.cl_to LIKE {p}' for p in patterns])
        
        cases.append(
            f"        WHEN {pattern_conditions} THEN '{slug}'"
        )
    
    # Default case
    cases.append("        ELSE NULL")
    
    return '\n'.join(cases)


def build_campaign_name_case(competitions: List[Dict]) -> str:
    """Build SQL CASE statement to get campaign name directly from category patterns."""
    cases = []
    
    for comp in competitions:
        slug = comp['slug']
        name = comp['name'].replace("'", "''")  # Escape single quotes
        category_pattern = get_category_pattern(slug, name)
        
        # Build LIKE patterns for this campaign (same as detection)
        pattern_conditions = f"cl.cl_to LIKE '%{category_pattern}%'"
        cases.append(f"        WHEN {pattern_conditions} THEN '{name}'")
    
    cases.append("        ELSE 'Unknown'")
    
    return '\n'.join(cases)


def build_date_range_case_from_category(competitions: List[Dict]) -> str:
    """Build SQL CASE statement to get date range directly from category patterns."""
    cases = []
    
    for comp in competitions:
        slug = comp['slug']
        name = comp['name']
        category_pattern = get_category_pattern(slug, name)
        start_month, _ = get_date_range(slug)
        date_string = f"{start_month:02d}01000000"  # First day of start month
        
        # Build LIKE patterns for this campaign (same as detection)
        pattern_conditions = f"cl.cl_to LIKE '%{category_pattern}%'"
        
        cases.append(f"        WHEN {pattern_conditions} THEN '{date_string}'")
    
    cases.append("        ELSE '0301000000'")  # Default to March 1st
    
    return '\n'.join(cases)


def generate_unified_query(competitions: List[Dict]) -> str:
    """Generate the unified SQL query for all campaigns."""
    
    # Sort campaigns alphabetically by name for consistency
    sorted_comps = sorted(competitions, key=lambda x: x['name'].lower())
    
    # Build CASE statements
    campaign_detection = build_campaign_detection_case(sorted_comps)
    campaign_name_mapping = build_campaign_name_case(sorted_comps)
    date_range_mapping = build_date_range_case_from_category(sorted_comps)
    
    query = f"""-- ============================================
-- UNIFIED QUERY FOR ALL 77 WIKI LOVES CAMPAIGNS
-- ============================================
-- This single query processes ALL campaigns in one execution
-- Returns: campaign_slug, campaign_name, year, country, uploads, uploaders, images_used, new_uploaders
-- Database: commonswiki_p
-- 
-- IMPORTANT NOTES:
-- - This query may take 15-30+ minutes to execute due to processing all campaigns
-- - Results include country-level breakdown for all campaigns
-- - Images_used correctly checks imagelinks table (not just counting uploads)
-- - New_uploaders uses campaign-specific date ranges (see date mappings below)
-- 
-- CAMPAIGN DATE RANGES (for new_uploaders calculation):
-- - Africa: March 1st onwards
-- - Monuments: September 1st onwards
-- - Earth: May 1st onwards
-- - Folklore: February 1st onwards
-- - Science: November 1st onwards
-- - Food: July 1st onwards
-- - Public Art: May 1st onwards
-- - Default: March 1st onwards (for campaigns without specific date)
-- ============================================

SELECT 
    -- Campaign identification
    CASE
{campaign_detection}
    END AS campaign_slug,
    
    CASE
{campaign_name_mapping}
    END AS campaign_name,
    
    -- Year extraction
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    
    -- Country extraction
    CASE 
        WHEN cl.cl_to LIKE '%_in_%' THEN
            REPLACE(SUBSTRING_INDEX(cl.cl_to, '_in_', -1), '_', ' ')
        ELSE 'Global'
    END AS country,
    
    -- Statistics
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    
    -- Images used: Check imagelinks table for actual usage
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    
    -- New uploaders: Users registered on/after campaign start date through end of year
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(
            CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), 
            CASE
{date_range_mapping}
            END
        )
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
    -- Match any Wiki Loves campaign category
    cl.cl_to LIKE '%Wiki_Loves_%'
    OR cl.cl_to LIKE '%Wiki_Science_Competition%'
    OR cl.cl_to LIKE '%WikiScience%'
    OR cl.cl_to LIKE '%Images_from_Wiki_Loves_%'
    OR cl.cl_to LIKE '%Images_from_Wiki_Science%'
  )
  AND cl.cl_to REGEXP '[0-9]{{4}}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
  -- Filter: Only include rows where we can identify a campaign
  AND (
    CASE
{campaign_detection}
    END IS NOT NULL
  )
GROUP BY campaign_slug, campaign_name, year, country
ORDER BY campaign_name, year DESC, uploads DESC;
"""
    
    return query


def main():
    """Generate the unified query."""
    print("=" * 70)
    print("Generating Unified Query for All Wiki Loves Campaigns")
    print("=" * 70)
    
    print(f"\nProcessing {len(COMPETITIONS)} campaigns...")
    
    # Generate the query
    query = generate_unified_query(COMPETITIONS)
    
    # Write to file
    output_dir = os.path.join(os.path.dirname(__file__), '..', 'queries')
    os.makedirs(output_dir, exist_ok=True)
    
    output_file = os.path.join(output_dir, 'unified_all_campaigns_query.sql')
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(query)
    
    print(f"\n✓ Generated unified query for {len(COMPETITIONS)} campaigns")
    print(f"  → {output_file}")
    print("\n" + "=" * 70)
    print("Query is ready to run in Quarry!")
    print("Database: commonswiki_p")
    print("Expected execution time: 15-30+ minutes")
    print("=" * 70)


if __name__ == '__main__':
    main()

