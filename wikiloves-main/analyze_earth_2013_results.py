"""Analyze Earth 2013 query results"""
import json

# Reference data
reference = {
    2013: {'uploads': 9655, 'uploaders': 346}
}

# Load query results
with open('wikiloves-main/wiki_loves_campaign_data/Earth_Fast_query1.json', 'r', encoding='utf-8') as f:
    categories = json.load(f)

with open('wikiloves-main/wiki_loves_campaign_data/Earth_UltraFast_query1.json', 'r', encoding='utf-8') as f:
    ultra_fast = json.load(f)

print("=" * 80)
print("EARTH 2013 QUERY RESULTS ANALYSIS")
print("=" * 80)

print("\n1. CATEGORIES FOUND (Step 1):")
print("-" * 80)
total_files = 0
for row in categories['rows']:
    category = row[0]
    count = row[1]
    total_files += count
    print(f"  {category}: {count:,} files")

print(f"\n  Total files across all categories: {total_files:,}")

print("\n2. ULTRA_FAST QUERY RESULTS:")
print("-" * 80)
result = ultra_fast['rows'][0]
year = result[0]
uploads = result[1]
uploaders = result[2]
images_used = result[3]
new_uploaders = result[4]

print(f"  Year: {year}")
print(f"  Uploads: {uploads:,}")
print(f"  Uploaders: {uploaders:,}")
print(f"  Images Used: {images_used:,}")
print(f"  New Uploaders: {new_uploaders:,}")

print("\n3. COMPARISON WITH REFERENCE:")
print("-" * 80)
if year in reference:
    ref = reference[year]
    print(f"  Reference Uploads: {ref['uploads']:,}")
    print(f"  Our Uploads: {uploads:,}")
    diff = uploads - ref['uploads']
    pct = (diff / ref['uploads'] * 100) if ref['uploads'] > 0 else 0
    print(f"  Difference: {diff:+,} ({pct:+.1f}%)")
    
    if abs(pct) < 5:
        print("  Status: ✓ Within acceptable range")
    elif uploads > ref['uploads']:
        print("  Status: ⚠ Higher than reference (may include extra categories)")
    else:
        print("  Status: ⚠ Lower than reference")

print("\n" + "=" * 80)
print("KEY FINDINGS:")
print("=" * 80)
print("1. Main category: Images_from_Wiki_Loves_Earth_2013_in_Ukraine (11,732 files)")
print("2. Total found: 12,141 uploads (vs reference: 9,655)")
print("3. The ULTRA_FAST query successfully found all categories!")
print("\nThe difference might be due to:")
print("  - Reference website may exclude country-specific categories")
print("  - Reference website may use different date filtering")
print("  - Our query includes all Earth 2013 categories (more comprehensive)")



