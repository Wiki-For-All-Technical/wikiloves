"""
Script to add summary statistics from Quarry to catalog.py
This handles cases where you only have totals (no country breakdown)
"""

import json
import sys
import os

# Add parent directories to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', '..'))
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

from data.campaigns_metadata import get_campaign_by_slug

def add_summary_to_catalog(campaign_slug: str, year: int, uploads: int, 
                           uploaders: int, images_used: int, new_uploaders: int = 0):
    """
    Add summary statistics to catalog.py for a campaign year.
    
    Args:
        campaign_slug: e.g., "wiki-loves-monuments"
        year: e.g., 2024
        uploads: Total uploads
        uploaders: Total unique uploaders
        images_used: Total images used
        new_uploaders: New uploaders (optional, defaults to 0)
    """
    # Read current catalog
    catalog_path = os.path.join(os.path.dirname(__file__), '..', 'data', 'catalog.py')
    
    if not os.path.exists(catalog_path):
        print(f"❌ Error: {catalog_path} not found!")
        return False
    
    # Read the catalog file
    with open(catalog_path, 'r', encoding='utf-8') as f:
        catalog_content = f.read()
    
    # Execute the catalog file to get COMPETITIONS
    catalog_globals = {}
    exec(catalog_content, catalog_globals)
    competitions = catalog_globals.get('COMPETITIONS', [])
    countries = catalog_globals.get('COUNTRIES', [])
    
    # Find the competition
    comp = None
    for c in competitions:
        if c.get('slug') == campaign_slug:
            comp = c
            break
    
    if not comp:
        print(f"❌ Error: Campaign '{campaign_slug}' not found in catalog!")
        print(f"   Available campaigns: {[c.get('slug') for c in competitions]}")
        return False
    
    # Check if year already exists
    existing_year = None
    for y in comp.get('years', []):
        if y.get('year') == year:
            existing_year = y
            break
    
    if existing_year:
        print(f"⚠️  Warning: Year {year} already exists for {campaign_slug}")
        print(f"   Existing: {existing_year.get('uploads')} uploads")
        print(f"   New: {uploads} uploads")
        response = input("   Replace? (y/n): ")
        if response.lower() != 'y':
            print("   Cancelled.")
            return False
        
        # Remove existing year
        comp['years'] = [y for y in comp['years'] if y.get('year') != year]
    
    # Create year entry (without country stats for now)
    year_entry = {
        "year": year,
        "countries": 0,  # Will be updated when country data is available
        "uploads": uploads,
        "images_used": images_used,
        "uploaders": uploaders,
        "new_uploaders": new_uploaders,
        "country_stats": []  # Empty for now
    }
    
    # Add year entry
    comp['years'].append(year_entry)
    
    # Sort years
    comp['years'].sort(key=lambda x: x['year'], reverse=True)
    
    # Write back to catalog
    output_code = f"""COMPETITIONS = {json.dumps(competitions, indent=4, ensure_ascii=False)}

COUNTRIES = {json.dumps(countries, indent=4, ensure_ascii=False)}
"""
    
    with open(catalog_path, 'w', encoding='utf-8') as f:
        f.write(output_code)
    
    print(f"✅ Success! Added {year} data for {campaign_slug}")
    print(f"   - {uploads:,} uploads")
    print(f"   - {uploaders:,} uploaders")
    print(f"   - {images_used:,} images used")
    print(f"\n   Note: Country breakdown not included. Run country query to add it.")
    
    return True


if __name__ == "__main__":
    if len(sys.argv) < 6:
        print("Usage: python add_quarry_summary.py <campaign_slug> <year> <uploads> <uploaders> <images_used> [new_uploaders]")
        print("\nExample:")
        print("  python add_quarry_summary.py wiki-loves-monuments 2024 239104 4358 239104 0")
        sys.exit(1)
    
    campaign_slug = sys.argv[1]
    year = int(sys.argv[2])
    uploads = int(sys.argv[3])
    uploaders = int(sys.argv[4])
    images_used = int(sys.argv[5])
    new_uploaders = int(sys.argv[6]) if len(sys.argv) > 6 else 0
    
    add_summary_to_catalog(campaign_slug, year, uploads, uploaders, images_used, new_uploaders)

