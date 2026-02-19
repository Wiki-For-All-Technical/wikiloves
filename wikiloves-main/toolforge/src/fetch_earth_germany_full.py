#!/usr/bin/env python3
import pymysql, json, os
from collections import defaultdict

CAT = 'Images_from_Wiki_Loves_Earth_2025_in_Germany'
COMP_START = '20250501000000'
host = 'commonswiki.web.db.svc.wikimedia.cloud'

creds = {}
with open(os.path.expanduser('~/replica.my.cnf')) as f:
    for line in f:
        if '=' in line:
            k, v = line.strip().split('=', 1)
            creds[k.strip()] = v.strip().strip("'")

conn = pymysql.connect(host=host, port=3306, db='commonswiki_p',
    user=creds['user'], password=creds['password'],
    charset='utf8mb4', connect_timeout=120, read_timeout=300)
cur = conn.cursor()

print('Querying images_used...')
cur.execute('''
SELECT COUNT(DISTINCT p.page_title)
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id AND p.page_namespace = 6
JOIN image img ON img.img_name = p.page_title
WHERE cl.cl_to = %s
AND EXISTS (SELECT 1 FROM imagelinks il WHERE il.il_to = p.page_title)
''', (CAT,))
images_used = cur.fetchone()[0]
print(f'  images_used = {images_used}')

print('Querying uploader registrations + upload dates...')
cur.execute('''
SELECT a.actor_name,
       u.user_registration,
       DATE(img.img_timestamp) as upload_date
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id AND p.page_namespace = 6
JOIN image img ON img.img_name = p.page_title
JOIN actor a ON img.img_actor = a.actor_id
LEFT JOIN user u ON a.actor_user = u.user_id
WHERE cl.cl_to = %s
''', (CAT,))
rows = cur.fetchall()
conn.close()
print(f'  Got {len(rows)} rows')

user_reg = {}
daily_data = defaultdict(lambda: {'uploads': 0, 'uploaders': set(), 'new_uploaders': set()})
user_uploads = defaultdict(int)

for actor_name, reg_date, upload_date in rows:
    actor_name = actor_name.decode() if isinstance(actor_name, bytes) else str(actor_name)
    reg_str = reg_date.decode() if isinstance(reg_date, (bytes, bytearray)) else str(reg_date) if reg_date else ''
    date_str = str(upload_date) if upload_date else ''

    if actor_name not in user_reg:
        user_reg[actor_name] = reg_str

    user_uploads[actor_name] += 1

    if date_str:
        daily_data[date_str]['uploads'] += 1
        daily_data[date_str]['uploaders'].add(actor_name)
        clean_reg = reg_str.replace('-', '').replace(' ', '').replace(':', '')
        if clean_reg >= COMP_START:
            daily_data[date_str]['new_uploaders'].add(actor_name)

total_new = sum(1 for r in user_reg.values()
                if r and r.replace('-', '').replace(' ', '').replace(':', '') >= COMP_START)
total_uploaders = len(user_reg)
total_uploads = len(rows)

print(f'  total_uploads={total_uploads}, total_uploaders={total_uploaders}')
print(f'  images_used={images_used}, new_uploaders={total_new}')

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
