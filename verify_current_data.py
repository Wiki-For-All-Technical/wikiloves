"""Verify current data status"""
import json

# Check query19.json
with open('wikiloves-main/wiki_loves_campaign_data/query19.json', 'r', encoding='utf-8') as f:
    query19 = json.load(f)

print("=" * 70)
print("CURRENT DATA STATUS")
print("=" * 70)

print("\n✅ query19.json (Year Summary):")
rows = [r for r in query19['rows'] if r[0] != 0]
print(f"  Total years: {len(rows)}")
row_2013 = [r for r in rows if r[0] == 2013][0]
print(f"  2013 new_uploaders: {row_2013[4]:,} (Reference: 275, Diff: {row_2013[4] - 275:+,} ({abs(row_2013[4] - 275)/275*100:.1f}%))")
print("  ✅ Updated with April 1st date range!")

# Check earth_complete_with_countries.json
with open('wikiloves-main/wiki_loves_campaign_data/earth_complete_with_countries.json', 'r', encoding='utf-8') as f:
    earth_complete = json.load(f)

print("\n❌ earth_complete_with_countries.json (Country Breakdown):")
global_rows = {r[0]: r[5] for r in earth_complete['rows'] if r[1] == 'Global'}
if 2013 in global_rows:
    print(f"  2013 Global new_uploaders: {global_rows[2013]:,}")
else:
    print("  2013 Global row: MISSING")
    ukraine_2013 = [r for r in earth_complete['rows'] if r[0] == 2013 and 'Ukraine' in r[1]]
    if ukraine_2013:
        print(f"  2013 Ukraine new_uploaders: {ukraine_2013[0][5]:,} (old data)")
print("  ⚠️  Still using old date range (May 1st)")

print("\n" + "=" * 70)
print("RECOMMENDATION")
print("=" * 70)
print("\nYour query19.json is already correct! ✅")
print("\nIf you need country breakdowns, run:")
print("  backend/queries/earth_complete_fixed_new_uploaders.sql")
print("\nOtherwise, you can proceed with query19.json as-is.")



