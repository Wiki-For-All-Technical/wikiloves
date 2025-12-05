"""
Script to generate comprehensive queries for all Wiki Loves campaigns.
Extracts campaign names and creates detailed statistics queries.
"""

import json
import re
from collections import defaultdict

# Read the campaign data
with open('wikiloves-main/quarry_data/query4.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

# Clean campaign names - map incorrectly extracted ones
campaign_cleanup = {
    'Earth_2015': 'Earth',
    'Earth_2016': 'Earth',
    'Earth_2017': 'Earth',
    'Earth_2018': 'Earth',
    'Folk_2016': 'Folk',
    'Folk_2017': 'Folk',
    'Heritage_Belgium_winners': 'Heritage_Belgium',
    'Heritage_Oost-Vlaanderen_nomination': 'Heritage_Belgium',
    'Heritage_Oost-Vlaanderen_winners': 'Heritage_Belgium',
    'Heritage_Vlaanderen_winners': 'Heritage_Belgium',
    'Monuments_exhibition': 'Monuments',
    'Monuments_Cologne': 'Monuments',
    'Monuments_Genova': 'Monuments',
    'Monuments_In_India': 'Monuments',
    'Monuments_Jurysitzung': 'Monuments',
    'Monuments_Meeting_Utrecht,_January': 'Monuments',
    'Monuments_Monumenten_Challenge': 'Monuments',
    'Monuments_Nantes': 'Monuments',
    'Monuments_Ukraine_Awards_Ceremony': 'Monuments',
    'Monuments_Workshop,_Wikimania': 'Monuments',
    'Monuments_Wuppertal': 'Monuments',
    'Monuments_at_the_Hackathon_Berlin': 'Monuments',
    'Monuments_international_team_offsite': 'Monuments',
    'Monuments_postcards': 'Monuments',
    'Monuments_2012_exhibition_at_GLAM-WIKI_UK': 'Monuments',
    'Monuments_2012_exhibition_at_Wikimania': 'Monuments',
    'Monuments_Brazil_photo_exhibition_at_WikiCon_Brasil': 'Monuments',
    'Puglia_exhibition': 'Puglia',
    'Puglia_photo_walks': 'Puglia',
    'Africa_Launch_and_Upload_Event': 'Africa',
    'Africa_Osun': 'Africa',
    'Africa_Unilorin': 'Africa',
    'Africa_at_Wikimania': 'Africa',
    'Africa_x_Wikimania': 'Africa',
    'Love_Workshop_Karnal': 'Love',
    'Love_meetup_at_Wikimania': 'Love',
    'Women_South_Asia': 'Women',
    'Women_at_Wikimania': 'Women',
    'Women_at_WikiConvention_francophone': 'Women',
    'Women_at_WikiIndaba': 'Women',
    'Women_-_Events': 'Women',
    'Women_SheSaid_In_Northern_Nigeria': 'Women',
    'Pride_Lagos': 'Pride',
    'Pride_editathon_at_IUPUI,': 'Pride',
    'Fashion_Nederland': 'Fashion',
    'Folklore_at_Indian_Photo_Festival': 'Folklore',
    'Folklore_photographic_contest': 'Folklore',
    'Living_Heritage_Bazaar_at_Wikimania': 'Living_Heritage',
    'Living_Heritage_Cordillera': 'Living_Heritage',
    'Living_Heritage_Sagada': 'Living_Heritage',
    'Living_Heritage_Zamboanga': 'Living_Heritage',
    'Living_Heritage_presentations_at_Wikimania': 'Living_Heritage',
    'Earth_-_Alde_Feanen_-_9_June': 'Earth',
    'Earth_-_Drents-Friese_Wold_-_15_June': 'Earth',
    'Earth_-_Drentsche_Aa_-_25_May': 'Earth',
    'Earth_-_Sallandse_Heuvelrug_-_25_May': 'Earth',
    'Earth_-_Utrechtse_Heuvelrug_-_25_May': 'Earth',
    'Earth_-_Weerribben-Wieden_-_3_May': 'Earth',
    'Earth_Biosphere_Reserves': 'Earth',
    'Earth_Biosphere_Reserves_and_UNESCO_Global_Geoparks': 'Earth',
    'Earth_Philippines': 'Earth',
    'Earth_by_Filo_gèn\'': 'Earth',
    'Earth_exposition': 'Earth',
    'Assamese_Culture_Photography_Competition': 'Assamese_Culture',
    'Bangla_&_Amar_Ekushey_Article_Contest_prize-giving_ceremony': 'Bangla',
    'Mangaluru/2024': 'Mangaluru',
    'Vizag/2024': 'Vizag',
    'Muziris_-': 'Muziris',
    'NYC_Parks_-_Prospect_Park': 'NYC_Parks',
    'Parliaments/Hamburg': 'Parliaments',
    'Public_Space_&_Ternat,_20_July': 'Public_Space',
    'Librarians,Corfu,': 'Librarians',
    'Litterature_Haitienne': 'Littérature_Haïtienne',
    'food': 'Food',
    'heritage_Ghana': 'Heritage_Ghana',
    'PLants': 'Plants',
    'Eemland,_9_October': 'Eemland',
    'Maps_expert_meeting,_Amsterdam,_24_May': 'Maps',
    'Maps_hackathon,_Helsinki,_February': 'Maps',
    'Stuff,_Wikimania': 'Stuff',
}

# Extract and clean campaign names
campaigns = set()
for row in data['rows']:
    campaign = row[0]
    # Skip Unknown
    if campaign == 'Unknown':
        continue
    # Apply cleanup
    if campaign in campaign_cleanup:
        campaign = campaign_cleanup[campaign]
    campaigns.add(campaign)

# Sort campaigns
sorted_campaigns = sorted(campaigns)

print(f"Found {len(sorted_campaigns)} unique campaigns:")
for i, camp in enumerate(sorted_campaigns, 1):
    print(f"{i}. {camp}")

# Map campaign names to category patterns
def get_category_pattern(campaign_name):
    """Get the category pattern for a campaign."""
    # Handle special cases
    if campaign_name == 'Science':
        return [
            "cl.cl_to LIKE '%Wiki_Science%' OR cl.cl_to LIKE '%WikiScience%'"
        ]
    
    # Convert campaign name to category pattern
    # Handle multi-word campaigns
    campaign_slug = campaign_name.replace(' ', '_').replace('-', '_')
    
    patterns = [
        f"cl.cl_to LIKE 'Images_from_Wiki_Loves_{campaign_slug}_%'",
        f"cl.cl_to LIKE 'Wiki_Loves_{campaign_slug}_%'",
    ]
    
    return patterns

def generate_query(campaign_name, query_num):
    """Generate comprehensive query for a campaign."""
    patterns = get_category_pattern(campaign_name)
    pattern_condition = ' OR '.join(patterns)
    
    # Determine year range (use broad range, will filter by actual data)
    year_range = "BETWEEN 2010 AND 2025"
    
    # Determine campaign month for new_uploaders (default to September for most)
    # This is a simplification - actual months vary by campaign
    campaign_month = "09"  # Default to September
    
    query = f"""-- ============================================
-- {query_num}. WIKI LOVES {campaign_name.upper().replace('_', ' ')}
-- ============================================
-- Campaign: {campaign_name}
-- Comprehensive statistics query
-- Database: commonswiki_p
-- ============================================

SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    cl.cl_to AS category_name,
    CASE 
        WHEN cl.cl_to LIKE '%_in_%' THEN
            REPLACE(SUBSTRING_INDEX(cl.cl_to, '_in_', -1), '_', ' ')
        ELSE 'Global'
    END AS country,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '{campaign_month}01000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '{campaign_month}30235959')
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
  AND ({pattern_condition})
  AND cl.cl_to REGEXP '[0-9]{{4}}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) {year_range}
GROUP BY year, category_name, country
ORDER BY year DESC, uploads DESC;

"""
    return query

# Generate all queries
queries = []
for i, campaign in enumerate(sorted_campaigns, 1):
    query = generate_query(campaign, i)
    queries.append(query)

# Write to file
output_file = 'wikiloves-main/backend/queries/comprehensive_campaign_queries.sql'
with open(output_file, 'w', encoding='utf-8') as f:
    f.write("""-- ============================================
-- COMPREHENSIVE QUERIES FOR ALL WIKI LOVES CAMPAIGNS
-- ============================================
-- This file contains detailed statistics queries for all Wiki Loves campaigns
-- Each query returns: year, category_name, country, uploads, uploaders, images_used, new_uploaders
-- Database: commonswiki_p
-- 
-- USAGE:
-- 1. Find the query for your campaign
-- 2. Run in Quarry (may take time for large campaigns)
-- 3. Results show statistics per year, category, and country
-- ============================================

""")
    f.write('\n'.join(queries))
    f.write(f"""
-- ============================================
-- SUMMARY
-- ============================================
-- Total campaigns: {len(sorted_campaigns)}
-- Generated: {len(queries)} queries
-- ============================================
""")

print(f"\nGenerated {len(queries)} queries in {output_file}")
print(f"Total campaigns: {len(sorted_campaigns)}")
