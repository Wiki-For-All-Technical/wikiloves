# Quick Start: Getting Data from Quarry

This is a quick guide to get Wiki Loves campaign data from [Quarry](https://quarry.wmcloud.org).

## Fastest Method

### Step 1: Generate Query

```bash
cd backend
python scripts/generate_quarry_query.py monuments 2024
```

This prints a ready-to-use SQL query. Copy it.

### Step 2: Run in Quarry

1. Go to **https://quarry.wmcloud.org**
2. Login with Wikimedia account
3. Select database: **`commonswiki_p`**
4. Paste the query
5. Click **"Run Query"**

### Step 3: Export Results

1. Click **"Export"** or **"Download"**
2. Choose **CSV** format
3. Save as: `monuments_2024.csv`

### Step 4: Process Data

```bash
# Create export directory
mkdir -p quarry_exports

# Move your CSV file
mv monuments_2024.csv quarry_exports/

# Process it
cd backend
python queries/process_quarry_results.py ../quarry_exports --output data/catalog.py
```

### Step 5: Verify

```bash
# Start backend
python backend/app.py

# Check API (in another terminal)
curl http://127.0.0.1:5000/api/competitions | grep "Wiki Loves Monuments"
```

## Discover Categories First

If you're not sure what categories exist for a campaign:

```bash
python scripts/generate_quarry_query.py monuments 2024 --discover
```

Run this query in Quarry first to see available categories, then adjust the main query.

## Available Campaigns

Use these prefixes with the script:

- `monuments` - Wiki Loves Monuments
- `earth` - Wiki Loves Earth
- `africa` - Wiki Loves Africa
- `folklore` - Wiki Loves Folklore
- `science` - Wiki Science Competition
- `public_art` - Wiki Loves Public Art
- `food` - Wiki Loves Food
- `women` - Wiki Loves Women
- And 17 more... (see `backend/data/campaigns_metadata.py`)

## Example: Complete Workflow

```bash
# 1. Generate query for Wiki Loves Earth 2024
cd backend
python scripts/generate_quarry_query.py earth 2024 > ../earth_2024_query.sql

# 2. Go to Quarry, run the query, export as earth_2024.csv

# 3. Process the export
mkdir -p ../quarry_exports
mv ../earth_2024.csv ../quarry_exports/
python queries/process_quarry_results.py ../quarry_exports --output data/catalog.py

# 4. Restart backend and check frontend!
```

## Troubleshooting

**Query returns no results?**
- Run the discovery query first: `--discover` flag
- Check if the year is correct
- Verify campaign dates (some run in specific months)

**Processing fails?**
- Check file naming: must be `campaignprefix_year.csv`
- Verify CSV has headers
- Check file encoding (should be UTF-8)

**Need help?**
- See full guide: `QUARRY_DATA_GUIDE.md`
- Check ready queries: `backend/queries/quarry_ready_queries.sql`









