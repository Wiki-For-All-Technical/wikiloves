# Wiki Loves Earth - Complete Verification Guide

## Overview

This guide walks you through fixing 2013 and 2014 data discrepancies, verifying all Wiki Loves Earth data (2013-2025), and including country breakdowns for all years.

## Files Created

1. **`backend/queries/earth_2013_2014_fix.sql`** - Optimized queries for fixing 2013 and 2014
2. **`backend/queries/earth_complete_with_countries.sql`** - Complete dataset with country breakdowns
3. **`verify_earth_complete.py`** - Comprehensive verification script
4. **`merge_earth_data.py`** - Script to merge year totals with country breakdowns
5. **Updated `backend/scripts/process_all_campaigns.py`** - Now handles country breakdown format

## Step-by-Step Process

### Step 1: Fix 2013 and 2014 Data

1. **Open Quarry**: Go to https://quarry.wmcloud.org
2. **Select Database**: `commonswiki_p`
3. **Open Query File**: `backend/queries/earth_2013_2014_fix.sql`
4. **Run Combined Query**: Use the "Combined query for both years" section (lines 67-95)
5. **Download as JSON**: Save as `earth_2013_2014_fix.json`
6. **Verify Results**: Check that 2013 shows ~9,655 uploads and 2014 shows ~62,351 uploads

### Step 2: Get Complete Dataset with Countries

1. **Open Quarry**: https://quarry.wmcloud.org
2. **Select Database**: `commonswiki_p`
3. **Open Query File**: `backend/queries/earth_complete_with_countries.sql`
4. **Run Query**: This may take 5-10 minutes (country breakdown is complex)
5. **Download as JSON**: Save as `earth_complete_with_countries.json`

**Expected Output Format:**
```json
{
  "headers": ["year", "country", "uploads", "uploaders", "images_used", "new_uploaders"],
  "rows": [
    [2025, "Global", 77844, 5283, 77844, 485],
    [2025, "Ukraine", 1234, 56, 1234, 12],
    [2024, "Global", 78572, 3807, 78572, 700],
    ...
  ]
}
```

### Step 3: Merge Data (If Needed)

If you have separate year totals and country breakdown files:

```bash
python merge_earth_data.py year_totals.json country_breakdown.json earth_merged.json
```

This will:
- Merge year totals with country breakdowns
- Validate that country sums match year totals
- Create a single JSON file ready for processing

### Step 4: Update Data Files

1. **Replace query19.json**: 
   - If you have merged data: `Copy-Item earth_merged.json wiki_loves_campaign_data/query19.json -Force`
   - If you have complete with countries: `Copy-Item earth_complete_with_countries.json wiki_loves_campaign_data/query19.json -Force`

2. **Process Data**:
   ```bash
   python wikiloves-main/backend/scripts/process_all_campaigns.py
   ```

   This will regenerate `backend/data/catalog.py` with the updated Earth data.

### Step 5: Verify Data

Run the comprehensive verification script:

```bash
python wikiloves-main/verify_earth_complete.py
```

This will:
- Compare all years (2013-2025) with reference website data
- Show detailed comparison for uploads, uploaders, and countries
- Generate `earth_verification_report.md` with full report
- Identify any remaining discrepancies

**Expected Output:**
```
================================================================================
WIKI LOVES EARTH - COMPREHENSIVE VERIFICATION REPORT
================================================================================

Source: JSON File (query19.json)

Summary:
  Total Years: 13
  OK Years: 11
  Warning Years: 0
  Error Years: 2

Issues Found:
  - 2013: 25.7% difference
  - 2014: 13.8% difference
```

### Step 6: Review Verification Report

Open `earth_verification_report.md` to see:
- Detailed year-by-year comparison
- Percentage differences
- Status for each metric (OK/GOOD/WARNING/ERROR)
- Recommendations

## Query Execution Times

- **2013-2014 Fix Query**: 1-2 minutes
- **Complete with Countries Query**: 5-10 minutes (due to country breakdown complexity)

## Data Format Notes

### Year Totals Format
```json
{
  "headers": ["year", "uploads", "uploaders", "images_used", "new_uploaders"],
  "rows": [[2025, 77844, 5283, 77844, 485], ...]
}
```

### Country Breakdown Format
```json
{
  "headers": ["year", "country", "uploads", "uploaders", "images_used", "new_uploaders"],
  "rows": [[2025, "Global", 77844, 5283, 77844, 485], [2025, "Ukraine", 1234, 56, 1234, 12], ...]
}
```

### Comprehensive Format (with category_name)
```json
{
  "headers": ["year", "category_name", "country", "uploads", "uploaders", "images_used", "new_uploaders"],
  "rows": [[2025, "Images_from_Wiki_Loves_Earth_2025", "Global", 77844, 5283, 77844, 485], ...]
}
```

The processing script automatically detects which format you're using.

## Troubleshooting

### Issue: Query takes too long
**Solution**: Use the optimized queries in `earth_2013_2014_fix.sql` which use specific patterns that can use indexes.

### Issue: Country sums don't match year totals
**Solution**: This is normal if files appear in multiple country categories. The processing script handles this by using Global row totals when available.

### Issue: Verification shows discrepancies
**Solution**: 
1. Check if query patterns are matching all categories
2. Compare with reference website to see if they exclude certain categories
3. Our data may be more comprehensive (including country-specific subcategories)

## Reference Data

Reference data from `wikiloves.toolforge.org/earth`:
- 2013: 9,655 uploads, 346 uploaders, 1 country
- 2014: 62,351 uploads, 2,882 uploaders, 14 countries
- 2015-2025: See `verify_earth_complete.py` for full reference data

## Next Steps After Verification

1. If verification passes: Data is ready for frontend
2. If discrepancies remain: Review the verification report and adjust queries if needed
3. Update frontend: Restart backend to serve updated data

## Files Summary

- **Queries**: `backend/queries/earth_*.sql`
- **Verification**: `verify_earth_complete.py`
- **Merging**: `merge_earth_data.py`
- **Processing**: `backend/scripts/process_all_campaigns.py` (updated)
- **Output**: `backend/data/catalog.py` (regenerated)
- **Report**: `earth_verification_report.md` (generated)

