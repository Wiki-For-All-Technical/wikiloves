"""
Add all campaigns from campaigns_metadata.py to catalog.py.
This ensures all Wiki Loves campaigns appear in the tool, even if they don't have data yet.
"""

import json
import os
import sys

# Add paths
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'data'))

from data.campaigns_metadata import get_all_campaigns, get_competition_map
from data.catalog import COMPETITIONS

def merge_all_campaigns():
    """Merge all campaigns from metadata into catalog, preserving existing data."""
    
    # Get all campaigns from metadata
    all_campaign_metadata = get_all_campaigns()
    metadata_map = {camp["slug"]: camp for camp in all_campaign_metadata}
    
    # Create a map of existing competitions by slug
    existing_map = {comp["slug"]: comp for comp in COMPETITIONS}
    
    # Merge: keep existing data, add new campaigns with empty years
    merged_competitions = []
    
    # First, add/update existing competitions
    for comp in COMPETITIONS:
        slug = comp["slug"]
        if slug in metadata_map:
            # Update metadata while preserving years data
            meta = metadata_map[slug]
            merged_comp = {
                "slug": meta["slug"],
                "name": meta["name"],
                "short_label": meta["short_label"],
                "tagline": meta["tagline"],
                "accent_color": meta["accent_color"],
                "hero_image": meta.get("hero_image", ""),
                "logo": meta.get("logo", ""),
                "path_segment": meta["path_segment"],
                "years": comp.get("years", []),  # Keep existing years data
                "links": comp.get("links", {"toolforge": f"https://wikiloves.toolforge.org/{meta['path_segment']}"}),
            }
            merged_competitions.append(merged_comp)
    
    # Then, add campaigns that don't exist yet (with empty years)
    for slug, meta in metadata_map.items():
        if slug not in existing_map:
            merged_comp = {
                "slug": meta["slug"],
                "name": meta["name"],
                "short_label": meta["short_label"],
                "tagline": meta["tagline"],
                "accent_color": meta["accent_color"],
                "hero_image": meta.get("hero_image", ""),
                "logo": meta.get("logo", ""),
                "path_segment": meta["path_segment"],
                "years": [],  # Empty - no data yet
                "links": {"toolforge": f"https://wikiloves.toolforge.org/{meta['path_segment']}"},
            }
            merged_competitions.append(merged_comp)
    
    # Sort by name for consistency
    merged_competitions.sort(key=lambda x: x["name"])
    
    # Keep existing COUNTRIES (don't modify)
    from data.catalog import COUNTRIES
    
    # Write updated catalog
    output_path = os.path.join(os.path.dirname(__file__), '..', 'data', 'catalog.py')
    
    output_code = f"""
COMPETITIONS = {json.dumps(merged_competitions, indent=4, ensure_ascii=False)}

COUNTRIES = {json.dumps(COUNTRIES, indent=4, ensure_ascii=False)}
"""
    
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(output_code)
    
    print("Successfully merged all campaigns into catalog.py")
    print(f"   - Total campaigns: {len(merged_competitions)}")
    print(f"   - Campaigns with data: {sum(1 for c in merged_competitions if c.get('years'))}")
    print(f"   - Campaigns without data: {sum(1 for c in merged_competitions if not c.get('years'))}")
    
    # List campaigns without data
    campaigns_without_data = [c["name"] for c in merged_competitions if not c.get("years")]
    if campaigns_without_data:
        print(f"\n   Campaigns without data (will appear but show 'no data'):")
        for name in campaigns_without_data:
            print(f"     - {name}")

if __name__ == "__main__":
    merge_all_campaigns()

