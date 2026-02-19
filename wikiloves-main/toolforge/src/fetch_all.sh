#!/bin/bash
set -e

MARIA="mariadb --defaults-file=$HOME/replica.my.cnf -h commonswiki.analytics.db.svc.wikimedia.cloud commonswiki_p --batch"
OUTDIR="/tmp/wl_bulk"
mkdir -p "$OUTDIR"

echo "============================================"
echo "  Wiki Loves Bulk Data Fetcher"
echo "  Output: $OUTDIR"
echo "============================================"

fetch_campaign_year() {
    local slug="$1"
    local prefix="$2"
    local year="$3"
    local pattern="${prefix}_${year}_in_%"
    local outfile="${OUTDIR}/${slug}_${year}.tsv"

    echo "[$(date +%H:%M:%S)] Fetching ${slug} ${year} ..."
    $MARIA -e "
SELECT
  cl.cl_to AS category,
  a.actor_name,
  u.user_registration,
  DATE(img.img_timestamp) AS upload_date
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
  AND p.page_namespace = 6
  AND p.page_is_redirect = 0
JOIN image img ON img.img_name = p.page_title
JOIN actor a ON img.img_actor = a.actor_id
LEFT JOIN user u ON a.actor_user = u.user_id
WHERE cl.cl_to LIKE '${pattern}'
  AND cl.cl_to NOT LIKE '%/%'
  AND cl.cl_to NOT LIKE '%_by_%'
  AND cl.cl_to NOT LIKE '%_at_%'
" > "$outfile"

    local rows
    rows=$(wc -l < "$outfile")
    echo "  -> ${rows} rows saved to ${outfile}"
}

# ---- Earth: 2013-2025 ----
for y in $(seq 2013 2025); do
    fetch_campaign_year "earth" "Images_from_Wiki_Loves_Earth" "$y"
done

# ---- Monuments: 2010-2025 ----
for y in $(seq 2010 2025); do
    fetch_campaign_year "monuments" "Images_from_Wiki_Loves_Monuments" "$y"
done

# ---- Science: 2015-2025 ----
for y in $(seq 2015 2025); do
    fetch_campaign_year "science" "Images_from_Wiki_Science_Competition" "$y"
done

# ---- Folklore: 2017-2025 ----
for y in $(seq 2017 2025); do
    fetch_campaign_year "folklore" "Images_from_Wiki_Loves_Folklore" "$y"
done

# ---- Africa: 2014-2025 ----
for y in $(seq 2014 2025); do
    fetch_campaign_year "africa" "Images_from_Wiki_Loves_Africa" "$y"
done

# ---- Food: 2016-2025 ----
for y in $(seq 2016 2025); do
    fetch_campaign_year "food" "Images_from_Wiki_Loves_Food" "$y"
done

# ---- Public Art: 2020-2025 ----
for y in $(seq 2020 2025); do
    fetch_campaign_year "public_art" "Images_from_Wiki_Loves_Public_Art" "$y"
done

echo ""
echo "============================================"
echo "  All fetches complete!"
echo "============================================"
echo "TSV files:"
ls -lh "${OUTDIR}"/*.tsv 2>/dev/null | wc -l
echo "total files in $OUTDIR"
echo ""
echo "Next step: run process_all.py to convert TSVs to JSON cache"
