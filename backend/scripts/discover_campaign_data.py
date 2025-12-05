"""
Script to discover which Wiki Loves campaigns have data in Commons.
This helps identify which campaigns need queries created.
"""

import sys
import os

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))
from data.campaigns_metadata import ALL_CAMPAIGNS

def generate_category_discovery_query():
    """
    Generate a SQL query to discover all Wiki Loves categories in Commons.
    This helps identify which campaigns have data.
    """
    query = """
-- ============================================
-- DISCOVER ALL WIKI LOVES CAMPAIGNS IN COMMONS
-- ============================================
-- Run this in Quarry to see which campaigns have categories
-- Database: commonswiki_p

SELECT DISTINCT 
    cl.cl_to AS category_name,
    COUNT(DISTINCT p.page_id) AS file_count
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves%'
    OR cl.cl_to LIKE '%WikiScience%'
    OR cl.cl_to LIKE '%WikiScience_Competition%'
  )
  AND p.page_namespace = 6
  AND p.page_is_redirect = 0
GROUP BY cl.cl_to
HAVING file_count > 0
ORDER BY file_count DESC
LIMIT 500;
"""
    return query


def generate_campaign_check_queries():
    """
    Generate queries to check each campaign for data availability.
    """
    queries = []
    
    for prefix, campaign in ALL_CAMPAIGNS.items():
        campaign_name = campaign['name']
        quarry_category = campaign.get('quarry_category', prefix)
        
        # Try different category patterns
        patterns = [
            f"Images_from_Wiki_Loves_{campaign_name.split()[-1]}_%",
            f"Wiki_Loves_{campaign_name.split()[-1]}_%",
            f"Images_from_{campaign_name.replace(' ', '_')}_%",
            f"{campaign_name.replace(' ', '_')}_%",
        ]
        
        query = f"""
-- ============================================
-- CHECK: {campaign_name} ({prefix})
-- ============================================
SELECT 
    cl.cl_to AS category_name,
    COUNT(DISTINCT p.page_id) AS file_count,
    MIN(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED)) AS earliest_year,
    MAX(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED)) AS latest_year
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
WHERE cl.cl_type = 'file'
  AND p.page_namespace = 6
  AND p.page_is_redirect = 0
  AND (
    cl.cl_to LIKE '%{quarry_category}%'
    OR cl.cl_to LIKE '%{campaign_name.replace(' ', '_')}%'
  )
  AND cl.cl_to REGEXP '[0-9]{{4}}$'
GROUP BY cl.cl_to
HAVING file_count > 0
ORDER BY file_count DESC
LIMIT 20;
"""
        queries.append((prefix, campaign_name, query))
    
    return queries


def print_discovery_guide():
    """Print a guide for discovering campaign data."""
    print("=" * 70)
    print("DISCOVERING DATA FOR REMAINING WIKI LOVES CAMPAIGNS")
    print("=" * 70)
    print()
    
    print("STEP 1: Discover Which Campaigns Have Data")
    print("-" * 70)
    print("1. Go to https://quarry.wmcloud.org")
    print("2. Select database: commonswiki_p")
    print("3. Run this discovery query:")
    print()
    print(generate_category_discovery_query())
    print()
    print("This will show ALL Wiki Loves categories that exist in Commons.")
    print()
    
    print("STEP 2: For Each Campaign, Check Data Availability")
    print("-" * 70)
    print("For campaigns you want to add, run individual check queries:")
    print()
    
    queries = generate_campaign_check_queries()
    for prefix, name, query in queries[:5]:  # Show first 5 as examples
        print(f"\n--- {name} ({prefix}) ---")
        print(query[:300] + "...")
    
    print(f"\n... and {len(queries) - 5} more campaigns")
    print()
    
    print("STEP 3: Create Multi-Year Queries")
    print("-" * 70)
    print("Once you find a campaign has data:")
    print("1. Note the category name pattern (e.g., 'Images_from_Wiki_Loves_Fashion_2024')")
    print("2. Use the template from quarry_multiyear_all_campaigns.sql")
    print("3. Replace the category pattern and date ranges")
    print("4. Run in Quarry and download as JSON")
    print("5. Process: python backend/scripts/process_multiyear_quarry.py <file.json> <prefix>")
    print()
    
    print("STEP 4: Quick Reference - Campaigns Already Processed")
    print("-" * 70)
    processed = ["monuments", "earth", "africa", "folklore", "science", "public_art"]
    for prefix in processed:
        if prefix in ALL_CAMPAIGNS:
            print(f"✓ {ALL_CAMPAIGNS[prefix]['name']}")
    print()
    
    print("STEP 5: Remaining Campaigns to Check")
    print("-" * 70)
    remaining = [p for p in ALL_CAMPAIGNS.keys() if p not in processed]
    for prefix in sorted(remaining):
        campaign = ALL_CAMPAIGNS[prefix]
        print(f"  - {campaign['name']} (prefix: {prefix})")
    print()


if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] == "--queries":
        # Output all check queries to a file
        queries = generate_campaign_check_queries()
        output_file = os.path.join(os.path.dirname(__file__), '..', 'queries', 'campaign_discovery_queries.sql')
        
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write("-- ============================================\n")
            f.write("-- CAMPAIGN DATA DISCOVERY QUERIES\n")
            f.write("-- ============================================\n")
            f.write("-- Run these queries in Quarry to check which campaigns have data\n")
            f.write("-- Database: commonswiki_p\n\n")
            
            for prefix, name, query in queries:
                f.write(query)
                f.write("\n\n")
        
        print(f"✅ Generated {len(queries)} discovery queries in {output_file}")
    else:
        print_discovery_guide()







