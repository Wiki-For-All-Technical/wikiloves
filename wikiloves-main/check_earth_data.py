"""Quick check of Earth data in catalog"""
import sys
sys.path.insert(0, 'wikiloves-main/backend')
from data.catalog import COMPETITIONS

earth = [c for c in COMPETITIONS if 'earth' in c.get('slug', '').lower()]
if earth:
    e = earth[0]
    print(f"Earth campaign found: {e['name']}")
    print(f"Total years: {len(e['years'])}")
    print("\nYear-by-year data:")
    for year_data in sorted(e['years'], key=lambda x: x['year'], reverse=True):
        print(f"  {year_data['year']}: {year_data['uploads']:,} uploads, {year_data['uploaders']:,} uploaders, {year_data.get('countries', 0)} countries")
else:
    print("Earth campaign not found!")



