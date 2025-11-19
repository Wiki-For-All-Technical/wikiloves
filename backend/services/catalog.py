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
        # Use .get() with defaults to prevent KeyErrors if data is missing
        formatted.append(
            {
                **entry,
                "images_used_pct": _percentage(entry.get("images_used", 0), entry.get("uploads", 0)),
                "new_uploaders_pct": _percentage(entry.get("new_uploaders", 0), entry.get("uploaders", 0)),
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
        prev_uploads = prev.get("uploads", 0) if prev else None
        trend = [entry.get("uploads", 0) for entry in sorted_years[:6]]
        summaries.append(
            {
                "slug": comp["slug"],
                "name": comp["name"],
                "short_label": comp.get("short_label", comp["name"]),
                "tagline": comp.get("tagline", ""),
                "accent_color": comp.get("accent_color", "#000"),
                "hero_image": comp.get("hero_image", ""),
                "logo": comp.get("logo"),
                "path_segment": comp.get("path_segment", comp["slug"]),
                "latest_year": latest["year"],
                "latest_uploads": latest.get("uploads", 0),
                "uploads_delta": _percentage_delta(latest.get("uploads", 0), prev_uploads),
                "countries": latest.get("countries", 0),
                "lifetime_uploads": sum(entry.get("uploads", 0) for entry in comp["years"]),
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
    upload_trend = [entry.get("uploads", 0) for entry in sorted_years[:6]]

    # Safe access for delta calculation
    prev_year_uploads = sorted_years[1].get("uploads", 0) if len(sorted_years) > 1 else None

    # Add percentage calculations to country_stats for each year entry
    formatted_yearly_stats = []
    for year_entry in sorted_years:
        formatted_entry = {**year_entry}
        if "country_stats" in formatted_entry and formatted_entry["country_stats"]:
            formatted_entry["country_stats"] = [
                {
                    **stat,
                    "images_used_pct": _percentage(
                        stat.get("images_used", 0),
                        stat.get("uploads", 0)
                    ),
                    "new_uploaders_pct": _percentage(
                        stat.get("new_uploaders", 0),
                        stat.get("uploaders", 0)
                    ),
                }
                for stat in formatted_entry["country_stats"]
            ]
        formatted_yearly_stats.append(formatted_entry)

    return {
        "slug": comp["slug"],
        "name": comp["name"],
        "short_label": comp.get("short_label", comp["name"]),
        "tagline": comp.get("tagline", ""),
        "hero_image": comp.get("hero_image", ""),
        "accent_color": comp.get("accent_color", "#000"),
        "logo": comp.get("logo"),
        "links": comp.get("links", {}),
        "spotlight": {
            "countries": latest.get("countries", 0),
            "uploads": latest.get("uploads", 0),
            "images_used": latest.get("images_used", 0),
            "uploaders": latest.get("uploaders", 0),
            "new_uploaders": latest.get("new_uploaders", 0),
            "uploads_delta": _percentage_delta(
                latest.get("uploads", 0),
                prev_year_uploads,
            ),
        },
        "yearly_stats": formatted_yearly_stats,
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
                "region": country.get("region", "Global"),
                "first_year": country.get("first_year", 2025),
                "focus": focus,
                "spotlight": country.get("spotlight", ""),
                "trend": [entry.get("uploads", 0) for entry in recent[-4:]],
            }
        )
    return summaries


def build_country_detail(slug: str) -> Optional[Dict]:
    country = _find_country(slug)
    if not country:
        return None

    activity = sorted(country.get("recent_activity", []), key=lambda e: e["year"])
    uploads = [entry.get("uploads", 0) for entry in activity]
    trend = uploads[-6:]

    return {
        "slug": country["slug"],
        "name": country["name"],
        "region": country.get("region", "Global"),
        "focus": country.get("focus", []),
        "first_year": country.get("first_year", 2025),
        "spotlight": country.get("spotlight", ""),
        "recent_activity": activity,
        "trend": trend,
    }


def build_overview_stats() -> Dict:
    totals = defaultdict(int)
    latest_uploads = []

    for comp in COMPETITIONS:
        for entry in comp["years"]:
            totals["uploads"] += entry.get("uploads", 0)
            totals["images_used"] += entry.get("images_used", 0)
            totals["countries_total"] = max(totals["countries_total"], entry.get("countries", 0))
        
        if comp["years"]:
            latest = _latest_year_entry(comp["years"])
            latest_uploads.append(latest.get("uploads", 0))

    return {
        "total_uploads": totals["uploads"],
        "total_images_used": totals["images_used"],
        "max_countries": totals["countries_total"],
        "avg_latest_uploads": int(mean(latest_uploads)) if latest_uploads else 0,
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