#!/usr/bin/env python3
"""
Standalone script to fetch Earth 2025 Germany data from Commons DB.
Run directly on Toolforge shell (NOT via HTTP/uWSGI).

Usage (on Toolforge):
    become wikiloves-data
    cd /data/project/wikiloves-data/www/python/src
    python3 fetch_earth_germany.py

Or with the venv:
    /data/project/wikiloves-data/www/python/venv/bin/python fetch_earth_germany.py
"""

import json
import os
import sys
import time

try:
    import pymysql
except ImportError:
    print("pymysql not found. Use the venv:")
    print("  /data/project/wikiloves-data/www/python/venv/bin/python fetch_earth_germany.py")
    sys.exit(1)


def get_credentials():
    for path in [os.path.expanduser('~/replica.my.cnf'), os.path.expanduser('~/.my.cnf')]:
        if os.path.exists(path):
            creds = {}
            with open(path) as f:
                for line in f:
                    line = line.strip()
                    if '=' in line and not line.startswith('[') and not line.startswith('#'):
                        k, v = line.split('=', 1)
                        creds[k.strip()] = v.strip().strip('"').strip("'")
            return creds
    return {}


def connect(host):
    creds = get_credentials()
    return pymysql.connect(
        host=host,
        port=3306,
        user=creds.get('user', ''),
        password=creds.get('password', ''),
        database='commonswiki_p',
        charset='utf8mb4',
        connect_timeout=60,
        read_timeout=300,
        cursorclass=pymysql.cursors.DictCursor,
    )


CATEGORY = 'Images_from_Wiki_Loves_Earth_2025_in_Germany'

DETAIL_SQL = f"""
SELECT 
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE WHEN il_used.il_to IS NOT NULL THEN i.img_name END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= '20250501000000' AND u.user_registration <= '20250531235959'
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id AND p.page_namespace = 6 AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
LEFT JOIN actor act ON a.actor_id = act.actor_id
LEFT JOIN user u ON act.actor_user = u.user_id
WHERE cl.cl_type = 'file'
  AND cl.cl_to = '{CATEGORY}'
"""

UPLOADERS_SQL = f"""
SELECT 
    a.actor_name AS username,
    COUNT(DISTINCT i.img_name) AS images,
    COUNT(DISTINCT CASE WHEN il_used.il_to IS NOT NULL THEN i.img_name END) AS images_used,
    u.user_registration AS user_registration,
    CASE 
        WHEN u.user_registration >= '20250501000000' AND u.user_registration <= '20250531235959'
        THEN 1 ELSE 0
    END AS is_new_uploader
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id AND p.page_namespace = 6 AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
LEFT JOIN actor act ON a.actor_id = act.actor_id
LEFT JOIN user u ON act.actor_user = u.user_id
WHERE cl.cl_type = 'file'
  AND cl.cl_to = '{CATEGORY}'
GROUP BY a.actor_name, u.user_registration
ORDER BY images DESC
LIMIT 500
"""


def main():
    data_dir = os.path.join(os.environ.get('HOME', '/data/project/wikiloves-data'), 'shared', 'data')
    os.makedirs(data_dir, exist_ok=True)
    os.makedirs(os.path.join(data_dir, 'country_detail'), exist_ok=True)
    os.makedirs(os.path.join(data_dir, 'uploaders'), exist_ok=True)

    host = 'commonswiki.web.db.svc.wikimedia.cloud'
    print(f"Connecting to {host}...")
    conn = connect(host)

    # Detail query
    print("Running detail query...")
    t0 = time.time()
    with conn.cursor() as cur:
        cur.execute(DETAIL_SQL)
        detail_rows = cur.fetchall()
    detail_time = time.time() - t0
    detail = detail_rows[0] if detail_rows else {}
    print(f"  Detail: {detail} ({detail_time:.1f}s)")

    # Uploaders query
    print("Running uploaders query...")
    t1 = time.time()
    with conn.cursor() as cur:
        cur.execute(UPLOADERS_SQL)
        uploader_rows = cur.fetchall()
    uploaders_time = time.time() - t1
    print(f"  Uploaders: {len(uploader_rows)} rows ({uploaders_time:.1f}s)")

    conn.close()

    # Save country detail cache
    detail_data = {
        'campaign': 'Wiki Loves Earth',
        'year': 2025,
        'country': 'Germany',
        'category_name': CATEGORY,
        'total_uploads': int(detail.get('uploads', 0) or 0),
        'total_uploaders': int(detail.get('uploaders', 0) or 0),
        'total_images_used': int(detail.get('images_used', 0) or 0),
        'total_new_uploaders': int(detail.get('new_uploaders', 0) or 0),
        'daily_stats': [],
    }
    detail_path = os.path.join(data_dir, 'country_detail', 'earth_2025_Germany.json')
    with open(detail_path, 'w') as f:
        json.dump(detail_data, f, ensure_ascii=False)
    print(f"  Saved: {detail_path}")

    # Save uploaders cache
    total = sum(int(r.get('images', 0) or 0) for r in uploader_rows)
    uploaders = []
    for r in uploader_rows:
        uploads = int(r.get('images', 0) or 0)
        reg = r.get('user_registration')
        if reg and isinstance(reg, (bytes, bytearray)):
            reg = reg.decode('utf-8', errors='replace')
        uploaders.append({
            'username': (r.get('username') or '').strip(),
            'uploads': uploads,
            'images_used': int(r.get('images_used', 0) or 0),
            'percentage': round(100 * uploads / total, 2) if total else 0,
        })
    uploaders_data = {'uploaders': uploaders, 'total_uploads': total}
    uploaders_path = os.path.join(data_dir, 'uploaders', 'earth_2025_Germany.json')
    with open(uploaders_path, 'w') as f:
        json.dump(uploaders_data, f, ensure_ascii=False)
    print(f"  Saved: {uploaders_path}")

    print(f"\nDone! Total: {detail_time + uploaders_time:.1f}s")
    print(f"  Detail:    {detail_data['total_uploads']} uploads, {detail_data['total_uploaders']} uploaders")
    print(f"  Uploaders: {len(uploaders)} contributors")


if __name__ == '__main__':
    main()
