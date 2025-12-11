"""
Analyze the category discovery JSON to identify main campaign categories.
This helps create queries for the actual categories that exist.
"""

import json
import re
from collections import defaultdict

def analyze_categories(json_file):
    """Analyze category names to identify main campaigns."""
    with open(json_file, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    categories = [row[0] for row in data.get('rows', [])]
    
    # Group by campaign type
    campaigns = defaultdict(list)
    
    # Pattern matching for main campaigns
    patterns = {
        'monuments': r'Wiki_Loves_Monuments.*2024',
        'earth': r'Wiki_Loves_Earth.*2024',
        'africa': r'Wiki_Loves_Africa.*2024',
        'folklore': r'Wiki_Loves_Folklore.*2024',
        'science': r'Wiki.*Science.*2024',
        'public_art': r'Wiki_Loves_Public_Art.*2024',
        'food': r'Wiki_Loves_Food.*2024',
        'birds': r'Wiki_Loves_Birds.*2024',
        'fashion': r'Wiki_Loves_Fashion.*2024',
        'sport': r'Wiki_Loves_Sport.*2024',
        'heritage': r'Wiki_Loves_Heritage.*2024',
        'schools': r'Wiki_Loves_Schools.*2024',
        'onam': r'Wiki_Loves_Onam.*2024',
        'pride': r'Wiki_Loves_Pride.*2024',
        'film': r'Wiki_Loves_Film.*2024',
    }
    
    # Find main category for each
    main_categories = {}
    
    for cat in categories:
        # Skip subcategories (those with "in_" or specific locations)
        if '_in_' in cat or cat.count('_') > 5:
            continue
        
        # Look for main campaign categories
        for campaign, pattern in patterns.items():
            if re.search(pattern, cat, re.IGNORECASE):
                # Prefer "Images_from_" prefix
                if 'Images_from_' in cat and campaign not in main_categories:
                    main_categories[campaign] = cat
                elif campaign not in main_categories:
                    main_categories[campaign] = cat
                campaigns[campaign].append(cat)
                break
    
    # Print results
    print("=" * 80)
    print("MAIN CAMPAIGN CATEGORIES (Use these in queries)")
    print("=" * 80)
    print()
    
    for campaign, main_cat in sorted(main_categories.items()):
        print(f"{campaign.upper()}:")
        print(f"  Main Category: {main_cat}")
        print(f"  Total related categories: {len(campaigns[campaign])}")
        print()
    
    print("=" * 80)
    print("ALL MAIN CATEGORIES (Copy-paste ready)")
    print("=" * 80)
    print()
    
    for campaign, main_cat in sorted(main_categories.items()):
        print(f"'{main_cat}',")
    
    print()
    print("=" * 80)
    print("QUERY TEMPLATE")
    print("=" * 80)
    print()
    print("-- Use this pattern for queries:")
    print("WHERE cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024'")
    print("   OR cl.cl_to = 'Images_from_Wiki_Loves_Earth_2024'")
    print("   -- etc...")
    
    return main_categories, campaigns

if __name__ == "__main__":
    import sys
    json_file = sys.argv[1] if len(sys.argv) > 1 else 'quarry-99402-untitled-run1043691.json'
    analyze_categories(json_file)







