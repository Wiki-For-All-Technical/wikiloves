#!/usr/bin/env python3
"""
Process bulk TSV files from fetch_all.sh into JSON cache files.

Reads: /tmp/wl_bulk/{campaign}_{year}.tsv
Writes:
  ~/shared/data/{campaign}_processed.json          (year-level summary + country_rows)
  ~/shared/data/country_detail/{campaign}_{year}_{Country}.json
  ~/shared/data/uploaders/{campaign}_{year}_{Country}.json
"""

import csv
import json
import os
import re
import sys
from collections import defaultdict
from pathlib import Path

TSV_DIR = "/tmp/wl_bulk"
STATIC_DIR = Path(os.path.expanduser("~/shared/static_data"))

DATA_DIR = Path(os.path.expanduser("~/shared/data"))
COUNTRY_DETAIL_DIR = DATA_DIR / "country_detail"
UPLOADERS_DIR = DATA_DIR / "uploaders"

CAMPAIGN_META = {
    "earth":      {"name": "Wiki Loves Earth",           "prefix": "Images_from_Wiki_Loves_Earth",           "comp_month": 5},
    "monuments":  {"name": "Wiki Loves Monuments",       "prefix": "Images_from_Wiki_Loves_Monuments",       "comp_month": 9},
    "science":    {"name": "Wiki Science Competition",   "prefix": "Images_from_Wiki_Science_Competition",   "comp_month": 11},
    "folklore":   {"name": "Wiki Loves Folklore",        "prefix": "Images_from_Wiki_Loves_Folklore",        "comp_month": 2},
    "africa":     {"name": "Wiki Loves Africa",          "prefix": "Images_from_Wiki_Loves_Africa",          "comp_month": 1},
    "food":       {"name": "Wiki Loves Food",            "prefix": "Images_from_Wiki_Loves_Food",            "comp_month": 1},
    "public_art": {"name": "Wiki Loves Public Art",      "prefix": "Images_from_Wiki_Loves_Public_Art",      "comp_month": 1},
}


def safe_key(campaign, year, country):
    raw = f"{campaign}_{year}_{country}"
    return re.sub(r'[^\w\-]', '_', raw)[:120]


def extract_country(category_name, prefix, year):
    """
    Extract country display name from category like Images_from_Wiki_Loves_Earth_2025_in_Germany.
    Returns None for subcategories (by_user, at_event, regional splits, etc.).
    """
    marker = f"{prefix}_{year}_in_"
    idx = category_name.find(marker)
    if idx == -1:
        return None
    raw = category_name[idx + len(marker):]
    country = raw.replace("_", " ")

    if " by " in country:
        return None
    if " at " in country:
        return None
    if re.search(r'\d', country):
        return None
    if " - " in country:
        return None
    if "Wiki" in country:
        return None
    if len(country) > 50:
        return None
    # Must start with uppercase (or "the")
    if country and not country[0].isupper() and not country.startswith("the "):
        return None

    return country


def load_static_country_whitelist():
    """
    Build a set of valid (slug, year, country_lower) from static JSON files.
    Used to validate extracted countries against known-good data.
    """
    whitelist = {}
    slug_to_file = {
        "earth": "wiki-earth.json",
        "monuments": "wiki-monuments.json",
        "science": "wiki-science-competition.json",
        "folklore": "wiki-folklore.json",
        "africa": "wiki-africa.json",
        "food": "wiki-food.json",
        "public_art": "wiki-public-art.json",
    }
    for slug, filename in slug_to_file.items():
        path = STATIC_DIR / filename
        if not path.exists():
            continue
        try:
            with open(path, "r", encoding="utf-8") as f:
                data = json.load(f)
            for yd in data.get("years", []):
                year = yd.get("year")
                rows = yd.get("country_rows", [])
                reported_countries = yd.get("countries", 0)
                # Only use as whitelist if the list is complete
                if rows and len(rows) >= reported_countries and reported_countries > 0:
                    countries = {(cr.get("country") or "").lower() for cr in rows}
                    whitelist[(slug, year)] = countries
        except (json.JSONDecodeError, OSError):
            pass
    return whitelist


def comp_start_ts(year, month):
    """Return competition start timestamp string like '20250501000000'."""
    return f"{year}{month:02d}01000000"


def clean_reg(reg_str):
    """Normalize user_registration to comparable format like '20250501000000'."""
    if not reg_str or reg_str == "NULL" or reg_str == "\\N":
        return ""
    return reg_str.replace("-", "").replace(" ", "").replace(":", "").replace("T", "")


def process_campaign(slug, country_whitelist=None):
    meta = CAMPAIGN_META[slug]
    campaign_name = meta["name"]
    prefix = meta["prefix"]
    comp_month = meta["comp_month"]

    years_data = []

    tsv_files = sorted(Path(TSV_DIR).glob(f"{slug}_*.tsv"))
    if not tsv_files:
        print(f"  No TSV files for {slug}")
        return

    for tsv_path in tsv_files:
        fname = tsv_path.stem
        parts = fname.rsplit("_", 1)
        if len(parts) != 2:
            continue
        try:
            year = int(parts[1])
        except ValueError:
            continue

        with open(tsv_path, "r", encoding="utf-8") as f:
            reader = csv.DictReader(f, delimiter="\t")
            rows = list(reader)

        if not rows:
            print(f"  {slug} {year}: empty")
            continue

        # Use whitelist if available for this campaign-year
        valid_countries = None
        if country_whitelist and (slug, year) in country_whitelist:
            valid_countries = country_whitelist[(slug, year)]

        start_ts = comp_start_ts(year, comp_month)

        # Group by country
        countries = defaultdict(lambda: {
            "uploads": 0,
            "uploaders": set(),
            "new_uploaders": set(),
            "user_reg": {},
            "daily": defaultdict(lambda: {"uploads": 0, "uploaders": set(), "new_uploaders": set()}),
            "user_uploads": defaultdict(int),
        })

        skipped_countries = set()
        for r in rows:
            cat = r.get("category", "")
            country = extract_country(cat, prefix, year)
            if not country:
                continue
            # If we have a whitelist for this year, only accept known countries
            if valid_countries and country.lower() not in valid_countries:
                skipped_countries.add(country)
                continue

            name = r.get("actor_name", "")
            reg = r.get("user_registration", "") or ""
            date = r.get("upload_date", "") or ""

            c = countries[country]
            c["uploads"] += 1
            c["uploaders"].add(name)
            c["user_uploads"][name] += 1

            if name not in c["user_reg"]:
                c["user_reg"][name] = reg

            is_new = clean_reg(reg) >= start_ts if clean_reg(reg) else False
            if is_new:
                c["new_uploaders"].add(name)

            if date:
                c["daily"][date]["uploads"] += 1
                c["daily"][date]["uploaders"].add(name)
                if is_new:
                    c["daily"][date]["new_uploaders"].add(name)

        if skipped_countries:
            print(f"    Skipped {len(skipped_countries)} subcategories (whitelist)")

        # Build per-country JSON files and summary rows
        country_rows = []
        year_total_uploads = 0
        year_total_uploaders = set()
        year_total_new = set()

        for country_name in sorted(countries.keys()):
            c = countries[country_name]
            total = c["uploads"]
            uploaders_count = len(c["uploaders"])
            new_count = len(c["new_uploaders"])

            year_total_uploads += total
            year_total_uploaders.update(c["uploaders"])
            year_total_new.update(c["new_uploaders"])

            # country_rows for year summary (matches wiki-earth.json format)
            country_rows.append({
                "country": country_name,
                "images": total,
                "images_used": 0,
                "images_used_pct": 0,
                "uploaders": uploaders_count,
                "new_uploaders": new_count,
                "new_uploaders_pct": round(100 * new_count / uploaders_count) if uploaders_count else 0,
            })

            # country_detail JSON
            category_name = f"{prefix}_{year}_in_{country_name.replace(' ', '_')}"
            year_prefix = str(year)
            daily_stats = []
            for dt in sorted(c["daily"].keys()):
                if not dt.startswith(year_prefix):
                    continue
                d = c["daily"][dt]
                nu = len(d["new_uploaders"])
                upl = len(d["uploaders"])
                pct = round(100 * nu / upl) if upl else 0
                daily_stats.append({
                    "date": dt,
                    "uploads": d["uploads"],
                    "uploaders": upl,
                    "new_uploaders": nu,
                    "new_uploaders_pct": f"{pct}%",
                })

            detail = {
                "campaign": campaign_name,
                "year": year,
                "country": country_name,
                "category_name": category_name,
                "total_uploads": total,
                "total_uploaders": uploaders_count,
                "total_images_used": 0,
                "total_new_uploaders": new_count,
                "daily_stats": daily_stats,
            }

            sk = safe_key(slug, year, country_name)
            detail_path = COUNTRY_DETAIL_DIR / f"{sk}.json"
            with open(detail_path, "w", encoding="utf-8") as f:
                json.dump(detail, f, ensure_ascii=False)

            # uploaders JSON
            uploaders_list = sorted(
                [
                    {
                        "username": u,
                        "uploads": cnt,
                        "percentage": round(100 * cnt / total, 2) if total else 0,
                    }
                    for u, cnt in c["user_uploads"].items()
                ],
                key=lambda x: x["uploads"],
                reverse=True,
            )

            upl_data = {"uploaders": uploaders_list, "total_uploads": total}
            upl_path = UPLOADERS_DIR / f"{sk}.json"
            with open(upl_path, "w", encoding="utf-8") as f:
                json.dump(upl_data, f, ensure_ascii=False)

        # Sort country_rows by images descending
        country_rows.sort(key=lambda x: x["images"], reverse=True)

        year_uploaders_total = len(year_total_uploaders)
        year_new_total = len(year_total_new)

        year_entry = {
            "year": year,
            "countries": len(countries),
            "uploads": year_total_uploads,
            "images_used": 0,
            "images_used_pct": 0,
            "uploaders": year_uploaders_total,
            "new_uploaders": year_new_total,
            "new_uploaders_pct": round(100 * year_new_total / year_uploaders_total) if year_uploaders_total else 0,
            "country_rows": country_rows,
        }
        years_data.append(year_entry)

        print(f"  {slug} {year}: {len(countries)} countries, {year_total_uploads} uploads, "
              f"{year_uploaders_total} uploaders, {year_new_total} new")

    # Sort years ascending
    years_data.sort(key=lambda x: x["year"])

    # Also add country_stats for API fallback (same data, different field names)
    for yd in years_data:
        yd["country_stats"] = [
            {
                "name": cr["country"],
                "uploads": cr["images"],
                "uploaders": cr["uploaders"],
                "images_used": cr["images_used"],
                "new_uploaders": cr["new_uploaders"],
                "images_used_pct": cr["images_used_pct"],
                "new_uploaders_pct": cr["new_uploaders_pct"],
            }
            for cr in yd["country_rows"]
        ]

    processed = {
        "campaign": slug,
        "campaign_name": campaign_name,
        "slug": slug,
        "source": "bulk_fetch",
        "years": years_data,
    }

    out_path = DATA_DIR / f"{slug}_processed.json"
    with open(out_path, "w", encoding="utf-8") as f:
        json.dump(processed, f, ensure_ascii=False)
    print(f"  Saved {out_path}")


def load_static_images_used():
    """
    Load images_used data from static JSON files (wiki-earth.json etc.).
    These files come from the existing wikiloves.toolforge.org tool.
    Returns dict: { (slug, year, country_lower): images_used_count }
    """
    lookup = {}
    slug_to_file = {
        "earth": "wiki-earth.json",
        "monuments": "wiki-monuments.json",
        "science": "wiki-science-competition.json",
        "folklore": "wiki-folklore.json",
        "africa": "wiki-africa.json",
        "food": "wiki-food.json",
        "public_art": "wiki-public-art.json",
    }

    for slug, filename in slug_to_file.items():
        path = STATIC_DIR / filename
        if not path.exists():
            continue
        try:
            with open(path, "r", encoding="utf-8") as f:
                data = json.load(f)
            for yd in data.get("years", []):
                year = yd.get("year")
                # Year-level images_used (for year summary)
                if yd.get("images_used"):
                    lookup[(slug, year, "__year__")] = yd["images_used"]
                    if yd.get("images_used_pct"):
                        lookup[(slug, year, "__year_pct__")] = yd["images_used_pct"]
                # Country-level
                for cr in yd.get("country_rows", []):
                    country = (cr.get("country") or "").lower()
                    if country and cr.get("images_used") is not None:
                        lookup[(slug, year, country)] = cr["images_used"]
                        if cr.get("images_used_pct") is not None:
                            lookup[(slug, year, f"{country}__pct")] = cr["images_used_pct"]
        except (json.JSONDecodeError, OSError) as e:
            print(f"  Warning: could not read {path}: {e}")

    return lookup


def merge_images_used(slug, processed_data, images_lookup):
    """Merge images_used from static data into processed + detail cache files."""
    merged_count = 0

    for yd in processed_data.get("years", []):
        year = yd["year"]

        # Year-level
        iu = images_lookup.get((slug, year, "__year__"), 0)
        iu_pct = images_lookup.get((slug, year, "__year_pct__"), 0)
        if iu:
            yd["images_used"] = iu
            yd["images_used_pct"] = iu_pct

        # Country-level
        for cr in yd.get("country_rows", []):
            country_lower = cr["country"].lower()
            cr_iu = images_lookup.get((slug, year, country_lower), 0)
            cr_pct = images_lookup.get((slug, year, f"{country_lower}__pct"), 0)
            if cr_iu:
                cr["images_used"] = cr_iu
                cr["images_used_pct"] = cr_pct
                merged_count += 1

        for cs in yd.get("country_stats", []):
            country_lower = cs["name"].lower()
            cs_iu = images_lookup.get((slug, year, country_lower), 0)
            cs_pct = images_lookup.get((slug, year, f"{country_lower}__pct"), 0)
            if cs_iu:
                cs["images_used"] = cs_iu
                cs["images_used_pct"] = cs_pct

        # Update country_detail cache files
        for cr in yd.get("country_rows", []):
            country_lower = cr["country"].lower()
            cr_iu = images_lookup.get((slug, year, country_lower), 0)
            if cr_iu:
                sk = safe_key(slug, year, cr["country"])
                detail_path = COUNTRY_DETAIL_DIR / f"{sk}.json"
                if detail_path.exists():
                    try:
                        with open(detail_path, "r", encoding="utf-8") as f:
                            detail = json.load(f)
                        detail["total_images_used"] = cr_iu
                        with open(detail_path, "w", encoding="utf-8") as f:
                            json.dump(detail, f, ensure_ascii=False)
                    except (json.JSONDecodeError, OSError):
                        pass

    return merged_count


def main():
    COUNTRY_DETAIL_DIR.mkdir(parents=True, exist_ok=True)
    UPLOADERS_DIR.mkdir(parents=True, exist_ok=True)

    campaigns = list(CAMPAIGN_META.keys())
    if len(sys.argv) > 1:
        campaigns = [c for c in sys.argv[1:] if not c.startswith("-")]
        for c in campaigns:
            if c not in CAMPAIGN_META:
                print(f"Unknown campaign: {c}")
                print(f"Available: {', '.join(CAMPAIGN_META.keys())}")
                sys.exit(1)

    print(f"Processing {len(campaigns)} campaigns from {TSV_DIR}")
    print(f"Output: {DATA_DIR}")

    # Load static images_used data
    images_lookup = {}
    if STATIC_DIR.exists():
        print(f"Loading static images_used from {STATIC_DIR}")
        images_lookup = load_static_images_used()
        print(f"  Loaded {len(images_lookup)} images_used entries")
    else:
        print(f"No static data dir ({STATIC_DIR}), images_used will be 0")
    print()

    # Load country whitelist from static data
    country_whitelist = {}
    if STATIC_DIR.exists():
        country_whitelist = load_static_country_whitelist()
        wl_years = sum(1 for _ in country_whitelist)
        print(f"  Country whitelist loaded for {wl_years} campaign-years")
    print()

    for slug in campaigns:
        print(f"=== {CAMPAIGN_META[slug]['name']} ({slug}) ===")
        process_campaign(slug, country_whitelist=country_whitelist)

        # Merge images_used from static data
        if images_lookup:
            out_path = DATA_DIR / f"{slug}_processed.json"
            if out_path.exists():
                with open(out_path, "r", encoding="utf-8") as f:
                    processed = json.load(f)
                merged = merge_images_used(slug, processed, images_lookup)
                with open(out_path, "w", encoding="utf-8") as f:
                    json.dump(processed, f, ensure_ascii=False)
                if merged:
                    print(f"  Merged images_used for {merged} country entries")
        print()

    print("Done! All JSON cache files generated.")
    print(f"  Processed JSONs: {DATA_DIR}/<campaign>_processed.json")
    print(f"  Country detail:  {COUNTRY_DETAIL_DIR}/")
    print(f"  Uploaders:       {UPLOADERS_DIR}/")


if __name__ == "__main__":
    main()
