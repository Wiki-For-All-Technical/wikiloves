"""
Merge processed Wiki Loves campaign data from Toolforge into catalog.py.

This script takes processed campaign data (from Toolforge processor)
and integrates it into the catalog system, replacing existing campaign data.
Supports all campaigns, not just Earth.
"""

import json
import os
import sys
from typing import Dict, List, Optional
from pathlib import Path

# Add parent directory to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'data'))

from data.campaigns_metadata import get_campaign_by_prefix, ALL_CAMPAIGNS


def load_processed_campaign_data(json_path: str) -> Dict:
    """
    Load processed campaign data from JSON file.
    
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


def merge_campaign_data(
    competitions: List[Dict],
    campaign_data: Dict,
    campaign_slug: Optional[str] = None
) -> List[Dict]:
    """
    Merge campaign data into competitions list.
    Replaces existing campaign entry or creates new one.
    
    Args:
        competitions: List of competition dictionaries.
        campaign_data: Processed campaign data dictionary.
        campaign_slug: Optional campaign slug (if not in campaign_data).
    
    Returns:
        Updated competitions list.
    """
    # Get campaign slug
    slug = campaign_slug or campaign_data.get('campaign')
    if not slug:
        raise ValueError("Campaign slug not found in data")
    
    # Get campaign metadata
    campaign_meta = get_campaign_by_prefix(slug)
    if not campaign_meta:
        # Try to find by slug
        for key, camp in ALL_CAMPAIGNS.items():
            if camp.get('slug') == slug or camp.get('path_segment') == slug:
                campaign_meta = camp
                break
    
    if not campaign_meta:
        print(f"⚠️  Warning: Campaign metadata not found for '{slug}', using data defaults")
        campaign_meta = {
            'slug': slug,
            'name': campaign_data.get('campaign_name', slug),
            'short_label': f"WL {slug.title()}",
            'tagline': '',
            'accent_color': '#000000',
            'hero_image': '',
            'logo': '',
            'path_segment': slug
        }
    
    campaign_slug_full = campaign_meta.get('slug', slug)
    
    # Find existing competition
    existing_comp = None
    existing_index = None
    for i, comp in enumerate(competitions):
        if comp.get('slug') == campaign_slug_full or comp.get('path_segment') == slug:
            existing_comp = comp
            existing_index = i
            break
    
    # Prepare new years data
    new_years = []
    for year_entry in campaign_data.get('years', []):
        new_years.append({
            'year': year_entry['year'],
            'uploads': year_entry.get('uploads', 0),
            'uploaders': year_entry.get('uploaders', 0),
            'images_used': year_entry.get('images_used', 0),
            'new_uploaders': year_entry.get('new_uploaders', 0),
            'countries': year_entry.get('countries', len(year_entry.get('country_stats', []))),
            'images_used_pct': year_entry.get('images_used_pct', 0),
            'new_uploaders_pct': year_entry.get('new_uploaders_pct', 0),
            'country_stats': year_entry.get('country_stats', [])
        })
    
    # Sort by year descending
    new_years.sort(key=lambda x: x['year'], reverse=True)
    
    # Create or update competition entry
    if existing_comp:
        # Update existing entry
        print(f"✓ Found existing {slug} competition entry")
        print(f"  Existing years: {[y['year'] for y in existing_comp.get('years', [])]}")
        print(f"  New years: {[y['year'] for y in new_years]}")
        
        # Preserve metadata from existing entry
        existing_comp['years'] = new_years
        # Keep other fields like links, hero_image, etc.
    else:
        # Create new entry
        print(f"✓ Creating new {slug} competition entry")
        existing_comp = {
            'slug': campaign_slug_full,
            'name': campaign_meta.get('name', campaign_data.get('campaign_name', slug)),
            'short_label': campaign_meta.get('short_label', f"WL {slug.title()}"),
            'tagline': campaign_meta.get('tagline', ''),
            'accent_color': campaign_meta.get('accent_color', '#000000'),
            'hero_image': campaign_meta.get('hero_image', ''),
            'logo': campaign_meta.get('logo', ''),
            'path_segment': campaign_meta.get('path_segment', slug),
            'years': new_years,
            'links': {
                'toolforge': f"https://wikiloves.toolforge.org/{campaign_meta.get('path_segment', slug)}"
            }
        }
        competitions.append(existing_comp)
        existing_index = len(competitions) - 1
    
    # Print summary
    print(f"\n✓ {slug} data merged:")
    print(f"  Total years: {len(new_years)}")
    for year_entry in new_years[:5]:  # Show first 5 years
        countries = year_entry.get('countries', 0)
        uploads = year_entry.get('uploads', 0)
        print(f"  - {year_entry['year']}: {countries} countries, {uploads:,} uploads")
    if len(new_years) > 5:
        print(f"  ... and {len(new_years) - 5} more years")
    
    return competitions


def merge_multiple_campaigns(
    competitions: List[Dict],
    data_dir: str
) -> List[Dict]:
    """
    Merge multiple campaign data files from a directory.
    
    Args:
        competitions: List of competition dictionaries.
        data_dir: Directory containing processed JSON files.
    
    Returns:
        Updated competitions list.
    """
    data_path = Path(data_dir)
    if not data_path.exists():
        print(f"⚠️  Warning: Data directory not found: {data_dir}")
        return competitions
    
    # Find all processed JSON files
    json_files = list(data_path.glob('*_processed.json'))
    
    if not json_files:
        print(f"⚠️  Warning: No processed JSON files found in {data_dir}")
        return competitions
    
    print(f"Found {len(json_files)} processed campaign files")
    
    for json_file in json_files:
        try:
            print(f"\nProcessing: {json_file.name}")
            campaign_data = load_processed_campaign_data(str(json_file))
            competitions = merge_campaign_data(competitions, campaign_data)
        except Exception as e:
            print(f"❌ Error processing {json_file.name}: {str(e)}", file=sys.stderr)
            continue
    
    return competitions


def write_catalog(competitions: List[Dict], countries: List[Dict], output_path: str = None):
    """
    Write competitions and countries to catalog.py file.
    """
    if output_path is None:
        output_path = os.path.join(os.path.dirname(__file__), '..', 'data', 'catalog.py')
    
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write('"""\n')
        f.write('Campaign catalog data - Updated with accurate Quarry data\n')
        f.write('This file is auto-generated by merge_campaign_data.py\n')
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
        description="Merge processed Wiki Loves campaign data into catalog.py"
    )
    parser.add_argument(
        "input",
        help="Path to processed campaign JSON file or directory containing processed files"
    )
    parser.add_argument(
        "--campaign",
        help="Campaign slug (if processing single file)"
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
    
    input_path = args.input
    if not os.path.exists(input_path):
        print(f"❌ Error: File or directory not found: {input_path}", file=sys.stderr)
        sys.exit(1)
    
    # Load existing catalog
    catalog_path = args.output or os.path.join(os.path.dirname(__file__), '..', 'data', 'catalog.py')
    
    if args.backup:
        backup_path = catalog_path + '.backup'
        import shutil
        shutil.copy2(catalog_path, backup_path)
        print(f"✓ Backup created: {backup_path}")
    
    print(f"Loading existing catalog from: {catalog_path}")
    competitions, countries = load_catalog()
    
    # Process input
    if os.path.isdir(input_path):
        # Merge multiple campaigns from directory
        print(f"Processing directory: {input_path}")
        updated_competitions = merge_multiple_campaigns(competitions, input_path)
    else:
        # Merge single campaign file
        print(f"Loading processed campaign data from: {input_path}")
        campaign_data = load_processed_campaign_data(input_path)
        updated_competitions = merge_campaign_data(
            competitions,
            campaign_data,
            campaign_slug=args.campaign
        )
    
    # Write updated catalog
    write_catalog(updated_competitions, countries, catalog_path)
    
    print("\n✅ Successfully merged campaign data into catalog!")


if __name__ == "__main__":
    main()
