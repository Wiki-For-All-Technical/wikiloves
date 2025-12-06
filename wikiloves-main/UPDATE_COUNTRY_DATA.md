# Update Earth Complete Country Data

## Current Status

✅ **query19.json** - Already updated with April 1st date range:
- 2013: 296 new_uploaders (good!)

❌ **earth_complete_with_countries.json** - Still has old data:
- 2013: Only has Ukraine row with 98 new_uploaders
- Missing Global row for 2013
- Still using May 1st date range

## Solution

You have two options:

### Option 1: Run Complete Query (Recommended if you need country breakdowns)

1. **Run**: `backend/queries/earth_complete_fixed_new_uploaders.sql` in Quarry
   - This query now uses April 1st date range
   - Will get all years (2013-2025) with country breakdowns
   - Takes 5-10 minutes

2. **Download as JSON**

3. **Save as**: `wiki_loves_campaign_data/earth_complete_with_countries.json` (replace existing)

4. **Process**:
   ```bash
   python wikiloves-main/backend/scripts/process_all_campaigns.py
   ```

### Option 2: Use Year Summary Only (If you don't need country breakdowns)

If you only need year totals (no country breakdowns), you can just use `query19.json` which is already correct.

The current `query19.json` has the correct data with April 1st date range, so your year totals are already accurate!

## Verification

After updating, verify:
```bash
python wikiloves-main/check_new_uploaders.py
```

You should see all years within 5-10% of reference.



