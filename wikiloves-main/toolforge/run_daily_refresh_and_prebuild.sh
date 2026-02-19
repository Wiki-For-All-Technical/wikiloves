#!/bin/bash
# Run daily refresh (processed stats) then prebuild uploaders cache.
# Schedule with Toolforge jobs, e.g. daily at 3 UTC (after 2 UTC refresh if you run it separately):
#   toolforge jobs run run_daily_refresh_and_prebuild.sh --schedule "0 3 * * *"
# Or run both in one job so uploaders cache is always warm after refresh:
#   toolforge jobs run run_daily_refresh_and_prebuild.sh --schedule "0 2 * * *"

set -e
cd "$(dirname "$0")/src"
# 1) Refresh campaign stats (writes *_processed.json)
python3 daily_refresh.py
# 2) Prebuild uploaders cache from processed data (frontend then gets data from cache, not DB)
python3 prebuild_uploaders_cache.py
