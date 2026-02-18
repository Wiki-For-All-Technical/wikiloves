"""
Process Quarry query results and convert them to the format expected by the catalog system.
This script can process CSV/JSON exports from Quarry and integrate them into the data pipeline.
"""

import json
import csv
import os
import sys
from typing import Dict, List, Optional
from datetime import datetime

# Add parent directory to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))
from data.campaigns_metadata import get_campaign_by_prefix, get_all_campaigns


def process_quarry_csv(csv_path: str, campaign_prefix: str, year: int) -> Dict:
    """
    Process a CSV file exported from Quarry.
    
    Expected CSV format:
    - Columns: country, uploads, uploaders, new_uploaders, images_used
    - Or: user_registration, uploads, uploaders, images_used
    
    Returns:
        Dictionary with processed statistics
    """
    country_stats = []
    total_uploads = 0
    total_uploaders = 0
    total_new_uploaders = 0
    total_images_used = 0
    
    with open(csv_path, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        
        for row in reader:
            uploads = int(row.get('uploads', 0) or 0)
            uploaders = int(row.get('uploaders', 0) or 0)
            new_uploaders = int(row.get('new_uploaders', 0) or 0)
            images_used = int(row.get('images_used', 0) or 0)
            
            # If country column exists, use it; otherwise aggregate
            country_name = row.get('country', 'Unknown')
            
            if country_name and country_name != 'Unknown':
                country_stats.append({
                    "name": country_name,
                    "uploads": uploads,
                    "images_used": images_used,
                    "uploaders": uploaders,
                    "new_uploaders": new_uploaders,
                })
            
            total_uploads += uploads
            total_uploaders = max(total_uploaders, uploaders)  # Use max for distinct count
            total_new_uploaders += new_uploaders
            total_images_used += images_used
    
    # Rank countries by uploads
    country_stats.sort(key=lambda x: x["uploads"], reverse=True)
    for i, stat in enumerate(country_stats):
        stat["rank"] = i + 1
    
    return {
        "year": year,
        "countries": len(country_stats),
        "uploads": total_uploads,
        "images_used": total_images_used,
        "uploaders": total_uploaders,
        "new_uploaders": total_new_uploaders,
        "country_stats": country_stats,
    }


def process_quarry_json(json_path: str, campaign_prefix: str, year: int = None) -> Dict:
    """
    Process a JSON file exported from Quarry.
    
    Expected JSON format:
    - Array of objects with: country, uploads, uploaders, new_uploaders, images_used
    - OR multi-year format with: year, country (optional), uploads, uploaders, etc.
    
    Args:
        json_path: Path to JSON file
        campaign_prefix: Campaign prefix (e.g., 'monuments')
        year: Optional year. If None and data has 'year' column, will process as multi-year
    """
    with open(json_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    if not isinstance(data, list):
        raise ValueError("JSON file must contain an array of objects")
    
    # Check if this is multi-year data (has 'year' column in first row)
    if data and 'year' in data[0]:
        # Multi-year format - return list of year data
        return process_multiyear_json(data, campaign_prefix)
    
    country_stats = []
    total_uploads = 0
    total_uploaders = 0  # Will use max for summary, sum for country breakdown
    total_new_uploaders = 0
    total_images_used = 0
    countries_set = set()
    
    # Check if this is summary data (single row) or country data (multiple rows)
    is_summary_data = len(data) == 1 and 'country' not in data[0]
    
    for row in data:
        uploads = int(row.get('uploads', 0) or 0)
        uploaders = int(row.get('uploaders', 0) or 0)
        new_uploaders = int(row.get('new_uploaders', 0) or 0)
        images_used = int(row.get('images_used', 0) or 0)
        country_name = row.get('country', row.get('name', None))
        
        if country_name and country_name != 'Unknown' and country_name != 'Global':
            if country_name not in countries_set:
                country_stats.append({
                    "name": country_name,
                    "uploads": uploads,
                    "images_used": images_used,
                    "uploaders": uploaders,
                    "new_uploaders": new_uploaders,
                })
                countries_set.add(country_name)
            else:
                # Merge if country appears multiple times
                for stat in country_stats:
                    if stat["name"] == country_name:
                        stat["uploads"] += uploads
                        stat["images_used"] += images_used
                        stat["uploaders"] = max(stat["uploaders"], uploaders)
                        stat["new_uploaders"] += new_uploaders
                        break
        
        total_uploads += uploads
        # For summary data, use the value directly; for country data, use max
        if is_summary_data:
            total_uploaders = uploaders  # Single value for summary
        else:
            total_uploaders = max(total_uploaders, uploaders)  # Max across countries
        total_new_uploaders += new_uploaders
        total_images_used += images_used
    
    # Rank countries by uploads
    country_stats.sort(key=lambda x: x["uploads"], reverse=True)
    for i, stat in enumerate(country_stats):
        stat["rank"] = i + 1
    
    return {
        "year": year,
        "countries": len(country_stats),
        "uploads": total_uploads,
        "images_used": total_images_used,
        "uploaders": total_uploaders,
        "new_uploaders": total_new_uploaders,
        "country_stats": country_stats,
    }


def process_multiyear_json(data: List[Dict], campaign_prefix: str) -> List[Dict]:
    """
    Process multi-year JSON data (rows with 'year' column).
    
    Returns a list of year data dictionaries, one per year.
    """
    # Group data by year
    years_data = {}
    
    for row in data:
        year = int(row.get('year', 0))
        if year == 0:
            continue
        
        if year not in years_data:
            years_data[year] = {
                "year": year,
                "uploads": 0,
                "uploaders": 0,
                "images_used": 0,
                "new_uploaders": 0,
                "country_stats": []
            }
        
        # Check if this row has country data
        country_name = row.get('country', row.get('name', None))
        
        if country_name and country_name not in ['Unknown', 'Global', None]:
            # Country-level data
            years_data[year]["country_stats"].append({
                "name": country_name,
                "uploads": int(row.get('uploads', 0) or 0),
                "images_used": int(row.get('images_used', 0) or 0),
                "uploaders": int(row.get('uploaders', 0) or 0),
                "new_uploaders": int(row.get('new_uploaders', 0) or 0),
            })
        else:
            # Summary data for this year
            years_data[year]["uploads"] = int(row.get('uploads', 0) or 0)
            years_data[year]["uploaders"] = int(row.get('uploaders', 0) or 0)
            years_data[year]["images_used"] = int(row.get('images_used', 0) or 0)
            years_data[year]["new_uploaders"] = int(row.get('new_uploaders', 0) or 0)
    
    # Process country stats for each year
    result = []
    for year, year_data in sorted(years_data.items(), reverse=True):
        country_stats = year_data["country_stats"]
        
        # If we have country stats, calculate totals from them
        if country_stats:
            total_uploads = sum(c["uploads"] for c in country_stats)
            total_uploaders = max((c["uploaders"] for c in country_stats), default=0)
            total_images_used = sum(c["images_used"] for c in country_stats)
            total_new_uploaders = sum(c["new_uploaders"] for c in country_stats)
            
            # Rank countries
            country_stats.sort(key=lambda x: x["uploads"], reverse=True)
            for i, stat in enumerate(country_stats):
                stat["rank"] = i + 1
            
            year_data["uploads"] = total_uploads
            year_data["uploaders"] = total_uploaders
            year_data["images_used"] = total_images_used
            year_data["new_uploaders"] = total_new_uploaders
            year_data["countries"] = len(country_stats)
        else:
            # Summary data only
            year_data["countries"] = 0
        
        result.append(year_data)
    
    return result


def merge_quarry_data_into_catalog(quarry_data_dir: str, output_catalog_path: str, merge_existing: bool = True):
    """
    Merge Quarry query results from multiple campaigns into the catalog format.
    
    Expected directory structure:
    quarry_data_dir/
        campaign_prefix_year.json (or .csv)
        e.g., earth_2024.json, monuments_2023.json
    
    Args:
        quarry_data_dir: Directory containing Quarry export files
        output_catalog_path: Path to output catalog.py file
        merge_existing: If True, merge with existing catalog.py; if False, create new
    """
    # Load existing catalog if merging
    existing_competitions = {}
    existing_countries = {}
    
    if merge_existing and os.path.exists(output_catalog_path):
        try:
            catalog_globals = {}
            with open(output_catalog_path, 'r', encoding='utf-8') as f:
                exec(f.read(), catalog_globals)
            existing_comps = catalog_globals.get('COMPETITIONS', [])
            existing_ctries = catalog_globals.get('COUNTRIES', [])
            
            # Index by slug for easy lookup
            for comp in existing_comps:
                existing_competitions[comp.get('slug')] = comp
            for country in existing_ctries:
                existing_countries[country.get('name')] = country
            
            print(f"📖 Loaded existing catalog: {len(existing_competitions)} competitions, {len(existing_countries)} countries")
        except Exception as e:
            print(f"⚠️  Warning: Could not load existing catalog: {e}")
            print("   Creating new catalog...")
    
    all_competitions = existing_competitions.copy()
    all_countries = existing_countries.copy()
    
    # Get list of files to process
    files_to_process = [f for f in os.listdir(quarry_data_dir) 
                       if f.endswith('.json') or f.endswith('.csv')]
    
    if not files_to_process:
        print(f"❌ Error: No JSON or CSV files found in {quarry_data_dir}")
        print("   Expected files named: {campaign_prefix}_{year}.json")
        return
    
    print(f"\n📦 Processing {len(files_to_process)} file(s)...\n")
    
    processed_count = 0
    skipped_count = 0
    error_count = 0
    
    # Process all files in the directory
    for filename in sorted(files_to_process):
        if not (filename.endswith('.json') or filename.endswith('.csv')):
            continue
        
        # Parse filename: campaign_year.ext
        base_name = os.path.splitext(filename)[0]
        parts = base_name.rsplit('_', 1)
        
        if len(parts) != 2:
            print(f"⚠️  Skipping {filename} - invalid format")
            print(f"   Expected: {{campaign_prefix}}_{{year}}.json (e.g., monuments_2024.json)")
            skipped_count += 1
            continue
        
        campaign_prefix, year_str = parts
        
        try:
            year = int(year_str)
            if year < 2010 or year > 2100:
                raise ValueError("Year out of reasonable range")
        except ValueError:
            print(f"⚠️  Skipping {filename} - invalid year: '{year_str}'")
            print(f"   Year must be 4 digits (e.g., 2024)")
            skipped_count += 1
            continue
        
        # Get campaign metadata
        campaign = get_campaign_by_prefix(campaign_prefix)
        if not campaign:
            print(f"⚠️  Skipping {filename} - unknown campaign prefix: '{campaign_prefix}'")
            print(f"   Check backend/data/campaigns_metadata.py for valid prefixes")
            print(f"   Common prefixes: monuments, earth, africa, folklore, science, public_art")
            skipped_count += 1
            continue
        
        # Process the file
        file_path = os.path.join(quarry_data_dir, filename)
        
        try:
            if filename.endswith('.json'):
                # Check if this is a multi-year file (contains 'multiyear' in name)
                is_multiyear = 'multiyear' in filename.lower()
                
                if is_multiyear:
                    # Process as multi-year
                    processed_data = process_quarry_json(file_path, campaign_prefix, None)
                    
                    # Multi-year format returns list of year data
                    if isinstance(processed_data, list):
                        for year_data in processed_data:
                            year = year_data["year"]
                            # Process this year's data
                            comp_slug = campaign["slug"]
                            if comp_slug in all_competitions:
                                existing_comp = all_competitions[comp_slug]
                                existing_years = [y.get('year') for y in existing_comp.get('years', [])]
                                
                                if year in existing_years:
                                    existing_comp['years'] = [y for y in existing_comp['years'] if y.get('year') != year]
                                    existing_comp['years'].append(year_data)
                                else:
                                    existing_comp['years'].append(year_data)
                            else:
                                all_competitions[comp_slug] = {
                                    "slug": campaign["slug"],
                                    "name": campaign["name"],
                                    "short_label": campaign["short_label"],
                                    "tagline": campaign["tagline"],
                                    "accent_color": campaign["accent_color"],
                                    "hero_image": campaign.get("hero_image", ""),
                                    "logo": campaign.get("logo", ""),
                                    "path_segment": campaign["path_segment"],
                                    "years": [year_data],
                                    "links": {"toolforge": f"https://wikiloves.toolforge.org/{campaign['path_segment']}"}
                                }
                            
                            # Update country profiles
                            country_stats = year_data.get("country_stats", [])
                            if country_stats:
                                for country_stat in country_stats:
                                    country_name = country_stat["name"]
                                    
                                    if country_name not in all_countries:
                                        all_countries[country_name] = {
                                            "slug": country_name.lower().replace(" ", "-"),
                                            "name": country_name,
                                            "region": "Global",
                                            "first_year": year,
                                            "focus": set(),
                                            "recent_activity": []
                                        }
                                    
                                    country_profile = all_countries[country_name]
                                    if isinstance(country_profile.get("focus"), set):
                                        country_profile["focus"].add(campaign["name"])
                                    else:
                                        country_profile["focus"] = set(country_profile.get("focus", []))
                                        country_profile["focus"].add(campaign["name"])
                                    
                                    country_profile["first_year"] = min(country_profile["first_year"], year)
                                    country_profile["recent_activity"].append({
                                        "competition": campaign["slug"],
                                        "year": year,
                                        "uploads": country_stat["uploads"]
                                    })
                        
                        print(f"✓ Processed {filename} - {len(processed_data)} years")
                        processed_count += len(processed_data)
                        continue
                
                year_data = process_quarry_json(file_path, campaign_prefix, year)
            else:
                year_data = process_quarry_csv(file_path, campaign_prefix, year)
            
            # Get or create competition entry
            comp_slug = campaign["slug"]
            if comp_slug in all_competitions:
                # Existing competition - check if year exists
                existing_comp = all_competitions[comp_slug]
                existing_years = [y.get('year') for y in existing_comp.get('years', [])]
                
                if year in existing_years:
                    # Year exists - merge or replace?
                    print(f"   ⚠️  Year {year} already exists for {campaign['name']}")
                    # For now, replace the year data
                    existing_comp['years'] = [y for y in existing_comp['years'] if y.get('year') != year]
                    existing_comp['years'].append(year_data)
                    print(f"   ✓ Replaced year {year} data")
                else:
                    existing_comp['years'].append(year_data)
                    print(f"✓ Processed {filename} - Added year {year} to {campaign['name']}")
            else:
                # New competition
                all_competitions[comp_slug] = {
                    "slug": campaign["slug"],
                    "name": campaign["name"],
                    "short_label": campaign["short_label"],
                    "tagline": campaign["tagline"],
                    "accent_color": campaign["accent_color"],
                    "hero_image": campaign.get("hero_image", ""),
                    "logo": campaign.get("logo", ""),
                    "path_segment": campaign["path_segment"],
                    "years": [year_data],
                    "links": {"toolforge": f"https://wikiloves.toolforge.org/{campaign['path_segment']}"}
                }
                print(f"✓ Processed {filename} - Created new campaign: {campaign['name']} ({year})")
            
            processed_count += 1
            
            # Update country profiles (only if country stats exist)
            country_stats = year_data.get("country_stats", [])
            if country_stats:
                for country_stat in country_stats:
                    country_name = country_stat["name"]
                    
                    if country_name not in all_countries:
                        all_countries[country_name] = {
                            "slug": country_name.lower().replace(" ", "-"),
                            "name": country_name,
                            "region": "Global",
                            "first_year": year,
                            "focus": set(),
                            "recent_activity": []
                        }
                    
                    country_profile = all_countries[country_name]
                    if isinstance(country_profile.get("focus"), set):
                        country_profile["focus"].add(campaign["name"])
                    else:
                        country_profile["focus"] = set(country_profile.get("focus", []))
                        country_profile["focus"].add(campaign["name"])
                    
                    country_profile["first_year"] = min(country_profile["first_year"], year)
                    country_profile["recent_activity"].append({
                        "competition": campaign["slug"],
                        "year": year,
                        "uploads": country_stat["uploads"]
                    })
            else:
                # Summary data only - no country breakdown
                print(f"   ℹ️  No country breakdown in this file (summary data only)")
            
        except Exception as e:
            print(f"❌ Error processing {filename}: {e}")
            import traceback
            print(f"   Details: {traceback.format_exc().split(chr(10))[-2]}")
            error_count += 1
            continue
    
    # Sort years for each competition
    for comp in all_competitions.values():
        comp["years"].sort(key=lambda y: y["year"], reverse=True)
    
    # Convert to lists and format
    final_competitions = list(all_competitions.values())
    final_countries = []
    
    for name, profile in all_countries.items():
        # Ensure focus is a list
        if isinstance(profile.get("focus"), set):
            profile["focus"] = list(profile["focus"])
        elif not isinstance(profile.get("focus"), list):
            profile["focus"] = []
        
        # Sort recent activity
        if "recent_activity" in profile:
            profile["recent_activity"].sort(key=lambda x: x.get("year", 0))
        final_countries.append(profile)
    
    final_countries.sort(key=lambda x: x.get("name", ""))
    
    # Write to catalog.py
    output_code = f"""COMPETITIONS = {json.dumps(final_competitions, indent=4, ensure_ascii=False)}

COUNTRIES = {json.dumps(final_countries, indent=4, ensure_ascii=False)}
"""
    
    os.makedirs(os.path.dirname(output_catalog_path), exist_ok=True)
    
    with open(output_catalog_path, 'w', encoding='utf-8') as f:
        f.write(output_code)
    
    # Summary report
    print(f"\n{'='*60}")
    print(f"📊 Processing Summary")
    print(f"{'='*60}")
    print(f"✅ Successfully processed: {processed_count} file(s)")
    if skipped_count > 0:
        print(f"⚠️  Skipped: {skipped_count} file(s)")
    if error_count > 0:
        print(f"❌ Errors: {error_count} file(s)")
    print(f"\n📁 Updated: {output_catalog_path}")
    print(f"   - {len(final_competitions)} competitions")
    print(f"   - {len(final_countries)} countries")
    print(f"{'='*60}\n")


if __name__ == "__main__":
    import argparse
    
    parser = argparse.ArgumentParser(
        description="Process Quarry query results into catalog format",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Process all files in quarry_data folder
  python process_quarry_results.py quarry_data

  # Process and output to specific location
  python process_quarry_results.py quarry_data --output backend/data/catalog.py

  # Create new catalog (don't merge with existing)
  python process_quarry_results.py quarry_data --no-merge

File naming:
  Files must be named: {campaign_prefix}_{year}.json
  Examples: monuments_2024.json, earth_2023.json
        """
    )
    parser.add_argument("quarry_dir", help="Directory containing Quarry export files")
    parser.add_argument("--output", default="data/catalog.py", 
                       help="Output catalog.py file path (default: data/catalog.py)")
    parser.add_argument("--no-merge", action="store_true",
                       help="Don't merge with existing catalog (create new)")
    
    args = parser.parse_args()
    
    if not os.path.exists(args.quarry_dir):
        print(f"❌ Error: Directory not found: {args.quarry_dir}")
        sys.exit(1)
    
    merge_quarry_data_into_catalog(args.quarry_dir, args.output, merge_existing=not args.no_merge)

