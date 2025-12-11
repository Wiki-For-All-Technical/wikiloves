"""Check if countries are stored in catalog"""
import sys
import os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'wikiloves-main', 'backend'))

from data.catalog import COMPETITIONS

earth = [c for c in COMPETITIONS if 'earth' in c.get('slug', '').lower()]
if not earth:
    print("Earth campaign not found!")
    sys.exit(1)

earth = earth[0]
print("=" * 70)
print("EARTH - COUNTRY COUNTS CHECK")
print("=" * 70)

for year_data in sorted(earth['years'], key=lambda x: x['year']):
    year = year_data['year']
    countries = year_data.get('countries', None)
    country_stats = year_data.get('country_stats', [])
    
    print(f"\n{year}:")
    print(f"  Countries field: {countries}")
    print(f"  Country stats entries: {len(country_stats)}")
    if country_stats:
        print(f"  First 3 countries: {[c['name'] for c in country_stats[:3]]}")



