#!/bin/bash
set -e

MARIA="mariadb --defaults-file=$HOME/replica.my.cnf -h commonswiki.analytics.db.svc.wikimedia.cloud commonswiki_p --batch"
OUTDIR="/tmp/wl_bulk"
mkdir -p "$OUTDIR"

echo "============================================"
echo "  Wiki Loves Earth - Bulk Data Fetcher"
echo "  Output: $OUTDIR"
echo "============================================"

PREFIX="Images_from_Wiki_Loves_Earth"

fetch_campaign_year() {
    local slug="$1"
    local year="$2"
    local pattern="${PREFIX}_${year}_in_%"
    local outfile="${OUTDIR}/${slug}_${year}.tsv"

    echo "[$(date +%H:%M:%S)] Fetching ${slug} ${year} (pattern: ${pattern}) ..."
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

for y in $(seq 2013 2025); do
    fetch_campaign_year "earth" "$y"
done

echo ""
echo "--- Fetching images_used counts per category ---"
$MARIA -e "
SELECT
  cl.cl_to AS category,
  COUNT(DISTINCT p.page_title) AS images_used
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
  AND p.page_namespace = 6
  AND p.page_is_redirect = 0
INNER JOIN globalimagelinks gil ON gil.gil_to = p.page_title
WHERE cl.cl_to LIKE '${PREFIX}_%'
  AND cl.cl_to NOT LIKE '%/%'
  AND cl.cl_to NOT LIKE '%_by_%'
  AND cl.cl_to NOT LIKE '%_at_%'
GROUP BY cl.cl_to
" > "${OUTDIR}/earth_images_used.tsv"
echo "  -> images_used saved to ${OUTDIR}/earth_images_used.tsv"

echo ""
echo "============================================"
echo "  Earth fetch complete!"
echo "============================================"
echo "TSV files:"
ls -lh "${OUTDIR}"/earth_*.tsv 2>/dev/null
echo ""
echo "Next step: python3 ~/process_all.py earth"
