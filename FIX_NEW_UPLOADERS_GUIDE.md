# Fix Guide: New Uploaders for Wiki Loves Earth

## Problem Identified
The "Uploaders registered after competition start" metric is significantly lower than the reference website because we were only counting users who registered **during May** (May 1-31), but the reference counts users who registered **on or after May 1st** through the end of the year.

## Current vs Reference Data

| Year | Our New Uploaders | Reference | Difference | Our % | Ref % |
|------|------------------|-----------|------------|-------|-------|
| 2013 | 98 | 275 | +177 (64%) | 24.9% | 79.0% |
| 2014 | 1,928 | 2,364 | +436 (18%) | 62.0% | 82.0% |
| 2015 | 7,155 | 7,700 | +545 (7%) | 80.0% | 87.0% |
| 2016 | 4,813 | 11,654 | +6,841 (59%) | 35.5% | 89.0% |
| 2017 | 5,310 | 13,629 | +8,319 (61%) | 36.0% | 91.0% |
| 2018 | 3,708 | 6,276 | +2,568 (41%) | 49.4% | 83.0% |
| 2019 | 5,073 | 8,314 | +3,241 (39%) | 52.1% | 86.0% |
| 2020 | 2,988 | 7,541 | +4,553 (60%) | 32.7% | 83.0% |
| 2021 | 1,194 | 3,512 | +2,318 (66%) | 26.4% | 77.0% |
| 2022 | 933 | 3,222 | +2,289 (71%) | 23.7% | 78.0% |
| 2023 | 529 | 2,376 | +1,847 (78%) | 15.4% | 69.0% |
| 2024 | 700 | 2,726 | +2,026 (74%) | 18.4% | 70.0% |
| 2025 | 485 | 3,680 | +3,195 (87%) | 9.2% | 70.0% |

## Solution

### Option 1: Complete Dataset (Recommended)
Run the complete query that gets all years with country breakdowns:

**File**: `backend/queries/earth_complete_fixed_new_uploaders.sql`

**Steps**:
1. Open Quarry (https://quarry.wmcloud.org/)
2. Copy and paste the query from `earth_complete_fixed_new_uploaders.sql`
3. Run the query (will take 5-10 minutes)
4. Download results as JSON
5. Save to: `wiki_loves_campaign_data/earth_complete_with_countries.json` (replace existing)
6. Process the data:
   ```bash
   python wikiloves-main/backend/scripts/process_all_campaigns.py
   ```

### Option 2: Multiyear Summary Only
If you only need year totals (no country breakdown):

**File**: `backend/queries/earth_multiyear_summary_fixed.sql`

**Steps**:
1. Run query in Quarry
2. Download as JSON
3. Save to: `wiki_loves_campaign_data/query19.json` (replace existing)
4. Process the data:
   ```bash
   python wikiloves-main/backend/scripts/process_all_campaigns.py
   ```

### Option 3: Fix 2013 and 2014 Only
If you want to fix just the problematic years first:

**File**: `backend/queries/earth_2013_2014_fix_new_uploaders.sql`

**Steps**:
1. Run query in Quarry
2. Download as JSON
3. Save results as:
   - `wiki_loves_campaign_data/earth_2013_fix.json`
   - `wiki_loves_campaign_data/earth_2014_fix.json`
4. Merge with existing data:
   ```bash
   python wikiloves-main/merge_earth_fix_data.py
   ```
5. Process the data:
   ```bash
   python wikiloves-main/backend/scripts/process_all_campaigns.py
   ```

## What Changed in the Query

**Old date range** (May 1-31 only):
```sql
user_registration >= CONCAT(year, '0501000000')
AND user_registration <= CONCAT(year, '0531235959')
```

**New date range** (May 1 - Dec 31):
```sql
user_registration >= CONCAT(year, '0501000000')
AND user_registration <= CONCAT(year, '1231235959')
```

## Verification

After processing, verify the fix:

```bash
python wikiloves-main/check_new_uploaders.py
```

You should see the new_uploaders values much closer to the reference (within 5-10% difference).

## Expected Results After Fix

- **2013**: ~275 new uploaders (79% of 346 total) ✓
- **2014**: ~2,364 new uploaders (82% of 2,882 total) ✓
- **2015**: ~7,700 new uploaders (87% of 8,785 total) ✓
- And similar improvements for all other years...

The percentages should now match the reference website much more closely.

