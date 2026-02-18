# Wiki Loves Earth Data Collection - Implementation Summary

## Overview

This document summarizes the implementation of the Wiki Loves Earth data collection system from Quarry. All SQL queries have been verified and fixed, processing scripts updated, and integration scripts created.

## Completed Tasks

### 1. SQL Query Verification & Fixes ✅

**Fixed Issues:**
- Corrected actor/user join path in all Earth SQL queries
- Changed from `LEFT JOIN user u ON a.actor_user = u.user_id` (incorrect)
- To: `LEFT JOIN actor act ON a.actor_id = act.actor_id` then `LEFT JOIN user u ON act.actor_user = u.user_id` (correct)

**Files Updated:**
- `backend/queries/earth_all_years_countries.sql`
- `backend/queries/earth_complete_with_countries.sql`
- `backend/queries/earth_2013_countries.sql` through `earth_2025_countries.sql` (all year-specific files)
- `backend/queries/generate_earth_queries.py`
- `backend/queries/generate_earth_year_queries.py`

**Query Structure:**
All queries now correctly return:
- `year` (INT): Campaign year (2013-2025)
- `country` (STRING): Country name or 'Global'
- `uploads` (INT): Total image uploads
- `uploaders` (INT): Unique uploaders
- `images_used` (INT): Images used in wikis (via imagelinks table)
- `new_uploaders` (INT): Uploaders registered between May 1-31 of that year

### 2. Uploader Query Created ✅

**New File:**
- `backend/queries/earth_uploaders_comprehensive.sql`

**Purpose:**
Comprehensive query to get ALL uploader data for ALL years and ALL countries in one query.

**Output Columns:**
- `year`, `country`, `username`, `images`, `images_used`, `user_registration`, `is_new_uploader`

### 3. Documentation Updated ✅

**File:**
- `backend/queries/EARTH_DATA_COLLECTION.md`

**Added:**
- Complete step-by-step instructions for Quarry data collection
- Instructions for both country statistics and uploader data
- Processing instructions
- Integration steps
- Troubleshooting guide
- Validation procedures

### 4. Processing Script Updated ✅

**File:**
- `backend/scripts/process_earth_quarry_data.py`

**Improvements:**
- Added percentage calculations (images_used_pct, new_uploaders_pct)
- Improved country aggregation logic
- Better handling of multi-year data
- Enhanced error handling

### 5. Catalog Integration Script Created ✅

**New File:**
- `backend/scripts/merge_earth_data.py`

**Features:**
- Loads processed Earth JSON data
- Reads existing catalog.py
- Finds/creates Earth competition entry
- Replaces years array with new data
- Preserves metadata (links, hero_image, etc.)
- Creates backup option

**Usage:**
```bash
python backend/scripts/merge_earth_data.py quarry_data/earth_countries_processed.json --backup
```

### 6. Validation Script Created ✅

**New File:**
- `backend/scripts/validate_earth_data.py`

**Features:**
- Validates data structure
- Checks required fields
- Verifies percentages
- Compares with known values (optional)
- Validates year-by-year data
- Comprehensive error reporting

**Usage:**
```bash
# Validate processed JSON
python backend/scripts/validate_earth_data.py quarry_data/earth_countries_processed.json --compare-known

# Validate from catalog.py
python backend/scripts/validate_earth_data.py backend/data/catalog.py --catalog --compare-known
```

## Workflow Summary

### Step 1: Fetch Data from Quarry

1. **Category Discovery** (optional):
   - Run `earth_category_discovery.sql` in Quarry
   - Database: `commonswiki_p`
   - Export as JSON

2. **Country Statistics**:
   - Run `earth_all_years_countries.sql` in Quarry
   - Takes 10-30 minutes
   - Export as JSON: `earth_all_years_countries.json`
   - Place in `quarry_data/`

3. **Uploader Data** (optional):
   - Run `earth_uploaders_comprehensive.sql` in Quarry
   - Takes 15-30 minutes
   - Export as JSON: `earth_all_uploaders.json`
   - Place in `quarry_data/uploaders/`

### Step 2: Process Data

```bash
# Process country statistics
python backend/scripts/process_earth_quarry_data.py quarry_data/earth_all_years_countries.json --output quarry_data/earth_countries_processed.json

# Process uploader data (if fetched)
python backend/scripts/process_all_uploaders.py quarry_data/uploaders/earth_all_uploaders.json earth
```

### Step 3: Validate Data

```bash
python backend/scripts/validate_earth_data.py quarry_data/earth_countries_processed.json --compare-known
```

### Step 4: Integrate into Catalog

```bash
python backend/scripts/merge_earth_data.py quarry_data/earth_countries_processed.json --backup
```

### Step 5: Verify Integration

```bash
# Validate catalog
python backend/scripts/validate_earth_data.py backend/data/catalog.py --catalog --compare-known

# Test API (if backend running)
curl http://127.0.0.1:5000/api/competitions/wiki-loves-earth
```

## Key Files Reference

### SQL Queries
- `backend/queries/earth_all_years_countries.sql` - Main query for all years
- `backend/queries/earth_complete_with_countries.sql` - Alternative comprehensive query
- `backend/queries/earth_uploaders_comprehensive.sql` - Uploader data query
- `backend/queries/earth_category_discovery.sql` - Category discovery
- `backend/queries/earth_2013_countries.sql` - `earth_2025_countries.sql` - Year-specific queries

### Processing Scripts
- `backend/scripts/process_earth_quarry_data.py` - Process country statistics
- `backend/scripts/process_all_uploaders.py` - Process uploader data
- `backend/scripts/merge_earth_data.py` - Integrate into catalog
- `backend/scripts/validate_earth_data.py` - Validate data

### Documentation
- `backend/queries/EARTH_DATA_COLLECTION.md` - Complete collection guide
- `backend/queries/EARTH_IMPLEMENTATION_SUMMARY.md` - This file

## Data Structure

Processed data follows this structure:

```json
{
  "campaign": "earth",
  "campaign_name": "Wiki Loves Earth",
  "years": [
    {
      "year": 2013,
      "uploads": 9655,
      "uploaders": 346,
      "images_used": 9394,
      "new_uploaders": 275,
      "countries": 1,
      "images_used_pct": 97.31,
      "new_uploaders_pct": 79.48,
      "country_stats": [
        {
          "name": "Ukraine",
          "uploads": 9655,
          "uploaders": 346,
          "images_used": 9394,
          "new_uploaders": 275,
          "rank": 1,
          "images_used_pct": 97.31,
          "new_uploaders_pct": 79.48
        }
      ]
    }
  ]
}
```

## Important Notes

1. **Date Range**: Wiki Loves Earth runs May 1-31 each year
   - Competition period: `YYYY0501000000` to `YYYY0531235959`
   - New uploaders: registered during this period

2. **Image Usage**: Uses `imagelinks` table where `il_to = page.page_id`

3. **Country Aggregation**: When calculating totals from country stats, uploaders may be double-counted if a user uploads in multiple countries. This is a known limitation.

4. **Execution Time**: Queries may take 10-30 minutes. Run during off-peak hours if possible.

5. **Validation**: Always validate data before integrating into catalog.

## Next Steps

1. User should fetch data from Quarry using the SQL queries
2. Process the data using the processing scripts
3. Validate the data
4. Integrate into catalog
5. Verify API and frontend display correctly

## Support

For issues or questions:
- Check `EARTH_DATA_COLLECTION.md` for detailed instructions
- Review query files for SQL structure
- Check validation output for data issues
- Compare with known values from wikiloves.toolforge.org
