"""
Convert Quarry export format to our expected JSON format.
Quarry exports have: {"meta": {...}, "headers": [...], "rows": [[...], [...]]}
We need: [{"year": ..., "uploads": ...}, ...]
"""

import json
import sys
import os
import glob


def convert_quarry_export(input_path: str, output_path: str = None):
    """
    Convert Quarry export format to our expected format.
    
    Args:
        input_path: Path to Quarry export JSON file
        output_path: Optional output path (default: same as input with _converted.json)
    """
    with open(input_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    if 'rows' not in data or 'headers' not in data:
        print(f"⚠️  Warning: {input_path} doesn't appear to be Quarry export format")
        return False
    
    headers = data['headers']
    rows = data['rows']
    
    # Convert rows to objects
    converted = []
    for row in rows:
        obj = {}
        for i, header in enumerate(headers):
            if i < len(row):
                obj[header] = row[i]
        converted.append(obj)
    
    # Determine output path
    if output_path is None:
        # Remove double .json.json if present, add _converted.json
        base = input_path.replace('.json.json', '').replace('.json', '')
        output_path = f"{base}_converted.json"
    
    # Write converted file
    with open(output_path, 'w', encoding='utf-8') as f:
        json.dump(converted, f, indent=2, ensure_ascii=False)
    
    print(f"✓ Converted {input_path} → {output_path} ({len(converted)} rows)")
    return True


def convert_all_in_folder(folder_path: str):
    """Convert all Quarry export files in a folder."""
    json_files = glob.glob(os.path.join(folder_path, '*.json.json')) + \
                 glob.glob(os.path.join(folder_path, '*.json'))
    
    converted_count = 0
    for json_file in json_files:
        # Skip already converted files
        if '_converted.json' in json_file:
            continue
        
        try:
            if convert_quarry_export(json_file):
                converted_count += 1
        except Exception as e:
            print(f"❌ Error converting {json_file}: {e}")
    
    print(f"\n✅ Converted {converted_count} file(s)")
    return converted_count


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage:")
        print("  python convert_quarry_export.py <file.json> [output.json]")
        print("  python convert_quarry_export.py <folder>")
        print("\nExamples:")
        print("  python convert_quarry_export.py quarry_data/")
        print("  python convert_quarry_export.py monuments_multiyear.json.json")
        sys.exit(1)
    
    path = sys.argv[1]
    
    if os.path.isdir(path):
        convert_all_in_folder(path)
    else:
        output = sys.argv[2] if len(sys.argv) > 2 else None
        convert_quarry_export(path, output)







