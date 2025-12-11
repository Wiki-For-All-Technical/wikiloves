"""
Generate comprehensive uploader queries for all campaigns.

This script generates Quarry SQL queries for all 77+ Wiki Loves campaigns,
creating one comprehensive query per campaign that fetches ALL uploader data
for ALL years and ALL countries.
"""

import os
import sys

# Add parent directories to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

import sys
import os

# Add parent directories to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'data'))
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

from campaigns_metadata import get_all_campaigns
from queries.quarry_templates import generate_all_uploaders_query

# Directory to save queries
QUERIES_DIR = os.path.join(os.path.dirname(__file__), '..', '..', 'quarry_data', 'queries', 'uploaders')


def ensure_queries_dir():
    """Ensure the queries directory exists."""
    os.makedirs(QUERIES_DIR, exist_ok=True)


def generate_all_queries():
    """Generate comprehensive uploader queries for all campaigns."""
    ensure_queries_dir()
    
    campaigns = get_all_campaigns()
    
    print(f"📝 Generating comprehensive uploader queries for {len(campaigns)} campaigns...\n")
    
    generated = 0
    skipped = 0
    
    for campaign in campaigns:
        name = campaign.get('name')
        path_segment = campaign.get('path_segment') or campaign.get('slug', '').replace('wiki-loves-', '').replace('wiki-', '')
        
        if not name or not path_segment:
            print(f"⚠️  Skipping campaign (missing name/path_segment): {campaign}")
            skipped += 1
            continue
        
        try:
            # Use path_segment as slug for query (matches how catalog uses it)
            quarry_category = campaign.get('quarry_category') or path_segment
            query = generate_all_uploaders_query(
                campaign_name=name,
                campaign_slug=path_segment,
                quarry_category=quarry_category
            )
            
            # Save to file using path_segment
            output_file = os.path.join(QUERIES_DIR, f"{path_segment}_all_uploaders.sql")
            with open(output_file, 'w', encoding='utf-8') as f:
                f.write(query)
            
            print(f"✓ {name} ({path_segment}) → {output_file}")
            generated += 1
            
        except Exception as e:
            print(f"❌ Error generating query for {name} ({slug}): {e}")
            skipped += 1
    
    print(f"\n✅ Generated {generated} queries")
    if skipped > 0:
        print(f"⚠️  Skipped {skipped} campaigns")
    print(f"\n📁 Queries saved to: {QUERIES_DIR}")
    print("\nNext steps:")
    print("1. Review queries in the directory above")
    print("2. Run each query on Quarry (https://quarry.wmcloud.org/)")
    print("3. Download results as JSON")
    print("4. Process with: python backend/scripts/process_all_uploaders.py <file.json> <campaign_slug>")


if __name__ == "__main__":
    generate_all_queries()

