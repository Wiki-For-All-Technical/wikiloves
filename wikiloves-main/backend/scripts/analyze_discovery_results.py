"""
Analyze the discovery query results to identify campaigns with data.
"""

import json
import re
from collections import defaultdict
import sys
import os

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))
from data.campaigns_metadata import ALL_CAMPAIGNS

def extract_campaign_from_category(category_name):
    """Extract campaign name and year from category name."""
    # Patterns to match
    patterns = [
        r'Images_from_Wiki_Loves_([^_]+)_(\d{4})',
        r'Wiki_Loves_([^_]+)_(\d{4})',
        r'Images_from_Wiki_Loves_([^_]+)_in_',
        r'Wiki_Loves_([^_]+)_in_',
    ]
    
    for pattern in patterns:
        match = re.search(pattern, category_name)
        if match:
            campaign_part = match.group(1).lower()
            year = match.group(2) if len(match.groups()) > 1 and match.group(2).isdigit() else None
            
            # Map to known campaigns
            campaign_map = {
                'monuments': 'monuments',
                'earth': 'earth',
                'africa': 'africa',
                'folklore': 'folklore',
                'food': 'food',
                'love': 'love',
                'public': 'public_art',
                'butterfly': 'butterfly',
                'birds': 'birds',
                'cultural': 'heritage',
            }
            
            # Try direct match first
            if campaign_part in campaign_map:
                return campaign_map[campaign_part], year
            
            # Try partial match
            for key, value in campaign_map.items():
                if key in campaign_part:
                    return value, year
            
            return campaign_part, year
    
    return None, None

def analyze_discovery_json(json_file):
    """Analyze discovery query results."""
    with open(json_file, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    categories = data.get('rows', [])
    
    # Group by campaign
    campaigns = defaultdict(lambda: {
        'categories': [],
        'years': set(),
        'total_files': 0,
        'main_categories': []
    })
    
    # Process each category
    for row in categories:
        category_name = row[0]
        file_count = row[1]
        
        # Skip maintenance/quality/check categories
        if any(skip in category_name.lower() for skip in ['missing_sdc', 'to_check', 'maintenance', 'quality', 'quantity', 'reviewed', 'unreviewed', 'not_for_prejury', 'without_categories']):
            continue
        
        campaign, year = extract_campaign_from_category(category_name)
        
        if campaign:
            campaigns[campaign]['categories'].append({
                'name': category_name,
                'files': file_count,
                'year': year
            })
            campaigns[campaign]['total_files'] += file_count
            if year:
                campaigns[campaign]['years'].add(int(year))
            
            # Identify main category (year-only, not country-specific)
            if year and not any(x in category_name for x in ['_in_', '_by_', 'uploaded_via', 'webapp']):
                campaigns[campaign]['main_categories'].append({
                    'name': category_name,
                    'files': file_count,
                    'year': int(year)
                })
    
    # Sort main categories by year
    for campaign in campaigns.values():
        campaign['main_categories'].sort(key=lambda x: x['year'], reverse=True)
        campaign['years'] = sorted(campaign['years'], reverse=True)
    
    return campaigns

def print_analysis(campaigns):
    """Print analysis results."""
    print("=" * 80)
    print("DISCOVERY QUERY ANALYSIS - CAMPAIGNS WITH DATA")
    print("=" * 80)
    print()
    
    # Separate known vs unknown campaigns
    known_campaigns = {}
    unknown_campaigns = {}
    
    for campaign_key, data in campaigns.items():
        if campaign_key in ALL_CAMPAIGNS:
            known_campaigns[campaign_key] = data
        else:
            unknown_campaigns[campaign_key] = data
    
    print("✅ KNOWN CAMPAIGNS WITH DATA")
    print("-" * 80)
    print()
    
    # Sort by total files
    sorted_known = sorted(known_campaigns.items(), key=lambda x: x[1]['total_files'], reverse=True)
    
    for campaign_key, data in sorted_known:
        campaign = ALL_CAMPAIGNS[campaign_key]
        print(f"📊 {campaign['name']} ({campaign_key})")
        print(f"   Total files: {data['total_files']:,}")
        print(f"   Years found: {', '.join(map(str, data['years']))}")
        print(f"   Main categories: {len(data['main_categories'])}")
        
        # Show top 5 main categories
        if data['main_categories']:
            print("   Top categories:")
            for cat in data['main_categories'][:5]:
                print(f"      - {cat['name']} ({cat['files']:,} files, {cat['year']})")
        print()
    
    print()
    print("⚠️  UNKNOWN/NEW CAMPAIGNS FOUND")
    print("-" * 80)
    print()
    
    sorted_unknown = sorted(unknown_campaigns.items(), key=lambda x: x[1]['total_files'], reverse=True)
    
    for campaign_key, data in sorted_unknown:
        print(f"📊 {campaign_key.title()}")
        print(f"   Total files: {data['total_files']:,}")
        print(f"   Years found: {', '.join(map(str, data['years']))}")
        if data['main_categories']:
            print("   Main categories:")
            for cat in data['main_categories'][:3]:
                print(f"      - {cat['name']} ({cat['files']:,} files, {cat['year']})")
        print()
    
    print()
    print("📋 NEXT STEPS")
    print("-" * 80)
    print()
    print("For campaigns with data:")
    print("1. Create multi-year query using the main category pattern")
    print("2. Run in Quarry and download as JSON")
    print("3. Process: python backend/scripts/process_multiyear_quarry.py <file> <prefix>")
    print()
    
    # Generate priority list
    print("🎯 PRIORITY CAMPAIGNS TO ADD")
    print("-" * 80)
    print()
    
    # Already processed
    processed = ['monuments', 'earth', 'africa', 'folklore', 'science', 'public_art']
    
    # Need to add
    to_add = [k for k, v in sorted_known if k not in processed and v['total_files'] > 1000]
    
    for campaign_key in to_add:
        data = known_campaigns[campaign_key]
        campaign = ALL_CAMPAIGNS[campaign_key]
        if data['main_categories']:
            main_cat = data['main_categories'][0]['name']
            print(f"  {campaign['name']} ({campaign_key})")
            print(f"    Category pattern: {main_cat.replace(str(data['main_categories'][0]['year']), '%')}")
            print(f"    Years: {min(data['years'])}-{max(data['years'])}")
            print()

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python analyze_discovery_results.py <discovery_json_file>")
        sys.exit(1)
    
    json_file = sys.argv[1]
    campaigns = analyze_discovery_json(json_file)
    print_analysis(campaigns)






