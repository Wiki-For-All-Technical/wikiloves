"""
Process comprehensive uploader data from Quarry that includes ALL years and ALL countries for a campaign.

This script processes a single JSON file containing uploader data for all years/countries
and organizes it into the storage structure for easy retrieval by year/country.
"""

import json
import os
import sys
from typing import Dict, List, Optional
from collections import defaultdict
from pathlib import Path

# Add parent directories to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

# Directory to store processed uploader data
UPLOADER_DATA_DIR = os.path.join(os.path.dirname(__file__), '..', '..', 'quarry_data', 'uploaders')


def ensure_uploader_dir():
    """Ensure the uploader data directory exists."""
    os.makedirs(UPLOADER_DATA_DIR, exist_ok=True)


def convert_quarry_format(data: Dict) -> List[Dict]:
    """
    Convert Quarry export format to our expected format.
    
    Quarry format: {"meta": {...}, "headers": [...], "rows": [[...], [...]]}
    Our format: [{"year": ..., "country": ..., "username": ..., ...}, ...]
    """
    if isinstance(data, list):
        # Already in array format
        return data
    
    if 'rows' in data and 'headers' in data:
        headers = data['headers']
        rows = data['rows']
        
        converted = []
        for row in rows:
            obj = {}
            for i, header in enumerate(headers):
                if i < len(row):
                    obj[header] = row[i]
            converted.append(obj)
        return converted
    
    return []


def normalize_field_names(row: Dict) -> Dict:
    """Normalize field names from various possible formats."""
    normalized = {}
    
    # Year
    normalized['year'] = int(row.get('year', 0) or 0)
    
    # Country
    normalized['country'] = row.get('country', 'Global') or 'Global'
    
    # Username (handle various field names)
    username = (row.get('username') or row.get('user') or 
                row.get('actor_name') or row.get('uploader') or '')
    normalized['username'] = username
    
    # Images
    normalized['images'] = int(row.get('images', 0) or row.get('uploads', 0) or 0)
    
    # Images used
    normalized['images_used'] = int(row.get('images_used', 0) or 0)
    
    # Registration
    normalized['registration'] = (row.get('registration') or 
                                  row.get('registration_date') or 
                                  row.get('reg') or '')
    
    return normalized


def process_all_uploaders_file(input_path: str, campaign_slug: str) -> bool:
    """
    Process a comprehensive uploader JSON file and organize by year/country.
    
    Args:
        input_path: Path to Quarry JSON export file
        campaign_slug: Campaign slug (e.g., 'earth')
    
    Returns:
        True if successful, False otherwise
    """
    ensure_uploader_dir()
    
    if not os.path.exists(input_path):
        print(f"❌ Error: File not found: {input_path}")
        return False
    
    try:
        with open(input_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
    except Exception as e:
        print(f"❌ Error reading JSON file: {e}")
        return False
    
    # Convert Quarry format
    rows = convert_quarry_format(data)
    
    if not rows:
        print(f"⚠️  Warning: No data found in {input_path}")
        return False
    
    print(f"📊 Processing {len(rows)} uploader records...")
    
    # Organize data by year and country
    organized_data = defaultdict(lambda: defaultdict(list))
    
    for row in rows:
        normalized = normalize_field_names(row)
        
        year = normalized['year']
        country = normalized['country']
        username = normalized['username']
        
        if not year or not username:
            continue
        
        # Skip 'Global' entries (we want country-specific data)
        if country == 'Global':
            continue
        
        # Create uploader entry
        uploader_entry = {
            'username': username,
            'images': normalized['images'],
            'images_used': normalized['images_used'],
            'registration': normalized['registration']
        }
        
        organized_data[year][country].append(uploader_entry)
    
    # Process and save each year/country combination
    total_files = 0
    total_uploaders = 0
    
    for year, countries in organized_data.items():
        for country, uploaders in countries.items():
            if not uploaders:
                continue
            
            # Sort by images count (descending)
            uploaders.sort(key=lambda x: x['images'], reverse=True)
            
            # Create output filename
            safe_country = country.replace(' ', '_').replace('/', '_')
            output_filename = f"{campaign_slug}_{year}_{safe_country}_users.json"
            output_path = os.path.join(UPLOADER_DATA_DIR, output_filename)
            
            # Save processed data
            with open(output_path, 'w', encoding='utf-8') as f:
                json.dump(uploaders, f, indent=2, ensure_ascii=False)
            
            total_files += 1
            total_uploaders += len(uploaders)
            print(f"  ✓ {year} / {country}: {len(uploaders)} uploaders → {output_filename}")
    
    print(f"\n✅ Processed {total_files} year/country combinations")
    print(f"   Total uploaders: {total_uploaders}")
    print(f"   Data saved to: {UPLOADER_DATA_DIR}")
    
    return True


def generate_query_for_campaign(campaign_slug: str) -> Optional[str]:
    """
    Generate the comprehensive query for a campaign.
    
    Args:
        campaign_slug: Campaign slug or path_segment (e.g., 'earth', 'wiki-loves-earth')
    
    Returns:
        SQL query string or None if campaign not found
    """
    try:
        import sys
        import os
        data_path = os.path.join(os.path.dirname(__file__), '..', 'data')
        if data_path not in sys.path:
            sys.path.insert(0, data_path)
        
        from campaigns_metadata import get_campaign_by_slug, get_campaign_by_prefix, get_all_campaigns
        from queries.quarry_templates import generate_all_uploaders_query
        
        # Try to find campaign by slug first, then by prefix/path_segment
        campaign = get_campaign_by_slug(campaign_slug)
        
        if not campaign:
            # Try as prefix (e.g., 'earth' instead of 'wiki-loves-earth')
            campaign = get_campaign_by_prefix(campaign_slug)
        
        if not campaign:
            # Try to find by path_segment
            all_campaigns = get_all_campaigns()
            for camp in all_campaigns:
                if camp.get('path_segment') == campaign_slug or camp.get('slug') == campaign_slug:
                    campaign = camp
                    break
        
        if not campaign:
            print(f"❌ Error: Campaign '{campaign_slug}' not found")
            print("Available campaigns:")
            all_campaigns = get_all_campaigns()
            for camp in all_campaigns[:10]:  # Show first 10
                print(f"  - {camp.get('path_segment')} ({camp.get('slug')})")
            return None
        
        # Use path_segment as the slug for query generation (matches catalog structure)
        query_slug = campaign.get('path_segment') or campaign_slug
        quarry_category = campaign.get('quarry_category') or query_slug
        
        query = generate_all_uploaders_query(
            campaign_name=campaign['name'],
            campaign_slug=query_slug,
            quarry_category=quarry_category
        )
        
        return query
    except ImportError as e:
        print(f"❌ Error importing modules: {e}")
        import traceback
        traceback.print_exc()
        return None


if __name__ == "__main__":
    import argparse
    
    parser = argparse.ArgumentParser(
        description="Process comprehensive uploader data for a campaign (all years, all countries)"
    )
    parser.add_argument(
        "input_file",
        nargs='?',
        help="Path to Quarry JSON export file (optional if using --generate-query)"
    )
    parser.add_argument(
        "campaign_slug",
        nargs='?',
        help="Campaign slug (e.g., 'earth') - required if processing file"
    )
    parser.add_argument(
        "--generate-query",
        metavar="CAMPAIGN_SLUG",
        help="Generate query for a campaign instead of processing data"
    )
    parser.add_argument(
        "--output-query",
        help="Save generated query to file (optional)"
    )
    
    args = parser.parse_args()
    
    if args.generate_query:
        query = generate_query_for_campaign(args.generate_query)
        if query:
            if args.output_query:
                with open(args.output_query, 'w', encoding='utf-8') as f:
                    f.write(query)
                print(f"✓ Query saved to: {args.output_query}")
            else:
                print(query)
        sys.exit(0 if query else 1)
    
    if not args.input_file or not args.campaign_slug:
        parser.print_help()
        print("\nExamples:")
        print("  # Generate query for a campaign:")
        print("  python process_all_uploaders.py --generate-query earth")
        print("  python process_all_uploaders.py --generate-query earth --output-query earth_uploaders_query.sql")
        print("\n  # Process downloaded data:")
        print("  python process_all_uploaders.py earth_all_uploaders.json earth")
        sys.exit(1)
    
    success = process_all_uploaders_file(args.input_file, args.campaign_slug)
    sys.exit(0 if success else 1)

