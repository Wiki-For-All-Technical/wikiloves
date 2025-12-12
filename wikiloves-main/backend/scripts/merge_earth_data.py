"""
Merge processed Wiki Loves Earth data from Quarry into catalog.py.

This script takes processed Earth data (from process_earth_quarry_data.py)
and integrates it into the catalog system, replacing existing Earth data.
"""

import json
import os
import sys
from typing import Dict, List

# Add parent directory to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'data'))

from data.campaigns_metadata import get_campaign_by_prefix


def load_processed_earth_data(json_path: str) -> Dict:
    """
    Load processed Earth data from JSON file.
    
    Expected format:
    {
        "campaign": "earth",
        "campaign_name": "Wiki Loves Earth",
        "years": [
            {
                "year": 2013,
                "uploads": 9655,
                "uploaders": 346,
                "images_used": 9394,
                "new_uploaders": 275,
                "countries": 1,
                "country_stats": [...]
            },
            ...
        ]
    }
    """
    with open(json_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    if data.get('campaign') != 'earth':
        print(f"⚠️  Warning: Expected campaign 'earth', got '{data.get('campaign')}'")
    
    return data


def load_catalog() -> tuple[List[Dict], List[Dict]]:
    """
    Load existing catalog.py file.
    Returns (competitions, countries) tuples.
    """
    catalog_path = os.path.join(os.path.dirname(__file__), '..', 'data', 'catalog.py')
    
    exec_globals = {}
    with open(catalog_path, 'r', encoding='utf-8') as f:
        exec(f.read(), exec_globals)
    
    competitions = exec_globals.get('COMPETITIONS', [])
    countries = exec_globals.get('COUNTRIES', [])
    
    return competitions, countries


def merge_earth_data(competitions: List[Dict], earth_data: Dict) -> List[Dict]:
    """
    Merge Earth data into competitions list.
    Replaces existing Earth competition entry or creates new one.
    """
    # Get Earth campaign metadata
    earth_meta = get_campaign_by_prefix('earth')
    if not earth_meta:
        raise ValueError("Earth campaign not found in campaigns_metadata.py")
    
    earth_slug = earth_meta['slug']  # Should be 'wiki-loves-earth'
    
    # Find existing Earth competition
    earth_comp = None
    earth_index = None
    for i, comp in enumerate(competitions):
        if comp['slug'] == earth_slug:
            earth_comp = comp
            earth_index = i
            break
    
    # Prepare new years data
    new_years = []
    for year_entry in earth_data.get('years', []):
        new_years.append({
            'year': year_entry['year'],
            'uploads': year_entry.get('uploads', 0),
            'uploaders': year_entry.get('uploaders', 0),
            'images_used': year_entry.get('images_used', 0),
            'new_uploaders': year_entry.get('new_uploaders', 0),
            'countries': year_entry.get('countries', len(year_entry.get('country_stats', []))),
            'country_stats': year_entry.get('country_stats', [])
        })
    
    # Sort by year descending
    new_years.sort(key=lambda x: x['year'], reverse=True)
    
    # Create or update Earth competition entry
    if earth_comp:
        # Update existing entry
        print(f"✓ Found existing Earth competition entry")
        print(f"  Existing years: {[y['year'] for y in earth_comp.get('years', [])]}")
        print(f"  New years: {[y['year'] for y in new_years]}")
        
        # Preserve metadata from existing entry
        earth_comp['years'] = new_years
        # Keep other fields like links, hero_image, etc.
    else:
        # Create new entry
        print(f"✓ Creating new Earth competition entry")
        earth_comp = {
            'slug': earth_slug,
            'name': earth_meta['name'],
            'short_label': earth_meta['short_label'],
            'tagline': earth_meta.get('tagline', ''),
            'accent_color': earth_meta.get('accent_color', '#1f8a70'),
            'hero_image': earth_meta.get('hero_image', ''),
            'logo': earth_meta.get('logo', ''),
            'path_segment': earth_meta.get('path_segment', 'earth'),
            'years': new_years,
            'links': {'toolforge': f"https://wikiloves.toolforge.org/{earth_meta.get('path_segment', 'earth')}"}
        }
        competitions.append(earth_comp)
        earth_index = len(competitions) - 1
    
    # Print summary
    print(f"\n✓ Earth data merged:")
    print(f"  Total years: {len(new_years)}")
    for year_entry in new_years:
        countries = year_entry.get('countries', 0)
        uploads = year_entry.get('uploads', 0)
        print(f"  - {year_entry['year']}: {countries} countries, {uploads:,} uploads")
    
    return competitions


def write_catalog(competitions: List[Dict], countries: List[Dict], output_path: str = None):
    """
    Write competitions and countries to catalog.py file.
    """
    if output_path is None:
        output_path = os.path.join(os.path.dirname(__file__), '..', 'data', 'catalog.py')
    
    # Read existing file to preserve structure/formatting if possible
    # For now, we'll write a clean version
    
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write('"""\n')
        f.write('Campaign catalog data - Updated with accurate Quarry data\n')
        f.write('This file is auto-generated by merge_earth_data.py\n')
        f.write('"""\n\n')
        f.write('COMPETITIONS = ')
        json.dump(competitions, f, indent=4, ensure_ascii=False)
        f.write('\n\n')
        f.write('COUNTRIES = ')
        json.dump(countries, f, indent=4, ensure_ascii=False)
        f.write('\n')
    
    print(f"\n✓ Catalog written to: {output_path}")


def main():
    import argparse
    
    parser = argparse.ArgumentParser(
        description="Merge processed Wiki Loves Earth data into catalog.py"
    )
    parser.add_argument(
        "input_file",
        help="Path to processed Earth JSON file (from process_earth_quarry_data.py)"
    )
    parser.add_argument(
        "--backup",
        action="store_true",
        help="Create backup of catalog.py before updating"
    )
    parser.add_argument(
        "--output",
        help="Output catalog.py path (default: backend/data/catalog.py)"
    )
    
    args = parser.parse_args()
    
    input_path = args.input_file
    if not os.path.exists(input_path):
        print(f"❌ Error: File not found: {input_path}", file=sys.stderr)
        sys.exit(1)
    
    # Load processed Earth data
    print(f"Loading processed Earth data from: {input_path}")
    earth_data = load_processed_earth_data(input_path)
    
    # Load existing catalog
    catalog_path = args.output or os.path.join(os.path.dirname(__file__), '..', 'data', 'catalog.py')
    
    if args.backup:
        backup_path = catalog_path + '.backup'
        import shutil
        shutil.copy2(catalog_path, backup_path)
        print(f"✓ Backup created: {backup_path}")
    
    print(f"Loading existing catalog from: {catalog_path}")
    competitions, countries = load_catalog()
    
    # Merge Earth data
    updated_competitions = merge_earth_data(competitions, earth_data)
    
    # Write updated catalog
    write_catalog(updated_competitions, countries, catalog_path)
    
    print("\n✅ Successfully merged Earth data into catalog!")


if __name__ == "__main__":
    main()
