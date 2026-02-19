#!/bin/bash
# Daily bulk refresh: fetch TSVs from Commons DB, then process to JSON.
# Schedule on Toolforge (as tool wikiloves-data):
#   toolforge jobs run run_bulk_refresh.sh --schedule "0 2 * * *"
#
# Run from tool home; ensure fetch_*.sh and process_all.py are in ~/ or set SCRIPT_DIR.

set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC="${SCRIPT_DIR}/src"
# If run from tool home with scripts in home (e.g. after cp from deploy)
if [ ! -d "$SRC" ]; then
  SRC="$HOME"
fi
cd "$SRC"
OUTDIR="/tmp/wl_bulk"
mkdir -p "$OUTDIR"
export OUTDIR

echo "[$(date -Iseconds)] Starting daily bulk refresh"

# 1) Upload TSVs for all campaigns (earth only in fetch_all; others get images_used from individual scripts)
if [ -f "$SRC/fetch_all.sh" ]; then
  bash "$SRC/fetch_all.sh"
else
  echo "Warning: fetch_all.sh not found, skipping"
fi

# 2) Campaign-specific fetches (add/refresh TSVs + images_used TSVs)
for script in fetch_earth.sh fetch_monuments.sh fetch_folklore.sh fetch_science.sh fetch_africa.sh fetch_food.sh fetch_public_art.sh; do
  if [ -f "$SRC/$script" ]; then
    bash "$SRC/$script"
  fi
done

# 3) Process TSVs to JSON (writes shared/data/*_processed.json)
python3 "$SRC/process_all.py" earth monuments folklore science africa food public_art

echo "[$(date -Iseconds)] Daily bulk refresh done"
