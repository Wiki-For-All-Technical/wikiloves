"""Generate multiyear summary queries (GROUP BY year only) for accurate totals"""
import json

# Read the campaign list
with open('wikiloves-main/quarry_data/query4.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

campaigns = []
for row in data.get('rows', []):
    campaign_name = row[0] if len(row) > 0 else ''
    if campaign_name:
        campaigns.append(campaign_name)

# Campaign-specific query patterns and date ranges
CAMPAIGN_CONFIGS = {
    'Africa': {
        'patterns': ['%Wiki_Loves_Africa%'],
        'start_month': '03', 'start_day': '01',
        'end_month': '03', 'end_day': '31'
    },
    'Earth': {
        'patterns': ['%Wiki_Loves_Earth%'],
        'start_month': '05', 'start_day': '01',
        'end_month': '05', 'end_day': '31'
    },
    'Monuments': {
        'patterns': ['%Wiki_Loves_Monuments%'],
        'start_month': '09', 'start_day': '01',
        'end_month': '09', 'end_day': '30'
    },
    'Folklore': {
        'patterns': ['%Wiki_Loves_Folklore%'],
        'start_month': '02', 'start_day': '01',
        'end_month': '02', 'end_day': '28'
    },
    'Science': {
        'patterns': ['%Wiki_Science_Competition%', '%Wiki_Loves_Science%'],
        'start_month': '11', 'start_day': '01',
        'end_month': '11', 'end_day': '30'
    },
}

def get_campaign_config(campaign_name):
    """Get configuration for a campaign"""
    for key, config in CAMPAIGN_CONFIGS.items():
        if key.lower() in campaign_name.lower():
            return config
    # Default
    return {
        'patterns': [f'%Wiki_Loves_{campaign_name}%', f'%{campaign_name}%'],
        'start_month': '01', 'start_day': '01',
        'end_month': '12', 'end_day': '31'
    }

def generate_multiyear_query(campaign_name, query_num):
    """Generate a multiyear summary query (GROUP BY year only)"""
    config = get_campaign_config(campaign_name)
    
    # Build WHERE clause with all patterns
    where_patterns = ' OR '.join([f"cl.cl_to LIKE '{pattern}'" for pattern in config['patterns']])
    
    query = f"""-- ============================================
-- {query_num}. {campaign_name.upper()} - MULTIYEAR SUMMARY
-- ============================================
-- Campaign: {campaign_name}
-- This query groups by YEAR only for accurate totals
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '{config['start_month']}{config['start_day']}000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '{config['end_month']}{config['end_day']}235959')
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title 
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
WHERE cl.cl_type = 'file'
  AND ({where_patterns})
  AND cl.cl_to REGEXP '[0-9]{{4}}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
GROUP BY year
ORDER BY year DESC;

"""
    return query

# Generate queries
queries = []
for i, campaign in enumerate(campaigns, 1):
    queries.append(generate_multiyear_query(campaign, i))

# Write to file
output_file = 'wikiloves-main/backend/queries/multiyear_summary_queries.sql'
with open(output_file, 'w', encoding='utf-8') as f:
    f.write("""-- ============================================
-- MULTIYEAR SUMMARY QUERIES (GROUP BY YEAR ONLY)
-- ============================================
-- These queries return accurate year totals by grouping by YEAR only
-- This matches the reference website approach
-- Database: commonswiki_p
-- 
-- USAGE:
-- 1. Copy the query for the campaign you need
-- 2. Run in Quarry (may take several minutes)
-- 3. Download as JSON
-- 4. Replace the corresponding queryN.json file
-- 5. Re-run: python backend/scripts/process_all_campaigns.py
-- ============================================

""")
    f.write('\n\n'.join(queries))

print(f"✅ Generated {len(queries)} multiyear summary queries")
print(f"   Output: {output_file}")
print("\n⚠️  IMPORTANT: These queries GROUP BY year only for accurate totals.")
print("   Re-run the queries for campaigns with wrong data (especially Earth 2013).")



