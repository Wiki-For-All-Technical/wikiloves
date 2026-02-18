"""
Generate year-wise SQL queries for Wiki Loves Earth campaign.
This script creates separate query files for each year (2013-2025) with countries ordered alphabetically (A-Z).
Each query matches the data structure shown on wikiloves.toolforge.org.
"""

import os
from pathlib import Path


def generate_year_country_query(year: int) -> str:
    """
    Generate a query to get country statistics for a specific year.
    Countries are ordered alphabetically (A-Z) to match toolforge.org structure.
    
    Args:
        year: Campaign year (e.g., 2013)
    
    Returns:
        SQL query string ready to paste into Quarry
    """
    return f"""-- ============================================
-- WIKI LOVES EARTH {year} - COUNTRY STATISTICS
-- ============================================
-- Gets statistics broken down by country for year {year}
-- Countries ordered alphabetically (A-Z)
-- Database: commonswiki_p
-- Year: {year}
--
-- Copy this into Quarry: https://quarry.wmcloud.org
--
-- This query matches the data structure shown on:
-- https://wikiloves.toolforge.org/earth/{year}

SELECT 
    {year} AS year,
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
        WHEN u.user_registration >= CONCAT({year}, '0501000000')
            AND u.user_registration <= CONCAT({year}, '0531235959')
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
    END, '_', -1) AS UNSIGNED) = {year}
GROUP BY year, country
ORDER BY country ASC;
"""


def generate_all_year_queries(output_dir: str = None):
    """
    Generate separate SQL query files for each year from 2013 to 2025.
    
    Args:
        output_dir: Directory to save query files (defaults to script directory)
    """
    if output_dir is None:
        # Default to the same directory as this script
        output_dir = Path(__file__).parent
    
    output_dir = Path(output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)
    
    years = range(2013, 2026)  # 2013 to 2025 inclusive
    
    print(f"Generating year-wise queries for Wiki Loves Earth...")
    print(f"Output directory: {output_dir}")
    print()
    
    for year in years:
        query = generate_year_country_query(year)
        filename = f"earth_{year}_countries.sql"
        filepath = output_dir / filename
        
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(query)
        
        print(f"Generated: {filename}")
    
    print()
    print(f"Successfully generated {len(years)} query files!")
    print(f"Each query filters for a specific year and orders countries alphabetically (A-Z).")


def main():
    """Main entry point for the script."""
    import argparse
    
    parser = argparse.ArgumentParser(
        description="Generate year-wise SQL queries for Wiki Loves Earth campaign"
    )
    parser.add_argument(
        "--output-dir",
        type=str,
        default=None,
        help="Directory to save query files (defaults to script directory)"
    )
    
    args = parser.parse_args()
    generate_all_year_queries(args.output_dir)


if __name__ == "__main__":
    main()
