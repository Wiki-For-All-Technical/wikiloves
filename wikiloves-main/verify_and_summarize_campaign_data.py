"""
Script to verify the mapping between query files and campaigns,
and create a summary of all campaign data.
"""

import json
import os
from collections import defaultdict

# Read the SQL file to extract campaign names in order
sql_file = 'wikiloves-main/backend/queries/comprehensive_campaign_queries.sql'
campaigns = []

with open(sql_file, 'r', encoding='utf-8') as f:
    content = f.read()
    # Extract campaign names from comments like "-- Campaign: Africa"
    import re
    matches = re.findall(r'-- Campaign: (.+)', content)
    campaigns = [m.strip() for m in matches]

print(f"Found {len(campaigns)} campaigns in SQL file\n")

# Verify each query file
data_dir = 'wikiloves-main/wiki_loves_campaign_data'
summary = []
total_files = 0
total_uploads = 0
total_uploaders = 0
total_images_used = 0
total_new_uploaders = 0

for i, campaign in enumerate(campaigns, 1):
    query_file = os.path.join(data_dir, f'query{i}.json')
    
    if not os.path.exists(query_file):
        print(f"⚠️  WARNING: query{i}.json not found for campaign: {campaign}")
        summary.append({
            'query_num': i,
            'campaign': campaign,
            'status': 'missing',
            'years': 0,
            'total_uploads': 0,
            'total_uploaders': 0,
            'total_images_used': 0,
            'total_new_uploaders': 0
        })
        continue
    
    try:
        with open(query_file, 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        rows = data.get('rows', [])
        if not rows:
            print(f"⚠️  WARNING: query{i}.json is empty for campaign: {campaign}")
            summary.append({
                'query_num': i,
                'campaign': campaign,
                'status': 'empty',
                'years': 0,
                'total_uploads': 0,
                'total_uploaders': 0,
                'total_images_used': 0,
                'total_new_uploaders': 0
            })
            continue
        
        # Aggregate statistics
        years = set()
        campaign_uploads = 0
        campaign_uploaders = set()
        campaign_images_used = 0
        campaign_new_uploaders = set()
        
        for row in rows:
            year = row[0]
            uploads = row[3]
            uploaders = row[4]
            images_used = row[5]
            new_uploaders = row[6]
            
            years.add(year)
            campaign_uploads += uploads
            campaign_uploaders.add(uploaders)  # This is actually a count, not a set
            campaign_images_used += images_used
            if new_uploaders:
                campaign_new_uploaders.add(new_uploaders)  # This is also a count
        
        # Note: uploaders and new_uploaders in the data are already counts, not sets
        # We need to recalculate properly - but for now, use max as approximation
        max_uploaders = max([row[4] for row in rows]) if rows else 0
        max_new_uploaders = max([row[6] for row in rows]) if rows else 0
        
        summary.append({
            'query_num': i,
            'campaign': campaign,
            'status': 'ok',
            'years': sorted(years, reverse=True),
            'year_count': len(years),
            'total_uploads': campaign_uploads,
            'max_uploaders': max_uploaders,
            'total_images_used': campaign_images_used,
            'max_new_uploaders': max_new_uploaders,
            'categories': len(rows)
        })
        
        total_files += 1
        total_uploads += campaign_uploads
        total_images_used += campaign_images_used
        
    except Exception as e:
        print(f"❌ ERROR processing query{i}.json for campaign {campaign}: {e}")
        summary.append({
            'query_num': i,
            'campaign': campaign,
            'status': 'error',
            'error': str(e)
        })

# Print summary
print("=" * 80)
print("CAMPAIGN DATA SUMMARY")
print("=" * 80)
print(f"\nTotal campaigns: {len(campaigns)}")
print(f"Files found: {total_files}")
print(f"Total uploads across all campaigns: {total_uploads:,}")
print(f"Total images used across all campaigns: {total_images_used:,}")

# Print top campaigns by uploads
print("\n" + "=" * 80)
print("TOP 10 CAMPAIGNS BY UPLOADS")
print("=" * 80)
sorted_by_uploads = sorted([s for s in summary if s.get('status') == 'ok'], 
                          key=lambda x: x.get('total_uploads', 0), reverse=True)

for i, camp in enumerate(sorted_by_uploads[:10], 1):
    print(f"{i:2}. {camp['campaign']:30} | "
          f"Uploads: {camp['total_uploads']:>10,} | "
          f"Years: {camp['year_count']:>2} | "
          f"Categories: {camp['categories']:>3}")

# Print campaigns with most years
print("\n" + "=" * 80)
print("CAMPAIGNS WITH MOST YEARS OF DATA")
print("=" * 80)
sorted_by_years = sorted([s for s in summary if s.get('status') == 'ok'], 
                        key=lambda x: x.get('year_count', 0), reverse=True)

for i, camp in enumerate(sorted_by_years[:10], 1):
    years_str = ', '.join(map(str, camp['years'][:5]))
    if len(camp['years']) > 5:
        years_str += f" ... ({len(camp['years'])} total)"
    print(f"{i:2}. {camp['campaign']:30} | "
          f"Years: {camp['year_count']:>2} ({years_str})")

# Check for missing or empty files
missing = [s for s in summary if s.get('status') in ['missing', 'empty', 'error']]
if missing:
    print("\n" + "=" * 80)
    print("ISSUES FOUND")
    print("=" * 80)
    for issue in missing:
        print(f"Query {issue['query_num']:2} ({issue['campaign']:30}): {issue['status']}")

print("\n" + "=" * 80)
print("Summary complete!")
print("=" * 80)



