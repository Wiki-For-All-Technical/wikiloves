"""
Merge Earth 2013 and 2014 fix data into the complete dataset
"""
import json
import os

def load_json(file_path):
    """Load JSON file"""
    with open(file_path, 'r', encoding='utf-8') as f:
        return json.load(f)

def save_json(data, file_path):
    """Save JSON file"""
    with open(file_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2)

def merge_earth_data():
    """Merge fix data into complete dataset"""
    # Load all files
    fix_2013 = load_json('wikiloves-main/wiki_loves_campaign_data/earth_2013_fix.json')
    fix_2014 = load_json('wikiloves-main/wiki_loves_campaign_data/earth_2014_fix.json')
    complete = load_json('wikiloves-main/wiki_loves_campaign_data/earth_complete_with_countries.json')
    
    # Extract fix data
    fix_2013_row = fix_2013['rows'][0]  # [2013, 12141, 394, 12141, 98]
    fix_2014_row = fix_2014['rows'][0]  # [2014, 71468, 3109, 71468, 1928]
    
    # Create new rows list
    new_rows = []
    
    # First, add 2013 Global row if it doesn't exist
    has_2013_global = any(row[0] == 2013 and row[1] == 'Global' for row in complete['rows'])
    if not has_2013_global:
        # Add 2013 Global row at the beginning (before country rows)
        new_rows.append([
            2013,
            'Global',
            fix_2013_row[1],  # uploads
            fix_2013_row[2],  # uploaders
            fix_2013_row[3],  # images_used
            fix_2013_row[4]   # new_uploaders
        ])
    
    # Process complete dataset
    for row in complete['rows']:
        year = row[0]
        
        # Replace 2013 and 2014 Global rows with fix data
        if year == 2013 and row[1] == 'Global':
            # Replace with fix data: [year, 'Global', uploads, uploaders, images_used, new_uploaders]
            new_rows.append([
                2013,
                'Global',
                fix_2013_row[1],  # uploads
                fix_2013_row[2],  # uploaders
                fix_2013_row[3],  # images_used
                fix_2013_row[4]   # new_uploaders
            ])
        elif year == 2014 and row[1] == 'Global':
            # Replace with fix data
            new_rows.append([
                2014,
                'Global',
                fix_2014_row[1],  # uploads
                fix_2014_row[2],  # uploaders
                fix_2014_row[3],  # images_used
                fix_2014_row[4]   # new_uploaders
            ])
        else:
            # Keep other rows as-is
            new_rows.append(row)
    
    # Create merged dataset
    merged_data = {
        'meta': {
            'source': 'merged',
            'description': 'Earth complete dataset with 2013 and 2014 fix data merged'
        },
        'headers': complete['headers'],
        'rows': new_rows
    }
    
    # Save merged data
    output_file = 'wikiloves-main/wiki_loves_campaign_data/earth_merged_final.json'
    save_json(merged_data, output_file)
    
    print(f"[OK] Merged data saved to: {output_file}")
    print(f"     Total rows: {len(new_rows)}")
    
    # Count years
    years = set(row[0] for row in new_rows)
    print(f"     Years covered: {sorted(years)}")
    
    # Show 2013 and 2014 totals
    for row in new_rows:
        if row[0] == 2013 and row[1] == 'Global':
            print(f"\n[2013] Uploads: {row[2]:,}, Uploaders: {row[3]:,}, Images Used: {row[4]:,}, New Uploaders: {row[5]:,}")
        elif row[0] == 2014 and row[1] == 'Global':
            print(f"[2014] Uploads: {row[2]:,}, Uploaders: {row[3]:,}, Images Used: {row[4]:,}, New Uploaders: {row[5]:,}")
    
    return output_file

if __name__ == '__main__':
    print("=" * 80)
    print("MERGE EARTH FIX DATA")
    print("=" * 80)
    print()
    
    output_file = merge_earth_data()
    
    print(f"\n[OK] Merge completed!")
    print(f"\nNext steps:")
    print(f"1. Copy merged file to query19.json:")
    print(f"   Copy-Item {output_file} wikiloves-main/wiki_loves_campaign_data/query19.json -Force")
    print(f"2. Process data:")
    print(f"   python wikiloves-main/backend/scripts/process_all_campaigns.py")
    print(f"3. Verify data:")
    print(f"   python wikiloves-main/verify_earth_complete.py")

