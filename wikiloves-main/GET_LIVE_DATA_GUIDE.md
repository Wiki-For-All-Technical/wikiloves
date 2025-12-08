# How to Get Live Wiki Loves Campaign Data

## The Problem
The current data for campaigns like Africa, Folklore, Science, etc. is missing country-level breakdown. You need to get this data from the live Wikimedia sources.

## Data Sources

### 1. EditathonStat Tool (Recommended)
**URL**: https://editathonstat.toolforge.org/campaign.php

This tool provides detailed statistics for Wiki campaigns including:
- Total uploads per country
- Number of uploaders per country
- Images used in articles
- New uploaders

**How to use:**
1. Go to https://editathonstat.toolforge.org/campaign.php
2. Enter the campaign category (e.g., `Images_from_Wiki_Loves_Africa_2024`)
3. Click "Get Statistics"
4. Copy the data for each country

### 2. Meta Wiki Campaign Page
**URL**: https://meta.wikimedia.org/wiki/wiki_loves_x_campaigns

This page lists all Wiki Loves campaigns with links to their statistics.

### 3. Quarry (For SQL Queries)
**URL**: https://quarry.wmcloud.org

Run SQL queries directly on the Commons database.

---

## Step-by-Step Guide

### Step 1: Get Campaign Category Names

For each campaign, you need the category pattern:
- **Africa**: `Images_from_Wiki_Loves_Africa_YEAR_in_COUNTRY`
- **Folklore**: `Images_from_Wiki_Loves_Folklore_YEAR_in_COUNTRY`
- **Monuments**: `Images_from_Wiki_Loves_Monuments_YEAR_in_COUNTRY`
- **Earth**: `Images_from_Wiki_Loves_Earth_YEAR_in_COUNTRY`
- **Science**: `Images_from_Wiki_Science_Competition_YEAR_in_COUNTRY`

### Step 2: Use EditathonStat Tool

1. Visit: https://editathonstat.toolforge.org/campaign.php?capval=Images_from_Wiki_Loves_Africa_2024
2. The tool will show statistics per country
3. Note down: uploads, uploaders, images_used, new_uploaders for each country

### Step 3: Create JSON Data File

Create a file like `quarry_data/africa_country_data.json` with this format:

```json
[
  {
    "year": 2024,
    "country": "Global",
    "uploads": 13977,
    "uploaders": 777,
    "images_used": 13977,
    "new_uploaders": 500
  },
  {
    "year": 2024,
    "country": "Nigeria",
    "uploads": 3500,
    "uploaders": 200,
    "images_used": 3500,
    "new_uploaders": 150
  },
  {
    "year": 2024,
    "country": "Ghana",
    "uploads": 2800,
    "uploaders": 150,
    "images_used": 2800,
    "new_uploaders": 100
  }
  // ... more countries
]
```

### Step 4: Process the Data

Run the processing script:
```bash
cd wikiloves-main
python backend/scripts/process_all_country_data.py
```

### Step 5: Verify

Start the backend and frontend to verify the data:
```bash
# Terminal 1
cd backend
python app.py

# Terminal 2
cd frontend/Wikiproject
npm run dev
```

---

## Quick Links for Each Campaign

### Wiki Loves Africa
- EditathonStat: https://editathonstat.toolforge.org/campaign.php?capval=Images_from_Wiki_Loves_Africa_2024
- Commons Category: https://commons.wikimedia.org/wiki/Category:Images_from_Wiki_Loves_Africa_2024

### Wiki Loves Folklore
- EditathonStat: https://editathonstat.toolforge.org/campaign.php?capval=Images_from_Wiki_Loves_Folklore_2024
- Commons Category: https://commons.wikimedia.org/wiki/Category:Images_from_Wiki_Loves_Folklore_2024

### Wiki Science Competition
- EditathonStat: https://editathonstat.toolforge.org/campaign.php?capval=Images_from_Wiki_Science_Competition_2024
- Commons Category: https://commons.wikimedia.org/wiki/Category:Images_from_Wiki_Science_Competition_2024

### Wiki Loves Monuments
- Already has country data in: `quarry_data/monuments_county_converted.json`
- Commons Category: https://commons.wikimedia.org/wiki/Category:Images_from_Wiki_Loves_Monuments_2024

### Wiki Loves Earth
- Already has country data in: `quarry_data/earth_country_converted.json`
- Commons Category: https://commons.wikimedia.org/wiki/Category:Images_from_Wiki_Loves_Earth_2024

---

## Alternative: Quarry SQL Query

If you prefer running SQL queries, go to https://quarry.wmcloud.org and run:

```sql
SELECT 
    CAST(REGEXP_SUBSTR(cl.cl_to, '[0-9]{4}') AS UNSIGNED) AS year,
    CASE 
        WHEN cl.cl_to LIKE '%_in_%' THEN
            REPLACE(SUBSTRING_INDEX(cl.cl_to, '_in_', -1), '_', ' ')
        ELSE 'Global'
    END AS country,
    COUNT(DISTINCT p.page_title) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id AND p.page_namespace = 6
LEFT JOIN image i ON i.img_name = p.page_title
LEFT JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
  AND cl.cl_to LIKE 'Images_from_Wiki_Loves_Africa_%'
GROUP BY year, country
ORDER BY year DESC, uploads DESC;
```

Download the results as JSON and save to `quarry_data/` folder.

---

## File Naming Convention

Save your data files as:
- `africa_country_data.json`
- `folklore_country_data.json`
- `science_country_data.json`
- `food_country_data.json`
- `public_art_country_data.json`

The processing script will automatically pick them up.

