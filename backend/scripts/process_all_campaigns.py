"""
Process all 77 campaign JSON files and generate catalog.py with all campaigns.
This script reads query1.json through query77.json and converts them to the catalog format.
"""

import json
import os
from collections import defaultdict
from typing import Dict, List, Any

def process_multiyear_summary_format(rows: List[List]) -> Dict[str, Any]:
    """Process multiyear summary format (GROUP BY year only)"""
    years_list = []
    for row in rows:
        year = row[0]
        uploads = row[1] if len(row) > 1 else 0
        uploaders = row[2] if len(row) > 2 else 0
        images_used = row[3] if len(row) > 3 else 0
        new_uploaders = row[4] if len(row) > 4 else 0
        
        years_list.append({
            'year': year,
            'uploads': uploads,
            'uploaders': uploaders,
            'images_used': images_used,
            'new_uploaders': new_uploaders,
            'countries': 0,  # Not available in summary format
            'country_stats': []
        })
    
    return {
        'years': sorted(years_list, key=lambda x: x['year'], reverse=True),
        'has_data': len(years_list) > 0
    }

def process_country_breakdown_format(rows: List[List]) -> Dict[str, Any]:
    """Process country breakdown format (GROUP BY year, country)"""
    # Group by year
    years_data = defaultdict(lambda: {
        'uploads': 0,
        'uploaders': 0,
        'images_used': 0,
        'new_uploaders': 0,
        'has_global': False,
        'country_stats': []
    })
    
    # First pass: collect all data
    for row in rows:
        year = row[0]
        country = row[1] if len(row) > 1 else 'Global'
        uploads = row[2] if len(row) > 2 else 0
        uploaders = row[3] if len(row) > 3 else 0
        images_used = row[4] if len(row) > 4 else 0
        new_uploaders = row[5] if len(row) > 5 else 0
        
        # Handle Global row (contains year totals)
        if country == 'Global':
            years_data[year]['uploads'] = uploads
            years_data[year]['uploaders'] = uploaders
            years_data[year]['images_used'] = images_used
            years_data[year]['new_uploaders'] = new_uploaders
            years_data[year]['has_global'] = True
        else:
            # Country-specific row
            years_data[year]['country_stats'].append({
                'name': country,
                'uploads': uploads,
                'uploaders': uploaders,
                'images_used': images_used,
                'new_uploaders': new_uploaders,
                'rank': 0  # Will be set later
            })
    
    # Convert to final format
    years_list = []
    for year in sorted(years_data.keys(), reverse=True):
        year_data = years_data[year]
        
        # If no Global row, we need to calculate totals from countries
        # Note: This is less accurate due to potential overlaps
        if not year_data['has_global'] and year_data['country_stats']:
            # Sum countries (approximation - may have overlaps)
            year_data['uploads'] = sum(c['uploads'] for c in year_data['country_stats'])
            year_data['images_used'] = sum(c['images_used'] for c in year_data['country_stats'])
            # For uploaders, use max (approximation)
            year_data['uploaders'] = max((c['uploaders'] for c in year_data['country_stats']), default=0)
            year_data['new_uploaders'] = max((c['new_uploaders'] for c in year_data['country_stats']), default=0)
        
        # Sort country stats by uploads and assign ranks
        country_stats = sorted(year_data['country_stats'], key=lambda x: x['uploads'], reverse=True)
        for i, stat in enumerate(country_stats, 1):
            stat['rank'] = i
        
        # Count unique countries
        country_count = len(country_stats)
        
        years_list.append({
            'year': year,
            'uploads': year_data['uploads'],
            'uploaders': year_data['uploaders'],
            'images_used': year_data['images_used'],
            'new_uploaders': year_data['new_uploaders'],
            'countries': country_count,
            'country_stats': country_stats
        })
    
    return {
        'years': years_list,
        'has_data': len(years_list) > 0
    }

# Map query numbers to campaign names (from comprehensive_campaign_queries.sql)
CAMPAIGN_NAMES = [
    "Africa", "Andes", "Art_Belgium", "Assamese_Culture", "Bangla", "Birds", "Birds_India",
    "Botswana", "Busto_Arsizio", "Canoeing_Hamburg", "Children", "China", "Classics",
    "Cocktails_at_WikiCon", "Cosplay", "Cultura_Popular_Brasil", "Culture", "Denderland",
    "Earth", "Eemland", "Emirates", "EuroPride", "Falles", "Fashion", "Festivals", "Film",
    "Fiumefreddo", "Folk", "Folklore", "Food", "For_Rural_Works", "Heritage_Belgium",
    "Heritage_Ghana", "Librarians", "Libraries_SAAM", "Littérature_Haïtienne",
    "Living_Heritage", "Love", "Mangaluru", "Maps", "Mexico", "Monuments", "Museums",
    "Museums_India", "Muziris", "México", "NYC_Parks", "Namibia", "Onam",
    "Pajottenland_Zennevallei", "Parliaments", "Pesto_Genovese", "Piemonte", "Plants",
    "Pride", "Public_Art", "Public_Space", "Puglia", "Ramadan", "Ratha_Jatra", "Romania",
    "Schools", "Science", "Sicilia", "Small_Museums", "Sport", "Stuff", "Sudan",
    "Switzerland", "Tirreno_Cosentino", "Trentino", "Tribal_Culture",
    "Valle_del_Primo_Presepe", "Villages", "Vizag", "Wahran", "Women"
]

def slugify(name: str) -> str:
    """Convert campaign name to URL-friendly slug."""
    return name.lower().replace('_', '-').replace(' ', '-')

def format_campaign_name(name: str) -> str:
    """Format campaign name for display."""
    return name.replace('_', ' ').title()

def get_short_label(name: str) -> str:
    """Get short label for campaign."""
    # Special cases
    if name == "Earth":
        return "WL Earth"
    elif name == "Monuments":
        return "WL Monuments"
    elif name == "Africa":
        return "WL Africa"
    elif name == "Folklore":
        return "WL Folklore"
    elif name == "Public_Art":
        return "WL Public Art"
    elif name == "Science":
        return "WL Science"
    elif name == "Public_Space":
        return "WL Public Space"
    elif name == "Living_Heritage":
        return "WL Living Heritage"
    elif name == "Heritage_Belgium":
        return "WL Heritage Belgium"
    
    # Default: add "WL " prefix
    return f"WL {format_campaign_name(name)}"

def process_campaign_file(file_path: str, campaign_name: str) -> Dict[str, Any]:
    """Process a single campaign JSON file and return structured data."""
    if not os.path.exists(file_path):
        return None
    
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
    except Exception as e:
        print(f"Error reading {file_path}: {e}")
        return None
    
    rows = data.get('rows', [])
    if not rows:
        return None
    
    # Check format type
    # Format 1: Multiyear summary [year, uploads, uploaders, images_used, new_uploaders]
    # Format 2: Comprehensive [year, category_name, country, uploads, uploaders, images_used, new_uploaders]
    # Format 3: Country breakdown [year, country, uploads, uploaders, images_used, new_uploaders]
    headers = data.get('headers', [])
    is_multiyear_summary = len(headers) == 5 and 'category_name' not in headers and 'country' not in headers
    is_country_breakdown = len(headers) == 6 and 'country' in headers and 'category_name' not in headers
    
    if is_multiyear_summary:
        # Process as multiyear summary (one row per year)
        return process_multiyear_summary_format(rows)
    
    if is_country_breakdown:
        # Process as country breakdown format
        return process_country_breakdown_format(rows)
    
    # First pass: collect all categories and identify main ones (comprehensive format) (comprehensive format processing continues below)
    years_data = defaultdict(lambda: {
        'main_uploads': None,
        'main_uploaders': None,
        'main_images_used': None,
        'main_new_uploaders': None,
        'country_stats': defaultdict(lambda: {
            'uploads': 0,
            'uploaders': 0,
            'images_used': 0,
            'new_uploaders': 0
        })
    })
    
    # First pass: collect all categories and identify main ones
    category_data = defaultdict(list)
    for row in rows:
        year = row[0]
        category_name = row[1]
        country = row[2] if len(row) > 2 else 'Global'
        uploads = row[3] if len(row) > 3 else 0
        uploaders = row[4] if len(row) > 4 else 0
        images_used = row[5] if len(row) > 5 else 0
        new_uploaders = row[6] if len(row) > 6 else 0
        
        category_data[year].append({
            'category': category_name,
            'country': country,
            'uploads': uploads,
            'uploaders': uploaders,
            'images_used': images_used,
            'new_uploaders': new_uploaders
        })
    
    # Second pass: identify main category for each year and process
    for year, categories in category_data.items():
        # Find main category - prefer "Images_from_Wiki_Loves_X_YYYY" pattern
        # Otherwise use the category with most uploads
        main_category = None
        max_uploads = 0
        
        for cat in categories:
            cat_name = cat['category']
            # Prefer "Images_from_Wiki_Loves_" pattern
            if cat_name.startswith('Images_from_Wiki_Loves_') and str(year) in cat_name:
                if cat['uploads'] > max_uploads:
                    main_category = cat
                    max_uploads = cat['uploads']
        
        # If no "Images_from_Wiki_Loves_" found, use category with most uploads
        if not main_category:
            for cat in categories:
                if cat['uploads'] > max_uploads:
                    main_category = cat
                    max_uploads = cat['uploads']
        
        # Use main category data for year totals
        if main_category:
            years_data[year]['main_uploads'] = main_category['uploads']
            years_data[year]['main_uploaders'] = main_category['uploaders']
            years_data[year]['main_images_used'] = main_category['images_used']
            years_data[year]['main_new_uploaders'] = main_category['new_uploaders']
        
        # Process all categories for country stats
        for cat in categories:
            country_key = cat['country'] if cat['country'] and cat['country'] != 'Global' else None
            if country_key:
                years_data[year]['country_stats'][country_key]['uploads'] += cat['uploads']
                years_data[year]['country_stats'][country_key]['images_used'] += cat['images_used']
                # For country uploaders, use max (approximation)
                if cat['uploaders'] > years_data[year]['country_stats'][country_key].get('uploaders', 0):
                    years_data[year]['country_stats'][country_key]['uploaders'] = cat['uploaders']
                if cat['new_uploaders'] > years_data[year]['country_stats'][country_key].get('new_uploaders', 0):
                    years_data[year]['country_stats'][country_key]['new_uploaders'] = cat['new_uploaders']
    
    # Convert to final format
    years_list = []
    for year in sorted(years_data.keys(), reverse=True):
        year_data = years_data[year]
        
        # Use main category data for year totals (if available)
        # Otherwise fall back to summing (less accurate)
        if 'main_uploads' in year_data:
            year_uploads = year_data['main_uploads']
            year_uploaders = year_data['main_uploaders']
            year_images_used = year_data['main_images_used']
            year_new_uploaders = year_data['main_new_uploaders']
        else:
            # Fallback: if no main category found, use the largest category from country stats
            # This shouldn't happen if data is correct, but handle it gracefully
            if year_data['country_stats']:
                max_country = max(year_data['country_stats'].items(), key=lambda x: x[1]['uploads'])
                year_uploads = max_country[1]['uploads']
                year_uploaders = max_country[1].get('uploaders', 0)
                year_images_used = max_country[1]['images_used']
                year_new_uploaders = max_country[1].get('new_uploaders', 0)
            else:
                # Last resort: use zeros
                year_uploads = 0
                year_uploaders = 0
                year_images_used = 0
                year_new_uploaders = 0
        
        # Calculate unique countries (excluding None/Global)
        countries = set(k for k in year_data['country_stats'].keys() if k and k != 'Global')
        country_count = len(countries)
        
        # Build country stats list
        country_stats_list = []
        for country_name, stats in sorted(year_data['country_stats'].items()):
            if country_name == 'Global':
                continue
            country_stats_list.append({
                'name': country_name,
                'uploads': stats['uploads'],
                'uploaders': stats.get('uploaders', 0),
                'images_used': stats['images_used'],
                'new_uploaders': stats.get('new_uploaders', 0),
                'rank': 0  # Will be set later
            })
        
        # Sort country stats by uploads and assign ranks
        country_stats_list.sort(key=lambda x: x['uploads'], reverse=True)
        for i, stat in enumerate(country_stats_list, 1):
            stat['rank'] = i
        
        years_list.append({
            'year': year,
            'uploads': year_uploads,
            'uploaders': year_uploaders,
            'images_used': year_images_used,
            'new_uploaders': year_new_uploaders,
            'countries': country_count,
            'country_stats': country_stats_list
        })
    
    return {
        'years': years_list,
        'has_data': len(years_list) > 0
    }

def generate_catalog():
    """Generate catalog.py with all 77 campaigns."""
    data_dir = os.path.join(os.path.dirname(__file__), '..', '..', 'wiki_loves_campaign_data')
    
    competitions = []
    
    for i, campaign_name in enumerate(CAMPAIGN_NAMES, 1):
        query_file = os.path.join(data_dir, f'query{i}.json')
        
        # Special handling for Earth: use country breakdown file if available
        if campaign_name == "Earth":
            country_file = os.path.join(data_dir, 'earth_complete_with_countries.json')
            if os.path.exists(country_file):
                query_file = country_file
        
        slug = slugify(campaign_name)
        formatted_name = f"Wiki Loves {format_campaign_name(campaign_name)}" if not campaign_name.startswith("Wiki") else format_campaign_name(campaign_name)
        
        # Special handling for Science
        if campaign_name == "Science":
            formatted_name = "Wiki Science Competition"
        
        processed = process_campaign_file(query_file, campaign_name)
        
        if processed and processed['has_data']:
            competition = {
                "slug": slug,
                "name": formatted_name,
                "short_label": get_short_label(campaign_name),
                "tagline": f"Photographing {format_campaign_name(campaign_name).lower()} for Wikimedia Commons.",
                "accent_color": "#1f8a70",  # Default green, can be customized
                "hero_image": "",
                "logo": "",
                "path_segment": slug,
                "years": processed['years']
            }
        else:
            # Campaign with no data
            competition = {
                "slug": slug,
                "name": formatted_name,
                "short_label": get_short_label(campaign_name),
                "tagline": f"Photographing {format_campaign_name(campaign_name).lower()} for Wikimedia Commons.",
                "accent_color": "#1f8a70",
                "hero_image": "",
                "logo": "",
                "path_segment": slug,
                "years": []
            }
        
        competitions.append(competition)
        print(f"Processed {i}/77: {campaign_name} - {len(processed['years']) if processed else 0} years")
    
    # Generate Python file
    output_file = os.path.join(os.path.dirname(__file__), '..', 'data', 'catalog.py')
    
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write('"""\n')
        f.write('Campaign catalog data - Auto-generated from query JSON files\n')
        f.write('Generated by process_all_campaigns.py\n')
        f.write('"""\n\n')
        f.write('COMPETITIONS = [\n')
        
        for comp in competitions:
            f.write('    {\n')
            f.write(f'        "slug": "{comp["slug"]}",\n')
            f.write(f'        "name": "{comp["name"]}",\n')
            f.write(f'        "short_label": "{comp["short_label"]}",\n')
            f.write(f'        "tagline": "{comp["tagline"]}",\n')
            f.write(f'        "accent_color": "{comp["accent_color"]}",\n')
            f.write(f'        "hero_image": "{comp["hero_image"]}",\n')
            f.write(f'        "logo": "{comp["logo"]}",\n')
            f.write(f'        "path_segment": "{comp["path_segment"]}",\n')
            f.write('        "years": [\n')
            
            for year_data in comp['years']:
                f.write('            {\n')
                f.write(f'                "year": {year_data["year"]},\n')
                f.write(f'                "uploads": {year_data["uploads"]},\n')
                f.write(f'                "uploaders": {year_data["uploaders"]},\n')
                f.write(f'                "images_used": {year_data["images_used"]},\n')
                f.write(f'                "new_uploaders": {year_data["new_uploaders"]},\n')
                f.write(f'                "countries": {year_data["countries"]},\n')
                f.write('                "country_stats": [\n')
                
                for country_stat in year_data['country_stats']:
                    f.write('                    {\n')
                    f.write(f'                        "name": {json.dumps(country_stat["name"])},\n')
                    f.write(f'                        "uploads": {country_stat["uploads"]},\n')
                    f.write(f'                        "uploaders": {country_stat["uploaders"]},\n')
                    f.write(f'                        "images_used": {country_stat["images_used"]},\n')
                    f.write(f'                        "new_uploaders": {country_stat["new_uploaders"]},\n')
                    f.write(f'                        "rank": {country_stat["rank"]}\n')
                    f.write('                    },\n')
                
                f.write('                ]\n')
                f.write('            },\n')
            
            f.write('        ]\n')
            f.write('    },\n')
        
        f.write(']\n\n')
        f.write('COUNTRIES = []  # Country data can be generated separately\n')
    
    print(f"\n[OK] Generated catalog.py with {len(competitions)} campaigns")
    print(f"   Output: {output_file}")

if __name__ == '__main__':
    generate_catalog()

