"""
Generate ready-to-use Quarry queries for specific Wiki Loves campaigns.
This script creates SQL queries that can be copied directly into Quarry.
"""

import sys
import os
import argparse

# Add paths
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))
from data.campaigns_metadata import get_campaign_by_prefix, get_all_campaigns
from queries.quarry_templates import get_campaign_dates

def generate_country_stats_query(campaign_prefix: str, year: int) -> str:
    """
    Generate a country statistics query for a specific campaign and year.
    
    Args:
        campaign_prefix: Campaign prefix (e.g., 'monuments', 'earth')
        year: Campaign year (e.g., 2024)
    
    Returns:
        SQL query string ready to paste into Quarry
    """
    campaign = get_campaign_by_prefix(campaign_prefix)
    if not campaign:
        raise ValueError(f"Unknown campaign prefix: {campaign_prefix}")
    
    # Get campaign dates
    start_date, end_date = get_campaign_dates(campaign_prefix, year)
    
    # Extract date components for SQL
    start_year = start_date[:4]
    start_month = start_date[4:6]
    start_day = start_date[6:8]
    end_year = end_date[:4]
    end_month = end_date[4:6]
    end_day = end_date[6:8]
    
    campaign_name = campaign["name"]
    campaign_slug = campaign["slug"]
    
    # Common category patterns
    category_patterns = [
        f"Images_from_{campaign_name.replace(' ', '_')}_{year}",
        f"Images_from_Wiki_Loves_{campaign_prefix.capitalize()}_{year}",
        f"Wiki_Loves_{campaign_prefix.capitalize()}_{year}",
        f"{campaign_name.replace(' ', '_')}_{year}",
    ]
    
    query = f"""-- {campaign_name} - Statistics for {year}
-- Copy this query into Quarry: https://quarry.wmcloud.org
-- Database: commonswiki_p
-- 
-- Campaign: {campaign_name}
-- Year: {year}
-- Date Range: {start_year}-{start_month}-{start_day} to {end_year}-{end_month}-{end_day}
--
-- IMPORTANT: First run the category discovery query to find the exact category name!
-- Then replace 'Images_from_Wiki_Loves_Monuments_2024' below with the actual category.
--
-- Pattern: categorylinks → page → image → actor_image

SELECT 
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= '{start_date}'
            AND u.user_registration <= '{end_date}'
        THEN a.actor_name
    END) AS new_uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM imagelinks il 
            WHERE il.il_from = p.page_id
        ) THEN i.img_name 
    END) AS images_used
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title 
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN user u ON a.actor_user = u.user_id
WHERE cl.cl_type = 'file'
  AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024';
  
-- To discover the exact category name, run:
-- SELECT DISTINCT cl.cl_to FROM categorylinks cl 
-- WHERE cl.cl_type = 'file' AND cl.cl_to LIKE '%Wiki_Loves%{year}%' 
-- ORDER BY cl.cl_to;
"""
    
    # Add category patterns
    category_conditions = []
    for pattern in category_patterns:
        category_conditions.append(f"    cl.cl_to LIKE '%{pattern}%'")
    
    query += " OR\n".join(category_conditions)
    query += """
  )
GROUP BY country_indicator
ORDER BY uploads DESC;

-- Export this as CSV with filename: {campaign_prefix}_{year}.csv
-- Then process with: python backend/queries/process_quarry_results.py <export_dir>
"""
    
    return query


def generate_category_discovery_query(campaign_prefix: str, year: int) -> str:
    """Generate a query to discover available categories for a campaign."""
    campaign = get_campaign_by_prefix(campaign_prefix)
    if not campaign:
        raise ValueError(f"Unknown campaign prefix: {campaign_prefix}")
    
    query = f"""-- Discover Categories for {campaign['name']} {year}
-- Run this first to see what categories actually exist

SELECT DISTINCT cl.cl_to AS category_name
FROM categorylinks cl
WHERE (
    cl.cl_to LIKE '%Wiki_Loves%{year}%'
    OR cl.cl_to LIKE '%{campaign_prefix}%{year}%'
    OR cl.cl_to LIKE '%{campaign['name'].replace(' ', '_')}%{year}%'
)
ORDER BY cl.cl_to;
"""
    return query


def main():
    parser = argparse.ArgumentParser(
        description="Generate Quarry queries for Wiki Loves campaigns"
    )
    parser.add_argument(
        "campaign",
        help="Campaign prefix (e.g., monuments, earth, africa)"
    )
    parser.add_argument(
        "year",
        type=int,
        help="Campaign year (e.g., 2024)"
    )
    parser.add_argument(
        "--discover",
        action="store_true",
        help="Generate category discovery query instead"
    )
    parser.add_argument(
        "--output",
        help="Output file path (default: print to stdout)"
    )
    
    args = parser.parse_args()
    
    try:
        if args.discover:
            query = generate_category_discovery_query(args.campaign, args.year)
        else:
            query = generate_country_stats_query(args.campaign, args.year)
        
        if args.output:
            with open(args.output, 'w', encoding='utf-8') as f:
                f.write(query)
            print(f"Query saved to: {args.output}")
        else:
            print(query)
            
    except ValueError as e:
        print(f"Error: {e}", file=sys.stderr)
        print("\nAvailable campaigns:", file=sys.stderr)
        for camp in get_all_campaigns():
            print(f"  - {camp['path_segment']}: {camp['name']}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()

