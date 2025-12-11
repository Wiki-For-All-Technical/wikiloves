"""Merge Earth 2013 data from ULTRA_FAST query with existing Earth data"""
import json

# Load existing Earth data (2014-2025)
with open('wikiloves-main/wiki_loves_campaign_data/query19.json', 'r', encoding='utf-8') as f:
    existing = json.load(f)

# Load new 2013 data
with open('wikiloves-main/wiki_loves_campaign_data/Earth_UltraFast_query1.json', 'r', encoding='utf-8') as f:
    new_2013 = json.load(f)

# Get 2013 row from new data
new_2013_row = new_2013['rows'][0]  # [2013, 12141, 394, 12141, 98]

# Check if 2013 already exists in existing data
existing_2013_index = None
for i, row in enumerate(existing['rows']):
    if row[0] == 2013:
        existing_2013_index = i
        break

# Update or add 2013 data
if existing_2013_index is not None:
    # Replace existing 2013 row
    existing['rows'][existing_2013_index] = new_2013_row
    print(f"Updated 2013 data: {existing['rows'][existing_2013_index][1]:,} uploads")
else:
    # Add new 2013 row
    existing['rows'].append(new_2013_row)
    print(f"Added 2013 data: {new_2013_row[1]:,} uploads")

# Sort by year (descending)
existing['rows'].sort(key=lambda x: x[0], reverse=True)

# Save updated data
with open('wikiloves-main/wiki_loves_campaign_data/query19.json', 'w', encoding='utf-8') as f:
    json.dump(existing, f, indent=2)

print(f"\n[OK] Updated query19.json with 2013 data")
print(f"Total years: {len(existing['rows'])}")
print("\nYears in data:")
for row in existing['rows']:
    print(f"  {row[0]}: {row[1]:,} uploads, {row[2]:,} uploaders")



