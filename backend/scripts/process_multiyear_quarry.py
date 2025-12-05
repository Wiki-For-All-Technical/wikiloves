"""
Standalone script to process multi-year Quarry query results.
This script processes JSON files from multi-year queries and adds them to the catalog.
"""

import json
import sys
import os
import argparse

# Add parent directories to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', '..'))
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

from queries.process_quarry_results import process_multiyear_json
from data.campaigns_metadata import get_campaign_by_prefix


def process_multiyear_file(json_path: str, campaign_prefix: str, output_catalog_path: str = None):
    """
    Process a multi-year JSON file and merge into catalog.
    
    Args:
        json_path: Path to multi-year JSON file from Quarry
        campaign_prefix: Campaign prefix (e.g., 'monuments', 'earth')
        output_catalog_path: Optional path to catalog.py (default: backend/data/catalog.py)
    """
    if not os.path.exists(json_path):
        print(f"❌ Error: File not found: {json_path}")
        return False
    
    # Verify campaign prefix
    campaign = get_campaign_by_prefix(campaign_prefix)
    if not campaign:
        print(f"❌ Error: Unknown campaign prefix: '{campaign_prefix}'")
        print(f"   Check backend/data/campaigns_metadata.py for valid prefixes")
        return False
    
    print(f"📖 Processing multi-year data for: {campaign['name']}")
    print(f"   File: {json_path}\n")
    
    # Load JSON
    try:
        with open(json_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
    except Exception as e:
        print(f"❌ Error reading JSON file: {e}")
        return False
    
    if not isinstance(data, list):
        print(f"❌ Error: JSON must contain an array of objects")
        return False
    
    if not data or 'year' not in data[0]:
        print(f"❌ Error: JSON does not appear to be multi-year format (missing 'year' column)")
        return False
    
    # Process multi-year data
    try:
        years_data = process_multiyear_json(data, campaign_prefix)
    except Exception as e:
        print(f"❌ Error processing data: {e}")
        import traceback
        traceback.print_exc()
        return False
    
    print(f"✓ Processed {len(years_data)} years:")
    for year_data in years_data:
        year = year_data['year']
        uploads = year_data.get('uploads', 0)
        countries = year_data.get('countries', 0)
        print(f"   - {year}: {uploads:,} uploads, {countries} countries")
    
    # Merge into catalog directly
    if output_catalog_path is None:
        output_catalog_path = os.path.join(
            os.path.dirname(__file__), '..', 'data', 'catalog.py'
        )
    
    # Load existing catalog
    existing_competitions = {}
    existing_countries = {}
    
    if os.path.exists(output_catalog_path):
        try:
            catalog_globals = {}
            with open(output_catalog_path, 'r', encoding='utf-8') as f:
                exec(f.read(), catalog_globals)
            existing_comps = catalog_globals.get('COMPETITIONS', [])
            existing_ctries = catalog_globals.get('COUNTRIES', [])
            
            # Index by slug for easy lookup
            for comp in existing_comps:
                existing_competitions[comp.get('slug')] = comp
            for country in existing_ctries:
                existing_countries[country.get('name')] = country
        except Exception as e:
            print(f"⚠️  Warning: Could not load existing catalog: {e}")
    
    all_competitions = existing_competitions.copy()
    all_countries = existing_countries.copy()
    
    # Add years to competition
    comp_slug = campaign["slug"]
    if comp_slug in all_competitions:
        existing_comp = all_competitions[comp_slug]
        existing_years = {y.get('year') for y in existing_comp.get('years', [])}
        
        for year_data in years_data:
            year = year_data['year']
            if year in existing_years:
                # Replace existing year
                existing_comp['years'] = [y for y in existing_comp['years'] if y.get('year') != year]
            existing_comp['years'].append(year_data)
        
        print(f"✓ Updated {campaign['name']} with {len(years_data)} years")
    else:
        # Create new competition
        all_competitions[comp_slug] = {
            "slug": campaign["slug"],
            "name": campaign["name"],
            "short_label": campaign["short_label"],
            "tagline": campaign["tagline"],
            "accent_color": campaign["accent_color"],
            "hero_image": campaign.get("hero_image", ""),
            "logo": campaign.get("logo", ""),
            "path_segment": campaign["path_segment"],
            "years": years_data,
            "links": {"toolforge": f"https://wikiloves.toolforge.org/{campaign['path_segment']}"}
        }
        print(f"✓ Created {campaign['name']} with {len(years_data)} years")
    
    # Update country profiles from country stats
    for year_data in years_data:
        year = year_data['year']
        country_stats = year_data.get("country_stats", [])
        for country_stat in country_stats:
            country_name = country_stat["name"]
            
            if country_name not in all_countries:
                all_countries[country_name] = {
                    "slug": country_name.lower().replace(" ", "-"),
                    "name": country_name,
                    "region": "Global",
                    "first_year": year,
                    "focus": set(),
                    "recent_activity": []
                }
            
            country_profile = all_countries[country_name]
            if isinstance(country_profile.get("focus"), set):
                country_profile["focus"].add(campaign["name"])
            else:
                country_profile["focus"] = set(country_profile.get("focus", []))
                country_profile["focus"].add(campaign["name"])
            
            country_profile["first_year"] = min(country_profile["first_year"], year)
            country_profile["recent_activity"].append({
                "competition": campaign["slug"],
                "year": year,
                "uploads": country_stat["uploads"]
            })
    
    # Sort years for each competition
    for comp in all_competitions.values():
        comp["years"].sort(key=lambda y: y.get("year", 0), reverse=True)
    
    # Convert to lists and format
    final_competitions = list(all_competitions.values())
    final_countries = []
    
    for name, profile in all_countries.items():
        if isinstance(profile.get("focus"), set):
            profile["focus"] = list(profile["focus"])
        if "recent_activity" in profile:
            profile["recent_activity"].sort(key=lambda x: x.get("year", 0))
        final_countries.append(profile)
    
    final_countries.sort(key=lambda x: x.get("name", ""))
    
    # Write to catalog.py
    output_code = f"""COMPETITIONS = {json.dumps(final_competitions, indent=4, ensure_ascii=False)}

COUNTRIES = {json.dumps(final_countries, indent=4, ensure_ascii=False)}
"""
    
    os.makedirs(os.path.dirname(output_catalog_path), exist_ok=True)
    
    with open(output_catalog_path, 'w', encoding='utf-8') as f:
        f.write(output_code)
    
    print(f"\n✅ Success! Multi-year data merged into {output_catalog_path}")
    print(f"   - {len(final_competitions)} competitions")
    print(f"   - {len(final_countries)} countries")
    return True


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Process multi-year Quarry query results",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Process monuments multi-year data
  python process_multiyear_quarry.py monuments_multiyear.json monuments

  # Process with custom output path
  python process_multiyear_quarry.py earth_multiyear.json earth --output backend/data/catalog.py

File format:
  JSON must have 'year' column in each row:
  [
    {"year": 2024, "uploads": 239104, "uploaders": 4358, ...},
    {"year": 2023, "uploads": 217420, "uploaders": 4694, ...},
    ...
  ]
        """
    )
    parser.add_argument("json_file", help="Path to multi-year JSON file from Quarry")
    parser.add_argument("campaign_prefix", help="Campaign prefix (e.g., monuments, earth)")
    parser.add_argument("--output", default=None,
                       help="Output catalog.py path (default: backend/data/catalog.py)")
    
    args = parser.parse_args()
    
    success = process_multiyear_file(args.json_file, args.campaign_prefix, args.output)
    sys.exit(0 if success else 1)

