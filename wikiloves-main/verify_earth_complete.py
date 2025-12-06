"""
Comprehensive verification script for Wiki Loves Earth data (2013-2025)
Compares our data with reference website data and generates detailed report
"""
import json
import sys
import os
from typing import Dict, List, Tuple

# Reference data from wikiloves.toolforge.org/earth
EARTH_REFERENCE = {
    2013: {
        'uploads': 9655,
        'uploaders': 346,
        'countries': 1,
        'images_used': 9394,
        'images_used_pct': 97,
        'new_uploaders': 275,
        'new_uploaders_pct': 79
    },
    2014: {
        'uploads': 62351,
        'uploaders': 2882,
        'countries': 14,
        'images_used': 20348,
        'images_used_pct': 32,
        'new_uploaders': 2364,
        'new_uploaders_pct': 82
    },
    2015: {
        'uploads': 95867,
        'uploaders': 8785,
        'countries': 25,
        'images_used': 28838,
        'images_used_pct': 30,
        'new_uploaders': 7700,
        'new_uploaders_pct': 87
    },
    2016: {
        'uploads': 109010,
        'uploaders': 13090,
        'countries': 24,
        'images_used': 25813,
        'images_used_pct': 23,
        'new_uploaders': 11654,
        'new_uploaders_pct': 89
    },
    2017: {
        'uploads': 129553,
        'uploaders': 14972,
        'countries': 36,
        'images_used': 30191,
        'images_used_pct': 23,
        'new_uploaders': 13629,
        'new_uploaders_pct': 91
    },
    2018: {
        'uploads': 88909,
        'uploaders': 7545,
        'countries': 32,
        'images_used': 21806,
        'images_used_pct': 24,
        'new_uploaders': 6276,
        'new_uploaders_pct': 83
    },
    2019: {
        'uploads': 93768,
        'uploaders': 9603,
        'countries': 37,
        'images_used': 20367,
        'images_used_pct': 21,
        'new_uploaders': 8314,
        'new_uploaders_pct': 86
    },
    2020: {
        'uploads': 105403,
        'uploaders': 8992,
        'countries': 34,
        'images_used': 30710,
        'images_used_pct': 29,
        'new_uploaders': 7541,
        'new_uploaders_pct': 83
    },
    2021: {
        'uploads': 62639,
        'uploaders': 4510,
        'countries': 35,
        'images_used': 19594,
        'images_used_pct': 31,
        'new_uploaders': 3512,
        'new_uploaders_pct': 77
    },
    2022: {
        'uploads': 50472,
        'uploaders': 4109,
        'countries': 39,
        'images_used': 6680,
        'images_used_pct': 13,
        'new_uploaders': 3222,
        'new_uploaders_pct': 78
    },
    2023: {
        'uploads': 60249,
        'uploaders': 3397,
        'countries': 50,
        'images_used': 12079,
        'images_used_pct': 20,
        'new_uploaders': 2376,
        'new_uploaders_pct': 69
    },
    2024: {
        'uploads': 79490,
        'uploaders': 3861,
        'countries': 57,
        'images_used': 11993,
        'images_used_pct': 15,
        'new_uploaders': 2726,
        'new_uploaders_pct': 70
    },
    2025: {
        'uploads': 79233,
        'uploaders': 5260,
        'countries': 56,
        'images_used': 10596,
        'images_used_pct': 13,
        'new_uploaders': 3947,
        'new_uploaders_pct': 75
    },
}

def load_our_data(file_path: str) -> Dict[int, Dict]:
    """Load our Earth data from JSON file"""
    if not os.path.exists(file_path):
        print(f"Error: File not found: {file_path}")
        return {}
    
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
    except Exception as e:
        print(f"Error reading {file_path}: {e}")
        return {}
    
    our_data = {}
    rows = data.get('rows', [])
    headers = data.get('headers', [])
    
    # Check format type
    is_country_breakdown = 'country' in headers
    
    # Count countries per year
    countries_by_year = {}
    
    for row in rows:
        if is_country_breakdown:
            # Country breakdown format: [year, country, uploads, uploaders, images_used, new_uploaders]
            if len(row) >= 6:
                year = int(row[0]) if isinstance(row[0], (int, str)) else row[0]
                country = row[1]
                
                if country == 'Global':
                    # This is a Global row with year totals
                    our_data[year] = {
                        'uploads': int(row[2]) if isinstance(row[2], (int, str)) else row[2],
                        'uploaders': int(row[3]) if isinstance(row[3], (int, str)) else row[3],
                        'images_used': int(row[4]) if isinstance(row[4], (int, str)) else row[4],
                        'new_uploaders': int(row[5]) if isinstance(row[5], (int, str)) else row[5],
                        'countries': 0  # Will be set below
                    }
                else:
                    # Count countries (exclude Global and special entries)
                    if country and country != 'Global' and not country.startswith('an unknown'):
                        if year not in countries_by_year:
                            countries_by_year[year] = set()
                        countries_by_year[year].add(country)
        else:
            # Multiyear summary format: [year, uploads, uploaders, images_used, new_uploaders]
            if len(row) >= 5:
                year = int(row[0]) if isinstance(row[0], (int, str)) else row[0]
                our_data[year] = {
                    'uploads': int(row[1]) if isinstance(row[1], (int, str)) else row[1],
                    'uploaders': int(row[2]) if isinstance(row[2], (int, str)) else row[2],
                    'images_used': int(row[3]) if isinstance(row[3], (int, str)) else row[3],
                    'new_uploaders': int(row[4]) if isinstance(row[4], (int, str)) else row[4],
                    'countries': 0
                }
    
    # Add country counts
    for year, country_set in countries_by_year.items():
        if year in our_data:
            our_data[year]['countries'] = len(country_set)
    
    return our_data

def load_catalog_data() -> Dict[int, Dict]:
    """Load Earth data from catalog.py"""
    sys.path.insert(0, 'wikiloves-main/backend')
    try:
        from data.catalog import COMPETITIONS
        earth = [c for c in COMPETITIONS if 'earth' in c['slug']]
        if not earth:
            return {}
        
        earth = earth[0]
        catalog_data = {}
        for year_data in earth.get('years', []):
            year = year_data['year']
            catalog_data[year] = {
                'uploads': year_data.get('uploads', 0),
                'uploaders': year_data.get('uploaders', 0),
                'images_used': year_data.get('images_used', 0),
                'new_uploaders': year_data.get('new_uploaders', 0),
                'countries': year_data.get('countries', 0)
            }
        return catalog_data
    except Exception as e:
        print(f"Error loading catalog data: {e}")
        return {}

def calculate_percentage_diff(our_value: int, ref_value: int) -> float:
    """Calculate percentage difference"""
    if ref_value == 0:
        return 100.0 if our_value > 0 else 0.0
    return abs((our_value - ref_value) / ref_value * 100)

def get_status(pct_diff: float) -> Tuple[str, str]:
    """Get status based on percentage difference"""
    if pct_diff < 1:
        return ("OK", "✓")
    elif pct_diff < 5:
        return ("GOOD", "✓")
    elif pct_diff < 10:
        return ("WARNING", "⚠")
    else:
        return ("ERROR", "❌")

def verify_data(our_data: Dict[int, Dict], source_name: str = "Our Data") -> Dict:
    """Verify our data against reference"""
    results = {
        'source': source_name,
        'years': {},
        'summary': {
            'total_years': 0,
            'ok_years': 0,
            'warning_years': 0,
            'error_years': 0,
            'issues': []
        }
    }
    
    for year in sorted(EARTH_REFERENCE.keys()):
        ref = EARTH_REFERENCE[year]
        our = our_data.get(year, {})
        
        if not our:
            results['years'][year] = {
                'status': 'MISSING',
                'uploads': {'our': 0, 'ref': ref['uploads'], 'diff': -ref['uploads'], 'pct': 100.0},
                'uploaders': {'our': 0, 'ref': ref['uploaders'], 'diff': -ref['uploaders'], 'pct': 100.0},
                'countries': {'our': 0, 'ref': ref['countries'], 'diff': -ref['countries'], 'pct': 100.0},
            }
            results['summary']['error_years'] += 1
            results['summary']['issues'].append(f"{year}: Missing data")
            continue
        
        # Compare uploads
        uploads_diff = our.get('uploads', 0) - ref['uploads']
        uploads_pct = calculate_percentage_diff(our.get('uploads', 0), ref['uploads'])
        uploads_status, uploads_icon = get_status(uploads_pct)
        
        # Compare uploaders
        uploaders_diff = our.get('uploaders', 0) - ref['uploaders']
        uploaders_pct = calculate_percentage_diff(our.get('uploaders', 0), ref['uploaders'])
        uploaders_status, uploaders_icon = get_status(uploaders_pct)
        
        # Compare countries (if available)
        countries_diff = our.get('countries', 0) - ref['countries']
        countries_pct = calculate_percentage_diff(our.get('countries', 0), ref['countries']) if ref['countries'] > 0 else 0
        countries_status, countries_icon = get_status(countries_pct)
        
        # Overall status (worst of all metrics)
        overall_pct = max(uploads_pct, uploaders_pct, countries_pct)
        overall_status, overall_icon = get_status(overall_pct)
        
        year_result = {
            'status': overall_status,
            'icon': overall_icon,
            'uploads': {
                'our': our.get('uploads', 0),
                'ref': ref['uploads'],
                'diff': uploads_diff,
                'pct': uploads_pct,
                'status': uploads_status,
                'icon': uploads_icon
            },
            'uploaders': {
                'our': our.get('uploaders', 0),
                'ref': ref['uploaders'],
                'diff': uploaders_diff,
                'pct': uploaders_pct,
                'status': uploaders_status,
                'icon': uploaders_icon
            },
            'countries': {
                'our': our.get('countries', 0),
                'ref': ref['countries'],
                'diff': countries_diff,
                'pct': countries_pct,
                'status': countries_status,
                'icon': countries_icon
            },
            'images_used': {
                'our': our.get('images_used', 0),
                'ref': ref['images_used'],
                'ref_pct': ref['images_used_pct']
            },
            'new_uploaders': {
                'our': our.get('new_uploaders', 0),
                'ref': ref['new_uploaders'],
                'ref_pct': ref['new_uploaders_pct']
            }
        }
        
        results['years'][year] = year_result
        results['summary']['total_years'] += 1
        
        if overall_pct < 1:
            results['summary']['ok_years'] += 1
        elif overall_pct < 5:
            results['summary']['ok_years'] += 1
        elif overall_pct < 10:
            results['summary']['warning_years'] += 1
            results['summary']['issues'].append(f"{year}: {overall_pct:.1f}% difference")
        else:
            results['summary']['error_years'] += 1
            results['summary']['issues'].append(f"{year}: {overall_pct:.1f}% difference")
    
    return results

def print_verification_report(results: Dict):
    """Print detailed verification report"""
    print("=" * 100)
    print("WIKI LOVES EARTH - COMPREHENSIVE VERIFICATION REPORT")
    print("=" * 100)
    print(f"\nSource: {results['source']}")
    print(f"\nSummary:")
    print(f"  Total Years: {results['summary']['total_years']}")
    print(f"  OK Years: {results['summary']['ok_years']}")
    print(f"  Warning Years: {results['summary']['warning_years']}")
    print(f"  Error Years: {results['summary']['error_years']}")
    
    if results['summary']['issues']:
        print(f"\nIssues Found:")
        for issue in results['summary']['issues']:
            print(f"  - {issue}")
    
    print("\n" + "=" * 100)
    print("DETAILED YEAR-BY-YEAR COMPARISON")
    print("=" * 100)
    print(f"\n{'Year':<6} {'Status':<10} {'Uploads':<25} {'Uploaders':<25} {'Countries':<20}")
    print("-" * 100)
    
    for year in sorted(results['years'].keys()):
        year_data = results['years'][year]
        status = year_data['status']
        icon = year_data.get('icon', '')
        
        uploads = year_data['uploads']
        uploaders = year_data['uploaders']
        countries = year_data['countries']
        
        uploads_icon = uploads.get('icon', '')
        uploaders_icon = uploaders.get('icon', '')
        countries_icon = countries.get('icon', '')
        
        uploads_str = f"{uploads['our']:>8,} vs {uploads['ref']:>8,} ({uploads['pct']:>5.1f}%) {uploads_icon}"
        uploaders_str = f"{uploaders['our']:>6,} vs {uploaders['ref']:>6,} ({uploaders['pct']:>5.1f}%) {uploaders_icon}"
        countries_str = f"{countries['our']:>3} vs {countries['ref']:>3} ({countries['pct']:>5.1f}%) {countries_icon}"
        
        print(f"{year:<6} {icon} {status:<8} {uploads_str:<25} {uploaders_str:<25} {countries_str:<20}")

def generate_markdown_report(results: Dict, output_file: str = "earth_verification_report.md"):
    """Generate markdown verification report"""
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write("# Wiki Loves Earth - Comprehensive Verification Report\n\n")
        f.write(f"**Source:** {results['source']}\n\n")
        
        f.write("## Summary\n\n")
        f.write(f"- **Total Years:** {results['summary']['total_years']}\n")
        f.write(f"- **OK Years:** {results['summary']['ok_years']}\n")
        f.write(f"- **Warning Years:** {results['summary']['warning_years']}\n")
        f.write(f"- **Error Years:** {results['summary']['error_years']}\n\n")
        
        if results['summary']['issues']:
            f.write("## Issues Found\n\n")
            for issue in results['summary']['issues']:
                f.write(f"- {issue}\n")
            f.write("\n")
        
        f.write("## Detailed Year-by-Year Comparison\n\n")
        f.write("| Year | Status | Uploads (Our vs Ref) | Uploaders (Our vs Ref) | Countries (Our vs Ref) |\n")
        f.write("|------|--------|---------------------|----------------------|----------------------|\n")
        
        for year in sorted(results['years'].keys()):
            year_data = results['years'][year]
            status = year_data['status']
            icon = year_data.get('icon', '')
            
            uploads = year_data['uploads']
            uploaders = year_data['uploaders']
            countries = year_data['countries']
            
            uploads_str = f"{uploads['our']:,} vs {uploads['ref']:,} ({uploads['pct']:.1f}%)"
            uploaders_str = f"{uploaders['our']:,} vs {uploaders['ref']:,} ({uploaders['pct']:.1f}%)"
            countries_str = f"{countries['our']} vs {countries['ref']} ({countries['pct']:.1f}%)"
            
            f.write(f"| {year} | {icon} {status} | {uploads_str} | {uploaders_str} | {countries_str} |\n")
        
        f.write("\n## Legend\n\n")
        f.write("- ✓ OK: < 1% difference\n")
        f.write("- ✓ GOOD: < 5% difference\n")
        f.write("- ⚠ WARNING: 5-10% difference\n")
        f.write("- ❌ ERROR: > 10% difference\n")
    
    print(f"\n[OK] Generated markdown report: {output_file}")

def main():
    """Main verification function"""
    # Try to load from JSON file first
    json_file = 'wikiloves-main/wiki_loves_campaign_data/query19.json'
    our_data = load_our_data(json_file)
    
    if not our_data:
        # Fallback to catalog data
        print("Loading from catalog.py...")
        our_data = load_catalog_data()
        source_name = "Catalog Data"
    else:
        source_name = "JSON File (query19.json)"
    
    if not our_data:
        print("Error: Could not load Earth data from any source")
        return
    
    print(f"Loaded {len(our_data)} years of data from {source_name}\n")
    
    # Verify data
    results = verify_data(our_data, source_name)
    
    # Print report
    print_verification_report(results)
    
    # Generate markdown report
    generate_markdown_report(results)
    
    # Return exit code based on results
    if results['summary']['error_years'] > 0:
        sys.exit(1)
    elif results['summary']['warning_years'] > 0:
        sys.exit(0)
    else:
        sys.exit(0)

if __name__ == '__main__':
    main()

