"""Compare all years from query19.json with reference data"""
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

# Load query19.json
with open('wikiloves-main/wiki_loves_campaign_data/query19.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

print("=" * 90)
print("EARTH NEW UPLOADERS - COMPLETE COMPARISON")
print("=" * 90)
print(f"\n{'Year':<6} {'Our New':<12} {'Ref New':<12} {'Diff':<15} {'Our %':<8} {'Ref %':<8} {'Status':<10}")
print("-" * 90)

total_diff = 0
years_with_ref = 0
ok_count = 0
warning_count = 0
error_count = 0

for row in sorted([r for r in data['rows'] if r[0] != 0], key=lambda x: x[0]):
    year = row[0]
    our_new = row[4]  # new_uploaders
    our_uploaders = row[2]  # uploaders
    our_pct = round((our_new / our_uploaders * 100) if our_uploaders > 0 else 0, 1)
    
    if year in REFERENCE:
        ref_new = REFERENCE[year]['new_uploaders']
        ref_pct = REFERENCE[year]['new_pct']
        diff = ref_new - our_new
        diff_pct = round((diff / ref_new * 100) if ref_new > 0 else 0, 1)
        
        if abs(diff_pct) < 5:
            status = "✓ OK"
            ok_count += 1
        elif abs(diff_pct) < 20:
            status = "⚠ WARNING"
            warning_count += 1
        else:
            status = "✗ ERROR"
            error_count += 1
        
        print(f"{year:<6} {our_new:<12,} {ref_new:<12,} {diff:>+14,} ({diff_pct:>+5.1f}%) {our_pct:>6.1f}% {ref_pct:>6.1f}% {status:<10}")
        
        total_diff += abs(diff)
        years_with_ref += 1

print("\n" + "=" * 90)
print("SUMMARY")
print("=" * 90)
print(f"Total years compared: {years_with_ref}")
print(f"✓ OK (< 5% difference): {ok_count}")
print(f"⚠ WARNING (5-20% difference): {warning_count}")
print(f"✗ ERROR (> 20% difference): {error_count}")
print(f"\nAverage absolute difference: {total_diff / years_with_ref:,.0f} uploaders per year")
print(f"Total absolute difference: {total_diff:,.0f} uploaders")



