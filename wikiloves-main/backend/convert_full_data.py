import json
import re
import os
import sys

# Add data directory to path to import campaigns_metadata
sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'data'))

from campaigns_metadata import get_competition_map

# Get comprehensive competition map from metadata
COMPETITION_MAP = get_competition_map()

def process_db():
    # Load db.json
    if not os.path.exists('db.json'):
        print("ERROR: 'db.json' not found in the current folder.")
        return

    with open('db.json', 'r', encoding='utf-8') as f:
        data = json.load(f)

    competitions = {}
    country_profiles = {}

    for key, countries_data in data.items():
        match = re.match(r"([a-zA-Z_]+)(\d{4})", key)
        if not match:
            continue
            
        prefix, year_str = match.groups()
        year = int(year_str)
        
        if prefix not in COMPETITION_MAP:
            continue

        # Initialize competition if new
        if prefix not in competitions:
            competitions[prefix] = {
                **COMPETITION_MAP[prefix],
                "path_segment": prefix,
                "years": [],
                "links": {"toolforge": f"https://wikiloves.toolforge.org/{prefix}"}
            }

        # --- Process Countries for this Year ---
        year_country_stats = []
        
        total_uploads = 0
        total_usage = 0
        total_uploaders = 0
        total_new_uploaders = 0
        country_count = 0

        for country_name, stats in countries_data.items():
            # Filter out non-country keys like 'data' or 'start'
            if not isinstance(stats, dict) or "count" not in stats:
                continue
                
            country_count += 1
            uploads = stats.get("count", 0)
            
            total_uploads += uploads
            total_usage += stats.get("usage", 0)
            total_uploaders += stats.get("usercount", 0)
            total_new_uploaders += stats.get("userreg", 0)

            # Add to Detailed List (This is what populates the table)
            year_country_stats.append({
                "name": country_name,
                "uploads": uploads,
                "images_used": stats.get("usage", 0),
                "uploaders": stats.get("usercount", 0),
                "new_uploaders": stats.get("userreg", 0),
            })

            # Build Country Profile
            if country_name not in country_profiles:
                country_profiles[country_name] = {
                    "slug": country_name.lower().replace(" ", "-"),
                    "name": country_name,
                    "region": "Global", 
                    "first_year": year,
                    "focus": set(),
                    "recent_activity": []
                }
            
            cp = country_profiles[country_name]
            cp["first_year"] = min(cp["first_year"], year)
            cp["focus"].add(COMPETITION_MAP[prefix]["name"])
            cp["recent_activity"].append({
                "competition": COMPETITION_MAP[prefix]["slug"],
                "year": year,
                "uploads": uploads
            })

        # Rank countries by uploads for this year
        year_country_stats.sort(key=lambda x: x["uploads"], reverse=True)
        for i, c_stat in enumerate(year_country_stats):
            c_stat["rank"] = i + 1

        # Add the Year Entry
        competitions[prefix]["years"].append({
            "year": year,
            "countries": country_count,
            "uploads": total_uploads,
            "images_used": total_usage,
            "uploaders": total_uploaders,
            "new_uploaders": total_new_uploaders,
            "country_stats": year_country_stats  # <--- CRITICAL FIELD
        })

    # Convert to lists
    final_competitions = []
    for prefix, comp_data in competitions.items():
        comp_data["years"].sort(key=lambda x: x["year"], reverse=True)
        final_competitions.append(comp_data)

    final_countries = []
    for name, profile in country_profiles.items():
        profile["focus"] = list(profile["focus"])
        profile["recent_activity"].sort(key=lambda x: x["year"])
        final_countries.append(profile)
    
    final_countries.sort(key=lambda x: x["name"])

    # Write to catalog.py
    output_code = f"""
COMPETITIONS = {json.dumps(final_competitions, indent=4)}

COUNTRIES = {json.dumps(final_countries, indent=4)}
"""
    
    # Determine output path (assume running inside backend folder)
    output_path = 'data/catalog.py'
    if not os.path.exists('data'):
        os.makedirs('data')
        
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(output_code)
    
    print(f"✅ Success! Updated {output_path} with detailed country stats.")

if __name__ == "__main__":
    process_db()