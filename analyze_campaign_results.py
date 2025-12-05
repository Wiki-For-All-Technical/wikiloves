import json
import re
from collections import defaultdict

# Read the JSON file
with open('wikiloves-main/quarry_data/quarry-99480-untitled-run1044465.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

campaigns = defaultdict(int)

# Extract campaign names and sum file counts
for row in data['rows']:
    category = row[0]
    file_count = row[1]
    
    # Skip technical categories (upload methods, maintenance, etc.)
    if any(skip in category for skip in ['Files_uploaded_via', 'Maintenance_for', 'Out_of_scope', 'Accepted_', 'Quality_', 'Featured_', 'GLAM_', 'Art_nouveau', 'WWI_related']):
        continue
    
    # Extract campaign name
    if 'Wiki_Science' in category or 'WikiScience' in category:
        campaign = 'Science'
        campaigns[campaign] += file_count
    elif 'Wiki_Loves_' in category:
        # Extract from patterns like "Images_from_Wiki_Loves_[Campaign]_YYYY"
        match = re.search(r'Wiki_Loves_([A-Za-z_]+?)(?:_\d{4}|_in_|$)', category)
        if match:
            campaign = match.group(1)
            # Handle country-specific variants - extract base campaign
            if campaign.startswith('Monuments_'):
                campaign = 'Monuments'
            elif campaign.startswith('Heritage_'):
                if 'Belgium' in campaign:
                    campaign = 'Heritage Belgium'
                else:
                    campaign = 'Heritage'
            elif campaign.startswith('Earth_'):
                campaign = 'Earth'
            elif campaign.startswith('Folk_'):
                campaign = 'Folk'
            elif campaign.startswith('Living_Heritage'):
                campaign = 'Living Heritage'
            elif campaign.startswith('Public_Art'):
                campaign = 'Public Art'
            elif campaign.startswith('Small_Museums'):
                campaign = 'Small Museums'
            elif campaign.startswith('Tribal_Culture'):
                campaign = 'Tribal Culture'
            elif campaign.startswith('Assamese_Culture'):
                campaign = 'Assamese Culture'
            elif campaign.startswith('Cultura_Popular'):
                campaign = 'Cultura Popular Brasil'
            elif campaign.startswith('Pajottenland'):
                campaign = 'Pajottenland Zennevallei'
            elif campaign.startswith('Valle_del'):
                campaign = 'Valle Del Primo Presepe'
            elif campaign.startswith('Tirreno_Cosentino'):
                campaign = 'Tirreno Cosentino'
            elif campaign.startswith('Ratha_Jatra'):
                campaign = 'Ratha Jatra'
            elif campaign.startswith('Pesto_Genovese'):
                campaign = 'Pesto Genovese'
            elif campaign.startswith('Busto_Arsizio'):
                campaign = 'Busto Arsizio'
            elif campaign.startswith('Canoeing_Hamburg'):
                campaign = 'Canoeing Hamburg'
            elif campaign.startswith('Litterature_Haitienne'):
                campaign = 'Litterature Haitienne'
            elif '_' in campaign:
                # Replace underscores with spaces for multi-word campaigns
                campaign = campaign.replace('_', ' ').title()
            
            campaigns[campaign] += file_count

# Sort by file count descending
sorted_campaigns = sorted(campaigns.items(), key=lambda x: x[1], reverse=True)

print(f"Total campaigns with file data: {len(sorted_campaigns)}\n")
print("Campaigns with file data (sorted by file count):")
print("=" * 60)
for campaign, count in sorted_campaigns:
    print(f"{campaign:40} {count:>15,} files")

print("\n" + "=" * 60)
print(f"Total files across all campaigns: {sum(campaigns.values()):,}")

