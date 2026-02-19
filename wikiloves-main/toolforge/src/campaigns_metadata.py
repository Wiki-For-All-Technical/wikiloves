"""
Campaign metadata for Toolforge data fetcher.
Used when running on Toolforge so campaign lookup works without backend/data/.
Keys are campaign prefixes (path_segment); get_campaign_by_prefix("earth") returns the earth campaign.
"""

from typing import Dict, Optional

ALL_CAMPAIGNS: Dict[str, Dict] = {
    "earth": {
        "slug": "wiki-loves-earth",
        "name": "Wiki Loves Earth",
        "path_segment": "earth",
        "quarry_category": "earth",
    },
    "monuments": {
        "slug": "wiki-loves-monuments",
        "name": "Wiki Loves Monuments",
        "path_segment": "monuments",
        "quarry_category": "monuments",
    },
    "science": {
        "slug": "wiki-science",
        "name": "Wiki Science Competition",
        "path_segment": "science",
        "quarry_category": "science",
    },
    "folklore": {
        "slug": "wiki-loves-folklore",
        "name": "Wiki Loves Folklore",
        "path_segment": "folklore",
        "quarry_category": "folklore",
    },
    "africa": {
        "slug": "wiki-loves-africa",
        "name": "Wiki Loves Africa",
        "path_segment": "africa",
        "quarry_category": "africa",
    },
    "food": {
        "slug": "wiki-loves-food",
        "name": "Wiki Loves Food",
        "path_segment": "food",
        "quarry_category": "food",
    },
    "public_art": {
        "slug": "wiki-loves-public-art",
        "name": "Wiki Loves Public Art",
        "path_segment": "public_art",
        "quarry_category": "public_art",
    },
}


def get_campaign_by_prefix(prefix: str) -> Optional[Dict]:
    """Get campaign metadata by prefix (e.g. 'earth', 'monuments')."""
    return ALL_CAMPAIGNS.get(prefix)
