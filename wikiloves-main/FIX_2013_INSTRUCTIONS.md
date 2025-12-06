# Fix 2013 New Uploaders Issue

## Current Status
- ✅ 2013 data is now being found (11,736 uploads, 392 uploaders)
- ❌ new_uploaders is still 100 (should be ~275)
- ❌ The date range fix may not have been applied correctly

## Solution

The issue is that your `query19.json` file was generated with an older version of the query. You need to:

### Option 1: Run the Updated Multi-Year Query (Recommended)

1. **Open the updated query file**: `backend/queries/earth_multiyear_summary_fixed.sql`
2. **Copy the entire SELECT statement** (lines 12-83)
3. **Run in Quarry** with database `commonswiki_p`
4. **Download as JSON**
5. **Save as**: `wiki_loves_campaign_data/query19.json` (replace existing)

### Option 2: Test 2013 Only First

To verify the fix works for 2013:

1. **Run the test query**: `backend/queries/earth_2013_test_date_range.sql`
   - This will show you both date ranges side-by-side
   - You should see:
     - May 1-31 only: ~100 new_uploaders
     - May 1 - Dec 31: ~275 new_uploaders

2. **If the test shows ~275**, then run the full multi-year query

### Option 3: Run 2013 Standalone Query

1. **Run**: `backend/queries/earth_2013_fixed_standalone.sql`
2. **Verify** it shows ~275 new_uploaders
3. **Then** run the full multi-year query

## What Changed

The fixed query uses:
- **Date range**: May 1 - Dec 31 (`20131231235959` instead of `20130531235959`)
- **Year extraction**: Correctly handles categories like `Images_from_Wiki_Loves_Earth_2013_in_Ukraine`

## Verification

After running the updated query, check:
- 2013 new_uploaders should be ~275 (not 100)
- All other years should remain similar or improve slightly

Then process the data:
```bash
python wikiloves-main/backend/scripts/process_all_campaigns.py
```

