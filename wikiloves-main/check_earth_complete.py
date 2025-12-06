"""Check earth_complete_with_countries.json"""
import json

with open('wikiloves-main/wiki_loves_campaign_data/earth_complete_with_countries.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

print("=" * 70)
print("EARTH COMPLETE WITH COUNTRIES - STATUS")
print("=" * 70)

# Check 2013
rows_2013 = [r for r in data['rows'] if r[0] == 2013]
print(f"\n2013 rows: {len(rows_2013)}")
for r in rows_2013:
    print(f"  {r[1]}: {r[2]:,} uploads, {r[3]:,} uploaders, {r[5]:,} new_uploaders")

# Check if Global row exists for 2013
global_2013 = [r for r in rows_2013 if r[1] == 'Global']
if global_2013:
    print(f"\n✅ 2013 Global row found: {global_2013[0][5]:,} new_uploaders")
else:
    print(f"\n❌ 2013 Global row MISSING")
    print(f"   Only found: {', '.join([r[1] for r in rows_2013])}")

# Check 2014
rows_2014 = [r for r in data['rows'] if r[0] == 2014]
global_2014 = [r for r in rows_2014 if r[1] == 'Global']
if global_2014:
    print(f"\n✅ 2014 Global row: {global_2014[0][5]:,} new_uploaders")
else:
    print(f"\n❌ 2014 Global row MISSING")

# Compare with query19.json
with open('wikiloves-main/wiki_loves_campaign_data/query19.json', 'r', encoding='utf-8') as f:
    query19 = json.load(f)

row_2013_query19 = [r for r in query19['rows'] if r[0] == 2013][0]
print(f"\n" + "=" * 70)
print("COMPARISON WITH query19.json")
print("=" * 70)
print(f"\nquery19.json 2013: {row_2013_query19[4]:,} new_uploaders")
if rows_2013:
    ukraine_2013 = rows_2013[0]
    print(f"earth_complete 2013 Ukraine: {ukraine_2013[5]:,} new_uploaders")
    if ukraine_2013[5] == row_2013_query19[4]:
        print("✅ Values match!")
    else:
        print("❌ Values don't match!")



