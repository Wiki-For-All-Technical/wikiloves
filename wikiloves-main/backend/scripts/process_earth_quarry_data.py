"""
Process Wiki Loves Earth data from Quarry exports.
This script processes JSON/CSV exports from Quarry and structures them for the catalog system.
"""

import json
import csv
import sys
import os
import argparse
from typing import Dict, List, Optional
from collections import defaultdict

# Add parent directory to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))
from data.campaigns_metadata import get_campaign_by_prefix
from queries.process_quarry_results import process_quarry_json, process_multiyear_json


def process_earth_category_discovery(json_path: str) -> List[Dict]:
    """
    Process the category discovery query results.
    Returns a list of categories with their file counts.
    """
    with open(json_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    # Handle Quarry format (meta/rows/headers) or array format
    if isinstance(data, dict) and 'rows' in data:
        headers = data.get('headers', [])
        rows = data['rows']
        categories = []
        for row in rows:
            if len(headers) >= 2 and len(row) >= 2:
                categories.append({
                    'category_name': row[0],
                    'file_count': row[1] if len(row) > 1 else 0
                })
        return categories
    elif isinstance(data, list):
        return data
    else:
        raise ValueError(f"Unknown JSON format in {json_path}")


def process_earth_country_stats(json_path: str, output_path: Optional[str] = None) -> Dict:
    """
    Process country statistics data from Quarry.
    Handles both single-year and multi-year data.
    
    Returns:
        Dictionary with processed statistics organized by year
    """
    with open(json_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    # Handle Quarry format (meta/rows/headers)
    if isinstance(data, dict) and 'rows' in data:
        headers = data.get('headers', [])
        rows = data['rows']
        
        # Convert to array of objects
        processed_data = []
        for row in rows:
            obj = {}
            for i, header in enumerate(headers):
                if i < len(row):
                    obj[header] = row[i]
            processed_data.append(obj)
        data = processed_data
    
    if not isinstance(data, list):
        raise ValueError("JSON file must contain an array of objects")
    
    # Check if this is multi-year data
    if data and 'year' in data[0]:
        return process_earth_multiyear_data(data, output_path)
    else:
        # Single year data
        return process_earth_single_year_data(data, output_path)


def process_earth_multiyear_data(data: List[Dict], output_path: Optional[str] = None) -> Dict:
    """
    Process multi-year Earth data with country breakdown.
    Groups data by year and organizes country statistics.
    """
    years_data = defaultdict(lambda: {
        'year': None,
        'uploads': 0,
        'uploaders': 0,
        'images_used': 0,
        'new_uploaders': 0,
        'countries': 0,
        'country_stats': []
    })
    
    for entry in data:
        year = int(entry.get('year', 0))
        if year == 0:
            continue
        
        country = entry.get('country', '').strip()
        uploads = int(entry.get('uploads', 0) or 0)
        uploaders = int(entry.get('uploaders', 0) or 0)
        images_used = int(entry.get('images_used', 0) or 0)
        new_uploaders = int(entry.get('new_uploaders', 0) or 0)
        
        if years_data[year]['year'] is None:
            years_data[year]['year'] = year
        
        if country and country.lower() not in ['global', 'unknown', '']:
            # Country-specific data
            years_data[year]['country_stats'].append({
                'name': country,
                'uploads': uploads,
                'uploaders': uploaders,
                'images_used': images_used,
                'new_uploaders': new_uploaders,
                'rank': 0  # Will be assigned later
            })
        elif country and country.lower() == 'global':
            # Global totals for this year
            years_data[year]['uploads'] = uploads
            years_data[year]['uploaders'] = uploaders
            years_data[year]['images_used'] = images_used
            years_data[year]['new_uploaders'] = new_uploaders
    
    # Sort country stats and assign ranks, calculate totals if needed
    result = {}
    for year, year_data in sorted(years_data.items(), reverse=True):
        # Sort countries by uploads
        year_data['country_stats'].sort(key=lambda x: x['uploads'], reverse=True)
        for i, country_stat in enumerate(year_data['country_stats']):
            country_stat['rank'] = i + 1
            # Calculate percentages for each country
            uploads = country_stat.get('uploads', 0)
            uploaders = country_stat.get('uploaders', 0)
            country_stat['images_used_pct'] = round(
                (country_stat.get('images_used', 0) / uploads * 100) if uploads > 0 else 0, 2
            )
            country_stat['new_uploaders_pct'] = round(
                (country_stat.get('new_uploaders', 0) / uploaders * 100) if uploaders > 0 else 0, 2
            )
        
        year_data['countries'] = len(year_data['country_stats'])
        
        # If global totals weren't set, calculate from country stats
        if year_data['uploads'] == 0 and year_data['country_stats']:
            year_data['uploads'] = sum(c['uploads'] for c in year_data['country_stats'])
            # For uploaders, we need to track unique users across countries
            # Note: This is an approximation - actual count would need user-level data
            # Users who upload in multiple countries will be counted multiple times
            year_data['uploaders'] = sum(c['uploaders'] for c in year_data['country_stats'])
            year_data['images_used'] = sum(c['images_used'] for c in year_data['country_stats'])
            year_data['new_uploaders'] = sum(c['new_uploaders'] for c in year_data['country_stats'])
        
        # Calculate percentages for year totals
        uploads = year_data.get('uploads', 0)
        uploaders = year_data.get('uploaders', 0)
        year_data['images_used_pct'] = round(
            (year_data.get('images_used', 0) / uploads * 100) if uploads > 0 else 0, 2
        )
        year_data['new_uploaders_pct'] = round(
            (year_data.get('new_uploaders', 0) / uploaders * 100) if uploaders > 0 else 0, 2
        )
        
        result[year] = year_data
    
    if output_path:
        output_data = {
            'campaign': 'earth',
            'campaign_name': 'Wiki Loves Earth',
            'years': list(result.values())
        }
        with open(output_path, 'w', encoding='utf-8') as f:
            json.dump(output_data, f, indent=2, ensure_ascii=False)
        print(f"✓ Processed data saved to: {output_path}")
    
    return result


def process_earth_single_year_data(data: List[Dict], output_path: Optional[str] = None) -> Dict:
    """
    Process single-year Earth data with country breakdown.
    """
    year_data = {
        'uploads': 0,
        'uploaders': 0,
        'images_used': 0,
        'new_uploaders': 0,
        'country_stats': []
    }
    
    year = None
    for entry in data:
        entry_year = entry.get('year')
        if entry_year:
            year = int(entry_year)
            year_data['year'] = year
        
        country = entry.get('country', '').strip()
        uploads = int(entry.get('uploads', 0) or 0)
        uploaders = int(entry.get('uploaders', 0) or 0)
        images_used = int(entry.get('images_used', 0) or 0)
        new_uploaders = int(entry.get('new_uploaders', 0) or 0)
        
        if country and country.lower() not in ['global', 'unknown', '']:
            year_data['country_stats'].append({
                'name': country,
                'uploads': uploads,
                'uploaders': uploaders,
                'images_used': images_used,
                'new_uploaders': new_uploaders,
                'rank': 0
            })
        elif country and country.lower() == 'global':
            year_data['uploads'] = uploads
            year_data['uploaders'] = uploaders
            year_data['images_used'] = images_used
            year_data['new_uploaders'] = new_uploaders
    
    # Sort and rank countries
    year_data['country_stats'].sort(key=lambda x: x['uploads'], reverse=True)
    for i, country_stat in enumerate(year_data['country_stats']):
        country_stat['rank'] = i + 1
        # Calculate percentages for each country
        uploads = country_stat.get('uploads', 0)
        uploaders = country_stat.get('uploaders', 0)
        country_stat['images_used_pct'] = round(
            (country_stat.get('images_used', 0) / uploads * 100) if uploads > 0 else 0, 2
        )
        country_stat['new_uploaders_pct'] = round(
            (country_stat.get('new_uploaders', 0) / uploaders * 100) if uploaders > 0 else 0, 2
        )
    
    year_data['countries'] = len(year_data['country_stats'])
    
    # Calculate percentages for year totals
    uploads = year_data.get('uploads', 0)
    uploaders = year_data.get('uploaders', 0)
    year_data['images_used_pct'] = round(
        (year_data.get('images_used', 0) / uploads * 100) if uploads > 0 else 0, 2
    )
    year_data['new_uploaders_pct'] = round(
        (year_data.get('new_uploaders', 0) / uploaders * 100) if uploaders > 0 else 0, 2
    )
    
    if output_path:
        output_data = {
            'campaign': 'earth',
            'campaign_name': 'Wiki Loves Earth',
            'years': [year_data]
        }
        with open(output_path, 'w', encoding='utf-8') as f:
            json.dump(output_data, f, indent=2, ensure_ascii=False)
        print(f"✓ Processed data saved to: {output_path}")
    
    return {year: year_data} if year else {}


def main():
    parser = argparse.ArgumentParser(
        description="Process Wiki Loves Earth data from Quarry exports"
    )
    parser.add_argument(
        "input_file",
        help="Path to Quarry JSON/CSV export file"
    )
    parser.add_argument(
        "--output",
        "-o",
        help="Output JSON file path (default: <input_file>_processed.json)"
    )
    parser.add_argument(
        "--type",
        choices=["categories", "countries"],
        default="countries",
        help="Type of data to process"
    )
    
    args = parser.parse_args()
    
    input_path = args.input_file
    if not os.path.exists(input_path):
        print(f"Error: File not found: {input_path}", file=sys.stderr)
        sys.exit(1)
    
    output_path = args.output
    if not output_path:
        base_name = os.path.splitext(input_path)[0]
        output_path = f"{base_name}_processed.json"
    
    try:
        if args.type == "categories":
            result = process_earth_category_discovery(input_path)
            with open(output_path, 'w', encoding='utf-8') as f:
                json.dump(result, f, indent=2, ensure_ascii=False)
            print(f"✓ Processed {len(result)} categories")
            print(f"✓ Saved to: {output_path}")
        else:
            result = process_earth_country_stats(input_path, output_path)
            total_years = len(result)
            print(f"✓ Processed {total_years} year(s) of data")
            for year, year_data in sorted(result.items(), reverse=True):
                countries = len(year_data.get('country_stats', []))
                uploads = year_data.get('uploads', 0)
                print(f"  - {year}: {countries} countries, {uploads:,} uploads")
            
    except Exception as e:
        print(f"Error processing file: {e}", file=sys.stderr)
        import traceback
        traceback.print_exc()
        sys.exit(1)


if __name__ == "__main__":
    main()




