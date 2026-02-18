# Wiki Loves Earth - Data Collection Guide

This guide explains how to fetch fresh data from Quarry (https://quarry.wmcloud.org/) for the Wiki Loves Earth campaign.

## Overview

Wiki Loves Earth runs annually from **May 1 to May 31**. We need to fetch data from Quarry that includes:
- Statistics by country and year (all years 2013-2025)
- Upload counts, uploader counts, images used, and new uploaders
- Individual uploader data by country and year
- Category information to identify all Earth campaigns

**Required Data Fields:**
- Year (2013-2025)
- Countries (number of participating countries)
- Uploads (total image uploads)
- Images Used (images used in wikis, with percentage)
- Uploaders (total number of unique uploaders)
- Uploaders Registered After Competition Start (count and percentage)
- Country-wise breakdown (all above metrics per country)
- User data (individual uploader statistics per country)

## Step-by-Step Process

### Step 1: Discover Categories (Optional)

First, run the category discovery query to see all available Wiki Loves Earth categories:

1. Open https://quarry.wmcloud.org/
2. Login with your Wikimedia account
3. Select database: `commonswiki_p`
4. Click "New Query"
5. Copy the contents of `earth_category_discovery.sql`
6. Paste into the query editor
7. Click "Run" (takes ~30 seconds)
8. Export results as JSON (save as `earth_categories.json`)

This will show you all category names like:
- `Images_from_Wiki_Loves_Earth_2025`
- `Images_from_Wiki_Loves_Earth_2024_in_India`
- `Images_from_Wiki_Loves_Earth_2013_in_Ukraine`
- etc.

**Note:** This step is optional but recommended to verify category patterns before running main queries.

### Step 2: Get Country Statistics (All Years)

Run the main country statistics query to get data for all years (2013-2025) with country breakdown:

1. Open https://quarry.wmcloud.org/
2. Login with your Wikimedia account
3. Select database: `commonswiki_p`
4. Click "New Query"
5. Copy the contents of `earth_all_years_countries.sql` (or `earth_complete_with_countries.sql`)
6. Paste into the query editor
7. Click "Run" (this may take 10-30 minutes)
8. Wait for query completion
9. Once complete, click "Download" button
10. Select "JSON" format
11. Save as: `earth_all_years_countries.json`
12. Place the file in: `quarry_data/` directory

**Expected Output:**
- Multiple rows per year (one per country)
- Columns: year, country, uploads, uploaders, images_used, new_uploaders
- Example: For 2013, you'll see data for Ukraine (or Global if no country-specific category)

**Alternative: Get Single Year**

If you want data for just one year:

1. Use the query from `earth_2013_countries.sql` (or any year-specific file)
2. Or generate one: `python backend/queries/generate_earth_queries.py countries --year 2025 --output earth_2025_countries.sql`
3. Run in Quarry and save as `earth_2025_countries.json`

### Step 3: Get Uploader Data (All Years & Countries)

Get individual uploader statistics for all years and countries in one comprehensive query:

1. Open https://quarry.wmcloud.org/
2. Login with your Wikimedia account
3. Select database: `commonswiki_p`
4. Click "New Query"
5. Copy the contents of `earth_uploaders_comprehensive.sql`
6. Paste into the query editor
7. Click "Run" (this may take 15-30 minutes)
8. Wait for query completion
9. Once complete, click "Download" button
10. Select "JSON" format
11. Save as: `earth_all_uploaders.json`
12. Place the file in: `quarry_data/uploaders/` directory

**Expected Output:**
- One row per uploader per country per year
- Columns: year, country, username, images, images_used, user_registration, is_new_uploader
- This will be a large file with thousands of rows

**Alternative: Get Uploaders for Specific Year/Country**

If you need uploader data for a specific year/country:

1. Generate query: `python backend/queries/generate_earth_queries.py uploaders --year 2025 --country "Ukraine" --output earth_2025_ukraine_uploaders.sql`
2. Run in Quarry
3. Save as: `earth_2025_Ukraine_users.json`
4. Place in: `quarry_data/uploaders/`

**Alternative: Get single year**

If you want data for just one year:

```bash
python backend/queries/generate_earth_queries.py countries --year 2025 --output earth_2025_countries.sql
```

Then run the generated SQL in Quarry.

### Step 4: Process the Data

After downloading the JSON files from Quarry, process them:

#### Process Country Statistics

```bash
# Process the main country statistics file
python backend/scripts/process_earth_quarry_data.py quarry_data/earth_all_years_countries.json --output quarry_data/earth_countries_processed.json
```

This will:
- Convert Quarry format (meta/rows/headers) to array of objects
- Group data by year
- Aggregate country statistics
- Calculate totals (uploads, uploaders, images_used, new_uploaders)
- Assign country ranks
- Create country_stats arrays sorted by uploads

#### Process Uploader Data

```bash
# Process the comprehensive uploader file
python backend/scripts/process_all_uploaders.py quarry_data/uploaders/earth_all_uploaders.json earth
```

This will:
- Parse uploader data by year and country
- Create individual files: `earth_{year}_{country}_users.json`
- Store in `quarry_data/uploaders/` directory
- Format data for API consumption

**Expected output files:**
```
quarry_data/
├── earth_all_years_countries.json (raw from Quarry)
├── earth_countries_processed.json (processed country stats)
└── uploaders/
    ├── earth_all_uploaders.json (raw from Quarry)
    ├── earth_2013_Ukraine_users.json (processed)
    ├── earth_2014_Germany_users.json (processed)
    └── ... (one file per year/country combination)
```

### Step 5: Integrate with Catalog

After processing, integrate the data into the catalog system:

```bash
# This will update catalog.py with the new Earth data
python backend/scripts/merge_earth_data.py
```

Or manually integrate using:

```bash
# Add country data to catalog
python backend/scripts/add_country_data_from_quarry.py
```

### Step 6: Generate Individual Year Queries (Optional - for verification)

For specific years, you can generate queries:

```bash
# Generate summary query for 2025
python backend/queries/generate_earth_queries.py summary --year 2025 --output earth_2025_summary.sql

# Generate uploader statistics for a specific year/country
python backend/queries/generate_earth_queries.py uploaders --year 2025 --country "India" --output earth_2025_india_uploaders.sql

# Generate detailed file list for a specific category
python backend/queries/generate_earth_queries.py files --year 2025 --category "Images_from_Wiki_Loves_Earth_2025" --output earth_2025_files.sql
```

## Query Types Available

The `generate_earth_queries.py` script supports these query types:

1. **discover** - Find all Wiki Loves Earth categories
2. **summary** - Get overall statistics for a year (requires `--year`)
3. **countries** - Get statistics by country (optional `--year` for single year, or all years)
4. **uploaders** - Get uploader-level statistics (requires `--year`, optional `--country` or `--category`)
5. **files** - Get detailed file information (requires `--year` and `--category`)

## Data Structure

The processed data follows this structure:

```json
{
  "campaign": "earth",
  "campaign_name": "Wiki Loves Earth",
  "years": [
    {
      "year": 2025,
      "uploads": 77831,
      "uploaders": 5282,
      "images_used": 77831,
      "new_uploaders": 4048,
      "countries": 45,
      "country_stats": [
        {
          "name": "Germany",
          "uploads": 13564,
          "uploaders": 356,
          "images_used": 13564,
          "new_uploaders": 200,
          "rank": 1
        },
        ...
      ]
    }
  ]
}
```

## Category Patterns

Wiki Loves Earth categories typically follow these patterns:
- `Images_from_Wiki_Loves_Earth_YYYY` - Global/main category
- `Images_from_Wiki_Loves_Earth_YYYY_in_CountryName` - Country-specific
- `Wiki_Loves_Earth_YYYY` - Alternative pattern
- `Wiki_Loves_Earth_YYYY_in_CountryName` - Alternative country pattern

## Important Notes

1. **Date Range**: Wiki Loves Earth runs May 1-31 each year. Queries use this date range for "new uploader" calculations:
   - Competition start: `YYYY0501000000` (May 1, 00:00:00)
   - Competition end: `YYYY0531235959` (May 31, 23:59:59)
   - New uploaders are those registered during this period

2. **Execution Time**: 
   - Category discovery: ~30 seconds
   - Single year country stats: ~1-2 minutes
   - All years country stats: ~10-30 minutes
   - Comprehensive uploader query: ~15-30 minutes

3. **Database**: Always use `commonswiki_p` (Commons database)

4. **Export Format**: Export as JSON from Quarry for easiest processing. CSV also works but requires minor adjustments.

5. **Category Patterns**: 
   - `Images_from_Wiki_Loves_Earth_YYYY` - Global/main category
   - `Images_from_Wiki_Loves_Earth_YYYY_in_CountryName` - Country-specific
   - `Wiki_Loves_Earth_YYYY` - Alternative pattern
   - `Wiki_Loves_Earth_YYYY_in_CountryName` - Alternative country pattern

6. **Image Usage Detection**: 
   - Uses `imagelinks` table to check if images are used in wikis
   - Join condition: `imagelinks.il_to = page.page_id` where page is the image file

7. **File Organization**:
   - Place raw Quarry exports in `quarry_data/`
   - Processed country stats can go in `quarry_data/`
   - Uploader files go in `quarry_data/uploaders/`

## Data Validation

After processing, validate the data:

1. **Check Totals**: Verify year totals match expected values from https://wikiloves.toolforge.org/earth/2013
   - Example: 2013 should show 9655 uploads, 346 uploaders (Ukraine)

2. **Verify Percentages**: 
   - images_used_pct = (images_used / uploads) * 100
   - new_uploaders_pct = (new_uploaders / uploaders) * 100

3. **Check Country Counts**: Verify number of countries per year matches expected values

4. **Validate Uploader Data**: Check that uploader files exist for major countries/years

## Troubleshooting

**Query Timeout**: If queries timeout:
- Try running during off-peak hours (nighttime in US/Europe)
- Split into year-specific queries
- Contact Quarry administrators if persistent issues

**Missing Data**: If some years/countries are missing:
- Check category names match expected patterns
- Verify year extraction logic (last 4 digits of category name)
- Check country name extraction (part after `_in_`)

**Incorrect Totals**: If totals don't match:
- Verify date ranges are correct (May 1-31)
- Check imagelinks join condition
- Verify actor/user join path (actor_image → actor → user)

## Next Steps

After processing the data:

1. Review the processed JSON to ensure data looks correct
2. Validate against known values from wikiloves.toolforge.org
3. Integrate with the catalog system using integration scripts
4. Test API endpoints return correct data
5. Verify frontend displays the new data correctly

For more details on the catalog system integration, see:
- `backend/services/catalog.py` - Business logic
- `backend/data/catalog.py` - Data structure
- `backend/scripts/process_earth_quarry_data.py` - Processing scripts




