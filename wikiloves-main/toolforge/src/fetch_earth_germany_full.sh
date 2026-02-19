#!/bin/bash
set -e

CAT="Images_from_Wiki_Loves_Earth_2025_in_Germany"
HOST="commonswiki.analytics.db.svc.wikimedia.cloud"
DB="commonswiki_p"
MARIA="mariadb --defaults-file=$HOME/replica.my.cnf -h $HOST $DB --batch"

echo "=== Step 1: Querying images_used count ==="
$MARIA -N -e "
SELECT COUNT(DISTINCT p.page_title)
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id AND p.page_namespace = 6
WHERE cl.cl_to = '${CAT}'
AND EXISTS (SELECT 1 FROM imagelinks il WHERE il.il_to = p.page_title);
" > /tmp/earth_images_used.txt
cat /tmp/earth_images_used.txt
echo "Done."

echo "=== Step 2: Querying uploader registrations + upload dates ==="
$MARIA -e "
SELECT a.actor_name, u.user_registration, DATE(img.img_timestamp) as upload_date
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id AND p.page_namespace = 6
JOIN image img ON img.img_name = p.page_title
JOIN actor a ON img.img_actor = a.actor_id
LEFT JOIN user u ON a.actor_user = u.user_id
WHERE cl.cl_to = '${CAT}';
" > /tmp/earth_uploaders_reg.tsv
wc -l /tmp/earth_uploaders_reg.tsv
echo "Done."

echo "=== Step 3: Building JSON cache ==="
/data/project/wikiloves-data/www/python/venv/bin/python -u - <<'PYEOF'
import csv, json, os
from collections import defaultdict

COMP_START = '20250501000000'
CAT = 'Images_from_Wiki_Loves_Earth_2025_in_Germany'

with open('/tmp/earth_images_used.txt') as f:
    images_used = int(f.read().strip())
print(f'  images_used = {images_used}')

with open('/tmp/earth_uploaders_reg.tsv') as f:
    reader = csv.DictReader(f, delimiter='\t')
    rows = list(reader)
print(f'  Got {len(rows)} rows')

user_reg = {}
user_uploads = defaultdict(int)
daily_data = defaultdict(lambda: {'uploads': 0, 'uploaders': set(), 'new_uploaders': set()})

for r in rows:
    name = r['actor_name']
    reg = r.get('user_registration', '') or ''
    date = r.get('upload_date', '') or ''

    if name not in user_reg:
        user_reg[name] = reg
    user_uploads[name] += 1

    if date:
        daily_data[date]['uploads'] += 1
        daily_data[date]['uploaders'].add(name)
        clean_reg = reg.replace('-', '').replace(' ', '').replace(':', '')
        if clean_reg >= COMP_START:
            daily_data[date]['new_uploaders'].add(name)

total_uploads = len(rows)
total_uploaders = len(user_reg)
total_new = sum(1 for r in user_reg.values()
                if r and r.replace('-', '').replace(' ', '').replace(':', '') >= COMP_START)

daily_stats = []
for date in sorted(daily_data.keys()):
    d = daily_data[date]
    nu = len(d['new_uploaders'])
    upl = len(d['uploaders'])
    pct = round(100 * nu / upl, 0) if upl else 0
    daily_stats.append({
        'date': date,
        'uploads': d['uploads'],
        'uploaders': upl,
        'new_uploaders': nu,
        'new_uploaders_pct': f'{pct:.0f}%'
    })

uploaders = sorted(
    [{'username': u, 'uploads': c, 'percentage': round(100 * c / total_uploads, 2)}
     for u, c in user_uploads.items()],
    key=lambda x: x['uploads'], reverse=True
)

data_dir = os.path.expanduser('~/shared/data')
os.makedirs(f'{data_dir}/country_detail', exist_ok=True)
os.makedirs(f'{data_dir}/uploaders', exist_ok=True)

detail = {
    'campaign': 'Wiki Loves Earth',
    'year': 2025,
    'country': 'Germany',
    'category_name': CAT,
    'total_uploads': total_uploads,
    'total_uploaders': total_uploaders,
    'total_images_used': images_used,
    'total_new_uploaders': total_new,
    'daily_stats': daily_stats
}

with open(f'{data_dir}/country_detail/earth_2025_Germany.json', 'w') as out:
    json.dump(detail, out, ensure_ascii=False)
print(f'Saved country_detail/earth_2025_Germany.json')

with open(f'{data_dir}/uploaders/earth_2025_Germany.json', 'w') as out:
    json.dump({'uploaders': uploaders, 'total_uploads': total_uploads}, out, ensure_ascii=False)
print(f'Saved uploaders/earth_2025_Germany.json')

print(f'\nDone!')
print(f'  Total Images: {total_uploads}')
print(f'  Total Uploaders: {total_uploaders}')
print(f'  Images Used: {images_used}')
print(f'  New Uploaders: {total_new} ({round(100*total_new/total_uploaders) if total_uploaders else 0}%)')
print(f'  Days with uploads: {len(daily_stats)}')
PYEOF
