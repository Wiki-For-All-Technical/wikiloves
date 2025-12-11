import json
import re
from collections import defaultdict

# Read the query4.json to get campaigns with data
with open('wikiloves-main/quarry_data/query4.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

# Also read the original campaign list
with open('wikiloves-main/quarry_data/wikiloves campaign.json', 'r', encoding='utf-8') as f:
    all_categories = json.load(f)

# Extract unique campaign names from categories
campaigns_from_categories = set()
for row in all_categories['rows']:
    category = row[0]
    
    # Skip technical/event categories
    if any(skip in category for skip in ['Files_uploaded_via', 'Maintenance_for', 'Out_of_scope', 
                                         'Accepted_', 'Quality_', 'Featured_', 'GLAM_', 'Art_nouveau', 
                                         'WWI_related', 'Best_', 'Winners_of', 'Winning_media', 
                                         'Valued_', 'Banners_', 'Banner_', 'Poster_', 'Flyers_',
                                         'Session_at', 'Evento_', 'Exhibition_', 'Exhibitions_',
                                         'Exposition_', 'Inaugurazione', 'ItWikiCon', 'Itzehoe',
                                         'Local_editions', 'Files_by_User', 'Photographs_by',
                                         'Photo_challenge', 'Photo_essay', 'Photo\'s_by',
                                         'Image_by', 'Image_from', 'Images_by', 'Images_de',
                                         'Images_for', 'Images_of', 'Images_sets', 'Image_sets',
                                         'Atelier_de', 'Conferenza', 'Editatona', 'Edit-a-thon',
                                         'Award_ceremony', 'Prijsuitreiking', 'Premiaci', 'Premia',
                                         'Preisverleihung', 'Showcase_of', 'NCPUG', 'Taxonomy',
                                         'BirdWalks', 'Clip_Videos', 'Narrative_Videos', 'Reportage_Videos',
                                         'Finalist_Videos', 'Videos_of', 'Videos_in', 'Videos_from',
                                         'Audio_from', 'Audios_from', 'Sounds_from', 'Music_by',
                                         'My_Wiki_Loves', 'Wiki_Goes', 'Https://', 'User:',
                                         'Uploaded_via_Campaign', 'Unreviewed', 'Ineligible',
                                         'Obviously_ineligible', 'Low-resolution', 'Low_quality',
                                         'Noisy', 'Blurred', 'Panoramas', 'Panoramic', 'Panaoramas',
                                         'Potential_candidates', 'Nominated', 'National_finalists',
                                         'Highlighted_content', 'Graphics', 'General_category',
                                         'General_from', 'Fynbos', 'Astronomy', 'Microscopy',
                                         'Wildlife_and_nature', 'Non-photographic', 'People_in_Science',
                                         'Living_organisms', 'Mobile_Photography', 'Sets_category',
                                         'Imágenes', 'OSLUCA', 'Claude_Truong', 'Aishik_Rehman',
                                         'Anup_Sadi', 'Biswarup_Ganguly', 'Dolon_Prova', 'MS_Sakib',
                                         'Md._Giashuddin', 'Mehedi_Abedin', 'Muhammad_Yahya',
                                         'Rocky_Masum', 'Shabab_Mustafa', 'Subrata_Roy']):
        continue
    
    # Extract campaign name
    if 'Wiki_Science' in category or 'WikiScience' in category:
        campaigns_from_categories.add('Science')
    elif 'Wiki_Loves_' in category:
        # Extract campaign name - try to get the main campaign
        match = re.search(r'Wiki_Loves_([A-Za-z_]+?)(?:_\d{4}|_in_|$)', category)
        if match:
            campaign = match.group(1)
            # Normalize common patterns
            if campaign.startswith('Monuments_'):
                campaigns_from_categories.add('Monuments')
            elif campaign.startswith('Earth_'):
                campaigns_from_categories.add('Earth')
            elif campaign.startswith('Heritage_'):
                if 'Belgium' in campaign:
                    campaigns_from_categories.add('Heritage_Belgium')
                else:
                    campaigns_from_categories.add('Heritage')
            elif campaign.startswith('Living_Heritage'):
                campaigns_from_categories.add('Living_Heritage')
            elif campaign.startswith('Public_Art'):
                campaigns_from_categories.add('Public_Art')
            elif campaign.startswith('Folk_'):
                campaigns_from_categories.add('Folk')
            elif campaign.startswith('Fashion_'):
                if 'Nederland' in campaign:
                    campaigns_from_categories.add('Fashion_Nederland')
                else:
                    campaigns_from_categories.add('Fashion')
            elif campaign.startswith('Women_'):
                if 'South_Asia' in campaign:
                    campaigns_from_categories.add('Women_South_Asia')
                elif 'at_Wikimania' in campaign:
                    campaigns_from_categories.add('Women_at_Wikimania')
                else:
                    campaigns_from_categories.add('Women')
            elif campaign.startswith('Pride_'):
                campaigns_from_categories.add('Pride')
            elif campaign.startswith('Puglia_'):
                campaigns_from_categories.add('Puglia')
            elif campaign.startswith('Museums_'):
                campaigns_from_categories.add('Museums')
            elif campaign.startswith('Birds_'):
                campaigns_from_categories.add('Birds')
            elif campaign.startswith('Assamese_Culture'):
                campaigns_from_categories.add('Assamese_Culture')
            elif campaign.startswith('Cultura_Popular'):
                campaigns_from_categories.add('Cultura_Popular_Brasil')
            elif campaign.startswith('Litterature_Haitienne') or campaign.startswith('Littérature_Haïtienne'):
                campaigns_from_categories.add('Litterature_Haitienne')
            elif '_' in campaign:
                # For multi-word campaigns, keep as is but normalize
                campaigns_from_categories.add(campaign.replace('_', ' ').title().replace(' ', '_'))
            else:
                campaigns_from_categories.add(campaign.title())

# Clean and normalize the list
clean_campaigns = set()
for camp in campaigns_from_categories:
    # Skip if it's clearly a subcategory or event
    if any(skip in camp for skip in ['_exhibition', '_photo_walks', '_winners', '_nomination',
                                     '_Workshop', '_meetup', '_at_', '_Launch', '_Upload',
                                     '_Event', '_x_', '_presentations', '_Bazaar', '_contest',
                                     '_ceremony', '_Challenge', '_Awards', '_Jurysitzung',
                                     '_Meeting', '_Workshop', '_postcards', '_offsite',
                                     '_hackathon', '_expert', '_Photography', '_Article',
                                     '_-_', '_by_', '_for_', '_in_', '_on_', '_of_',
                                     'Oost-Vlaanderen', 'Vlaanderen', 'Corfu', 'IUPUI',
                                     'Karnal', 'Kigali', 'Côte', 'FFEEF', 'SheSaid',
                                     'Northern_Nigeria', 'South_Asia', 'WikiConvention',
                                     'WikiIndaba', 'Wikimania', 'WikiCon', 'GLAM-WIKI',
                                     'Bucharest', 'Bari', 'Palazzo', 'Hotel_Royal',
                                     'Pisa', 'September', 'June', 'May', 'October',
                                     'January', 'February', 'August', 'November',
                                     'December', 'March', 'April', 'July']):
        continue
    
    # Normalize names
    if camp == 'Science':
        clean_campaigns.add('Science')
    elif camp in ['Monuments', 'Earth', 'Africa', 'Folklore', 'Food', 'Love', 'Pride',
                  'Fashion', 'Sport', 'Film', 'Folk', 'Heritage', 'Living_Heritage',
                  'Public_Art', 'Birds', 'Onam', 'Falles', 'Bangla', 'Andes', 'Emirates',
                  'Romania', 'Switzerland', 'China', 'México', 'Mexico', 'Sudan', 'Namibia',
                  'Botswana', 'Children', 'Classics', 'Cosplay', 'Culture', 'Denderland',
                  'EuroPride', 'Festivals', 'Film', 'Museums', 'Plants', 'Ramadan',
                  'Schools', 'Sicilia', 'Sport', 'Tribal_Culture', 'Villages', 'Women']:
        clean_campaigns.add(camp)
    elif camp.startswith('Heritage_Belgium'):
        clean_campaigns.add('Heritage_Belgium')
    elif camp.startswith('Birds_India'):
        clean_campaigns.add('Birds_India')
    elif camp.startswith('Fashion_Nederland'):
        clean_campaigns.add('Fashion_Nederland')
    elif camp.startswith('Women_South_Asia'):
        clean_campaigns.add('Women_South_Asia')
    elif camp.startswith('Women_at_Wikimania'):
        clean_campaigns.add('Women_at_Wikimania')
    elif camp.startswith('Assamese_Culture'):
        clean_campaigns.add('Assamese_Culture')
    elif camp.startswith('Cultura_Popular'):
        clean_campaigns.add('Cultura_Popular_Brasil')
    elif camp.startswith('Litterature_Haitienne'):
        clean_campaigns.add('Litterature_Haitienne')
    else:
        # Keep other unique campaigns
        clean_campaigns.add(camp)

# Add main campaigns from metadata
main_campaigns = [
    'Monuments', 'Earth', 'Folklore', 'Science', 'Public_Art', 'Africa', 'Food',
    'Women', 'Libraries', 'Fashion', 'Dance', 'Music', 'Books', 'Maps', 'Design',
    'Peace', 'Love', 'Heritage', 'Democracy', 'Sports', 'Trees', 'Rivers',
    'Mountains', 'Coasts', 'Biodiversity'
]

# Combine and get unique list
all_campaigns = sorted(set(clean_campaigns) | set(main_campaigns))

print(f"Found {len(all_campaigns)} unique campaigns")
print("\nCampaigns:")
for i, camp in enumerate(all_campaigns, 1):
    print(f"{i}. {camp}")

# Save to file for reference
with open('wikiloves-main/campaign_list.txt', 'w', encoding='utf-8') as f:
    for camp in all_campaigns:
        f.write(f"{camp}\n")

print(f"\nCampaign list saved to campaign_list.txt")

