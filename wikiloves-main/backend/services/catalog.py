from collections import defaultdict
from statistics import mean
from typing import Dict, List, Optional

from data.catalog import COMPETITIONS, COUNTRIES

# Import campaign metadata for category filtering
try:
    import sys
    import os
    sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'data'))
    from campaigns_metadata import (
        get_campaign_by_slug,
        CATEGORY_INTERNATIONAL,
        CATEGORY_REGIONAL,
        CATEGORY_LOCAL
    )
except ImportError:
    # Fallback if metadata not available
    def get_campaign_by_slug(slug):
        return None
    CATEGORY_INTERNATIONAL = "international"
    CATEGORY_REGIONAL = "regional"
    CATEGORY_LOCAL = "local"


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


def build_competition_summaries(category: Optional[str] = None) -> List[Dict]:
    """
    Build competition summaries, optionally filtered by category.
    
    Args:
        category: Optional category filter ('international', 'regional', 'local')
    
    Returns:
        List of competition summary dictionaries
    """
    summaries = []
    for comp in COMPETITIONS:
        # Filter by category if specified
        if category:
            campaign_meta = get_campaign_by_slug(comp["slug"])
            if not campaign_meta or campaign_meta.get("category") != category:
                continue
        
        sorted_years_raw = sorted(comp["years"], key=lambda y: y["year"], reverse=True) if comp.get("years") else []
        
        # Get category from metadata
        campaign_meta = get_campaign_by_slug(comp["slug"])
        category_value = campaign_meta.get("category") if campaign_meta else None
        
        # Handle campaigns with no data
        if not sorted_years_raw:
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
                    "category": category_value,
                    "latest_year": None,
                    "latest_uploads": 0,
                    "uploads_delta": 0.0,
                    "countries": 0,
                    "lifetime_uploads": 0,
                    "year_count": 0,
                    "trend": [],
                    "yearly_stats": [],
                    "has_data": False,
                }
            )
            continue
            
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
                "category": category_value,
                "latest_year": latest["year"],
                "latest_uploads": latest.get("uploads", 0),
                "uploads_delta": _percentage_delta(latest.get("uploads", 0), prev_uploads),
                "countries": latest.get("countries", 0),
                "lifetime_uploads": sum(entry.get("uploads", 0) for entry in comp["years"]),
                "year_count": len(comp["years"]),
                "trend": list(reversed(trend)),
                "yearly_stats": sorted_years,
                "has_data": True,
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
        years = sorted([entry["year"] for entry in comp.get("years", [])], reverse=True) if comp.get("years") else []
        path_segment = comp.get("path_segment", comp["slug"])
        
        # Get category from metadata
        campaign_meta = get_campaign_by_slug(comp["slug"])
        category_value = campaign_meta.get("category") if campaign_meta else None
        
        nav.append(
            {
                "type": "competition",
                "label": comp.get("short_label", comp["name"]),
                "slug": comp["slug"],
                "path_segment": path_segment,
                "logo": comp.get("logo"),
                "category": category_value,
                "years": years,
                "path": f"/{path_segment}",
            }
        )
    return nav


def build_cross_campaign_comparison(year: Optional[int] = None) -> Dict:
    """
    Build cross-campaign comparison statistics.
    
    Args:
        year: Optional year filter. If None, uses latest year for each campaign.
    
    Returns:
        Dictionary with comparison statistics
    """
    comparison_data = []
    
    for comp in COMPETITIONS:
        if not comp.get("years"):
            continue
        
        if year:
            year_entry = next((y for y in comp["years"] if y["year"] == year), None)
            if not year_entry:
                continue
            stats = year_entry
        else:
            stats = _latest_year_entry(comp["years"])
        
        comparison_data.append({
            "slug": comp["slug"],
            "name": comp["name"],
            "short_label": comp.get("short_label", comp["name"]),
            "year": stats.get("year"),
            "uploads": stats.get("uploads", 0),
            "countries": stats.get("countries", 0),
            "uploaders": stats.get("uploaders", 0),
            "images_used": stats.get("images_used", 0),
            "images_used_pct": _percentage(
                stats.get("images_used", 0),
                stats.get("uploads", 0)
            ),
        })
    
    # Sort by uploads descending
    comparison_data.sort(key=lambda x: x["uploads"], reverse=True)
    
    return {
        "year": year,
        "campaigns": comparison_data,
        "total_campaigns": len(comparison_data),
        "total_uploads": sum(c["uploads"] for c in comparison_data),
    }


def build_campaign_country_detail(campaign_slug: str, year: int, country: str) -> Optional[Dict]:
    """
    Build daily statistics for a specific country in a campaign year.
    
    Args:
        campaign_slug: The campaign slug (e.g., 'earth')
        year: The year (e.g., 2025)
        country: The country name (e.g., 'Germany')
    
    Returns:
        Dictionary with daily statistics or None if not found
    """
    competition = _find_competition(campaign_slug)
    if not competition:
        return None
    
    # Find the year data
    year_data = next((y for y in competition.get("years", []) if y["year"] == year), None)
    if not year_data:
        return None
    
    # Find country in country_stats
    country_stats = year_data.get("country_stats", [])
    country_data = next((c for c in country_stats if c["name"].lower() == country.lower()), None)
    
    if not country_data:
        return None
    
    # Generate sample daily data (in a real implementation, this would come from a database)
    # For now, we'll create a structure that matches the live site
    daily_stats = _generate_daily_stats(country_data, year)
    
    return {
        "campaign": competition["name"],
        "campaign_slug": campaign_slug,
        "year": year,
        "country": country_data["name"],
        "total_uploads": country_data.get("uploads", 0),
        "total_uploaders": country_data.get("uploaders", 0),
        "total_images_used": country_data.get("images_used", 0),
        "total_new_uploaders": country_data.get("new_uploaders", 0),
        "daily_stats": daily_stats,
        "category_name": f"Images_from_Wiki_Loves_{competition['name'].replace(' ', '_')}_{year}_in_{country.replace(' ', '_')}",
    }


def _generate_daily_stats(country_data: Dict, year: int) -> List[Dict]:
    """
    Generate sample daily statistics.
    In a production system, this would query actual daily data from the database.
    """
    import random
    from datetime import datetime, timedelta
    
    # Determine the competition period (typically May-June for Earth)
    start_date = datetime(year, 5, 1)
    end_date = datetime(year, 6, 30)
    
    total_uploads = country_data.get("uploads", 0)
    total_uploaders = country_data.get("uploaders", 0)
    
    daily_data = []
    current_date = start_date
    remaining_uploads = total_uploads
    
    days = (end_date - start_date).days + 1
    
    while current_date <= end_date:
        # Distribute uploads across days with some randomness
        if days > 1:
            daily_uploads = max(1, int(remaining_uploads / days * random.uniform(0.5, 1.5)))
        else:
            daily_uploads = remaining_uploads
        
        daily_uploads = min(daily_uploads, remaining_uploads)
        
        # Estimate daily uploaders (roughly proportional to uploads)
        daily_uploaders = max(1, int(daily_uploads / (total_uploads / total_uploaders)) if total_uploads > 0 else 1)
        daily_uploaders = min(daily_uploaders, daily_uploads)
        
        # Estimate new uploaders
        new_uploaders = int(daily_uploaders * random.uniform(0.3, 0.8))
        new_uploaders_pct = int((new_uploaders / daily_uploaders * 100) if daily_uploaders > 0 else 0)
        
        daily_data.append({
            "date": current_date.strftime("%Y-%m-%d"),
            "uploads": daily_uploads,
            "uploaders": daily_uploaders,
            "new_uploaders": new_uploaders,
            "new_uploaders_pct": new_uploaders_pct,
        })
        
        remaining_uploads -= daily_uploads
        current_date += timedelta(days=1)
        days -= 1
        
        if remaining_uploads <= 0:
            break
    
    return daily_data


def build_trend_analysis(campaign_slugs: Optional[List[str]] = None) -> Dict:
    """
    Build trend analysis across campaigns.
    
    Args:
        campaign_slugs: Optional list of campaign slugs to include. If None, includes all.
    
    Returns:
        Dictionary with trend data
    """
    trends = {}
    
    for comp in COMPETITIONS:
        if campaign_slugs and comp["slug"] not in campaign_slugs:
            continue
        
        if not comp.get("years"):
            continue
        
        sorted_years = sorted(comp["years"], key=lambda y: y["year"])
        trends[comp["slug"]] = {
            "name": comp["name"],
            "short_label": comp.get("short_label", comp["name"]),
            "years": [y["year"] for y in sorted_years],
            "uploads": [y.get("uploads", 0) for y in sorted_years],
            "countries": [y.get("countries", 0) for y in sorted_years],
            "uploaders": [y.get("uploaders", 0) for y in sorted_years],
        }
    
    return {
        "trends": trends,
        "campaign_count": len(trends),
    }


def build_uploader_data(campaign_slug: str, year: int, country: str) -> Optional[Dict]:
    """
    Get uploader statistics for a specific campaign, year, and country.
    First tries to load from stored data, otherwise returns query instructions.
    
    Args:
        campaign_slug: The campaign slug (e.g., 'earth')
        year: The year (e.g., 2025)
        country: The country name (e.g., 'Albania')
    
    Returns:
        Dictionary with uploader data or query information
    """
    competition = _find_competition(campaign_slug)
    if not competition:
        return None
    
    campaign_name = competition["name"]
    
    # Try to load stored uploader data
    try:
        import sys
        import os
        scripts_path = os.path.join(os.path.dirname(__file__), '..', 'scripts')
        if scripts_path not in sys.path:
            sys.path.insert(0, scripts_path)
        from process_uploader_data import load_uploader_data
        uploaders = load_uploader_data(campaign_slug, year, country)
        
        if uploaders:
            # Return actual data
            return {
                "campaign": campaign_name,
                "campaign_slug": campaign_slug,
                "year": year,
                "country": country,
                "uploaders": uploaders,
                "total_uploaders": len(uploaders),
                "has_data": True
            }
    except (ImportError, Exception) as e:
        # If loading fails, continue to generate query
        pass
    
    # If no stored data, generate query instructions
    # First try to generate comprehensive query (all years/countries)
    try:
        from queries.quarry_templates import generate_all_uploaders_query, generate_uploader_query
        
        # Get quarry_category from metadata if available
        try:
            import sys
            import os
            data_path = os.path.join(os.path.dirname(__file__), '..', 'data')
            if data_path not in sys.path:
                sys.path.insert(0, data_path)
            from campaigns_metadata import get_campaign_by_slug, get_campaign_by_prefix
            
            # Try to find campaign metadata
            meta_campaign = get_campaign_by_slug(campaign_slug)
            if not meta_campaign:
                # Try by path_segment
                all_campaigns = get_all_campaigns()
                for camp in all_campaigns:
                    if camp.get('path_segment') == campaign_slug:
                        meta_campaign = camp
                        break
            
            quarry_category = meta_campaign.get('quarry_category') if meta_campaign else None
        except:
            quarry_category = None
        
        # Offer comprehensive query option (gets all years/countries at once)
        comprehensive_query = generate_all_uploaders_query(
            campaign_name=campaign_name,
            campaign_slug=campaign_slug,
            quarry_category=quarry_category
        )
        
        # Also generate specific query for this year/country (as fallback option)
        specific_query = generate_uploader_query(
            campaign_name=campaign_name,
            campaign_slug=campaign_slug,
            year=year,
            country=country
        )
        
        query = comprehensive_query  # Prefer comprehensive query
        
        return {
            "campaign": campaign_name,
            "campaign_slug": campaign_slug,
            "year": year,
            "country": country,
            "query": query,
            "instructions": {
                "step1": "Go to https://quarry.wmcloud.org/ and login with your Wikimedia account",
                "step2": "Click 'New Query'",
                "step3": "Select database: commonswiki_p",
                "step4": "Copy and paste the comprehensive query below (gets ALL years and ALL countries)",
                "step5": "Click 'Run' (query may take 10-30 minutes for large campaigns)",
                "step6": "Once complete, click 'Download' and select JSON format",
                "step7": f"Process the file using: python backend/scripts/process_all_uploaders.py <file.json> {campaign_slug}",
                "note": "This comprehensive query will process ALL years and countries at once, then organize them automatically."
            },
            "query_type": "comprehensive",
            "specific_query": specific_query,  # Also include specific query as alternative
            "quarry_url": "https://quarry.wmcloud.org/",
            "database": "commonswiki_p",
            "has_data": False
        }
    except ImportError:
        return None