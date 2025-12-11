"""
Convert Quarry JSON format (with meta/rows) to array format expected by processing scripts.
"""
import json
import sys
import os

def convert_quarry_json(input_path, output_path=None):
    """Convert Quarry JSON format to array format."""
    with open(input_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    # Check if it's already in array format
    if isinstance(data, list):
        print(f"✓ {input_path} is already in array format")
        return data
    
    # Convert from Quarry format (meta/rows) to array format
    if 'rows' in data and 'headers' in data:
        headers = data['headers']
        rows = data['rows']
        
        # Convert rows to objects
        result = []
        for row in rows:
            obj = {}
            for i, header in enumerate(headers):
                obj[header] = row[i] if i < len(row) else None
            result.append(obj)
        
        if output_path:
            with open(output_path, 'w', encoding='utf-8') as f:
                json.dump(result, f, indent=2, ensure_ascii=False)
            print(f"✓ Converted {input_path} -> {output_path}")
        
        return result
    else:
        raise ValueError(f"Unknown JSON format in {input_path}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python convert_quarry_json.py <input.json> [output.json]")
        sys.exit(1)
    
    input_path = sys.argv[1]
    output_path = sys.argv[2] if len(sys.argv) > 2 else None
    
    convert_quarry_json(input_path, output_path)

