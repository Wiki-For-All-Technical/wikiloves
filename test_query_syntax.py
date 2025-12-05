"""
Test SQL query syntax by extracting a sample query and validating it
"""
import re

# Read the generated queries file
with open('wikiloves-main/backend/queries/comprehensive_campaign_queries.sql', 'r', encoding='utf-8') as f:
    content = f.read()

# Extract first few queries
queries = re.split(r'-- ============================================\n-- CAMPAIGN:', content)

print(f"Total queries found: {len(queries) - 1}")  # -1 because first split is header

# Check for common SQL syntax issues
issues = []

# Check for duplicate patterns
duplicate_pattern = re.compile(r"cl\.cl_to LIKE '([^']+)'\s+OR\s+cl\.cl_to LIKE '\1'")
for i, query in enumerate(queries[1:6], 1):  # Check first 5 queries
    if duplicate_pattern.search(query):
        campaign_match = re.search(r'CAMPAIGN: ([^\n]+)', query)
        campaign = campaign_match.group(1) if campaign_match else f"Query {i}"
        issues.append(f"Query {i} ({campaign}): Duplicate LIKE pattern found")

# Check for missing year ranges
for i, query in enumerate(queries[1:6], 1):
    if 'BETWEEN' not in query and 'Years: Unknown' in query:
        campaign_match = re.search(r'CAMPAIGN: ([^\n]+)', query)
        campaign = campaign_match.group(1) if campaign_match else f"Query {i}"
        issues.append(f"Query {i} ({campaign}): Missing year range")

# Check for proper JOIN syntax
for i, query in enumerate(queries[1:6], 1):
    if 'INNER JOIN image' not in query:
        campaign_match = re.search(r'CAMPAIGN: ([^\n]+)', query)
        campaign = campaign_match.group(1) if campaign_match else f"Query {i}"
        issues.append(f"Query {i} ({campaign}): Missing INNER JOIN image")

if issues:
    print("\n⚠️  Issues found:")
    for issue in issues:
        print(f"  - {issue}")
else:
    print("\n✅ No syntax issues found in sample queries")

# Show sample query structure
print("\n" + "="*60)
print("Sample Query Structure (first query):")
print("="*60)
if len(queries) > 1:
    sample = queries[1].split('\n')[:50]  # First 50 lines
    print('\n'.join(sample))
    print("...")

