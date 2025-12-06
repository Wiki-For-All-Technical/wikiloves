"""
Merge Earth year totals with country breakdowns
Validates that country sums match year totals
"""
import json
import os
import sys
from collections import defaultdict
from typing import Dict, List, Any

def load_json_file(file_path: str) -> Dict:
    """Load JSON file"""
    if not os.path.exists(file_path):
        print(f"Error: File not found: {file_path}")
        return None
    
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            return json.load(f)
    except Exception as e:
        print(f"Error reading {file_path}: {e}")
        return None

def merge_earth_data(year_totals_file: str, country_breakdown_file: str, output_file: str):
    """
    Merge year totals with country breakdowns
    
    Args:
        year_totals_file: Path to JSON with year totals (format: [year, uploads, uploaders, images_used, new_uploaders])
        country_breakdown_file: Path to JSON with country breakdown (format: [year, country, uploads, uploaders, images_used, new_uploaders])
        output_file: Path to save merged JSON
    """
    # Load year totals
    year_totals_data = load_json_file(year_totals_file)
    if not year_totals_data:
        return False
    
    # Load country breakdown
    country_data = load_json_file(country_breakdown_file)
    if not country_data:
        return False
    
    year_totals_rows = year_totals_data.get('rows', [])
    country_rows = country_data.get('rows', [])
    
    # Build year totals map
    year_totals = {}
    for row in year_totals_rows:
        if len(row) >= 5:
            year = row[0]
            year_totals[year] = {
                'uploads': row[1],
                'uploaders': row[2],
                'images_used': row[3],
                'new_uploaders': row[4]
            }
    
    # Group country data by year
    countries_by_year = defaultdict(list)
    for row in country_rows:
        if len(row) >= 6:
            year = row[0]
            country = row[1]
            if country and country != 'Global':  # Skip Global entries
                countries_by_year[year].append({
                    'country': country,
                    'uploads': row[2],
                    'uploaders': row[3],
                    'images_used': row[4],
                    'new_uploaders': row[5]
                })
    
    # Merge data
    merged_rows = []
    validation_errors = []
    
    for year in sorted(year_totals.keys(), reverse=True):
        totals = year_totals[year]
        countries = countries_by_year.get(year, [])
        
        # Sort countries by uploads
        countries_sorted = sorted(countries, key=lambda x: x['uploads'], reverse=True)
        
        # Validate: Check if country sums match totals (with tolerance for rounding)
        if countries_sorted:
            country_uploads_sum = sum(c['uploads'] for c in countries_sorted)
            country_uploaders_max = max((c['uploaders'] for c in countries_sorted), default=0)
            
            # Allow 5% tolerance for uploads (due to potential overlaps)
            uploads_diff = abs(country_uploads_sum - totals['uploads'])
            uploads_pct = (uploads_diff / totals['uploads'] * 100) if totals['uploads'] > 0 else 0
            
            if uploads_pct > 5:
                validation_errors.append(
                    f"Year {year}: Country uploads sum ({country_uploads_sum:,}) differs from total ({totals['uploads']:,}) by {uploads_pct:.1f}%"
                )
        
        # Create merged row: [year, uploads, uploaders, images_used, new_uploaders, country_count, country_data]
        # For compatibility with existing processing, we'll create a structure that can be processed
        # We'll output in a format that includes country breakdown
        
        merged_rows.append({
            'year': year,
            'uploads': totals['uploads'],
            'uploaders': totals['uploaders'],
            'images_used': totals['images_used'],
            'new_uploaders': totals['new_uploaders'],
            'countries': len(countries_sorted),
            'country_stats': countries_sorted
        })
    
    # Create output structure compatible with process_all_campaigns.py
    # We'll create a format that can be processed as country breakdown
    output_rows = []
    for merged in merged_rows:
        year = merged['year']
        # Add Global row first (year totals)
        output_rows.append([
            year,
            'Global',
            merged['uploads'],
            merged['uploaders'],
            merged['images_used'],
            merged['new_uploaders']
        ])
        # Add country rows
        for country_stat in merged['country_stats']:
            output_rows.append([
                year,
                country_stat['country'],
                country_stat['uploads'],
                country_stat['uploaders'],
                country_stat['images_used'],
                country_stat['new_uploaders']
            ])
    
    # Create output JSON
    output_data = {
        'meta': {
            'source': 'merged',
            'year_totals_file': year_totals_file,
            'country_breakdown_file': country_breakdown_file
        },
        'headers': ['year', 'country', 'uploads', 'uploaders', 'images_used', 'new_uploaders'],
        'rows': output_rows
    }
    
    # Save merged data
    try:
        with open(output_file, 'w', encoding='utf-8') as f:
            json.dump(output_data, f, indent=2)
        print(f"[OK] Merged data saved to: {output_file}")
        print(f"     Total years: {len(merged_rows)}")
        print(f"     Total rows: {len(output_rows)}")
        
        if validation_errors:
            print(f"\n[WARNING] Validation issues found:")
            for error in validation_errors:
                print(f"  - {error}")
        else:
            print(f"\n[OK] Data validation passed")
        
        return True
    except Exception as e:
        print(f"Error saving merged data: {e}")
        return False

def main():
    """Main function"""
    if len(sys.argv) < 4:
        print("Usage: python merge_earth_data.py <year_totals.json> <country_breakdown.json> <output.json>")
        print("\nExample:")
        print("  python merge_earth_data.py query19.json earth_countries.json earth_merged.json")
        sys.exit(1)
    
    year_totals_file = sys.argv[1]
    country_breakdown_file = sys.argv[2]
    output_file = sys.argv[3]
    
    print("=" * 80)
    print("MERGE EARTH DATA")
    print("=" * 80)
    print(f"\nYear Totals: {year_totals_file}")
    print(f"Country Breakdown: {country_breakdown_file}")
    print(f"Output: {output_file}\n")
    
    success = merge_earth_data(year_totals_file, country_breakdown_file, output_file)
    
    if success:
        print("\n[OK] Merge completed successfully!")
        print(f"\nNext steps:")
        print(f"1. Replace query19.json with {output_file}")
        print(f"2. Run: python wikiloves-main/backend/scripts/process_all_campaigns.py")
        print(f"3. Verify: python wikiloves-main/verify_earth_complete.py")
    else:
        print("\n[ERROR] Merge failed!")
        sys.exit(1)

if __name__ == '__main__':
    main()



