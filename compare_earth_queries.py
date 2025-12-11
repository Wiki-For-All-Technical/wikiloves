"""Compare Earth query results"""
import json

# Reference data
reference = {
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

# Load query results
with open('wikiloves-main/wiki_loves_campaign_data/Earth_query1.json', 'r', encoding='utf-8') as f:
    query1 = json.load(f)

with open('wikiloves-main/wiki_loves_campaign_data/Earth_query2.json', 'r', encoding='utf-8') as f:
    query2 = json.load(f)

print("=" * 80)
print("EARTH QUERY COMPARISON")
print("=" * 80)
print(f"\n{'Year':<6} {'Query1 Uploads':<15} {'Query2 Uploads':<15} {'Reference':<12} {'Status'}")
print("-" * 80)

for row in sorted(query1['rows'], key=lambda x: x[0]):
    year = row[0]
    q1_uploads = row[1]
    q2_uploads = query2['rows'][query2['rows'].index([y for y in query2['rows'] if y[0] == year][0])][1]
    
    if year in reference:
        ref_uploads = reference[year]['uploads']
        diff1 = abs(q1_uploads - ref_uploads)
        diff2 = abs(q2_uploads - ref_uploads)
        pct1 = (diff1 / ref_uploads * 100) if ref_uploads > 0 else 0
        pct2 = (diff2 / ref_uploads * 100) if ref_uploads > 0 else 0
        
        if pct1 < 5:
            status = "✓ OK"
        elif pct1 < 10:
            status = "⚠ Close"
        else:
            status = "❌ Wrong"
        
        print(f"{year:<6} {q1_uploads:>13,} {q2_uploads:>13,} {ref_uploads:>10,} {status:>10}")
    else:
        print(f"{year:<6} {q1_uploads:>13,} {q2_uploads:>13,} {'N/A':>10}")

print("\n" + "=" * 80)
print("NOTE: Both queries return the same upload counts.")
print("2013 still shows only 31 uploads (should be 9,655).")
print("This means the query pattern is missing some 2013 categories.")
print("\nRun the query in: backend/queries/find_earth_2013_categories.sql")
print("to find what categories we're missing.")



