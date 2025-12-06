# Quarry Data Processing - Quick Reference

Quick reference for batch processing Quarry data.

## File Naming Convention

**Format**: `{campaign_prefix}_{year}.json`

### Examples
```
monuments_2024.json
earth_2023.json
africa_2024.json
folklore_2022.json
public_art_2024.json
```

## Campaign Prefixes

| Campaign Name | Prefix | Example File |
|--------------|--------|--------------|
| Wiki Loves Monuments | `monuments` | `monuments_2024.json` |
| Wiki Loves Earth | `earth` | `earth_2024.json` |
| Wiki Loves Africa | `africa` | `africa_2024.json` |
| Wiki Loves Folklore | `folklore` | `folklore_2024.json` |
| Wiki Science Competition | `science` | `science_2024.json` |
| Wiki Loves Public Art | `public_art` | `public_art_2024.json` |
| Wiki Loves Food | `food` | `food_2024.json` |
| Wiki Loves Women | `women` | `women_2024.json` |
| Wiki Loves Birds | `birds` | `birds_2024.json` |
| Wiki Loves Fashion | `fashion` | `fashion_2024.json` |
| Wiki Loves Film | `film` | `film_2024.json` |
| Wiki Loves Pride | `pride` | `pride_2024.json` |
| Wiki Loves Sport | `sport` | `sport_2024.json` |
| Wiki Loves Onam | `onam` | `onam_2024.json` |
| Wiki Loves Heritage Belgium | `heritage_belgium` | `heritage_belgium_2024.json` |

**Note**: Use underscores, not spaces or hyphens in the prefix.

## Quick Commands

### Multi-Year Query (Recommended)
```bash
# Process multi-year data (all years in one file)
python backend/scripts/process_multiyear_quarry.py monuments_multiyear.json monuments
```

### Process All Files in Folder
```bash
python backend/queries/process_quarry_results.py quarry_data
```

### Process with Custom Output
```bash
python backend/queries/process_quarry_results.py quarry_data --output backend/data/catalog.py
```

### Create New Catalog (Don't Merge)
```bash
python backend/queries/process_quarry_results.py quarry_data --no-merge
```

### Add Single Summary Entry
```bash
python backend/scripts/add_quarry_summary.py monuments 2024 239104 4358 239104 0
```

## SQL Query Locations

- **Multi-year queries (recommended)**: `backend/queries/quarry_multiyear_all_campaigns.sql`
- **Multi-year templates**: 
  - `backend/queries/quarry_multiyear_summary.sql` (summary only)
  - `backend/queries/quarry_multiyear_countries.sql` (with country breakdown)
- **Single-year queries**: `backend/queries/quarry_batch_queries.sql`
- **Country queries**: `backend/queries/country_stats_query.sql`
- **Working patterns**: `backend/queries/quarry_actual_categories.sql`

## JSON Format Requirements

### Summary Data (Totals Only)
```json
[
  {
    "uploads": 239104,
    "uploaders": 4358,
    "images_used": 239104,
    "new_uploaders": 0
  }
]
```

### Country Data (With Breakdown)
```json
[
  {
    "country": "Italy",
    "uploads": 45000,
    "uploaders": 500,
    "images_used": 45000,
    "new_uploaders": 50
  },
  {
    "country": "Germany",
    "uploads": 38000,
    "uploaders": 420,
    "images_used": 38000,
    "new_uploaders": 40
  }
]
```

## Common Category Names (2024)

| Campaign | Category Name |
|----------|---------------|
| Monuments | `Images_from_Wiki_Loves_Monuments_2024` |
| Earth | `Images_from_Wiki_Loves_Earth_2024` |
| Africa | `Images_from_Wiki_Loves_Africa_2024` |
| Folklore | `Images_from_Wiki_Loves_Folklore_2024` |
| Birds | `Images_from_Wiki_Loves_Birds_2024` |
| Fashion | `Wiki_Loves_Fashion_2024` |
| Film | `Wiki_Loves_Film_2024` |
| Pride | `Wiki_Loves_Pride_2024` |
| Onam | `Images_from_Wiki_Loves_Onam_2024` |
| Heritage Belgium | `Images_from_Wiki_Loves_Heritage_Belgium_in_2024` |

**Note**: Replace `2024` with your actual year in queries.

## Typical Campaign Dates

| Campaign | Typical Month |
|----------|---------------|
| Wiki Loves Monuments | September |
| Wiki Loves Earth | May |
| Wiki Loves Africa | March |
| Wiki Loves Folklore | February |
| Wiki Science Competition | November |

## Workflow

### Multi-Year (Recommended)
1. **Run multi-year query** → Copy from `quarry_multiyear_all_campaigns.sql`
2. **Download as JSON** → Save as `{prefix}_multiyear.json` (e.g., `monuments_multiyear.json`)
3. **Process** → `python backend/scripts/process_multiyear_quarry.py monuments_multiyear.json monuments`
4. **Done!** → All years added automatically

### Single-Year (Alternative)
1. **Run query in Quarry** → Copy from `quarry_batch_queries.sql`
2. **Download as JSON** → Save with correct name: `{prefix}_{year}.json`
3. **Place in folder** → Put all files in `quarry_data/`
4. **Process batch** → `python backend/queries/process_quarry_results.py quarry_data`
5. **Done!** → Restart Flask server to see data

## Troubleshooting

| Error | Solution |
|-------|----------|
| "Unknown campaign prefix" | Check prefix matches table above (use underscores) |
| "Invalid format" | File must be `{prefix}_{year}.json` (one underscore) |
| "Invalid year" | Year must be 4 digits (e.g., 2024) |
| "No files found" | Check folder path and file extensions (.json or .csv) |

## Related Files

- `BATCH_PROCESSING_GUIDE.md` - Detailed step-by-step guide
- `HOW_TO_ADD_QUARRY_DATA.md` - Individual file processing
- `backend/queries/quarry_batch_queries.sql` - All SQL queries
- `backend/data/campaigns_metadata.py` - Campaign definitions

