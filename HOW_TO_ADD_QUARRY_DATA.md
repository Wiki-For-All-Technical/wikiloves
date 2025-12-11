# How to Add Quarry Data to the Tool

This guide shows you step-by-step how to add statistics from Quarry to your Wiki Loves tool.

## Step 1: Run Your Summary Query in Quarry

You already have a working query that returns totals! Here's what you got:
- **Uploads**: 239,104
- **Uploaders**: 4,358
- **Images Used**: 239,104

### Your Current Query (Keep this!)
```sql
SELECT 
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
        ) THEN i.img_name 
    END) AS images_used
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title 
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
  AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024';
```

## Step 2: Add Summary Data to Catalog

You can add the summary data right now, even without country breakdown:

```bash
cd wikiloves-main
python backend/scripts/add_quarry_summary.py wiki-loves-monuments 2024 239104 4358 239104 0
```

This will:
- Add 2024 data for Wiki Loves Monuments
- Include totals (uploads, uploaders, images_used)
- Leave country_stats empty (you can add it later)

## Step 3: Get Country-Level Data (Optional but Recommended)

To get country breakdown, run this query in Quarry:

```sql
SELECT 
    CASE 
        WHEN cl.cl_to LIKE '%_in_%' THEN
            REPLACE(SUBSTRING_INDEX(cl.cl_to, '_in_', -1), '_', ' ')
        ELSE 'Global'
    END AS country,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= '20240901000000'
            AND u.user_registration <= '20240930235959'
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title 
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024'
    OR cl.cl_to LIKE 'Images_from_Wiki_Loves_Monuments_2024_in_%'
  )
  AND i.img_timestamp >= '20240901000000'
  AND i.img_timestamp <= '20240930235959'
GROUP BY country
ORDER BY uploads DESC;
```

### Download Results
1. Click "Download data" button in Quarry
2. Choose **JSON** format
3. Save as `monuments_2024_countries.json` in a `quarry_data` folder

## Step 4: Process Country Data

If you downloaded country data:

```bash
# Create directory for quarry exports
mkdir -p quarry_data

# Move your JSON file there
# (or download directly to quarry_data/)

# Process the file
python backend/queries/process_quarry_results.py quarry_data --output backend/data/catalog.py
```

## Quick Start: Add Your Current Data Now

Since you already have the summary data, let's add it:

```bash
cd wikiloves-main
python backend/scripts/add_quarry_summary.py wiki-loves-monuments 2024 239104 4358 239104 0
```

This will immediately add the 2024 data to your catalog!

## For Other Campaigns

1. **Find the category name** using the category discovery query
2. **Run summary query** (like you did for Monuments)
3. **Add summary data** using the script
4. **Optionally get country data** and process it

## File Structure

```
wikiloves-main/
├── backend/
│   ├── data/
│   │   └── catalog.py          # Main data file (auto-updated)
│   ├── queries/
│   │   ├── country_stats_query.sql  # Country breakdown query
│   │   └── process_quarry_results.py # Process JSON/CSV files
│   └── scripts/
│       └── add_quarry_summary.py    # Add summary data quickly
└── quarry_data/                 # Put your Quarry exports here
    └── monuments_2024_countries.json
```

## Troubleshooting

**"Campaign not found" error?**
- Check the campaign slug in `backend/data/campaigns_metadata.py`
- Use the exact slug (e.g., `wiki-loves-monuments`, not `Wiki Loves Monuments`)

**"Year already exists" warning?**
- The script will ask if you want to replace it
- Type `y` to replace, `n` to cancel

**Need to update country stats later?**
- Just run the country query and process it
- The script will merge it with existing data







