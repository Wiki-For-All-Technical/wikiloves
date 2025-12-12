"""
Process Quarry uploader data JSON files and store them for the API.

This script processes JSON files from Quarry queries that return uploader statistics
and stores them in a structured format for easy retrieval by the API.
"""

import json
import os
import sys
from typing import Dict, List, Optional
from pathlib import Path

# Add parent directories to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

# Directory to store processed uploader data
UPLOADER_DATA_DIR = os.path.join(os.path.dirname(__file__), '..', '..', 'quarry_data', 'uploaders')


def ensure_uploader_dir():
    """Ensure the uploader data directory exists."""
    os.makedirs(UPLOADER_DATA_DIR, exist_ok=True)


def convert_quarry_format(data: Dict) -> List[Dict]:
    """
    Convert Quarry export format to our expected format.
    
    Quarry format: {"meta": {...}, "headers": [...], "rows": [[...], [...]]}
    Our format: [{"username": ..., "images": ..., "images_used": ..., "registration": ...}, ...]
    """
    if isinstance(data, list):
        # Already in array format
        return data
    
    if 'rows' in data and 'headers' in data:
        headers = data['headers']
        rows = data['rows']
        
        converted = []
        for row in rows:
            obj = {}
            for i, header in enumerate(headers):
                if i < len(row):
                    # Normalize header names
                    header_lower = header.lower()
                    if 'username' in header_lower or 'user' in header_lower or 'actor_name' in header_lower:
                        obj['username'] = row[i]
                    elif 'images' in header_lower and 'used' not in header_lower:
                        obj['images'] = int(row[i]) if row[i] else 0
                    elif 'images_used' in header_lower or ('images' in header_lower and 'used' in header_lower):
                        obj['images_used'] = int(row[i]) if row[i] else 0
                    elif 'registration' in header_lower or 'reg' in header_lower:
                        obj['registration'] = row[i]
                    else:
                        obj[header] = row[i]
            converted.append(obj)
        return converted
    
    return []


def process_uploader_file(input_path: str, campaign_slug: str, year: int, country: str) -> bool:
    """
    Process a Quarry uploader JSON file and save it in structured format.
    
    Args:
        input_path: Path to Quarry JSON export file
        campaign_slug: Campaign slug (e.g., 'earth')
        year: Campaign year (e.g., 2024)
        country: Country name (e.g., 'Albania')
    
    Returns:
        True if successful, False otherwise
    """
    ensure_uploader_dir()
    
    if not os.path.exists(input_path):
        print(f"❌ Error: File not found: {input_path}")
        return False
    
    try:
        with open(input_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
    except Exception as e:
        print(f"❌ Error reading JSON file: {e}")
        return False
    
    # Convert Quarry format
    uploaders = convert_quarry_format(data)
    
    if not uploaders:
        print(f"⚠️  Warning: No uploader data found in {input_path}")
        return False
    
    # Normalize data structure
    normalized = []
    for uploader in uploaders:
        normalized_uploader = {
            'username': uploader.get('username') or uploader.get('user') or uploader.get('actor_name', ''),
            'images': int(uploader.get('images', 0) or 0),
            'images_used': int(uploader.get('images_used', 0) or 0),
            'registration': uploader.get('registration') or uploader.get('registration_date') or ''
        }
        if normalized_uploader['username']:
            normalized.append(normalized_uploader)
    
    # Sort by images count (descending)
    normalized.sort(key=lambda x: x['images'], reverse=True)
    
    # Create output filename
    safe_country = country.replace(' ', '_').replace('/', '_')
    output_filename = f"{campaign_slug}_{year}_{safe_country}_users.json"
    output_path = os.path.join(UPLOADER_DATA_DIR, output_filename)
    
    # Save processed data
    with open(output_path, 'w', encoding='utf-8') as f:
        json.dump(normalized, f, indent=2, ensure_ascii=False)
    
    print(f"✓ Processed {len(normalized)} uploaders → {output_path}")
    return True


def load_uploader_data(campaign_slug: str, year: int, country: str) -> Optional[List[Dict]]:
    """
    Load uploader data for a specific campaign, year, and country.
    
    Args:
        campaign_slug: Campaign slug (e.g., 'earth')
        year: Campaign year (e.g., 2024)
        country: Country name (e.g., 'Albania')
    
    Returns:
        List of uploader dictionaries or None if not found
    """
    safe_country = country.replace(' ', '_').replace('/', '_')
    filename = f"{campaign_slug}_{year}_{safe_country}_users.json"
    file_path = os.path.join(UPLOADER_DATA_DIR, filename)
    
    if not os.path.exists(file_path):
        return None
    
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            return json.load(f)
    except Exception as e:
        print(f"Error loading uploader data: {e}")
        return None


def list_available_uploader_data() -> Dict[str, List[str]]:
    """
    List all available uploader data files.
    
    Returns:
        Dictionary mapping campaign slugs to lists of available files
    """
    ensure_uploader_dir()
    
    available = {}
    
    if not os.path.exists(UPLOADER_DATA_DIR):
        return available
    
    for filename in os.listdir(UPLOADER_DATA_DIR):
        if filename.endswith('_users.json'):
            # Parse filename: campaign_slug_year_country_users.json
            parts = filename.replace('_users.json', '').split('_')
            if len(parts) >= 3:
                campaign_slug = parts[0]
                year = parts[1]
                country = '_'.join(parts[2:])
                
                if campaign_slug not in available:
                    available[campaign_slug] = []
                available[campaign_slug].append({
                    'year': int(year),
                    'country': country.replace('_', ' '),
                    'filename': filename
                })
    
    return available


if __name__ == "__main__":
    import argparse
    
    parser = argparse.ArgumentParser(
        description="Process Quarry uploader data JSON files"
    )
    parser.add_argument(
        "input_file",
        help="Path to Quarry JSON export file"
    )
    parser.add_argument(
        "campaign_slug",
        help="Campaign slug (e.g., 'earth')"
    )
    parser.add_argument(
        "year",
        type=int,
        help="Campaign year (e.g., 2024)"
    )
    parser.add_argument(
        "country",
        help="Country name (e.g., 'Albania')"
    )
    parser.add_argument(
        "--list",
        action="store_true",
        help="List all available uploader data files"
    )
    
    args = parser.parse_args()
    
    if args.list:
        available = list_available_uploader_data()
        print("\nAvailable uploader data files:")
        for campaign, files in available.items():
            print(f"\n  {campaign}:")
            for file_info in files:
                print(f"    - {file_info['year']} / {file_info['country']} ({file_info['filename']})")
    else:
        success = process_uploader_file(
            args.input_file,
            args.campaign_slug,
            args.year,
            args.country
        )
        sys.exit(0 if success else 1)





