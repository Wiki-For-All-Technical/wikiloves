"""Check new_uploaders data for Earth and compare with reference"""
import sys
sys.path.insert(0, 'wikiloves-main/backend')
from data.catalog import COMPETITIONS

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

earth = [c for c in COMPETITIONS if 'earth' in c.get('slug', '').lower()]
if not earth:
    print("Earth campaign not found!")
    sys.exit(1)

earth = earth[0]
print("=" * 80)
print("EARTH NEW UPLOADERS COMPARISON")
print("=" * 80)
print(f"\n{'Year':<6} {'Our New':<12} {'Ref New':<12} {'Diff':<12} {'Our %':<8} {'Ref %':<8}")
print("-" * 80)

for year_data in sorted(earth['years'], key=lambda x: x['year']):
    year = year_data['year']
    our_new = year_data.get('new_uploaders', 0)
    our_uploaders = year_data.get('uploaders', 0)
    our_pct = round((our_new / our_uploaders * 100) if our_uploaders > 0 else 0, 1)
    
    if year in REFERENCE:
        ref_new = REFERENCE[year]['new_uploaders']
        ref_pct = REFERENCE[year]['new_pct']
        diff = ref_new - our_new
        diff_pct = round((diff / ref_new * 100) if ref_new > 0 else 0, 1)
        
        status = "✓" if abs(diff_pct) < 5 else "⚠" if abs(diff_pct) < 20 else "✗"
        print(f"{year:<6} {our_new:<12,} {ref_new:<12,} {diff:>+11,} ({diff_pct:>+5.1f}%) {our_pct:>6.1f}% {ref_pct:>6.1f}% {status}")
    else:
        print(f"{year:<6} {our_new:<12,} {'N/A':<12} {'N/A':<12} {our_pct:>6.1f}%")

print("\n" + "=" * 80)
print("SUMMARY")
print("=" * 80)
total_diff = 0
years_with_ref = 0
for year_data in sorted(earth['years'], key=lambda x: x['year']):
    year = year_data['year']
    if year in REFERENCE:
        our_new = year_data.get('new_uploaders', 0)
        ref_new = REFERENCE[year]['new_uploaders']
        total_diff += (ref_new - our_new)
        years_with_ref += 1

avg_diff = total_diff / years_with_ref if years_with_ref > 0 else 0
print(f"Average difference: {avg_diff:,.0f} uploaders per year")
print(f"Total difference across all years: {total_diff:,.0f} uploaders")
print("\nThe reference website likely uses a broader date range for 'registered after")
print("competition start' - possibly from May 1st through end of year, or just")
print("checking if registration >= May 1st of the competition year.")



