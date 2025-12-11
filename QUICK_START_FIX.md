# Quick Start: Fix Earth New Uploaders

## Step-by-Step Instructions

### Step 1: Open Quarry
1. Go to: **https://quarry.wmcloud.org/**
2. Login with your Wikimedia account
3. Click **"New Query"** or **"Run Query"**

### Step 2: Select Database
- In the database dropdown, select: **`commonswiki_p`**

### Step 3: Copy the Query
I recommend starting with the **faster option** (year summary only):

**File to use:** `backend/queries/earth_multiyear_summary_fixed.sql`

1. Open the file in your editor
2. Select all (Ctrl+A)
3. Copy (Ctrl+C)

### Step 4: Paste and Run
1. Paste the query into Quarry's query editor
2. Click **"Run"** button
3. Wait 3-5 minutes for results

### Step 5: Download Results
1. When query finishes, click **"Download"** button
2. Select format: **JSON**
3. Save the file

### Step 6: Save the File
Save the downloaded JSON file as:
```
wiki_loves_campaign_data/query19.json
```
(Replace the existing file)

### Step 7: Process the Data
Open terminal and run:
```bash
python wikiloves-main/backend/scripts/process_all_campaigns.py
```

### Step 8: Verify
Check if it worked:
```bash
python wikiloves-main/check_new_uploaders.py
```

You should see 2013 now has ~275 new_uploaders instead of 0!

---

## Alternative: Complete Dataset with Countries

If you need country breakdowns, use:
- **File:** `backend/queries/earth_complete_fixed_new_uploaders.sql`
- **Save as:** `wiki_loves_campaign_data/earth_complete_with_countries.json`
- **Time:** 5-10 minutes

---

## What Changed?

The fixed query uses:
- **Old:** May 1-31 only (`0531235959`)
- **New:** May 1 - Dec 31 (`1231235959`)

This matches the reference website's definition of "registered after competition start".

