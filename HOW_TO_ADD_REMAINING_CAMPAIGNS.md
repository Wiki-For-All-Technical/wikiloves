# How to Add Data for Remaining Wiki Loves Campaigns

This guide shows you how to discover and add data for campaigns that don't have statistics yet.

## Current Status

### ✅ Campaigns with Data (Already Processed)
- Wiki Loves Monuments (2010-2025) - with country breakdown
- Wiki Loves Earth (2013-2025) - with country breakdown  
- Wiki Loves Africa (2014-2025) - summary only
- Wiki Loves Folklore (2021-2025) - summary only
- Wiki Science Competition (2011-2025) - summary only
- Wiki Loves Public Art (2013) - summary only

### 📋 Remaining Campaigns to Add
There are 19+ more campaigns in the metadata that need data. Some may have data in Commons, others may not.

## Step-by-Step Process

### Step 1: Discover Which Campaigns Have Data

**Option A: Run Discovery Query (Recommended)**

1. Go to https://quarry.wmcloud.org
2. Select database: `commonswiki_p`
3. Run this query:

```sql
-- Discover all Wiki Loves categories
SELECT DISTINCT 
    cl.cl_to AS category_name,
    COUNT(DISTINCT p.page_id) AS file_count
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
WHERE cl.cl_type = 'file'
  AND (
    cl.cl_to LIKE '%Wiki_Loves%'
    OR cl.cl_to LIKE '%WikiScience%'
  )
  AND p.page_namespace = 6
  AND p.page_is_redirect = 0
GROUP BY cl.cl_to
HAVING file_count > 0
ORDER BY file_count DESC
LIMIT 500;
```

This shows ALL Wiki Loves categories that exist in Commons with file counts.

**Option B: Use Discovery Script**

```bash
# Generate discovery queries for all campaigns
python backend/scripts/discover_campaign_data.py --queries

# This creates: backend/queries/campaign_discovery_queries.sql
# Run individual queries to check each campaign
```

### Step 2: Identify Category Names

From the discovery query results, identify:
- **Exact category name pattern** (e.g., `Images_from_Wiki_Loves_Fashion_2024`)
- **Years available** (look for patterns like `_2024`, `_2023`, etc.)
- **File counts** (to see if there's enough data)

### Step 3: Create Multi-Year Query

Use the template from `backend/queries/quarry_multiyear_all_campaigns.sql`:

1. **Copy the Monuments query** as a template
2. **Replace**:
   - Category pattern: `Images_from_Wiki_Loves_Monuments_%` → Your campaign pattern
   - Year range: `BETWEEN 2010 AND 2025` → Adjust based on discovery
   - Date ranges: Adjust months/days for campaign dates

**Example for Wiki Loves Fashion:**

```sql
SELECT 
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
        ) THEN i.img_name 
    END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '0101000000')
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
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
  AND cl.cl_to LIKE 'Wiki_Loves_Fashion_%'
  AND cl.cl_to REGEXP 'Wiki_Loves_Fashion_[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2020 AND 2025
GROUP BY year
ORDER BY year DESC;
```

### Step 4: Run Query and Download

1. **Run the query** in Quarry (may take a few minutes)
2. **Download as JSON** from Quarry
3. **Convert format** (if needed):
   ```bash
   python backend/scripts/convert_quarry_export.py <file.json.json>
   ```
4. **Save as**: `{campaign_prefix}_multiyear.json` (e.g., `fashion_multiyear.json`)

### Step 5: Process the Data

```bash
python backend/scripts/process_multiyear_quarry.py fashion_multiyear.json fashion
```

This will automatically:
- Process all years in the file
- Merge with existing catalog
- Add country profiles (if country data included)

### Step 6: Add Country Breakdown (Optional)

If you want country-level statistics:

1. **Run country breakdown query** (use template from `quarry_multiyear_countries.sql`)
2. **Download and convert** the JSON
3. **Process** with the same script - it will merge country data into existing years

## Campaign-Specific Notes

### Campaigns Likely to Have Data (Based on Commons)

From your category discovery, these campaigns likely have data:

- **Wiki Loves Birds** - Category: `Images_from_Wiki_Loves_Birds_2024`
- **Wiki Loves Fashion** - Category: `Wiki_Loves_Fashion_2024`
- **Wiki Loves Film** - Category: `Wiki_Loves_Film_2024`
- **Wiki Loves Pride** - Category: `Wiki_Loves_Pride_2024`
- **Wiki Loves Onam** - Category: `Images_from_Wiki_Loves_Onam_2024`
- **Wiki Loves Heritage Belgium** - Category: `Images_from_Wiki_Loves_Heritage_Belgium_in_2024`

### Campaigns That May Not Have Data

Some campaigns in the metadata may not have run or may have different category names:
- Wiki Loves Biodiversity
- Wiki Loves Coasts
- Wiki Loves Democracy
- Wiki Loves Mountains
- Wiki Loves Rivers
- Wiki Loves Trees

**Check first** with the discovery query before creating queries.

## Quick Reference: Campaign Prefixes

| Campaign Name | Prefix | Example File |
|--------------|--------|--------------|
| Wiki Loves Fashion | `fashion` | `fashion_multiyear.json` |
| Wiki Loves Film | `film` | `film_multiyear.json` |
| Wiki Loves Pride | `pride` | `pride_multiyear.json` |
| Wiki Loves Birds | `birds` | `birds_multiyear.json` |
| Wiki Loves Food | `food` | `food_multiyear.json` |
| Wiki Loves Women | `women` | `women_multiyear.json` |
| Wiki Loves Sport | `sport` | `sport_multiyear.json` |

See `QUARRY_QUICK_REFERENCE.md` for complete list.

## Batch Processing Multiple Campaigns

If you discover multiple campaigns have data:

1. **Create queries** for each campaign
2. **Run all queries** in Quarry (one at a time)
3. **Download all JSON files** to `quarry_data/`
4. **Convert all files**:
   ```bash
   python backend/scripts/convert_quarry_export.py quarry_data/
   ```
5. **Process all multi-year files**:
   ```bash
   python backend/scripts/process_multiyear_quarry.py quarry_data/fashion_multiyear_converted.json fashion
   python backend/scripts/process_multiyear_quarry.py quarry_data/film_multiyear_converted.json film
   # ... etc
   ```

## Troubleshooting

**"No categories found"**
- Campaign may not have run yet
- Category names might be different
- Try broader search patterns

**"Query returns 0 results"**
- Check category name spelling
- Verify year range
- Try discovery query first

**"Year extraction fails"**
- Category names may not end with year
- Use timestamp-based year extraction instead
- See alternative query in `quarry_multiyear_summary.sql`

## Next Steps

1. **Run discovery query** to see what's available
2. **Prioritize campaigns** with most data
3. **Create queries** for top campaigns
4. **Process data** systematically
5. **Add country breakdowns** for major campaigns

Your tool will automatically show "No statistics data available" for campaigns without data, so you can add them gradually!

