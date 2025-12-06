# Guide: Getting Wiki Loves Data from Quarry

This guide explains how to extract Wiki Loves campaign statistics from [Quarry](https://quarry.wmcloud.org) and add them to the tool.

## Step 1: Access Quarry

1. Go to **https://quarry.wmcloud.org**
2. Click **"Login with Wikimedia"**
3. Sign in with your Wikimedia account
4. You'll need to agree to the Wikimedia Cloud Services Terms of Use

## Step 2: Select Database

1. Click **"New Query"** or use an existing query
2. Select database: **`commonswiki_p`** (Commons database)
   - This contains all the image upload data for Wiki Loves campaigns

## Step 3: Run a Query

### Option A: Use Ready-Made Queries

We've prepared queries in `backend/queries/quarry_ready_queries.sql`. Here's how to use them:

1. Open `backend/queries/quarry_ready_queries.sql`
2. Find the query for your campaign (e.g., "Wiki Loves Monuments")
3. Copy the query
4. **Replace `YEAR` with the actual year** (e.g., replace `YEAR` with `2024`)
5. Paste into Quarry
6. Click **"Run Query"**

### Option B: Discover Categories First

Before running a campaign query, you might want to see what categories exist:

```sql
-- Replace CAMPAIGN_NAME and YEAR
SELECT DISTINCT cl.cl_to AS category_name
FROM categorylinks cl
WHERE cl.cl_to LIKE '%Wiki_Loves%2024%'
   OR cl.cl_to LIKE '%Monuments%2024%'
ORDER BY cl.cl_to;
```

This shows you the exact category names to use in your main query.

## Step 4: Export Results

1. After the query runs, you'll see a table with results
2. Click **"Export"** or **"Download"**
3. Choose format: **CSV** (recommended) or **JSON**
4. Save the file with naming: `campaignname_year.csv` (e.g., `monuments_2024.csv`)

### Expected CSV Format

Your exported CSV should have columns like:
- `country_indicator` or `country` - Country name
- `uploads` - Number of uploads
- `uploaders` - Number of unique uploaders  
- `images_used` - Number of images used in articles
- `new_uploaders` - Number of newly registered uploaders

## Step 5: Process the Data

### Single File

If you have one export file:

```bash
# Create a directory for exports
mkdir quarry_exports

# Move your CSV file there with proper naming
# e.g., monuments_2024.csv, earth_2023.csv

# Process all files in the directory
cd backend
python queries/process_quarry_results.py ../quarry_exports --output data/catalog.py
```

### Multiple Files

If you have multiple campaign/year combinations:

```bash
# Put all export files in quarry_exports/
# Naming: campaignprefix_year.csv
# Examples:
#   - monuments_2024.csv
#   - earth_2023.csv
#   - africa_2024.csv

cd backend
python queries/process_quarry_results.py ../quarry_exports --output data/catalog.py
```

## Step 6: Verify Results

1. Check the output - it should show:
   ```
   Successfully merged all campaigns into catalog.py
      - Total campaigns: 25
      - Campaigns with data: X
      - Campaigns without data: Y
   ```

2. Start the backend:
   ```bash
   python backend/app.py
   ```

3. Test the API:
   ```bash
   curl http://127.0.0.1:5000/api/competitions
   ```

4. Check the frontend - campaigns with new data should now show statistics!

## Common Campaign Dates

Different campaigns run at different times of year:

- **Wiki Loves Monuments**: September (09)
- **Wiki Loves Earth**: May (05)
- **Wiki Loves Africa**: March (03)
- **Wiki Loves Folklore**: February (02)
- **Wiki Science Competition**: November (11)
- **Wiki Loves Public Art**: Varies

Adjust the date ranges in queries accordingly.

## Troubleshooting

### Query Returns No Results

1. **Check category names**: Run the category discovery query first
2. **Verify year**: Make sure the year is correct
3. **Check date range**: Campaigns may have different date ranges
4. **Try broader search**: Some campaigns use different category naming

### Country Data Not Accurate

- Commons doesn't have direct country data
- The queries use user registration as a proxy
- For accurate country data, you may need:
  - Campaign-specific tracking data
  - User profile information
  - Manual country assignment

### Processing Errors

1. **Check file naming**: Must be `campaignprefix_year.ext`
2. **Verify CSV format**: Should have headers
3. **Check encoding**: Use UTF-8 encoding
4. **Review logs**: Check error messages for specific issues

## Example Workflow

Here's a complete example for adding Wiki Loves Monuments 2024 data:

1. **Go to Quarry**: https://quarry.wmcloud.org
2. **Login** with Wikimedia account
3. **Select database**: `commonswiki_p`
4. **Copy query** from `quarry_ready_queries.sql` (Query 1)
5. **Replace `YEAR`** with `2024`:
   ```sql
   WHERE img.img_timestamp >= '20240901000000'
     AND img.img_timestamp <= '20240930235959'
   ```
6. **Run query**
7. **Export as CSV**: Save as `monuments_2024.csv`
8. **Process**:
   ```bash
   mkdir -p quarry_exports
   mv monuments_2024.csv quarry_exports/
   cd backend
   python queries/process_quarry_results.py ../quarry_exports --output data/catalog.py
   ```
9. **Restart backend** and verify in frontend!

## Next Steps

- Add data for all campaigns that need it
- Update existing campaigns with new year data
- Set up a schedule to refresh data periodically
- Consider automating the Quarry query process

## Resources

- **Quarry**: https://quarry.wmcloud.org
- **Quarry Documentation**: Check the "Documentation" link on Quarry
- **Commons Database Schema**: Available in Quarry's "Database tables" section
- **Ready Queries**: `backend/queries/quarry_ready_queries.sql`
- **Processing Script**: `backend/queries/process_quarry_results.py`









