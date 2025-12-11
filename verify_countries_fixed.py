"""Verify countries are now populated"""
import sys
import os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'wikiloves-main', 'backend'))

try:
    from data.catalog import COMPETITIONS
except ImportError as e:
    print(f"Error importing: {e}")
    print("Trying alternative path...")
    sys.path.insert(0, 'wikiloves-main/backend')
    from data.catalog import COMPETITIONS

earth = [c for c in COMPETITIONS if 'earth' in c.get('slug', '').lower()]
if not earth:
    print("Earth campaign not found!")
    sys.exit(1)

earth = earth[0]
print("=" * 70)
print("EARTH - COUNTRY COUNTS VERIFICATION")
print("=" * 70)

for year_data in sorted(earth['years'], key=lambda x: x['year']):
    year = year_data['year']
    countries = year_data.get('countries', None)
    country_stats = year_data.get('country_stats', [])
    
    status = "✅" if countries and countries > 0 else "❌"
    print(f"{status} {year}: {countries} countries ({len(country_stats)} country stats entries)")

print("\n" + "=" * 70)
print("SUMMARY")
print("=" * 70)
years_with_countries = [y for y in earth['years'] if y.get('countries', 0) > 0]
print(f"Years with country counts: {len(years_with_countries)}/{len(earth['years'])}")



