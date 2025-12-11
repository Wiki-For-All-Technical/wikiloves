import json
import re

# Metadata for competitions
COMPETITION_MAP = {
    "earth": {
        "slug": "wiki-loves-earth",
        "name": "Wiki Loves Earth",
        "short_label": "WL Earth",
        "path_segment": "earth",
        "tagline": "Celebrating biodiversity, natural sites, and protected landscapes.",
        "hero_image": "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a3/Herzogstand_heaven.jpg/640px-Herzogstand_heaven.jpg",
        "logo": "https://upload.wikimedia.org/wikipedia/commons/thumb/8/83/Wiki_Loves_Earth_logo.svg/320px-Wiki_Loves_Earth_logo.svg.png",
        "accent_color": "#1f8a70",
        "links": {"toolforge": "https://wikiloves.toolforge.org/earth/2025"}
    },
    "monuments": {
        "slug": "wiki-loves-monuments",
        "name": "Wiki Loves Monuments",
        "short_label": "WL Monuments",
        "path_segment": "monuments",
        "tagline": "Documenting built heritage and monuments worldwide.",
        "hero_image": "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6e/Taj_Mahal_in_India.jpg/640px-Taj_Mahal_in_India.jpg",
        "logo": "https://upload.wikimedia.org/wikipedia/commons/thumb/5/58/Wiki_Loves_Monuments_logo.svg/320px-Wiki_Loves_Monuments_logo.svg.png",
        "accent_color": "#c14953",
        "links": {"toolforge": "https://wikiloves.toolforge.org/monuments/2025"}
    },
    "africa": {
        "slug": "wiki-loves-africa",
        "name": "Wiki Loves Africa",
        "short_label": "WL Africa",
        "path_segment": "africa",
        "tagline": "Photographing cultural heritage, daily life, and traditions across Africa.",
        "hero_image": "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/Nubian_Girl_2014.jpg/640px-Nubian_Girl_2014.jpg",
        "logo": "https://upload.wikimedia.org/wikipedia/commons/thumb/7/7c/Wiki_Loves_Africa_logo.svg/320px-Wiki_Loves_Africa_logo.svg.png",
        "accent_color": "#f4a127",
        "links": {"toolforge": "https://wikiloves.toolforge.org/africa/2025"}
    },
    "folklore": {
        "slug": "wiki-loves-folklore",
        "name": "Wiki Loves Folklore",
        "short_label": "WL Folklore",
        "path_segment": "folklore",
        "tagline": "Spotlighting folklore traditions from around the world.",
        "hero_image": "https://upload.wikimedia.org/wikipedia/commons/thumb/7/7a/Wiki_Loves_Folklore_2023.jpg/640px-Wiki_Loves_Folklore_2023.jpg",
        "logo": "https://upload.wikimedia.org/wikipedia/commons/thumb/2/21/Wiki_Loves_Folklore_logo.svg/320px-Wiki_Loves_Folklore_logo.svg.png",
        "accent_color": "#c77dff",
        "links": {"toolforge": "https://wikiloves.toolforge.org/folklore/2025"}
    },
     "science": {
        "slug": "wiki-science",
        "name": "Wiki Science Competition",
        "short_label": "WL Science",
        "path_segment": "science",
        "tagline": "Showcasing scientific imagery from labs, field work, and microscopy.",
        "hero_image": "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/Science_microscope_image.jpg/640px-Science_microscope_image.jpg",
        "logo": "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c9/Wiki_Science_Competition_logo.svg/320px-Wiki_Science_Competition_logo.svg.png",
        "accent_color": "#00b4d8",
        "links": {"toolforge": "https://wikiloves.toolforge.org/science/2025"}
    },
    "public_art": {
        "slug": "wiki-loves-public-art",
        "name": "Wiki Loves Public Art",
        "short_label": "WL Public Art",
        "path_segment": "public_art",
        "tagline": "Mapping public artworks in cities across the globe.",
        "hero_image": "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6d/Public_art_in_Stockholm.jpg/640px-Public_art_in_Stockholm.jpg",
        "logo": "https://upload.wikimedia.org/wikipedia/commons/thumb/c/cd/Wiki_Loves_Public_Art_logo.svg/320px-Wiki_Loves_Public_Art_logo.svg.png",
        "accent_color": "#ff914d",
        "links": {"toolforge": "https://wikiloves.toolforge.org/public_art"}
    }
}

def process_db():
    try:
        with open('db.json', 'r', encoding='utf-8') as f:
            data = json.load(f)
    except FileNotFoundError:
        print("Error: db.json not found. Make sure it is in the same folder.")
        return

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

        if prefix not in competitions:
            competitions[prefix] = {**COMPETITION_MAP[prefix], "years": []}

        # Process country data for this year
        year_country_stats = []
        
        total_uploads = 0
        total_usage = 0
        total_uploaders = 0
        total_new_uploaders = 0
        country_count = 0

        for country_name, stats in countries_data.items():
            if not isinstance(stats, dict) or "count" not in stats:
                continue
                
            country_count += 1
            uploads = stats.get("count", 0)
            
            # Aggregate totals
            total_uploads += uploads
            total_usage += stats.get("usage", 0)
            total_uploaders += stats.get("usercount", 0)
            total_new_uploaders += stats.get("userreg", 0)

            # Add to detailed list for this year
            year_country_stats.append({
                "name": country_name,
                "uploads": uploads,
                "images_used": stats.get("usage", 0),
                "uploaders": stats.get("usercount", 0),
                "new_uploaders": stats.get("userreg", 0),
            })

            # Add to Country Profile (Global list)
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

        # Append year data
        competitions[prefix]["years"].append({
            "year": year,
            "countries": country_count,
            "uploads": total_uploads,
            "images_used": total_usage,
            "uploaders": total_uploaders,
            "new_uploaders": total_new_uploaders,
            "country_stats": year_country_stats  # <--- THIS is the key field the UI needs
        })

    # 1. Finalize Competitions List
    final_competitions = []
    for prefix, comp_data in competitions.items():
        comp_data["years"].sort(key=lambda x: x["year"], reverse=True)
        final_competitions.append(comp_data)

    # 2. Finalize Countries List
    final_countries = []
    for name, profile in country_profiles.items():
        profile["focus"] = list(profile["focus"]) # Convert set to list
        # Sort activity to help finding trends
        profile["recent_activity"].sort(key=lambda x: x["year"])
        final_countries.append(profile)
    
    final_countries.sort(key=lambda x: x["name"]) # Sort alphabetically

    # Write to file directly (safest way)
    output_code = f"""
COMPETITIONS = {json.dumps(final_competitions, indent=4)}

COUNTRIES = {json.dumps(final_countries, indent=4)}
"""
    
    with open('backend/data/catalog.py', 'w', encoding='utf-8') as f:
        f.write(output_code)
    
    print("Success! Updated backend/data/catalog.py with detailed country data.")

if __name__ == "__main__":
    process_db()