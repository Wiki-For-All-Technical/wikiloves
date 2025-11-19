from collections import defaultdict
from statistics import mean
from typing import Dict, List, Optional

from data.catalog import COMPETITIONS, COUNTRIES


def _find_competition(slug: str) -> Optional[Dict]:
    return next((comp for comp in COMPETITIONS if comp["slug"] == slug), None)


def _find_country(slug: str) -> Optional[Dict]:
    return next((country for country in COUNTRIES if country["slug"] == slug), None)


def _latest_year_entry(years: List[Dict]) -> Dict:
    return max(years, key=lambda y: y["year"])


def _previous_year_entry(years: List[Dict], reference_year: int) -> Optional[Dict]:
    sorted_years = sorted(years, key=lambda y: y["year"], reverse=True)
    for entry in sorted_years:
        if entry["year"] < reference_year:
            return entry
    return None


def _percentage_delta(current: int, previous: Optional[int]) -> float:
    if not previous:
        return 0.0
    if previous == 0:
        return 0.0
    return round(((current - previous) / previous) * 100, 2)


def _percentage(part: int, total: int) -> float:
    if not total:
        return 0.0
    return round((part / total) * 100, 2)


def _format_year_entries(years: List[Dict]) -> List[Dict]:
    formatted = []
    for entry in years:
        formatted.append(
            {
                **entry,
                "images_used_pct": _percentage(entry["images_used"], entry["uploads"]),
                "new_uploaders_pct": _percentage(entry["new_uploaders"], entry["uploaders"]),
            }
        )
    return formatted


def build_competition_summaries() -> List[Dict]:
    summaries = []
    for comp in COMPETITIONS:
        sorted_years_raw = sorted(comp["years"], key=lambda y: y["year"], reverse=True)
        sorted_years = _format_year_entries(sorted_years_raw)
        latest = sorted_years[0]
        prev = _previous_year_entry(sorted_years_raw, latest["year"])
        prev_uploads = prev["uploads"] if prev else None
        trend = [entry["uploads"] for entry in sorted_years[:6]]
        summaries.append(
            {
                "slug": comp["slug"],
                "name": comp["name"],
                "short_label": comp.get("short_label", comp["name"]),
                "tagline": comp["tagline"],
                "accent_color": comp["accent_color"],
                "hero_image": comp["hero_image"],
                "logo": comp.get("logo"),
                "path_segment": comp.get("path_segment", comp["slug"]),
                "latest_year": latest["year"],
                "latest_uploads": latest["uploads"],
                "uploads_delta": _percentage_delta(latest["uploads"], prev_uploads),
                "countries": latest["countries"],
                "lifetime_uploads": sum(entry["uploads"] for entry in comp["years"]),
                "year_count": len(comp["years"]),
                "trend": list(reversed(trend)),
                "yearly_stats": sorted_years,
            }
        )
    return summaries


def build_competition_detail(slug: str) -> Optional[Dict]:
    comp = _find_competition(slug)
    if not comp:
        return None

    sorted_years_raw = sorted(comp["years"], key=lambda y: y["year"], reverse=True)
    sorted_years = _format_year_entries(sorted_years_raw)
    latest = sorted_years[0]
    upload_trend = [entry["uploads"] for entry in sorted_years[:6]]

    return {
        "slug": comp["slug"],
        "name": comp["name"],
        "short_label": comp.get("short_label", comp["name"]),
        "tagline": comp["tagline"],
        "hero_image": comp["hero_image"],
        "accent_color": comp["accent_color"],
        "logo": comp.get("logo"),
        "links": comp["links"],
        "spotlight": {
            "countries": latest["countries"],
            "uploads": latest["uploads"],
            "images_used": latest["images_used"],
            "uploaders": latest["uploaders"],
            "new_uploaders": latest["new_uploaders"],
            "uploads_delta": _percentage_delta(
                latest["uploads"],
                sorted_years[1]["uploads"] if len(sorted_years) > 1 else None,
            ),
        },
        "yearly_stats": sorted_years,
        "trend": list(reversed(upload_trend)),
    }


def build_country_summaries() -> List[Dict]:
    summaries = []
    for country in COUNTRIES:
        focus = country.get("focus", [])
        recent = sorted(country.get("recent_activity", []), key=lambda e: e["year"])
        summaries.append(
            {
                "slug": country["slug"],
                "name": country["name"],
                "region": country["region"],
                "first_year": country["first_year"],
                "focus": focus,
                "spotlight": country["spotlight"],
                "trend": [entry["uploads"] for entry in recent[-4:]],
            }
        )
    return summaries


def build_country_detail(slug: str) -> Optional[Dict]:
    country = _find_country(slug)
    if not country:
        return None

    activity = sorted(country.get("recent_activity", []), key=lambda e: e["year"])
    uploads = [entry["uploads"] for entry in activity]
    trend = uploads[-6:]

    return {
        "slug": country["slug"],
        "name": country["name"],
        "region": country["region"],
        "focus": country["focus"],
        "first_year": country["first_year"],
        "spotlight": country["spotlight"],
        "recent_activity": activity,
        "trend": trend,
    }


def build_overview_stats() -> Dict:
    totals = defaultdict(int)
    latest_uploads = []

    for comp in COMPETITIONS:
        for entry in comp["years"]:
            totals["uploads"] += entry["uploads"]
            totals["images_used"] += entry["images_used"]
            totals["countries_total"] = max(totals["countries_total"], entry["countries"])
        latest = _latest_year_entry(comp["years"])
        latest_uploads.append(latest["uploads"])

    return {
        "total_uploads": totals["uploads"],
        "total_images_used": totals["images_used"],
        "max_countries": totals["countries_total"],
        "avg_latest_uploads": int(mean(latest_uploads)),
    }


def build_navigation() -> List[Dict]:
    nav = [
        {
            "type": "home",
            "label": "Main page",
            "slug": "home",
            "path": "/",
        }
    ]
    for comp in COMPETITIONS:
        years = sorted([entry["year"] for entry in comp["years"]], reverse=True)
        path_segment = comp.get("path_segment", comp["slug"])
        nav.append(
            {
                "type": "competition",
                "label": comp.get("short_label", comp["name"]),
                "slug": comp["slug"],
                "path_segment": path_segment,
                "logo": comp.get("logo"),
                "years": years,
                "path": f"/{path_segment}",
            }
        )
    return nav

