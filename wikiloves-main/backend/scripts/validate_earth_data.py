"""
Validate Wiki Loves Earth data completeness and accuracy.

This script checks:
1. All required years are present (2013-2025)
2. Data structure is correct
3. Totals match between year summary and country breakdowns
4. Values match expected data from wikiloves.toolforge.org (where available)
"""

import json
import os
import sys
from typing import Dict, List, Optional

# Known reference values from wikiloves.toolforge.org
KNOWN_VALUES = {
    2013: {
        'countries': 1,
        'uploads': 9655,
        'uploaders': 346,
        'images_used': 9394,
        'new_uploaders': 275,
        'country_stats': [
            {'name': 'Ukraine', 'uploads': 9655, 'uploaders': 346}
        ]
    },
    # Add more known values as needed for validation
}


def validate_year_data(year: int, year_data: Dict, known_values: Optional[Dict] = None) -> List[str]:
    """
    Validate data for a single year.
    Returns list of validation errors (empty if valid).
    """
    errors = []
    
    # Check required fields
    required_fields = ['year', 'uploads', 'uploaders', 'images_used', 'new_uploaders', 'countries', 'country_stats']
    for field in required_fields:
        if field not in year_data:
            errors.append(f"Missing required field: {field}")
    
    if errors:
        return errors
    
    # Check data types
    if not isinstance(year_data['uploads'], int) or year_data['uploads'] < 0:
        errors.append(f"Invalid uploads value: {year_data['uploads']}")
    if not isinstance(year_data['uploaders'], int) or year_data['uploaders'] < 0:
        errors.append(f"Invalid uploaders value: {year_data['uploaders']}")
    if not isinstance(year_data['countries'], int) or year_data['countries'] < 0:
        errors.append(f"Invalid countries value: {year_data['countries']}")
    
    # Check country_stats structure
    country_stats = year_data.get('country_stats', [])
    if not isinstance(country_stats, list):
        errors.append("country_stats must be a list")
    else:
        # Verify country count matches
        if len(country_stats) != year_data['countries']:
            errors.append(
                f"Country count mismatch: countries={year_data['countries']}, "
                f"country_stats.length={len(country_stats)}"
            )
        
        # Check each country stat
        country_uploads_total = 0
        for i, country_stat in enumerate(country_stats):
            if 'name' not in country_stat:
                errors.append(f"Country stat {i} missing 'name' field")
            if 'uploads' not in country_stat:
                errors.append(f"Country stat {i} missing 'uploads' field")
            else:
                country_uploads_total += country_stat.get('uploads', 0)
            
            # Check rank
            expected_rank = i + 1
            if country_stat.get('rank') != expected_rank:
                errors.append(
                    f"Country '{country_stat.get('name')}' has incorrect rank: "
                    f"expected {expected_rank}, got {country_stat.get('rank')}"
                )
        
        # Check totals match
        # Note: This may not match exactly if uploaders are counted across countries
        if abs(country_uploads_total - year_data['uploads']) > 100:
            errors.append(
                f"Uploads mismatch: year total={year_data['uploads']}, "
                f"country sum={country_uploads_total} (difference: {abs(country_uploads_total - year_data['uploads'])})"
            )
    
    # Check percentages
    uploads = year_data.get('uploads', 0)
    uploaders = year_data.get('uploaders', 0)
    images_used = year_data.get('images_used', 0)
    new_uploaders = year_data.get('new_uploaders', 0)
    
    if uploads > 0:
        expected_images_used_pct = round((images_used / uploads) * 100, 2)
        actual_pct = year_data.get('images_used_pct', 0)
        if abs(expected_images_used_pct - actual_pct) > 0.1:
            errors.append(
                f"images_used_pct mismatch: expected {expected_images_used_pct}, "
                f"got {actual_pct}"
            )
    
    if uploaders > 0:
        expected_new_uploaders_pct = round((new_uploaders / uploaders) * 100, 2)
        actual_pct = year_data.get('new_uploaders_pct', 0)
        if abs(expected_new_uploaders_pct - actual_pct) > 0.1:
            errors.append(
                f"new_uploaders_pct mismatch: expected {expected_new_uploaders_pct}, "
                f"got {actual_pct}"
            )
    
    # Compare with known values if available
    if known_values:
        known = known_values.get(year)
        if known:
            for field in ['countries', 'uploads', 'uploaders', 'images_used', 'new_uploaders']:
                if field in known and year_data.get(field) != known[field]:
                    errors.append(
                        f"Value mismatch with known data: {field} = {year_data.get(field)}, "
                        f"expected {known[field]} (from wikiloves.toolforge.org)"
                    )
    
    return errors


def validate_earth_data(data: Dict, known_values: Optional[Dict] = None) -> Dict:
    """
    Validate complete Earth data structure.
    Returns validation results dictionary.
    """
    results = {
        'valid': True,
        'errors': [],
        'warnings': [],
        'year_validations': {}
    }
    
    # Check top-level structure
    if data.get('campaign') != 'earth':
        results['errors'].append(f"Expected campaign 'earth', got '{data.get('campaign')}'")
        results['valid'] = False
    
    if 'years' not in data:
        results['errors'].append("Missing 'years' field")
        results['valid'] = False
        return results
    
    years = data.get('years', [])
    if not isinstance(years, list):
        results['errors'].append("'years' must be a list")
        results['valid'] = False
        return results
    
    # Check all required years are present (2013-2025)
    expected_years = set(range(2013, 2026))
    actual_years = {year_data.get('year') for year_data in years if year_data.get('year')}
    missing_years = expected_years - actual_years
    if missing_years:
        results['warnings'].append(f"Missing years: {sorted(missing_years)}")
    
    extra_years = actual_years - expected_years
    if extra_years:
        results['warnings'].append(f"Unexpected years: {sorted(extra_years)}")
    
    # Validate each year
    for year_data in years:
        year = year_data.get('year')
        if not year:
            results['errors'].append("Year entry missing 'year' field")
            results['valid'] = False
            continue
        
        year_errors = validate_year_data(year, year_data, known_values)
        results['year_validations'][year] = {
            'valid': len(year_errors) == 0,
            'errors': year_errors
        }
        
        if year_errors:
            results['errors'].extend([f"Year {year}: {err}" for err in year_errors])
            results['valid'] = False
    
    return results


def print_validation_results(results: Dict):
    """Print validation results in a readable format."""
    print("\n" + "=" * 80)
    print("EARTH DATA VALIDATION RESULTS")
    print("=" * 80)
    
    if results['valid']:
        print("\n✅ Validation PASSED")
    else:
        print("\n❌ Validation FAILED")
    
    if results['errors']:
        print(f"\nErrors ({len(results['errors'])}):")
        for error in results['errors']:
            print(f"  ❌ {error}")
    
    if results['warnings']:
        print(f"\nWarnings ({len(results['warnings'])}):")
        for warning in results['warnings']:
            print(f"  ⚠️  {warning}")
    
    # Print year-by-year results
    print(f"\nYear-by-Year Validation:")
    for year in sorted(results['year_validations'].keys()):
        year_result = results['year_validations'][year]
        status = "✅" if year_result['valid'] else "❌"
        print(f"  {status} Year {year}: ", end="")
        if year_result['valid']:
            print("Valid")
        else:
            print(f"{len(year_result['errors'])} error(s)")
            for error in year_result['errors'][:3]:  # Show first 3 errors
                print(f"      - {error}")
            if len(year_result['errors']) > 3:
                print(f"      ... and {len(year_result['errors']) - 3} more")
    
    print("\n" + "=" * 80)


def main():
    import argparse
    
    parser = argparse.ArgumentParser(
        description="Validate Wiki Loves Earth data"
    )
    parser.add_argument(
        "input_file",
        help="Path to processed Earth JSON file or catalog.py"
    )
    parser.add_argument(
        "--compare-known",
        action="store_true",
        help="Compare with known values from wikiloves.toolforge.org"
    )
    parser.add_argument(
        "--catalog",
        action="store_true",
        help="Input file is catalog.py (extract Earth data)"
    )
    
    args = parser.parse_args()
    
    input_path = args.input_file
    if not os.path.exists(input_path):
        print(f"❌ Error: File not found: {input_path}", file=sys.stderr)
        sys.exit(1)
    
    # Load data
    if args.catalog:
        # Load from catalog.py
        exec_globals = {}
        with open(input_path, 'r', encoding='utf-8') as f:
            exec(f.read(), exec_globals)
        
        competitions = exec_globals.get('COMPETITIONS', [])
        earth_comp = next((c for c in competitions if c.get('slug') == 'wiki-loves-earth'), None)
        
        if not earth_comp:
            print("❌ Error: Earth competition not found in catalog.py", file=sys.stderr)
            sys.exit(1)
        
        data = {
            'campaign': 'earth',
            'campaign_name': earth_comp.get('name', 'Wiki Loves Earth'),
            'years': earth_comp.get('years', [])
        }
    else:
        # Load from JSON
        with open(input_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
    
    # Validate
    known_values = KNOWN_VALUES if args.compare_known else None
    results = validate_earth_data(data, known_values)
    
    # Print results
    print_validation_results(results)
    
    # Exit with error code if validation failed
    sys.exit(0 if results['valid'] else 1)


if __name__ == "__main__":
    main()
