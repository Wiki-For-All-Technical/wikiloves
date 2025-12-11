"""Identify campaigns with significant data discrepancies"""
import sys
sys.path.insert(0, 'wikiloves-main/backend')
from data.catalog import COMPETITIONS

# Reference data for Earth (from reference website)
EARTH_REFERENCE = {
    2013: {'uploads': 9655, 'uploaders': 346},
    2014: {'uploads': 62351, 'uploaders': 2882},
    2015: {'uploads': 95867, 'uploaders': 8785},
    2016: {'uploads': 109010, 'uploaders': 13090},
    2017: {'uploads': 129553, 'uploaders': 14972},
    2018: {'uploads': 88909, 'uploaders': 7545},
    2019: {'uploads': 93768, 'uploaders': 9603},
    2020: {'uploads': 105403, 'uploaders': 8992},
    2021: {'uploads': 62639, 'uploaders': 4510},
    2022: {'uploads': 50472, 'uploaders': 4109},
    2023: {'uploads': 60249, 'uploaders': 3397},
    2024: {'uploads': 79490, 'uploaders': 3861},
    2025: {'uploads': 79233, 'uploaders': 5260},
}

print("=" * 80)
print("CAMPAIGNS WITH DATA DISCREPANCIES")
print("=" * 80)
print("\n⚠️  These campaigns likely need re-querying with multiyear summary queries")
print("   (GROUP BY year only, not GROUP BY year, category_name, country)\n")

issues_found = []

# Check Earth campaign
earth = [c for c in COMPETITIONS if 'earth' in c['slug']]
if earth:
    earth = earth[0]
    print(f"\n📍 {earth['name']} (slug: {earth['slug']})")
    print("-" * 80)
    
    for year_data in sorted(earth['years'], key=lambda x: x['year']):
        year = year_data['year']
        if year in EARTH_REFERENCE:
            ref = EARTH_REFERENCE[year]
            our_uploads = year_data['uploads']
            ref_uploads = ref['uploads']
            
            upload_diff = abs(our_uploads - ref_uploads)
            upload_pct = (upload_diff / ref_uploads * 100) if ref_uploads > 0 else 0
            
            if upload_pct > 5:  # More than 5% difference
                issues_found.append({
                    'campaign': earth['name'],
                    'year': year,
                    'our': our_uploads,
                    'ref': ref_uploads,
                    'diff_pct': upload_pct
                })
                status = "❌ WRONG"
            else:
                status = "✓ OK"
            
            print(f"  {year}: {our_uploads:>8,} vs {ref_uploads:>8,} ref ({upload_pct:>5.1f}% diff) {status}")

print("\n" + "=" * 80)
print("SUMMARY")
print("=" * 80)
print(f"\nFound {len(issues_found)} year(s) with significant discrepancies (>5%):")
for issue in issues_found:
    print(f"  - {issue['campaign']} {issue['year']}: {issue['diff_pct']:.1f}% difference")

if issues_found:
    print("\n" + "=" * 80)
    print("RECOMMENDED ACTION")
    print("=" * 80)
    print("\n1. Open: wikiloves-main/backend/queries/multiyear_summary_queries.sql")
    print("2. Find the query for the campaign(s) with issues")
    print("3. Run it in Quarry (https://quarry.wmcloud.org)")
    print("4. Download as JSON")
    print("5. Replace the corresponding queryN.json file")
    print("6. Re-run: python wikiloves-main/backend/scripts/process_all_campaigns.py")
    print("\nThe multiyear summary queries GROUP BY year only, which gives accurate totals.")
else:
    print("\n✅ No significant discrepancies found!")



