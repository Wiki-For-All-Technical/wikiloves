#!/usr/bin/env python3
"""
Pre-build uploaders and country-detail caches for all campaign/year/country in processed data.
Run on Toolforge (e.g. daily after daily_refresh) so the frontend gets data immediately
when clicking a country (e.g. earth/2025/Germany): both country stats and contributors
are served from cache, no DB wait.
"""

import sys
import json
import re
from pathlib import Path

# Add src directory to path
sys.path.insert(0, str(Path(__file__).parent))

from config import Config
from queries import get_query_manager
from logger import get_logger
from errors import CampaignNotFoundError


def safe_cache_key(campaign_slug: str, year: int, country: str) -> str:
    """Same key logic as routes.get_country_uploaders."""
    return re.sub(r'[^\w\-]', '_', f"{campaign_slug}_{year}_{country}")[:120]


def build_one_uploaders_cache(
    campaign_slug: str,
    year: int,
    country: str,
    cache_dir: Path,
    query_manager,
    logger,
    use_analytics: bool = True,
) -> bool:
    """Build and write uploaders JSON for one (campaign, year, country). Returns True on success."""
    safe_key = safe_cache_key(campaign_slug, year, country)
    cache_file = cache_dir / f"{safe_key}.json"
    try:
        raw_data = query_manager.execute_uploader_query(
            campaign_slug, year=year, country=country, use_analytics=use_analytics
        )
        total = sum(int(r.get('images', 0) or 0) for r in raw_data)
        result = []
        for r in raw_data:
            uploads = int(r.get('images', 0) or 0)
            result.append({
                'username': (r.get('username') or '').strip(),
                'uploads': uploads,
                'images_used': int(r.get('images_used', 0) or 0),
                'percentage': round(100 * uploads / total, 2) if total else 0,
            })
        data = {'uploaders': result, 'total_uploads': total}
        cache_dir.mkdir(parents=True, exist_ok=True)
        with open(cache_file, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False)
        logger.info(f'Prebuilt uploaders: {safe_key} ({len(result)} uploaders)')
        return True
    except Exception as e:
        logger.warning(f'Prebuild failed {safe_key}: {e}')
        return False


def build_one_country_detail_cache(
    campaign_slug: str,
    year: int,
    country: str,
    cache_dir: Path,
    query_manager,
    logger,
    use_analytics: bool = True,
) -> bool:
    """Build and write country detail JSON for one (campaign, year, country). Returns True on success."""
    safe_key = safe_cache_key(campaign_slug, year, country)
    cache_file = cache_dir / f"{safe_key}.json"
    try:
        raw_data = query_manager.execute_campaign_query(
            campaign_slug, year=year, country=country, use_analytics=use_analytics
        )
        if not raw_data:
            return False
        uploads = sum(int(r.get('uploads', 0) or 0) for r in raw_data)
        uploaders = max(int(r.get('uploaders', 0) or 0) for r in raw_data)
        images_used = sum(int(r.get('images_used', 0) or 0) for r in raw_data)
        new_uploaders = max(int(r.get('new_uploaders', 0) or 0) for r in raw_data)
        first = raw_data[0]
        campaign_name = (first.get('campaign_name') or campaign_slug).replace('_', ' ')
        country_display = (first.get('country') or country).strip()
        category_name = f"Images_from_{first.get('campaign_name', campaign_slug).replace(' ', '_')}_{year}_in_{country_display.replace(' ', '_')}"
        data = {
            'campaign': campaign_name,
            'year': year,
            'country': country_display,
            'category_name': category_name,
            'total_uploads': uploads,
            'total_uploaders': uploaders,
            'total_images_used': images_used,
            'total_new_uploaders': new_uploaders,
            'daily_stats': [],
        }
        cache_dir.mkdir(parents=True, exist_ok=True)
        with open(cache_file, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False)
        logger.info(f'Prebuilt country detail: {safe_key}')
        return True
    except CampaignNotFoundError:
        return False
    except Exception as e:
        logger.warning(f'Prebuild country detail failed {safe_key}: {e}')
        return False


def get_tasks_from_processed_data(data_dir: Path, recent_years_only: int = 3) -> list:
    """
    Collect (campaign_slug, year, country) from all *_processed.json.
    If recent_years_only > 0, only include that many most recent years per campaign.
    """
    import time
    current_year = int(time.strftime('%Y', time.gmtime()))
    tasks = []
    for path in sorted(data_dir.glob('*_processed.json')):
        slug = path.stem.replace('_processed', '')
        if slug == 'all':
            continue
        try:
            with open(path, 'r', encoding='utf-8') as f:
                data = json.load(f)
        except (json.JSONDecodeError, OSError):
            continue
        years_list = data.get('years') or []
        if recent_years_only > 0:
            years_list = [y for y in years_list if (current_year - int(y.get('year', 0))) < recent_years_only]
        for y in years_list:
            year = int(y.get('year', 0))
            if not year:
                continue
            country_stats = y.get('country_stats') or y.get('country_rows') or []
            for c in country_stats:
                country = (c.get('name') or c.get('country') or '').strip()
                if country:
                    tasks.append((slug, year, country))
    return tasks


def main():
    logger = get_logger('prebuild_uploaders')
    cfg = Config()
    data_dir = cfg.DATA_DIR
    uploaders_dir = cfg.UPLOADERS_CACHE_DIR
    country_detail_dir = cfg.COUNTRY_DETAIL_CACHE_DIR

    RECENT_YEARS = 3
    tasks = get_tasks_from_processed_data(data_dir, recent_years_only=RECENT_YEARS)
    if not tasks:
        logger.warning('No (campaign, year, country) tasks from processed data')
        return 0

    logger.info(f'Prebuilding uploaders + country detail for {len(tasks)} tasks (recent {RECENT_YEARS} years)')
    query_manager = get_query_manager()
    ok_uploaders = 0
    ok_detail = 0
    fail = 0
    for campaign_slug, year, country in tasks:
        if build_one_country_detail_cache(
            campaign_slug, year, country, country_detail_dir, query_manager, logger
        ):
            ok_detail += 1
        if build_one_uploaders_cache(
            campaign_slug, year, country, uploaders_dir, query_manager, logger
        ):
            ok_uploaders += 1
        else:
            fail += 1

    logger.info(f'Prebuild done: country_detail {ok_detail} ok, uploaders {ok_uploaders} ok, {fail} uploaders failed')
    return 0 if fail == 0 else 1


if __name__ == '__main__':
    sys.exit(main())
