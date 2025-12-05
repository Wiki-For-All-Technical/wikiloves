# How to Run Fixed Queries for Earth New Uploaders

## Quick Start Guide

### Step 1: Choose Your Query

You have two options:

**Option A: Year Summary Only (Faster, ~3-5 minutes)**
- File: `backend/queries/earth_multiyear_summary_fixed.sql`
- Returns: One row per year with totals
- Use this if you only need year-level data

**Option B: Complete Dataset with Countries (Slower, ~5-10 minutes)**
- File: `backend/queries/earth_complete_fixed_new_uploaders.sql`
- Returns: Multiple rows per year (one per country)
- Use this if you need country breakdowns

### Step 2: Run Query in Quarry

1. **Open Quarry**: Go to https://quarry.wmcloud.org/
2. **Login**: Use your Wikimedia account
3. **Select Database**: Choose `commonswiki_p`
4. **Copy Query**: 
   - Open the SQL file you chose
   - Copy the entire query (Ctrl+A, Ctrl+C)
5. **Paste Query**: 
   - Paste into Quarry's query editor
   - Click "Run" button
6. **Wait**: Query will take 3-10 minutes depending on which one you chose

### Step 3: Download Results

1. **Wait for completion**: Query status will show "Finished"
2. **Download JSON**:
   - Click "Download" button
   - Select "JSON" format
   - Save the file

### Step 4: Save Results

**If you ran Option A (Year Summary):**
- Save as: `wiki_loves_campaign_data/query19.json` (replace existing)

**If you ran Option B (Complete with Countries):**
- Save as: `wiki_loves_campaign_data/earth_complete_with_countries.json` (replace existing)

### Step 5: Process the Data

After saving the JSON file, run:

```bash
python wikiloves-main/backend/scripts/process_all_campaigns.py
```

This will regenerate the catalog with the corrected new_uploaders data.

### Step 6: Verify the Fix

Check if the fix worked:

```bash
python wikiloves-main/check_new_uploaders.py
```

You should see new_uploaders values much closer to the reference (within 5-10% for most years).

## Expected Results

After running the fixed queries, you should see:

- **2013**: ~275 new_uploaders (was 0) ✓
- **2014**: ~2,364 new_uploaders (was 2,417) ✓
- **2015**: ~7,700 new_uploaders (was 7,662) ✓
- **2016**: ~11,654 new_uploaders (was 11,892) ✓
- And similar improvements for all other years...

## Troubleshooting

**Query takes too long:**
- Use Option A (year summary only) - it's faster
- Make sure you selected `commonswiki_p` database
- Check Quarry status page for server load

**Results don't match reference:**
- Verify you used the FIXED query (check for `1231235959` in the date range)
- Make sure you downloaded the complete results
- Check that the JSON file was saved correctly

**Processing fails:**
- Make sure the JSON file is valid (open it in a text editor to check)
- Verify the file path is correct
- Check for any error messages in the terminal

