"""
Comprehensive metadata for all Wiki Loves campaigns.
This file contains metadata for all known Wiki Loves X campaigns from Meta-Wiki.
Campaigns are categorized as: international, regional, or local.
"""

from typing import Dict, Optional

# Campaign categories
CATEGORY_INTERNATIONAL = "international"
CATEGORY_REGIONAL = "regional"
CATEGORY_LOCAL = "local"

# Comprehensive list of all Wiki Loves campaigns
ALL_CAMPAIGNS = {
    # ===== INTERNATIONAL CAMPAIGNS =====
    "monuments": {
        "slug": "wiki-loves-monuments",
        "name": "Wiki Loves Monuments",
        "short_label": "WL Monuments",
        "tagline": "Documenting built heritage and monuments worldwide.",
        "accent_color": "#c14953",
        "hero_image": "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6e/Taj_Mahal_in_India.jpg/640px-Taj_Mahal_in_India.jpg",
        "logo": "https://upload.wikimedia.org/wikipedia/commons/thumb/5/58/Wiki_Loves_Monuments_logo.svg/320px-Wiki_Loves_Monuments_logo.svg.png",
        "category": CATEGORY_INTERNATIONAL,
        "path_segment": "monuments",
        "quarry_category": "monuments",
    },
    "moments": {
        "slug": "wiki-loves-moments",
        "name": "Wiki Loves Moments",
        "short_label": "WL Moments",
        "tagline": "Wiki Loves Monuments – yearly statistics by country (data from live queries).",
        "accent_color": "#c14953",
        "hero_image": "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6e/Taj_Mahal_in_India.jpg/640px-Taj_Mahal_in_India.jpg",
        "logo": "https://upload.wikimedia.org/wikipedia/commons/thumb/5/58/Wiki_Loves_Monuments_logo.svg/320px-Wiki_Loves_Monuments_logo.svg.png",
        "category": CATEGORY_INTERNATIONAL,
        "path_segment": "moments",
        "quarry_category": "moments",
    },
    "earth": {
        "slug": "wiki-loves-earth",
        "name": "Wiki Loves Earth",
        "short_label": "WL Earth",
        "tagline": "Celebrating biodiversity, natural sites, and protected landscapes.",
        "accent_color": "#1f8a70",
        "hero_image": "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a3/Herzogstand_heaven.jpg/640px-Herzogstand_heaven.jpg",
        "logo": "https://upload.wikimedia.org/wikipedia/commons/thumb/8/83/Wiki_Loves_Earth_logo.svg/320px-Wiki_Loves_Earth_logo.svg.png",
        "category": CATEGORY_INTERNATIONAL,
        "path_segment": "earth",
        "quarry_category": "earth",
    },
    "folklore": {
        "slug": "wiki-loves-folklore",
        "name": "Wiki Loves Folklore",
        "short_label": "WL Folklore",
        "tagline": "Spotlighting folklore traditions from around the world.",
        "accent_color": "#c77dff",
        "hero_image": "https://upload.wikimedia.org/wikipedia/commons/thumb/7/7a/Wiki_Loves_Folklore_2023.jpg/640px-Wiki_Loves_Folklore_2023.jpg",
        "logo": "https://upload.wikimedia.org/wikipedia/commons/thumb/2/21/Wiki_Loves_Folklore_logo.svg/320px-Wiki_Loves_Folklore_logo.svg.png",
        "category": CATEGORY_INTERNATIONAL,
        "path_segment": "folklore",
        "quarry_category": "folklore",
    },
    "science": {
        "slug": "wiki-science",
        "name": "Wiki Science Competition",
        "short_label": "WL Science",
        "tagline": "Showcasing scientific imagery from labs, field work, and microscopy.",
        "accent_color": "#00b4d8",
        "hero_image": "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/Science_microscope_image.jpg/640px-Science_microscope_image.jpg",
        "logo": "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c9/Wiki_Science_Competition_logo.svg/320px-Wiki_Science_Competition_logo.svg.png",
        "category": CATEGORY_INTERNATIONAL,
        "path_segment": "science",
        "quarry_category": "science",
    },
    "public_art": {
        "slug": "wiki-loves-public-art",
        "name": "Wiki Loves Public Art",
        "short_label": "WL Public Art",
        "tagline": "Mapping public artworks in cities across the globe.",
        "accent_color": "#ff914d",
        "hero_image": "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6d/Public_art_in_Stockholm.jpg/640px-Public_art_in_Stockholm.jpg",
        "logo": "https://upload.wikimedia.org/wikipedia/commons/thumb/c/cd/Wiki_Loves_Public_Art_logo.svg/320px-Wiki_Loves_Public_Art_logo.svg.png",
        "category": CATEGORY_INTERNATIONAL,
        "path_segment": "public_art",
        "quarry_category": "public_art",
    },
    "africa": {
        "slug": "wiki-loves-africa",
        "name": "Wiki Loves Africa",
        "short_label": "WL Africa",
        "tagline": "Photographing cultural heritage, daily life, and traditions across Africa.",
        "accent_color": "#f4a127",
        "hero_image": "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/Nubian_Girl_2014.jpg/640px-Nubian_Girl_2014.jpg",
        "logo": "https://upload.wikimedia.org/wikipedia/commons/thumb/7/7c/Wiki_Loves_Africa_logo.svg/320px-Wiki_Loves_Africa_logo.svg.png",
        "category": CATEGORY_REGIONAL,
        "path_segment": "africa",
        "quarry_category": "africa",
    },
    "food": {
        "slug": "wiki-loves-food",
        "name": "Wiki Loves Food",
        "short_label": "WL Food",
        "tagline": "Documenting food culture, recipes, and culinary traditions.",
        "accent_color": "#e63946",
        "hero_image": "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6f/WS_Food_2021.jpg/640px-WS_Food_2021.jpg",
        "logo": "",
        "category": CATEGORY_REGIONAL,
        "path_segment": "food",
        "quarry_category": "food",
    },
    "women": {
        "slug": "wiki-loves-women",
        "name": "Wiki Loves Women",
        "short_label": "WL Women",
        "tagline": "Celebrating women's contributions and achievements.",
        "accent_color": "#d63384",
        "hero_image": "",
        "logo": "",
        "category": CATEGORY_REGIONAL,
        "path_segment": "women",
        "quarry_category": "women",
    },
    "libraries": {
        "slug": "wiki-loves-libraries",
        "name": "Wiki Loves Libraries",
        "short_label": "WL Libraries",
        "tagline": "Documenting libraries and their collections worldwide.",
        "accent_color": "#6f42c1",
        "hero_image": "",
        "logo": "",
        "category": CATEGORY_REGIONAL,
        "path_segment": "libraries",
        "quarry_category": "libraries",
    },
    "fashion": {
        "slug": "wiki-loves-fashion",
        "name": "Wiki Loves Fashion",
        "short_label": "WL Fashion",
        "tagline": "Showcasing fashion, textiles, and traditional clothing.",
        "accent_color": "#ff6b9d",
        "hero_image": "",
        "logo": "",
        "category": CATEGORY_REGIONAL,
        "path_segment": "fashion",
        "quarry_category": "fashion",
    },
    "dance": {
        "slug": "wiki-loves-dance",
        "name": "Wiki Loves Dance",
        "short_label": "WL Dance",
        "tagline": "Capturing dance forms and cultural expressions.",
        "accent_color": "#9d4edd",
        "hero_image": "",
        "logo": "",
        "category": CATEGORY_REGIONAL,
        "path_segment": "dance",
        "quarry_category": "dance",
    },
    "music": {
        "slug": "wiki-loves-music",
        "name": "Wiki Loves Music",
        "short_label": "WL Music",
        "tagline": "Documenting musical instruments, performances, and traditions.",
        "accent_color": "#7209b7",
        "hero_image": "",
        "logo": "",
        "category": CATEGORY_REGIONAL,
        "path_segment": "music",
        "quarry_category": "music",
    },
    "books": {
        "slug": "wiki-loves-books",
        "name": "Wiki Loves Books",
        "short_label": "WL Books",
        "tagline": "Showcasing books, manuscripts, and literary heritage.",
        "accent_color": "#8b4513",
        "hero_image": "",
        "logo": "",
        "category": CATEGORY_REGIONAL,
        "path_segment": "books",
        "quarry_category": "books",
    },
    "maps": {
        "slug": "wiki-loves-maps",
        "name": "Wiki Loves Maps",
        "short_label": "WL Maps",
        "tagline": "Documenting historical and contemporary maps.",
        "accent_color": "#2d5016",
        "hero_image": "",
        "logo": "",
        "category": CATEGORY_REGIONAL,
        "path_segment": "maps",
        "quarry_category": "maps",
    },
    "design": {
        "slug": "wiki-loves-design",
        "name": "Wiki Loves Design",
        "short_label": "WL Design",
        "tagline": "Celebrating design, architecture, and visual arts.",
        "accent_color": "#ff6b35",
        "hero_image": "",
        "logo": "",
        "category": CATEGORY_REGIONAL,
        "path_segment": "design",
        "quarry_category": "design",
    },
    "peace": {
        "slug": "wiki-loves-peace",
        "name": "Wiki Loves Peace",
        "short_label": "WL Peace",
        "tagline": "Promoting peace and understanding through imagery.",
        "accent_color": "#4a90e2",
        "hero_image": "",
        "logo": "",
        "category": CATEGORY_REGIONAL,
        "path_segment": "peace",
        "quarry_category": "peace",
    },
    "love": {
        "slug": "wiki-loves-love",
        "name": "Wiki Loves Love",
        "short_label": "WL Love",
        "tagline": "Celebrating love in all its forms and expressions.",
        "accent_color": "#e91e63",
        "hero_image": "",
        "logo": "",
        "category": CATEGORY_REGIONAL,
        "path_segment": "love",
        "quarry_category": "love",
    },
    "heritage": {
        "slug": "wiki-loves-heritage",
        "name": "Wiki Loves Heritage",
        "short_label": "WL Heritage",
        "tagline": "Documenting cultural and natural heritage sites.",
        "accent_color": "#795548",
        "hero_image": "",
        "logo": "",
        "category": CATEGORY_REGIONAL,
        "path_segment": "heritage",
        "quarry_category": "heritage",
    },
    "democracy": {
        "slug": "wiki-loves-democracy",
        "name": "Wiki Loves Democracy",
        "short_label": "WL Democracy",
        "tagline": "Documenting democratic processes and institutions.",
        "accent_color": "#1976d2",
        "hero_image": "",
        "logo": "",
        "category": CATEGORY_REGIONAL,
        "path_segment": "democracy",
        "quarry_category": "democracy",
    },
    "sports": {
        "slug": "wiki-loves-sports",
        "name": "Wiki Loves Sports",
        "short_label": "WL Sports",
        "tagline": "Capturing sports, athletes, and sporting events.",
        "accent_color": "#ff5722",
        "hero_image": "",
        "logo": "",
        "category": CATEGORY_REGIONAL,
        "path_segment": "sports",
        "quarry_category": "sports",
    },
    "trees": {
        "slug": "wiki-loves-trees",
        "name": "Wiki Loves Trees",
        "short_label": "WL Trees",
        "tagline": "Documenting trees, forests, and arboreal heritage.",
        "accent_color": "#2e7d32",
        "hero_image": "",
        "logo": "",
        "category": CATEGORY_REGIONAL,
        "path_segment": "trees",
        "quarry_category": "trees",
    },
    "rivers": {
        "slug": "wiki-loves-rivers",
        "name": "Wiki Loves Rivers",
        "short_label": "WL Rivers",
        "tagline": "Documenting rivers, waterways, and aquatic ecosystems.",
        "accent_color": "#0277bd",
        "hero_image": "",
        "logo": "",
        "category": CATEGORY_REGIONAL,
        "path_segment": "rivers",
        "quarry_category": "rivers",
    },
    "mountains": {
        "slug": "wiki-loves-mountains",
        "name": "Wiki Loves Mountains",
        "short_label": "WL Mountains",
        "tagline": "Capturing mountain landscapes and alpine environments.",
        "accent_color": "#546e7a",
        "hero_image": "",
        "logo": "",
        "category": CATEGORY_REGIONAL,
        "path_segment": "mountains",
        "quarry_category": "mountains",
    },
    "coasts": {
        "slug": "wiki-loves-coasts",
        "name": "Wiki Loves Coasts",
        "short_label": "WL Coasts",
        "tagline": "Documenting coastal areas and marine environments.",
        "accent_color": "#00acc1",
        "hero_image": "",
        "logo": "",
        "category": CATEGORY_REGIONAL,
        "path_segment": "coasts",
        "quarry_category": "coasts",
    },
    "biodiversity": {
        "slug": "wiki-loves-biodiversity",
        "name": "Wiki Loves Biodiversity",
        "short_label": "WL Biodiversity",
        "tagline": "Showcasing biodiversity and ecological diversity.",
        "accent_color": "#43a047",
        "hero_image": "",
        "logo": "",
        "category": CATEGORY_REGIONAL,
        "path_segment": "biodiversity",
        "quarry_category": "biodiversity",
    },
}


def get_campaign_by_prefix(prefix: str) -> dict:
    """Get campaign metadata by prefix (e.g., 'earth', 'monuments')."""
    return ALL_CAMPAIGNS.get(prefix)


def get_campaign_by_slug(slug: str) -> dict:
    """Get campaign metadata by slug (e.g., 'wiki-loves-earth')."""
    for campaign in ALL_CAMPAIGNS.values():
        if campaign["slug"] == slug:
            return campaign
    return None


def get_campaigns_by_category(category: str) -> list:
    """Get all campaigns in a specific category."""
    return [camp for camp in ALL_CAMPAIGNS.values() if camp["category"] == category]


def get_all_campaigns() -> list:
    """Get all campaigns as a list."""
    return list(ALL_CAMPAIGNS.values())


def get_competition_map() -> dict:
    """Get the competition map in the format expected by convert_full_data.py."""
    return {
        prefix: {
            "slug": camp["slug"],
            "name": camp["name"],
            "short_label": camp["short_label"],
            "tagline": camp["tagline"],
            "accent_color": camp["accent_color"],
            "hero_image": camp.get("hero_image", ""),
            "logo": camp.get("logo", ""),
            "path_segment": camp["path_segment"],
            "category": camp["category"],
        }
        for prefix, camp in ALL_CAMPAIGNS.items()
    }


def get_campaign_by_prefix(prefix: str) -> Optional[Dict]:
    """
    Get campaign metadata by its prefix (e.g., 'monuments', 'earth').
    
    Args:
        prefix: Campaign prefix key from ALL_CAMPAIGNS dict
        
    Returns:
        Campaign metadata dict or None if not found
    """
    return ALL_CAMPAIGNS.get(prefix)



