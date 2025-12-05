# Fix for "New Uploaders" Calculation

## Problem
The "Uploaders registered after competition start" metric was significantly lower than the reference website. For example:
- **2013**: Our data showed 98, but reference shows 275 (64% difference)
- **2014**: Our data showed 1,928, but reference shows 2,364 (18% difference)

## Root Cause
The SQL queries were using a date range of **May 1-31 only** (`0501000000` to `0531235959`) to count "new uploaders". However, the reference website counts users who registered **on or after May 1st** of the competition year (through the end of the year).

## Solution
Updated the date range from:
- **Old**: `user_registration >= year + '0501000000' AND user_registration <= year + '0531235959'` (May 1-31 only)
- **New**: `user_registration >= year + '0501000000' AND user_registration <= year + '1231235959'` (May 1 - Dec 31)

## Files Updated
1. `backend/queries/earth_complete_fixed_new_uploaders.sql` - Complete dataset with country breakdown
2. `backend/queries/earth_2013_2014_fix_new_uploaders.sql` - 2013 and 2014 fix queries

## Next Steps
1. **Run the fixed queries in Quarry:**
   - Run `earth_complete_fixed_new_uploaders.sql` to get all years with correct new_uploaders
   - Or run `earth_2013_2014_fix_new_uploaders.sql` for just 2013-2014

2. **Download results as JSON:**
   - Save complete query results as `earth_complete_with_countries.json`
   - Or save 2013-2014 results as `earth_2013_fix.json` and `earth_2014_fix.json`

3. **Update the data:**
   - If using complete query: Replace `wiki_loves_campaign_data/earth_complete_with_countries.json`
   - If using fix queries: Merge with existing data using `merge_earth_fix_data.py`

4. **Reprocess the catalog:**
   ```bash
   python wikiloves-main/backend/scripts/process_all_campaigns.py
   ```

5. **Verify the fix:**
   ```bash
   python wikiloves-main/check_new_uploaders.py
   ```

## Expected Results After Fix
- **2013**: 275 new uploaders (79% of 346 total)
- **2014**: 2,364 new uploaders (82% of 2,882 total)
- **2015**: 7,700 new uploaders (87% of 8,785 total)
- And so on for all years...

The percentages should now match the reference website much more closely.



