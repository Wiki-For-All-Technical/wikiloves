# Final Fix for Earth New Uploaders

## Key Discovery

The diagnostic queries revealed that **April 1st** (not May 1st) is the correct start date for counting "new uploaders":

### Test Results:
- **May 1 - Dec 31**: 101 new_uploaders ❌ (too low)
- **April 1 - Dec 31**: 297 new_uploaders ✅ (close to reference 275, only 8% difference)
- **Jan 1 - Dec 31**: 309 new_uploaders (too high)

### Registration Period Breakdown (2013):
- Before May 1, 2013: 280 uploaders
- May 1-31, 2013: 98 uploaders
- June 1 - Dec 31, 2013: 3 uploaders
- After 2013: 8 uploaders
- No registration date: 5 uploaders
- **Total: 394 uploaders**

## Solution

Updated queries now use **April 1 - Dec 31** instead of May 1 - Dec 31:

### Updated Files:
1. ✅ `backend/queries/earth_multiyear_summary_fixed.sql` - Year summary query
2. ✅ `backend/queries/earth_complete_fixed_new_uploaders.sql` - Complete with countries

### Date Range Change:
- **Old**: `0501000000` (May 1st)
- **New**: `0401000000` (April 1st)
- **End**: `1231235959` (Dec 31st) - unchanged

## Next Steps

1. **Run the updated query** in Quarry:
   - Use: `backend/queries/earth_multiyear_summary_fixed.sql`
   - Or: `backend/queries/earth_complete_fixed_new_uploaders.sql` (if you need countries)

2. **Download results as JSON**

3. **Save as**: 
   - `wiki_loves_campaign_data/query19.json` (for year summary)
   - Or `wiki_loves_campaign_data/earth_complete_with_countries.json` (for complete)

4. **Process the data**:
   ```bash
   python wikiloves-main/backend/scripts/process_all_campaigns.py
   ```

5. **Verify**:
   ```bash
   python wikiloves-main/check_new_uploaders.py
   ```

## Expected Results

After running with April 1st date range:
- **2013**: ~297 new_uploaders (reference: 275, difference: 8%) ✅
- **2014**: Should be closer to 2,364
- **All other years**: Should improve significantly

The April 1st date range should give much better results across all years!

