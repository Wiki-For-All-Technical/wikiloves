"""Add Global row for 2013 to earth_complete_with_countries.json"""
import json

# Load the file
with open('wikiloves-main/wiki_loves_campaign_data/earth_complete_with_countries.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

# Find 2013 Ukraine row (which has the correct totals)
ukraine_2013 = [r for r in data['rows'] if r[0] == 2013 and r[1] == 'Ukraine']
if not ukraine_2013:
    print("Error: 2013 Ukraine row not found!")
    exit(1)

ukraine_row = ukraine_2013[0]
# Create Global row: [year, "Global", uploads, uploaders, images_used, new_uploaders]
global_row = [2013, "Global", ukraine_row[2], ukraine_row[3], ukraine_row[4], ukraine_row[5]]

# Check if Global row already exists
existing_global = [r for r in data['rows'] if r[0] == 2013 and r[1] == 'Global']
if existing_global:
    print("2013 Global row already exists, replacing it...")
    # Replace existing
    for i, row in enumerate(data['rows']):
        if row[0] == 2013 and row[1] == 'Global':
            data['rows'][i] = global_row
            break
else:
    print("Adding 2013 Global row...")
    # Insert Global row before Ukraine row (or at the beginning of 2013 rows)
    # Find the position of the first 2013 row
    insert_pos = None
    for i, row in enumerate(data['rows']):
        if row[0] == 2013:
            insert_pos = i
            break
    
    if insert_pos is not None:
        data['rows'].insert(insert_pos, global_row)
    else:
        # If no 2013 rows found, append at the end
        data['rows'].append(global_row)

# Save the file
with open('wikiloves-main/wiki_loves_campaign_data/earth_complete_with_countries.json', 'w', encoding='utf-8') as f:
    json.dump(data, f, indent=2, ensure_ascii=False)

print(f"✅ Added 2013 Global row:")
print(f"   Year: {global_row[0]}")
print(f"   Uploads: {global_row[2]:,}")
print(f"   Uploaders: {global_row[3]:,}")
print(f"   Images Used: {global_row[4]:,}")
print(f"   New Uploaders: {global_row[5]:,}")
print(f"\nFile saved successfully!")



