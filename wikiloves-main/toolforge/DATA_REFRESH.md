# When does the API data update?

The API serves **pre-built JSON files** from disk (`shared/data/*_processed.json`). It does **not** hit the database on each request. So data only changes when those files are regenerated.

## By default: no automatic update

If you never schedule anything, the API keeps serving whatever was last written. You update data by running the fetch and process steps manually (e.g. over SSH).

## Option 1: Daily update with the bulk pipeline (recommended)

This is the same pipeline you use manually: fetch TSVs, then `process_all.py`.

1. **Schedule a daily job** on Toolforge (from your tool account):

   ```bash
   # From the tool’s home directory, e.g. /data/project/wikiloves-data
   toolforge jobs run run_bulk_refresh.sh --schedule "0 2 * * *"
   ```

2. **Create `run_bulk_refresh.sh`** in the tool’s repo (or home) so the job has one script to run:

   ```bash
   #!/bin/bash
   set -e
   cd /data/project/wikiloves-data  # or where your scripts live
   bash src/fetch_all.sh            # or run each fetch_*.sh
   python3 src/process_all.py earth monuments folklore science africa food public_art
   # Optional: prebuild uploaders cache
   python3 src/prebuild_uploaders_cache.py
   ```

   Use the `run_bulk_refresh.sh` script in this directory; see commands below.

**Daily job commands (run on Toolforge as tool wikiloves-data):**
- Deploy once: `scp wikiloves-main/toolforge/run_bulk_refresh.sh sanjesh200@login.toolforge.org:~/`
- Then: `become wikiloves-data`, copy script to `~/run_bulk_refresh.sh`, `sed -i 's/\r$//' ~/run_bulk_refresh.sh`, `chmod +x ~/run_bulk_refresh.sh`
- Schedule: `toolforge jobs run run_bulk_refresh.sh --schedule "0 2 * * *"` (daily at 02:00 UTC).

## Option 2: Daily update with the unified-query pipeline

The repo also has a **different** refresh path that uses a single SQL query and Python processor:

- Script: `run_daily_refresh_and_prebuild.sh`
- It runs `daily_refresh.py` (unified query + processor) then `prebuild_uploaders_cache.py`.

To run it daily at 02:00 UTC:

```bash
toolforge jobs run run_daily_refresh_and_prebuild.sh --schedule "0 2 * * *"
```

Use **either** Option 1 (bulk fetch + `process_all.py`) **or** Option 2 (daily_refresh.py), not both, so one pipeline is the single source of truth for `*_processed.json`.

## Summary

| Question | Answer |
|----------|--------|
| Does the API update by itself? | **No.** It only serves existing JSON files. |
| How to get daily updates? | Schedule a daily Toolforge job that runs one of the refresh pipelines above. |
| What schedule is suggested? | Once per day, e.g. `0 2 * * *` (02:00 UTC). |
