"""Process multiyear summary JSON (GROUP BY year only format)"""
import json
import os
import sys

def process_multiyear_json(file_path: str) -> dict:
    """Process a multiyear summary JSON file (one row per year)"""
    if not os.path.exists(file_path):
        return None
    
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
    except Exception as e:
        print(f"Error reading {file_path}: {e}")
        return None
    
    rows = data.get('rows', [])
    if not rows:
        return None
    
    years_list = []
    for row in rows:
        year = row[0]
        uploads = row[1] if len(row) > 1 else 0
        uploaders = row[2] if len(row) > 2 else 0
        images_used = row[3] if len(row) > 3 else 0
        new_uploaders = row[4] if len(row) > 4 else 0
        
        years_list.append({
            'year': year,
            'uploads': uploads,
            'uploaders': uploaders,
            'images_used': images_used,
            'new_uploaders': new_uploaders,
            'countries': 0,  # Not available in summary format
            'country_stats': []
        })
    
    return {
        'years': sorted(years_list, key=lambda x: x['year'], reverse=True),
        'has_data': len(years_list) > 0
    }

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Usage: python process_multiyear_summary.py <json_file>")
        sys.exit(1)
    
    result = process_multiyear_json(sys.argv[1])
    if result:
        print(f"Processed {len(result['years'])} years")
        for year_data in result['years']:
            print(f"  {year_data['year']}: {year_data['uploads']:,} uploads, {year_data['uploaders']:,} uploaders")
    else:
        print("Failed to process file")



