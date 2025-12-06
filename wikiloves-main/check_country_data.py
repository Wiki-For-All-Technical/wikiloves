"""Check if earth_complete_with_countries.json has 2013 Global row"""
import json

with open('wikiloves-main/wiki_loves_campaign_data/earth_complete_with_countries.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

# Check for 2013 Global row
global_2013 = [r for r in data['rows'] if r[0] == 2013 and r[1] == 'Global']
if global_2013:
    row = global_2013[0]
    print(f"2013 Global row found:")
    print(f"  Year: {row[0]}")
    print(f"  Country: {row[1]}")
    print(f"  Uploads: {row[2]:,}")
    print(f"  Uploaders: {row[3]:,}")
    print(f"  Images Used: {row[4]:,}")
    print(f"  New Uploaders: {row[5]:,}")
else:
    print("2013 Global row NOT found!")
    print("\n2013 rows found:")
    rows_2013 = [r for r in data['rows'] if r[0] == 2013]
    for r in rows_2013:
        print(f"  {r[1]}: {r[2]:,} uploads, {r[3]:,} uploaders, {r[5]:,} new_uploaders")



