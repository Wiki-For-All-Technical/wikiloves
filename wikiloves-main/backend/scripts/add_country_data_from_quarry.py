"""
Add country data from quarry_data converted JSON files to catalog.py

This script reads the country breakdown files from quarry_data/ and updates
the campaigns in catalog.py with comprehensive country-level statistics.
"""

import json
import os
import sys
from collections import defaultdict
from typing import Dict, List, Any, Optional

# Add parent directory to path for imports
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

# Mapping of quarry data files to campaign slugs
QUARRY_COUNTRY_FILES = {
    'earth_country_converted.json': 'earth',
    'monuments_county_converted.json': 'monuments',
    'folklore_multiyear_converted.json': 'folklore',
    'africa_multiyear_converted.json': 'africa', 
    'science_multiyear_converted.json': 'science',
    'public_art_multiyear_converted.json': 'public-art',
}

# Also load from wiki_loves_campaign_data if country data available
CAMPAIGN_DATA_FILES = {
    'earth_complete_with_countries.json': 'earth',
}


def load_quarry_country_data(file_path: str) -> List[Dict]:
    """Load country data from a quarry converted JSON file."""
    if not os.path.exists(file_path):
        print(f"File not found: {file_path}")
        return []
    
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
        return data if isinstance(data, list) else []
    except Exception as e:
        print(f"Error loading {file_path}: {e}")
        return []


def load_campaign_country_data(file_path: str) -> List[Dict]:
    """Load country data from wiki_loves_campaign_data JSON file (Quarry export format)."""
    if not os.path.exists(file_path):
        print(f"File not found: {file_path}")
        return []
    
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        # Convert from Quarry format to our format
        rows = data.get('rows', [])
        headers = data.get('headers', [])
        
        converted = []
        for row in rows:
            if len(row) >= 6:
                converted.append({
                    'year': row[0],
                    'country': row[1],
                    'uploads': row[2],
                    'uploaders': row[3],
                    'images_used': row[4],
                    'new_uploaders': row[5]
                })
        return converted
    except Exception as e:
        print(f"Error loading {file_path}: {e}")
        return []


def process_country_data(data: List[Dict]) -> Dict[int, Dict]:
    """Process country data and organize by year."""
    years_data = defaultdict(lambda: {
        'uploads': 0,
        'uploaders': 0,
        'images_used': 0,
        'new_uploaders': 0,
        'countries': 0,
        'country_stats': []
    })
    
    for entry in data:
        year = entry.get('year')
        country = entry.get('country')
        
        if country is None:
            # No country field - this is a yearly summary row (like africa_multiyear)
            years_data[year]['uploads'] = entry.get('uploads', 0)
            years_data[year]['uploaders'] = entry.get('uploaders', 0)
            years_data[year]['images_used'] = entry.get('images_used', 0)
            years_data[year]['new_uploaders'] = entry.get('new_uploaders', 0)
            # Use the countries count from the data if available
            if 'countries' in entry:
                years_data[year]['countries'] = entry.get('countries', 0)
        elif country == 'Global':
            # Global row - use for totals
            years_data[year]['uploads'] = entry.get('uploads', 0)
            years_data[year]['uploaders'] = entry.get('uploaders', 0)
            years_data[year]['images_used'] = entry.get('images_used', 0)
            years_data[year]['new_uploaders'] = entry.get('new_uploaders', 0)
        else:
            # Country-specific data
            years_data[year]['country_stats'].append({
                'name': country,
                'uploads': entry.get('uploads', 0),
                'uploaders': entry.get('uploaders', 0),
                'images_used': entry.get('images_used', 0),
                'new_uploaders': entry.get('new_uploaders', 0),
                'rank': 0  # Will be assigned later
            })
    
    # Sort country stats by uploads and assign ranks
    for year, year_data in years_data.items():
        country_stats = sorted(year_data['country_stats'], key=lambda x: x['uploads'], reverse=True)
        for i, stat in enumerate(country_stats, 1):
            stat['rank'] = i
        year_data['country_stats'] = country_stats
        
        # Update countries count based on country_stats if we have them
        if country_stats:
            year_data['countries'] = len(country_stats)
        
        # If no Global row, calculate from countries
        if year_data['uploads'] == 0 and country_stats:
            year_data['uploads'] = sum(c['uploads'] for c in country_stats)
            year_data['images_used'] = sum(c['images_used'] for c in country_stats)
            year_data['uploaders'] = sum(c['uploaders'] for c in country_stats)
            year_data['new_uploaders'] = sum(c['new_uploaders'] for c in country_stats)
    
    return dict(years_data)


def read_current_catalog() -> str:
    """Read the current catalog.py file."""
    catalog_path = os.path.join(os.path.dirname(__file__), '..', 'data', 'catalog.py')
    with open(catalog_path, 'r', encoding='utf-8') as f:
        return f.read()


def update_campaign_in_catalog(catalog_content: str, slug: str, years_data: Dict[int, Dict]) -> str:
    """Update a campaign's years data in the catalog content."""
    import re
    
    # Find the campaign section
    pattern = rf'(\{{\s*"slug":\s*"{slug}".*?"years":\s*\[)(.*?)(\s*\]\s*\}})'
    
    def replace_years(match):
        prefix = match.group(1)
        suffix = match.group(3)
        
        # Build new years data
        years_list = []
        for year in sorted(years_data.keys(), reverse=True):
            year_data = years_data[year]
            country_stats_str = ""
            
            for stat in year_data['country_stats']:
                country_stats_str += f'''
                    {{
                        "name": {json.dumps(stat['name'])},
                        "uploads": {stat['uploads']},
                        "uploaders": {stat['uploaders']},
                        "images_used": {stat['images_used']},
                        "new_uploaders": {stat['new_uploaders']},
                        "rank": {stat['rank']}
                    }},'''
            
            year_entry = f'''
            {{
                "year": {year},
                "uploads": {year_data['uploads']},
                "uploaders": {year_data['uploaders']},
                "images_used": {year_data['images_used']},
                "new_uploaders": {year_data['new_uploaders']},
                "countries": {year_data.get('countries', len(year_data['country_stats']))},
                "country_stats": [{country_stats_str}
                ]
            }},'''
            years_list.append(year_entry)
        
        new_years = ''.join(years_list)
        return prefix + new_years + suffix
    
    updated = re.sub(pattern, replace_years, catalog_content, flags=re.DOTALL)
    return updated


def generate_new_catalog():
    """Generate a completely new catalog.py with all country data."""
    quarry_dir = os.path.join(os.path.dirname(__file__), '..', '..', 'quarry_data')
    campaign_dir = os.path.join(os.path.dirname(__file__), '..', '..', 'wiki_loves_campaign_data')
    
    # Load all country data
    all_campaign_data = {}
    
    # Load from quarry_data
    for filename, slug in QUARRY_COUNTRY_FILES.items():
        file_path = os.path.join(quarry_dir, filename)
        data = load_quarry_country_data(file_path)
        if data:
            years_data = process_country_data(data)
            all_campaign_data[slug] = years_data
            print(f"Loaded {len(years_data)} years for {slug} from {filename}")
    
    # Load from wiki_loves_campaign_data
    for filename, slug in CAMPAIGN_DATA_FILES.items():
        file_path = os.path.join(campaign_dir, filename)
        data = load_campaign_country_data(file_path)
        if data:
            years_data = process_country_data(data)
            # Merge or replace existing data
            if slug in all_campaign_data:
                # Prefer the data with more years or more country details
                if len(years_data) > len(all_campaign_data[slug]):
                    all_campaign_data[slug] = years_data
            else:
                all_campaign_data[slug] = years_data
            print(f"Loaded {len(years_data)} years for {slug} from {filename}")
    
    # Print summary
    print("\nData summary:")
    for slug, years_data in all_campaign_data.items():
        total_countries = sum(len(y['country_stats']) for y in years_data.values())
        print(f"  {slug}: {len(years_data)} years, {total_countries} total country entries")
    
    # Now update the catalog.py
    catalog_path = os.path.join(os.path.dirname(__file__), '..', 'data', 'catalog.py')
    
    # Read current catalog and parse it to get existing campaign structure
    exec_globals = {}
    with open(catalog_path, 'r', encoding='utf-8') as f:
        exec(f.read(), exec_globals)
    
    existing_competitions = exec_globals.get('COMPETITIONS', [])
    
    # Update competitions with new country data
    updated_competitions = []
    for comp in existing_competitions:
        slug = comp['slug']
        
        if slug in all_campaign_data:
            # Replace years data with new data
            years_data = all_campaign_data[slug]
            new_years = []
            
            for year in sorted(years_data.keys(), reverse=True):
                year_data = years_data[year]
                new_years.append({
                    'year': year,
                    'uploads': year_data['uploads'],
                    'uploaders': year_data['uploaders'],
                    'images_used': year_data['images_used'],
                    'new_uploaders': year_data['new_uploaders'],
                    'countries': year_data.get('countries', len(year_data['country_stats'])),
                    'country_stats': year_data['country_stats']
                })
            
            comp['years'] = new_years
            print(f"Updated {slug} with {len(new_years)} years of country data")
        
        updated_competitions.append(comp)
    
    # Write updated catalog
    write_catalog(catalog_path, updated_competitions)
    print(f"\nUpdated catalog.py saved to {catalog_path}")


def write_catalog(output_path: str, competitions: List[Dict]):
    """Write the catalog.py file."""
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write('"""\n')
        f.write('Campaign catalog data - Auto-generated with country data\n')
        f.write('Generated by add_country_data_from_quarry.py\n')
        f.write('"""\n\n')
        f.write('COMPETITIONS = [\n')
        
        for comp in competitions:
            f.write('    {\n')
            f.write(f'        "slug": "{comp["slug"]}",\n')
            f.write(f'        "name": "{comp["name"]}",\n')
            f.write(f'        "short_label": "{comp.get("short_label", comp["name"])}",\n')
            f.write(f'        "tagline": "{comp.get("tagline", "")}",\n')
            f.write(f'        "accent_color": "{comp.get("accent_color", "#1f8a70")}",\n')
            f.write(f'        "hero_image": "{comp.get("hero_image", "")}",\n')
            f.write(f'        "logo": "{comp.get("logo", "")}",\n')
            f.write(f'        "path_segment": "{comp.get("path_segment", comp["slug"])}",\n')
            f.write('        "years": [\n')
            
            for year_data in comp.get('years', []):
                f.write('            {\n')
                f.write(f'                "year": {year_data["year"]},\n')
                f.write(f'                "uploads": {year_data.get("uploads", 0)},\n')
                f.write(f'                "uploaders": {year_data.get("uploaders", 0)},\n')
                f.write(f'                "images_used": {year_data.get("images_used", 0)},\n')
                f.write(f'                "new_uploaders": {year_data.get("new_uploaders", 0)},\n')
                f.write(f'                "countries": {year_data.get("countries", 0)},\n')
                f.write('                "country_stats": [\n')
                
                for country_stat in year_data.get('country_stats', []):
                    f.write('                    {\n')
                    f.write(f'                        "name": {json.dumps(country_stat["name"])},\n')
                    f.write(f'                        "uploads": {country_stat.get("uploads", 0)},\n')
                    f.write(f'                        "uploaders": {country_stat.get("uploaders", 0)},\n')
                    f.write(f'                        "images_used": {country_stat.get("images_used", 0)},\n')
                    f.write(f'                        "new_uploaders": {country_stat.get("new_uploaders", 0)},\n')
                    f.write(f'                        "rank": {country_stat.get("rank", 0)}\n')
                    f.write('                    },\n')
                
                f.write('                ]\n')
                f.write('            },\n')
            
            f.write('        ]\n')
            f.write('    },\n')
        
        f.write(']\n\n')
        f.write('COUNTRIES = []  # Country data can be generated separately\n')


if __name__ == '__main__':
    generate_new_catalog()







