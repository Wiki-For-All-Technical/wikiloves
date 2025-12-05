"""Compare new_uploaders in JSON files with reference data"""
import json

# Reference data from wikiloves.toolforge.org
REFERENCE = {
    2013: {'uploaders': 346, 'new_uploaders': 275, 'new_pct': 79},
    2014: {'uploaders': 2882, 'new_uploaders': 2364, 'new_pct': 82},
    2015: {'uploaders': 8785, 'new_uploaders': 7700, 'new_pct': 87},
    2016: {'uploaders': 13090, 'new_uploaders': 11654, 'new_pct': 89},
    2017: {'uploaders': 14972, 'new_uploaders': 13629, 'new_pct': 91},
    2018: {'uploaders': 7545, 'new_uploaders': 6276, 'new_pct': 83},
    2019: {'uploaders': 9603, 'new_uploaders': 8314, 'new_pct': 86},
    2020: {'uploaders': 8992, 'new_uploaders': 7541, 'new_pct': 83},
    2021: {'uploaders': 4510, 'new_uploaders': 3512, 'new_pct': 77},
    2022: {'uploaders': 4109, 'new_uploaders': 3222, 'new_pct': 78},
    2023: {'uploaders': 3397, 'new_uploaders': 2376, 'new_pct': 69},
    2024: {'uploaders': 3861, 'new_uploaders': 2726, 'new_pct': 70},
    2025: {'uploaders': 5260, 'new_uploaders': 3680, 'new_pct': 70},
}

# Load query19.json (year summary)
with open('wikiloves-main/wiki_loves_campaign_data/query19.json', 'r', encoding='utf-8') as f:
    query19 = json.load(f)

# Load earth_complete_with_countries.json (country breakdown)
with open('wikiloves-main/wiki_loves_campaign_data/earth_complete_with_countries.json', 'r', encoding='utf-8') as f:
    earth_complete = json.load(f)

print("=" * 100)
print("COMPARISON: JSON Files vs Reference Data")
print("=" * 100)
print(f"\n{'Year':<6} {'query19.json':<15} {'earth_complete.json':<20} {'Reference':<15} {'Diff (query19)':<15} {'Status':<10}")
print("-" * 100)

# Get Global rows from earth_complete
global_rows = {row[0]: row[5] for row in earth_complete['rows'] if row[1] == 'Global'}

for row in sorted(query19['rows'], key=lambda x: x[0]):
    year = row[0]
    query19_new = row[4]  # new_uploaders is at index 4
    earth_complete_new = global_rows.get(year, 'N/A')
    
    if year in REFERENCE:
        ref_new = REFERENCE[year]['new_uploaders']
        diff = ref_new - query19_new
        diff_pct = round((diff / ref_new * 100) if ref_new > 0 else 0, 1)
        
        if abs(diff_pct) < 5:
            status = "✓ OK"
        elif abs(diff_pct) < 20:
            status = "⚠ WARNING"
        else:
            status = "✗ ERROR"
        
        earth_str = f"{earth_complete_new:,}" if earth_complete_new != 'N/A' else "N/A"
        print(f"{year:<6} {query19_new:<15,} {earth_str:<20} {ref_new:<15,} {diff:>+14,} ({diff_pct:>+5.1f}%) {status:<10}")
    else:
        earth_str = f"{earth_complete_new:,}" if earth_complete_new != 'N/A' else "N/A"
        print(f"{year:<6} {query19_new:<15,} {earth_str:<20} {'N/A':<15} {'N/A':<15} {'N/A':<10}")

print("\n" + "=" * 100)
print("NOTES:")
print("=" * 100)
print("1. query19.json: Year summary data (one row per year)")
print("2. earth_complete_with_countries.json: Country breakdown data (multiple rows per year)")
print("3. Both files appear to still use the OLD date range (May 1-31 only)")
print("4. They need to be updated with the FIXED queries (May 1 - Dec 31)")
print("\n2013 ISSUE:")
print("- query19.json shows 0 new_uploaders for 2013 (should be ~275)")
print("- earth_complete_with_countries.json has no Global row for 2013")
print("- This suggests 2013 data needs to be re-queried with the fixed date range")



