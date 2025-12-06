# Batch Processing Guide for Quarry Data

This guide shows you how to download multiple Quarry JSON files and process them all at once.

## Quick Start

### Option 1: Multi-Year Queries (Recommended)
1. **Run multi-year query** in Quarry (gets all years in one query)
2. **Download as JSON** and save as `{prefix}_multiyear.json` (e.g., `monuments_multiyear.json`)
3. **Process**: `python backend/scripts/process_multiyear_quarry.py monuments_multiyear.json monuments`

### Option 2: Individual Year Files
1. **Create a folder** for your Quarry exports: `quarry_data/`
2. **Download JSON files** from Quarry with correct naming
3. **Run one command** to process everything: `python backend/queries/process_quarry_results.py quarry_data`

## Multi-Year Queries (Recommended)

Multi-year queries extract ALL years of data for a campaign in a single query, matching the format from https://wikiloves.toolforge.org/.

### Advantages
- **One query instead of 15+**: Get all years (2010-2025) in one execution
- **Faster**: Single download and processing step
- **Complete**: Automatically captures all available years
- **Consistent**: Same query pattern for all campaigns

### How to Use

1. **Open** `backend/queries/quarry_multiyear_all_campaigns.sql`
2. **Copy** the query for your campaign (e.g., Wiki Loves Monuments)
3. **Run in Quarry** (may take several minutes for large campaigns)
4. **Download as JSON** and save as `{prefix}_multiyear.json` (e.g., `monuments_multiyear.json`)
5. **Process**:
   ```bash
   python backend/scripts/process_multiyear_quarry.py monuments_multiyear.json monuments
   ```

### Example: Wiki Loves Monuments (2010-2025)

```bash
# 1. Run query from quarry_multiyear_all_campaigns.sql in Quarry
# 2. Download as monuments_multiyear.json
# 3. Process:
python backend/scripts/process_multiyear_quarry.py monuments_multiyear.json monuments
```

This will automatically add all 16 years (2010-2025) to your catalog!

## Step-by-Step Workflow (Individual Year Files)

### Step 1: Prepare Your Folder

Create a folder to store all your Quarry exports:

```bash
mkdir quarry_data
```

### Step 2: Run SQL Queries in Quarry

For each campaign/year you want to add:

1. Go to [Quarry](https://quarry.wmcloud.org)
2. Open `backend/queries/quarry_batch_queries.sql`
3. Copy the appropriate query (summary or country-level)
4. Replace the year and dates in the query
5. Run the query in Quarry
6. Click "Download data" → Choose **JSON** format
7. Save the file with the correct name (see naming convention below)

### Step 3: File Naming Convention

**CRITICAL**: Files must be named exactly: `{campaign_prefix}_{year}.json`

#### Examples:
- `monuments_2024.json` - Wiki Loves Monuments 2024
- `earth_2023.json` - Wiki Loves Earth 2023
- `africa_2024.json` - Wiki Loves Africa 2024
- `folklore_2022.json` - Wiki Loves Folklore 2022

#### Campaign Prefixes

The prefix must match the key in `backend/data/campaigns_metadata.py`:

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

See `QUARRY_QUICK_REFERENCE.md` for the complete list.

### Step 4: Organize Your Files

Place all JSON files in the `quarry_data/` folder:

```
quarry_data/
├── monuments_2024.json
├── earth_2024.json
├── africa_2024.json
├── folklore_2024.json
└── monuments_2023.json
```

### Step 5: Process All Files

Run the batch processor:

```bash
cd wikiloves-main
python backend/queries/process_quarry_results.py quarry_data --output backend/data/catalog.py
```

This will:
- Read all JSON/CSV files in the folder
- Parse each file based on its name
- Merge data into the catalog
- Update `backend/data/catalog.py`

### Step 6: Verify Results

The script will show:
- Which files were processed
- Any errors or warnings
- Summary of competitions and countries added

Example output:
```
✓ Processed monuments_2024.json
✓ Processed earth_2024.json
✓ Processed africa_2024.json

✅ Success! Updated backend/data/catalog.py
   - 15 competitions
   - 89 countries
```

## Data Types

### Summary Data Only

If you only have totals (no country breakdown):
- The script will still process the file
- Country stats will be empty
- You can add country data later by running the country query

### Country-Level Data

If your JSON has country breakdown:
- Must have columns: `country`, `uploads`, `uploaders`, `images_used`, `new_uploaders`
- Countries will be ranked automatically
- Full statistics will be available in the UI

## JSON Format Requirements

### For Summary Data

Your JSON should have one row with totals:
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

### For Country Data

Your JSON should have multiple rows, one per country:
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

## Common Issues

### "Unknown campaign prefix" Error

**Problem**: The file name doesn't match a known campaign prefix.

**Solution**: 
- Check the file name matches the prefix from `campaigns_metadata.py`
- Use underscores, not spaces (e.g., `public_art_2024.json`, not `public art 2024.json`)

### "Invalid format" Warning

**Problem**: File name doesn't follow `{prefix}_{year}.json` pattern.

**Solution**:
- Ensure file name has exactly one underscore before the year
- Year must be 4 digits
- Extension must be `.json` or `.csv`

### "Year already exists" Warning

**Problem**: The catalog already has data for this campaign/year.

**Solution**:
- The script will merge the data
- If you want to replace, delete the year from catalog.py first
- Or use the individual script: `add_quarry_summary.py` with replace option

### Missing Country Data

**Problem**: Processed file but no country stats shown.

**Solution**:
- Check if your JSON has a `country` column
- Run the country-level query from `quarry_batch_queries.sql`
- Process the new file (it will merge with existing data)

## Workflow Examples

### Example 1: Add Multiple Years for One Campaign

```bash
# Download files:
quarry_data/
├── monuments_2024.json
├── monuments_2023.json
└── monuments_2022.json

# Process all at once:
python backend/queries/process_quarry_results.py quarry_data
```

### Example 2: Add Multiple Campaigns for One Year

```bash
# Download files:
quarry_data/
├── monuments_2024.json
├── earth_2024.json
├── africa_2024.json
└── folklore_2024.json

# Process all at once:
python backend/queries/process_quarry_results.py quarry_data
```

### Example 3: Mixed Years and Campaigns

```bash
# Download files:
quarry_data/
├── monuments_2024.json
├── monuments_2023.json
├── earth_2024.json
└── africa_2023.json

# Process all at once:
python backend/queries/process_quarry_results.py quarry_data
```

## Tips

1. **Start with summary data**: Get totals first, then add country breakdowns later
2. **Use consistent naming**: Always use the same prefix format
3. **Keep backups**: The script modifies `catalog.py` - keep a backup
4. **Test with one file**: Try processing one file first to verify the format
5. **Check Quarry exports**: Make sure JSON format matches requirements

## Next Steps

After processing:
1. Restart your Flask server to see new data
2. Check the UI to verify statistics appear correctly
3. Add more data by repeating the process

## Related Files

- `backend/queries/quarry_batch_queries.sql` - All SQL queries
- `backend/queries/process_quarry_results.py` - Batch processor script
- `QUARRY_QUICK_REFERENCE.md` - Quick reference for prefixes and commands
- `backend/data/campaigns_metadata.py` - Campaign definitions

