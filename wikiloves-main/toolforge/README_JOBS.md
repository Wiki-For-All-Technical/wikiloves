# Toolforge jobs

## Fetching data (avoiding MySQL timeout)

`POST /api/fetch/all` runs one huge unified query and often times out with "Lost connection to MySQL server during query (timed out)".

**Quarry-style fetch** – The app now uses the same approach as [Quarry](https://quarry.wmcloud.org/): per-category exact-match queries (~14 sec each). For each campaign/year, it discovers category names (e.g. `Images_from_Wiki_Loves_Earth_2025_in_Germany`), then runs one fast aggregation query per category.

**Use batch fetch** – fetches campaigns one-by-one:

```bash
curl -X POST https://wikiloves-data.toolforge.org/api/fetch/batch
```

Optional body to limit campaigns:

```bash
curl -X POST -H "Content-Type: application/json" -d '{"campaigns":["earth","monuments"]}' https://wikiloves-data.toolforge.org/api/fetch/batch
```

For a single campaign (e.g. earth only):

```bash
curl -X POST https://wikiloves-data.toolforge.org/api/fetch/earth
```

Check status: `GET /api/status`

---

## Fast data when clicking a country (e.g. earth/2025/Germany)

Both **country detail** (totals, images, uploaders) and **contributors (uploaders list)** are served from cache when present. The prebuild fills both caches so the frontend gets data immediately when you click a country.

### Option A: API trigger (recommended – no extra job setup)

The web app has `POST /api/prebuild` which runs the prebuild in a background thread (same process, has pymysql etc.):

```bash
curl -X POST https://wikiloves-data.toolforge.org/api/prebuild
```

Returns immediately; prebuild runs in background. To run daily, use an external cron (e.g. cron-job.org) to hit that URL at 3 UTC (after your daily refresh at 2 UTC).

### Option B: Toolforge scheduled job

Requires a custom image (the base `python3.11` image has no pip). If you use the Build Service or a custom image with dependencies:

```bash
toolforge jobs run daily-refresh-prebuild --command "cd /data/project/wikiloves-data && bash www/python/run_daily_refresh_and_prebuild.sh" --image <your-built-image> --schedule "0 2 * * *" --mount=all
```

### Prebuild script

`src/prebuild_uploaders_cache.py` reads `*_processed.json` and, for each campaign/year/country in the last 3 years, writes:
- **country detail** → `data/country_detail/` (instant `GET /api/data/earth/2025/Germany`)
- **uploaders** → `data/uploaders/` (instant contributors, no "building" message)
