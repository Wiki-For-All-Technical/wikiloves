"""Verify Earth data against reference website"""
import sys
sys.path.insert(0, 'wikiloves-main/backend')
from data.catalog import COMPETITIONS

# Reference data from wikiloves.toolforge.org
reference_data = {
    2013: {'uploads': 9655, 'uploaders': 346, 'countries': 1},
    2014: {'uploads': 62351, 'uploaders': 2882, 'countries': 14},
    2015: {'uploads': 95867, 'uploaders': 8785, 'countries': 25},
    2016: {'uploads': 109010, 'uploaders': 13090, 'countries': 24},
    2017: {'uploads': 129553, 'uploaders': 14972, 'countries': 36},
    2018: {'uploads': 88909, 'uploaders': 7545, 'countries': 32},
    2019: {'uploads': 93768, 'uploaders': 9603, 'countries': 37},
    2020: {'uploads': 105403, 'uploaders': 8992, 'countries': 34},
    2021: {'uploads': 62639, 'uploaders': 4510, 'countries': 35},
    2022: {'uploads': 50472, 'uploaders': 4109, 'countries': 39},
    2023: {'uploads': 60249, 'uploaders': 3397, 'countries': 50},
    2024: {'uploads': 79490, 'uploaders': 3861, 'countries': 57},
    2025: {'uploads': 79233, 'uploaders': 5260, 'countries': 56},
}

earth = [c for c in COMPETITIONS if 'earth' in c['slug']][0]

print("Earth Data Comparison:")
print("=" * 80)
print(f"{'Year':<6} {'Reference Uploads':<18} {'Our Uploads':<15} {'Diff':<10} {'Match'}")
print("-" * 80)

for year_data in sorted(earth['years'], key=lambda x: x['year']):
    year = year_data['year']
    our_uploads = year_data['uploads']
    
    if year in reference_data:
        ref_uploads = reference_data[year]['uploads']
        diff = our_uploads - ref_uploads
        pct_diff = (diff / ref_uploads * 100) if ref_uploads > 0 else 0
        match = "✓" if abs(pct_diff) < 5 else "✗"
        print(f"{year:<6} {ref_uploads:>15,} {our_uploads:>15,} {diff:>+10,} ({pct_diff:+.1f}%) {match}")
    else:
        print(f"{year:<6} {'N/A':<18} {our_uploads:>15,}")

print("\n" + "=" * 80)
print("Note: Large differences indicate the query may not be capturing all categories.")



