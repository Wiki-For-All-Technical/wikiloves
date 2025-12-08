"""
Fetch CRT (Campaign Registration Tool) data for Wiki Loves Africa.

This script fetches campaign statistics from crt.toolforge.org for comparison
with the live website data.

Usage:
    python backend/scripts/fetch_crt_africa.py
"""

import json
import os
import urllib.request
import urllib.parse
from datetime import datetime
from typing import Dict, List, Any, Optional


# CRT API base URL
CRT_BASE_URL = "https://crt.toolforge.org"

# Wiki Loves Africa campaign codes/IDs on CRT
# These are the campaign slugs used on CRT for each year
AFRICA_CAMPAIGN_CODES = {
    2025: "wla2025",
    2024: "wla2024",
    2023: "wla2023",
    2022: "wla2022",
    2021: "wla2021",
    2020: "wla2020",
    2019: "wla2019",
    2018: "wla2018",
    2017: "wla2017",
    2016: "wla2016",
    2015: "wla2015",
    2014: "wla2014",
}


def fetch_crt_campaign_data(campaign_code: str) -> Optional[Dict]:
    """
    Fetch campaign data from CRT API.
    
    Args:
        campaign_code: The CRT campaign code (e.g., 'wla2024')
    
    Returns:
        Campaign data dictionary or None if failed
    """
    # Try different API endpoints
    endpoints = [
        f"/api/campaign/{campaign_code}",
        f"/api/stats/{campaign_code}",
        f"/campaigns/{campaign_code}/stats.json",
        f"/data/{campaign_code}.json",
    ]
    
    for endpoint in endpoints:
        try:
            url = f"{CRT_BASE_URL}{endpoint}"
            print(f"  Trying: {url}")
            
            req = urllib.request.Request(
                url,
                headers={
                    'User-Agent': 'WikiLovesDataFetcher/1.0 (https://meta.wikimedia.org/wiki/User:DataBot)',
                    'Accept': 'application/json'
                }
            )
            
            with urllib.request.urlopen(req, timeout=30) as response:
                data = json.loads(response.read().decode())
                return data
                
        except urllib.error.HTTPError as e:
            if e.code != 404:
                print(f"    HTTP Error {e.code}: {e.reason}")
        except Exception as e:
            print(f"    Error: {e}")
    
    return None


def fetch_crt_campaign_list() -> List[Dict]:
    """
    Fetch list of all campaigns from CRT.
    """
    endpoints = [
        "/api/campaigns",
        "/campaigns.json",
        "/api/campaign/list",
    ]
    
    for endpoint in endpoints:
        try:
            url = f"{CRT_BASE_URL}{endpoint}"
            print(f"Fetching campaign list from: {url}")
            
            req = urllib.request.Request(
                url,
                headers={
                    'User-Agent': 'WikiLovesDataFetcher/1.0',
                    'Accept': 'application/json'
                }
            )
            
            with urllib.request.urlopen(req, timeout=30) as response:
                data = json.loads(response.read().decode())
                return data if isinstance(data, list) else data.get('campaigns', [])
                
        except Exception as e:
            print(f"  Error: {e}")
    
    return []


def fetch_crt_statistics_page(campaign_code: str) -> Optional[str]:
    """
    Fetch the HTML statistics page from CRT for parsing.
    """
    try:
        url = f"{CRT_BASE_URL}/campaign/{campaign_code}"
        print(f"  Fetching page: {url}")
        
        req = urllib.request.Request(
            url,
            headers={
                'User-Agent': 'WikiLovesDataFetcher/1.0',
                'Accept': 'text/html'
            }
        )
        
        with urllib.request.urlopen(req, timeout=30) as response:
            return response.read().decode()
            
    except Exception as e:
        print(f"    Error fetching page: {e}")
    
    return None


def fetch_wikiloves_africa_crt_data() -> Dict[int, Dict]:
    """
    Fetch all Wiki Loves Africa campaign data from CRT.
    
    Returns:
        Dictionary mapping year to campaign statistics
    """
    print("\n" + "=" * 60)
    print("Fetching Wiki Loves Africa CRT Data")
    print("=" * 60)
    
    all_data = {}
    
    # First try to get the campaign list
    print("\nStep 1: Fetching campaign list...")
    campaigns = fetch_crt_campaign_list()
    
    if campaigns:
        print(f"  Found {len(campaigns)} campaigns")
        
        # Filter for Africa campaigns
        africa_campaigns = [
            c for c in campaigns 
            if 'africa' in str(c).lower() or 'wla' in str(c).lower()
        ]
        print(f"  Found {len(africa_campaigns)} Africa campaigns")
        
        for campaign in africa_campaigns:
            print(f"    - {campaign}")
    
    # Now fetch individual campaign data
    print("\nStep 2: Fetching individual campaign data...")
    
    for year, code in sorted(AFRICA_CAMPAIGN_CODES.items(), reverse=True):
        print(f"\nYear {year} ({code}):")
        
        data = fetch_crt_campaign_data(code)
        
        if data:
            all_data[year] = {
                'source': 'crt_api',
                'campaign_code': code,
                'raw_data': data,
                'uploads': data.get('uploads', data.get('total_images', 0)),
                'uploaders': data.get('uploaders', data.get('participants', 0)),
                'countries': data.get('countries', data.get('country_count', 0)),
                'images_used': data.get('images_used', 0),
                'new_uploaders': data.get('new_uploaders', 0),
            }
            print(f"  ✓ Got data: {all_data[year]['uploads']} uploads, {all_data[year]['uploaders']} uploaders")
        else:
            print(f"  ✗ No API data available")
    
    return all_data


def save_crt_data(data: Dict[int, Dict], output_path: str):
    """Save the CRT data to a JSON file."""
    # Prepare data for JSON serialization
    serializable_data = []
    
    for year in sorted(data.keys(), reverse=True):
        year_data = data[year]
        serializable_data.append({
            'year': year,
            'campaign_code': year_data.get('campaign_code', ''),
            'source': year_data.get('source', 'crt'),
            'uploads': year_data.get('uploads', 0),
            'uploaders': year_data.get('uploaders', 0),
            'countries': year_data.get('countries', 0),
            'images_used': year_data.get('images_used', 0),
            'new_uploaders': year_data.get('new_uploaders', 0),
            'raw_data': year_data.get('raw_data', {})
        })
    
    with open(output_path, 'w', encoding='utf-8') as f:
        json.dump(serializable_data, f, indent=2, ensure_ascii=False)
    
    print(f"\n✓ Saved to: {output_path}")


def compare_with_local_data(crt_data: Dict[int, Dict]):
    """Compare CRT data with local data."""
    local_file = os.path.join(
        os.path.dirname(__file__), '..', '..', 
        'quarry_data', 'africa_multiyear_converted.json'
    )
    
    if not os.path.exists(local_file):
        print("\n⚠ Local data file not found for comparison")
        return
    
    with open(local_file, 'r', encoding='utf-8') as f:
        local_data = json.load(f)
    
    # Convert to dict by year
    local_by_year = {item['year']: item for item in local_data}
    
    print("\n" + "=" * 80)
    print("COMPARISON: CRT Data vs Local Data")
    print("=" * 80)
    print(f"\n{'Year':<6} {'Source':<10} {'Uploads':<12} {'Uploaders':<12} {'Countries':<12} {'Images Used':<12}")
    print("-" * 80)
    
    all_years = sorted(set(crt_data.keys()) | set(local_by_year.keys()), reverse=True)
    
    for year in all_years:
        # CRT data
        if year in crt_data:
            crt = crt_data[year]
            print(f"{year:<6} {'CRT':<10} {crt.get('uploads', 0):<12,} {crt.get('uploaders', 0):<12,} {crt.get('countries', 0):<12} {crt.get('images_used', 0):<12,}")
        else:
            print(f"{year:<6} {'CRT':<10} {'N/A':<12} {'N/A':<12} {'N/A':<12} {'N/A':<12}")
        
        # Local data
        if year in local_by_year:
            local = local_by_year[year]
            print(f"{'':<6} {'Local':<10} {local.get('uploads', 0):<12,} {local.get('uploaders', 0):<12,} {local.get('countries', 0):<12} {local.get('images_used', 0):<12,}")
        else:
            print(f"{'':<6} {'Local':<10} {'N/A':<12} {'N/A':<12} {'N/A':<12} {'N/A':<12}")
        
        # Show difference
        if year in crt_data and year in local_by_year:
            crt = crt_data[year]
            local = local_by_year[year]
            diff_uploads = crt.get('uploads', 0) - local.get('uploads', 0)
            diff_uploaders = crt.get('uploaders', 0) - local.get('uploaders', 0)
            if diff_uploads != 0 or diff_uploaders != 0:
                print(f"{'':<6} {'DIFF':<10} {diff_uploads:+<12,} {diff_uploaders:+<12,}")
        
        print()


def main():
    """Main function to fetch and compare CRT data for Africa."""
    print("=" * 60)
    print("Wiki Loves Africa - CRT Data Fetcher")
    print("=" * 60)
    print(f"Timestamp: {datetime.now().isoformat()}")
    print(f"CRT Base URL: {CRT_BASE_URL}")
    
    # Fetch CRT data
    crt_data = fetch_wikiloves_africa_crt_data()
    
    # Save the data
    output_dir = os.path.join(os.path.dirname(__file__), '..', '..', 'quarry_data')
    os.makedirs(output_dir, exist_ok=True)
    
    output_file = os.path.join(output_dir, 'africa_crt_data.json')
    save_crt_data(crt_data, output_file)
    
    # Compare with local data
    compare_with_local_data(crt_data)
    
    print("\n" + "=" * 60)
    print("Done!")
    print("=" * 60)


if __name__ == '__main__':
    main()


