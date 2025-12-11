# Fixing Data Accuracy Issues

## Problem Identified

The comprehensive queries (`comprehensive_campaign_queries.sql`) use `GROUP BY year, category_name, country`, which returns **per-category data**. When processing, we pick the "main category" (largest), but this only gives that category's data, not the **total for the year**.

The reference website (`wikiloves.toolforge.org`) uses queries that `GROUP BY year` only, which gives accurate **year totals** across all categories.

## Current Status

✅ **Most years are accurate** (within 1-5% of reference)
❌ **Some years have significant discrepancies:**
- **Earth 2013**: 31 uploads (should be 9,655) - **99.7% difference**
- **Earth 2014**: 70,940 uploads (should be 62,351) - **13.8% difference**

## Solution

I've created **multiyear summary queries** that `GROUP BY year` only, matching the reference website approach.

### Files Created

1. **`backend/queries/multiyear_summary_queries.sql`**
   - Contains queries for all 77 campaigns
   - Uses `GROUP BY year` only for accurate totals
   - Matches reference website query pattern

2. **`backend/scripts/process_multiyear_summary.py`**
   - Processes multiyear summary JSON format
   - Handles year-only grouping

3. **`identify_wrong_data.py`**
   - Identifies campaigns with data discrepancies
   - Shows which years need re-querying

## How to Fix

### Step 1: Identify Issues
```bash
python wikiloves-main/identify_wrong_data.py
```

This will show which campaigns/years have wrong data.

### Step 2: Re-run Queries for Affected Campaigns

1. Open `wikiloves-main/backend/queries/multiyear_summary_queries.sql`
2. Find the query for the campaign (e.g., "Earth")
3. Copy the query
4. Go to https://quarry.wmcloud.org
5. Select database: `commonswiki_p`
6. Paste and run the query
7. Download as JSON
8. Replace the corresponding `queryN.json` file in `wiki_loves_campaign_data/`

**Example for Earth (query #19):**
- Find query #19 in `multiyear_summary_queries.sql`
- Run in Quarry
- Download as JSON
- Save as `wiki_loves_campaign_data/query19.json` (replace existing)

### Step 3: Re-process All Campaigns
```bash
python wikiloves-main/backend/scripts/process_all_campaigns.py
```

This will regenerate `backend/data/catalog.py` with corrected data.

### Step 4: Restart Backend
```bash
cd wikiloves-main\backend
python app.py
```

The frontend will automatically show the corrected data.

## Why This Happened

The comprehensive queries were designed to get **per-category breakdowns** (for country stats), but this approach:
- Returns multiple rows per year (one per category)
- When we pick the "main category", we only get that category's data
- The reference website sums ALL categories for the year using `GROUP BY year`

The multiyear summary queries fix this by grouping by year only, giving accurate totals.

## Priority

**High Priority** (fix these first):
- Earth 2013 (99.7% difference)
- Earth 2014 (13.8% difference)

**Low Priority** (within 1-5%, acceptable):
- All other years are within acceptable range

## Notes

- The processing script now handles **both formats**:
  - Comprehensive format (per-category)
  - Multiyear summary format (year-only)
- You can mix formats - some campaigns can use comprehensive, others use summary
- The script automatically detects which format each JSON file uses



