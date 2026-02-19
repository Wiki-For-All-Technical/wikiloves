#!/bin/bash
set -e

MARIA="mariadb --defaults-file=$HOME/replica.my.cnf -h commonswiki.analytics.db.svc.wikimedia.cloud commonswiki_p --batch"
OUTDIR="/tmp/wl_bulk"
mkdir -p "$OUTDIR"

echo "============================================"
echo "  Wiki Science Competition - Bulk Data Fetcher"
echo "  Output: $OUTDIR"
echo "============================================"

PREFIX_NEW="Images_from_Wiki_Science_Competition"
PREFIX_OLD="Images_from_European_Science_Photo_Competition"

fetch_science_year() {
    local year="$1"
    local outfile="${OUTDIR}/science_${year}.tsv"

    echo "[$(date +%H:%M:%S)] Fetching science ${year} (both prefixes) ..."
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
WHERE (cl.cl_to LIKE '${PREFIX_NEW}_${year}_in_%'
    OR cl.cl_to LIKE '${PREFIX_OLD}_${year}_in_%'
    OR cl.cl_to = '${PREFIX_NEW}_${year}'
    OR cl.cl_to = '${PREFIX_OLD}_${year}')
  AND cl.cl_to NOT LIKE '%/%'
  AND cl.cl_to NOT LIKE '%_by_%'
  AND cl.cl_to NOT LIKE '%_at_%'
" > "$outfile"

    local rows
    rows=$(wc -l < "$outfile")
    echo "  -> ${rows} rows saved to ${outfile}"
}

for y in 2011 2012 2013 2015 2017 2019 2021 2023 2024; do
    fetch_science_year "$y"
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
WHERE (cl.cl_to LIKE '${PREFIX_NEW}_%' OR cl.cl_to LIKE '${PREFIX_OLD}_%')
  AND cl.cl_to NOT LIKE '%/%'
  AND cl.cl_to NOT LIKE '%_by_%'
  AND cl.cl_to NOT LIKE '%_at_%'
GROUP BY cl.cl_to
" > "${OUTDIR}/science_images_used.tsv"
echo "  -> images_used saved to ${OUTDIR}/science_images_used.tsv"

echo ""
echo "============================================"
echo "  Science fetch complete!"
echo "============================================"
echo "TSV files:"
ls -lh "${OUTDIR}"/science_*.tsv 2>/dev/null
echo ""
echo "Next step: python3 ~/process_all.py science"
