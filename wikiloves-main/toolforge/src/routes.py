"""
API routes for Toolforge data fetcher.
Provides endpoints for manual triggers and status monitoring.
"""

import time
import sys
import json
from pathlib import Path
from flask import Blueprint, jsonify, request
from typing import Dict, Any, Optional
import threading

from queries import get_query_manager
from processor import get_processor
from database import get_db
from logger import get_logger, log_processing_start, log_processing_complete, log_query_execution
from errors import CampaignNotFoundError, DatabaseError, ProcessingError, QueryTimeoutError
from config import Config

try:
    import campaigns_metadata
    _BATCH_CAMPAIGNS = list(campaigns_metadata.ALL_CAMPAIGNS.keys())
except ImportError:
    _BATCH_CAMPAIGNS = ['earth', 'monuments', 'science', 'folklore', 'africa', 'food', 'public_art']

# Global processing status
_processing_status: Dict[str, Any] = {
    'is_processing': False,
    'current_task': None,
    'start_time': None,
    'last_update': None,
    'error': None
}

# Lock for thread-safe status updates
_status_lock = threading.Lock()

# Uploaders cache: keys currently being built in background (so we don't block the request)
_uploaders_building = set()
_uploaders_building_lock = threading.Lock()


def register_routes(app):
    """Register all routes with Flask app."""
    api = Blueprint('api', __name__, url_prefix='/api')
    
    @api.route('/health', methods=['GET'])
    def health():
        """Health check endpoint."""
        import os
        db = get_db()
        db_healthy, db_error = db.test_connection(use_analytics=False)
        
        # Check if credential files exist
        my_cnf_path = os.path.expanduser('~/.my.cnf')
        replica_cnf_path = os.path.expanduser('~/replica.my.cnf')
        my_cnf_exists = os.path.exists(my_cnf_path)
        replica_cnf_exists = os.path.exists(replica_cnf_path)
        
        response = {
            'status': 'ok',
            'database': 'connected' if db_healthy else 'disconnected',
            'timestamp': time.time(),
            'database_config': {
                'my_cnf_exists': my_cnf_exists,
                'my_cnf_path': my_cnf_path,
                'replica_cnf_exists': replica_cnf_exists,
                'replica_cnf_path': replica_cnf_path,
                'host': db.config.DB_WEB_HOST if not db_healthy else None,
                'database': db.config.DB_NAME if not db_healthy else None
            }
        }
        
        if db_error:
            response['database_error'] = db_error
        
        return jsonify(response)
    
    @api.route('/status', methods=['GET'])
    def status():
        """Get current processing status."""
        with _status_lock:
            status_copy = _processing_status.copy()
        
        return jsonify(status_copy)
    
    @api.route('/test/earth-2025-germany', methods=['GET'])
    def test_earth_2025_germany():
        """
        Test endpoint: run exact Earth 2025 Germany queries on Toolforge.
        Returns country detail + uploaders. Uses web replica (fast).
        """
        logger = get_logger()
        db = get_db()
        category = 'Images_from_Wiki_Loves_Earth_2025_in_Germany'
        
        detail_query = f"""
SELECT 
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    COUNT(DISTINCT CASE WHEN il_used.il_to IS NOT NULL THEN i.img_name END) AS images_used,
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= '20250501000000' AND u.user_registration <= '20250531235959'
        THEN a.actor_name
    END) AS new_uploaders
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
LEFT JOIN actor act ON a.actor_id = act.actor_id
LEFT JOIN user u ON act.actor_user = u.user_id
WHERE cl.cl_type = 'file'
  AND cl.cl_to = '{category}'
"""
        uploaders_query = f"""
SELECT 
    a.actor_name AS username,
    COUNT(DISTINCT i.img_name) AS images,
    COUNT(DISTINCT CASE WHEN il_used.il_to IS NOT NULL THEN i.img_name END) AS images_used,
    u.user_registration AS user_registration,
    CASE 
        WHEN u.user_registration >= '20250501000000' AND u.user_registration <= '20250531235959'
        THEN 1
        ELSE 0
    END AS is_new_uploader
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN imagelinks il_used ON il_used.il_to = p.page_id
LEFT JOIN actor act ON a.actor_id = act.actor_id
LEFT JOIN user u ON act.actor_user = u.user_id
WHERE cl.cl_type = 'file'
  AND cl.cl_to = '{category}'
GROUP BY a.actor_name, u.user_registration
ORDER BY images DESC
LIMIT 500
"""
        try:
            start = time.time()
            detail_rows = db.execute_query(detail_query, use_analytics=False)
            detail_time = time.time() - start
            uploaders_rows = db.execute_query(uploaders_query, use_analytics=False)
            uploaders_time = time.time() - start - detail_time
            total_time = time.time() - start
            
            detail = detail_rows[0] if detail_rows else {}
            total_uploads = sum(int(r.get('images', 0) or 0) for r in uploaders_rows)
            uploaders = []
            for r in uploaders_rows:
                uploads = int(r.get('images', 0) or 0)
                uploaders.append({
                    'username': (r.get('username') or '').strip(),
                    'uploads': uploads,
                    'images_used': int(r.get('images_used', 0) or 0),
                    'percentage': round(100 * uploads / total_uploads, 2) if total_uploads else 0,
                })
            
            return jsonify({
                'campaign': 'earth',
                'year': 2025,
                'country': 'Germany',
                'category': category,
                'detail': {
                    'uploads': int(detail.get('uploads', 0) or 0),
                    'uploaders': int(detail.get('uploaders', 0) or 0),
                    'images_used': int(detail.get('images_used', 0) or 0),
                    'new_uploaders': int(detail.get('new_uploaders', 0) or 0),
                },
                'uploaders': uploaders,
                'total_uploads': total_uploads,
                'timing': {
                    'detail_query_sec': round(detail_time, 2),
                    'uploaders_query_sec': round(uploaders_time, 2),
                    'total_sec': round(total_time, 2),
                },
            })
        except Exception as e:
            logger.error(f'Earth 2025 Germany test failed: {e}', exc_info=True)
            return jsonify({'error': str(e), 'message': 'Query failed'}), 500

    _prebuild_state = {'running': False}
    _prebuild_lock = threading.Lock()

    @api.route('/prebuild/status', methods=['GET'])
    def prebuild_status():
        """Check if prebuild is currently running."""
        with _prebuild_lock:
            running = _prebuild_state['running']
        return jsonify({'running': running, 'status': 'running' if running else 'idle'})

    @api.route('/prebuild', methods=['POST'])
    def trigger_prebuild():
        """
        Run prebuild (country detail + uploaders cache) in background.
        Uses the web app's Python env (has pymysql etc). Returns immediately.
        """
        try:
            with _prebuild_lock:
                if _prebuild_state['running']:
                    return jsonify({
                        'message': 'Prebuild already running',
                        'status': 'running'
                    }), 409
                _prebuild_state['running'] = True

            def run_prebuild():
                try:
                    from prebuild_uploaders_cache import main as prebuild_main
                    prebuild_main()
                except Exception as e:
                    logger = get_logger()
                    logger.error(f'Prebuild failed: {e}', exc_info=True)
                finally:
                    with _prebuild_lock:
                        _prebuild_state['running'] = False

            t = threading.Thread(target=run_prebuild, daemon=True)
            t.start()
            return jsonify({
                'message': 'Prebuild started in background. Country detail and uploaders caches will be filled.',
                'status': 'started'
            }), 202
        except Exception as e:
            with _prebuild_lock:
                _prebuild_state['running'] = False
            logger = get_logger()
            logger.error(f'Prebuild trigger failed: {e}', exc_info=True)
            return jsonify({'error': str(e), 'message': 'Failed to start prebuild'}), 500
    
    @api.route('/campaigns', methods=['GET'])
    def campaigns():
        """List all available campaigns."""
        try:
            # Define the 7 campaigns to show
            ALLOWED_CAMPAIGN_SLUGS = [
                'science',      # Wiki Science Competition
                'folklore',     # Wiki Loves Folklore
                'africa',       # Wiki Loves Africa
                'food',         # Wiki Loves Food
                'public_art',   # Wiki Loves Public Art
                'earth',        # Wiki Loves Earth
                'monuments'     # Wiki Loves Monuments
            ]
            
            # Try importing from src/ directory first (Toolforge deployment)
            try:
                import campaigns_metadata
                ALL_CAMPAIGNS = campaigns_metadata.ALL_CAMPAIGNS
            except ImportError:
                # Fallback: try importing from backend/data/ (local development)
                sys.path.insert(0, str(Config().BASE_DIR.parent / 'backend'))
                from data.campaigns_metadata import ALL_CAMPAIGNS
            
            campaigns_list = []
            for key, campaign in ALL_CAMPAIGNS.items():
                # Only include campaigns in the allowed list
                if key in ALLOWED_CAMPAIGN_SLUGS:
                    campaigns_list.append({
                        'slug': campaign.get('slug'),
                        'name': campaign.get('name'),
                        'path_segment': campaign.get('path_segment'),
                        'category': campaign.get('category')
                    })
            
            return jsonify({
                'campaigns': campaigns_list,
                'total': len(campaigns_list)
            })
        except Exception as e:
            return jsonify({'error': str(e)}), 500
    
    def _load_processed_data(campaign_slug: str) -> Optional[Dict[str, Any]]:
        """Load processed JSON for a campaign from DATA_DIR. Returns None if not found."""
        data_dir = Config().DATA_DIR
        path = data_dir / f'{campaign_slug}_processed.json'
        if not path.exists():
            return None
        try:
            with open(path, 'r', encoding='utf-8') as f:
                return json.load(f)
        except (json.JSONDecodeError, OSError):
            return None
    
    @api.route('/data', methods=['GET'])
    def list_data():
        """List campaigns that have processed statistics data available."""
        data_dir = Config().DATA_DIR
        if not data_dir.exists():
            return jsonify({'campaigns': [], 'total': 0})
        campaigns = []
        for path in sorted(data_dir.glob('*_processed.json')):
            slug = path.stem.replace('_processed', '')
            if slug == 'all':
                continue
            campaigns.append({'slug': slug})
        return jsonify({'campaigns': campaigns, 'total': len(campaigns)})

    # More specific route first: /uploaders must be before /<path:country> so it isn't captured as country
    @api.route('/data/<campaign_slug>/<int:year>/<path:country>/uploaders', methods=['GET'])
    def get_country_uploaders(campaign_slug: str, year: int, country: str):
        """
        Get per-user (uploader) statistics for a country. Serves from cache when available.
        On cache miss: return immediately with empty list and building=True; build cache in background.
        """
        import urllib.parse
        import re
        logger = get_logger()
        country_decoded = urllib.parse.unquote(country).strip()
        if not country_decoded:
            return jsonify({'error': 'Invalid country', 'message': 'Country parameter is empty'}), 400

        cfg = Config()
        cache_dir = cfg.UPLOADERS_CACHE_DIR
        cache_dir.mkdir(parents=True, exist_ok=True)
        safe_key = re.sub(r'[^\w\-]', '_', f"{campaign_slug}_{year}_{country_decoded}")[:120]
        cache_file = cache_dir / f"{safe_key}.json"
        now = time.time()
        if cache_file.exists() and (now - cache_file.stat().st_mtime) < cfg.UPLOADERS_CACHE_TTL_SEC:
            try:
                with open(cache_file, 'r', encoding='utf-8') as f:
                    data = json.load(f)
                return jsonify(data)
            except (json.JSONDecodeError, OSError):
                pass

        def build_cache():
            with _uploaders_building_lock:
                _uploaders_building.add(safe_key)
            try:
                query_manager = get_query_manager()
                raw_data = query_manager.execute_uploader_quarry_style(
                    campaign_slug, year=year, country=country_decoded, use_analytics=False
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
                with open(cache_file, 'w', encoding='utf-8') as f:
                    json.dump(data, f, ensure_ascii=False)
                logger.info(f'Uploaders cache written: {safe_key}')
            except Exception as e:
                logger.error(f'Background uploaders cache build failed {safe_key}: {e}', exc_info=True)
            finally:
                with _uploaders_building_lock:
                    _uploaders_building.discard(safe_key)

        with _uploaders_building_lock:
            already_building = safe_key in _uploaders_building
            if not already_building:
                t = threading.Thread(target=build_cache, daemon=True)
                t.start()

        return jsonify({
            'uploaders': [],
            'total_uploads': 0,
            'building': True,
            'message': 'Contributors data is being prepared. Please retry in 1–2 minutes.',
        })

    @api.route('/data/<campaign_slug>/<int:year>/<path:country>', methods=['GET'])
    def get_country_detail(campaign_slug: str, year: int, country: str):
        """
        Get statistics for a single country in a campaign year.
        Serves from cache when available; otherwise runs query and caches result for instant future loads.
        """
        import urllib.parse
        import re
        logger = get_logger()
        country_decoded = urllib.parse.unquote(country).strip()
        if not country_decoded:
            return jsonify({'error': 'Invalid country', 'message': 'Country parameter is empty'}), 400
        cfg = Config()
        cache_dir = cfg.COUNTRY_DETAIL_CACHE_DIR
        cache_dir.mkdir(parents=True, exist_ok=True)
        safe_key = re.sub(r'[^\w\-]', '_', f"{campaign_slug}_{year}_{country_decoded}")[:120]
        cache_file = cache_dir / f"{safe_key}.json"
        now = time.time()
        if cache_file.exists() and (now - cache_file.stat().st_mtime) < cfg.COUNTRY_DETAIL_CACHE_TTL_SEC:
            try:
                with open(cache_file, 'r', encoding='utf-8') as f:
                    data = json.load(f)
                return jsonify(data)
            except (json.JSONDecodeError, OSError):
                pass
        try:
            query_manager = get_query_manager()
            raw_data = query_manager.execute_campaign_query(
                campaign_slug,
                year=year,
                country=country_decoded,
                use_analytics=True
            )
            if not raw_data:
                return jsonify({
                    'error': 'Not found',
                    'message': f'No data for campaign "{campaign_slug}" year {year} country "{country_decoded}"'
                }), 404
            uploads = sum(int(r.get('uploads', 0) or 0) for r in raw_data)
            uploaders = max(int(r.get('uploaders', 0) or 0) for r in raw_data)
            images_used = sum(int(r.get('images_used', 0) or 0) for r in raw_data)
            new_uploaders = max(int(r.get('new_uploaders', 0) or 0) for r in raw_data)
            first = raw_data[0]
            campaign_name = (first.get('campaign_name') or campaign_slug).replace('_', ' ')
            country_display = (first.get('country') or country_decoded).strip()
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
            try:
                with open(cache_file, 'w', encoding='utf-8') as f:
                    json.dump(data, f, ensure_ascii=False)
                logger.info(f'Country detail cache written: {safe_key}')
            except OSError:
                pass
            return jsonify(data)
        except CampaignNotFoundError as e:
            return jsonify({'error': 'Campaign not found', 'message': str(e)}), 404
        except QueryTimeoutError as e:
            logger.error(f'Query timeout for country detail: {e}')
            return jsonify({'error': 'Query timeout', 'message': str(e)}), 503
        except DatabaseError as e:
            logger.error(f'Database error for country detail: {e}', exc_info=True)
            return jsonify({'error': 'Database error', 'message': str(e)}), 500
        except Exception as e:
            logger.error(f'Error loading country detail: {e}', exc_info=True)
            return jsonify({'error': 'Server error', 'message': str(e)}), 500

    @api.route('/data/<campaign_slug>', methods=['GET'])
    def get_campaign_data(campaign_slug: str):
        """
        Get full statistics for a campaign: year list, countries participated,
        uploads, images used in wikis, uploaders, uploaders registered after start.
        Data is returned per year with country-level breakdown.
        """
        data = _load_processed_data(campaign_slug)
        if not data:
            return jsonify({
                'error': 'Data not found',
                'message': f'No processed data for campaign "{campaign_slug}". '
                           'Trigger a fetch first: POST /api/fetch/all or POST /api/fetch/<campaign_slug>'
            }), 404
        return jsonify(data)
    
    @api.route('/data/<campaign_slug>/summary', methods=['GET'])
    def get_campaign_summary(campaign_slug: str):
        """
        Get a compact summary: one row per year with totals only (no country breakdown).
        Fields: year, countries (count), uploads, images_used, images_used_pct,
        uploaders, new_uploaders, new_uploaders_pct.
        """
        data = _load_processed_data(campaign_slug)
        if not data:
            return jsonify({
                'error': 'Data not found',
                'message': f'No processed data for campaign "{campaign_slug}". Trigger a fetch first.'
            }), 404
        years = data.get('years', [])
        summary = []
        for y in years:
            summary.append({
                'year': y['year'],
                'countries': y.get('countries', 0),
                'uploads': y.get('uploads', 0),
                'images_used': y.get('images_used', 0),
                'images_used_pct': y.get('images_used_pct', 0),
                'uploaders': y.get('uploaders', 0),
                'new_uploaders': y.get('new_uploaders', 0),
                'new_uploaders_pct': y.get('new_uploaders_pct', 0),
            })
        return jsonify({
            'campaign': data.get('campaign'),
            'campaign_name': data.get('campaign_name'),
            'years': summary
        })
    
    @api.route('/fetch/all', methods=['POST'])
    def fetch_all():
        """Trigger full data refresh for all campaigns."""
        logger = get_logger()
        
        with _status_lock:
            if _processing_status['is_processing']:
                return jsonify({
                    'error': 'Processing already in progress',
                    'current_task': _processing_status['current_task']
                }), 409
            
            _processing_status.update({
                'is_processing': True,
                'current_task': 'fetch_all',
                'start_time': time.time(),
                'last_update': time.time(),
                'error': None
            })
        
        def process_all():
            try:
                logger.info('Starting full data refresh')
                query_manager = get_query_manager()
                processor = get_processor()
                
                # Execute unified query
                start_time = time.time()
                raw_data = query_manager.execute_unified_query(use_analytics=True)
                query_duration = time.time() - start_time
                
                log_query_execution(
                    logger,
                    'unified_all_campaigns',
                    query_duration,
                    rows_returned=len(raw_data)
                )
                
                # Process data
                processed_data = processor.process_campaign_data(raw_data)
                
                # Validate
                for campaign_slug, campaign_data in processed_data.items():
                    errors = processor.validate_data(campaign_data)
                    if errors:
                        logger.warning(
                            f'Validation errors for {campaign_slug}',
                            extra={'errors': errors}
                        )
                
                # Save processed data
                for campaign_slug, campaign_data in processed_data.items():
                    output_path = Config().DATA_DIR / f'{campaign_slug}_processed.json'
                    processor.save_processed_data(campaign_data, str(output_path))
                
                duration = time.time() - start_time
                log_processing_complete(
                    logger,
                    records_processed=len(raw_data),
                    duration_seconds=duration
                )
                
                with _status_lock:
                    _processing_status.update({
                        'is_processing': False,
                        'current_task': None,
                        'last_update': time.time(),
                        'error': None
                    })
                
            except Exception as e:
                logger.error(f'Error in full refresh: {str(e)}', exc_info=True)
                with _status_lock:
                    _processing_status.update({
                        'is_processing': False,
                        'current_task': None,
                        'error': str(e)
                    })
        
        # Start processing in background thread
        thread = threading.Thread(target=process_all, daemon=True)
        thread.start()
        
        return jsonify({
            'message': 'Full data refresh started',
            'status': 'processing'
        }), 202
    
    @api.route('/fetch/batch', methods=['POST'])
    def fetch_batch():
        """
        Fetch campaigns one-by-one to avoid unified query timeout.
        Each campaign uses a smaller query that typically completes before timeout.
        Body (optional): {"campaigns": ["earth", "monuments", ...]}
        If omitted, fetches all campaigns from metadata.
        """
        logger = get_logger()
        
        with _status_lock:
            if _processing_status['is_processing']:
                return jsonify({
                    'error': 'Processing already in progress',
                    'current_task': _processing_status['current_task']
                }), 409
            
            campaigns = _BATCH_CAMPAIGNS
            try:
                data = request.get_json(silent=True) or {}
                if data.get('campaigns'):
                    campaigns = data['campaigns']
            except Exception:
                pass
            
            _processing_status.update({
                'is_processing': True,
                'current_task': f'fetch_batch({len(campaigns)} campaigns)',
                'start_time': time.time(),
                'last_update': time.time(),
                'error': None
            })
        
        def process_batch():
            query_manager = get_query_manager()
            processor = get_processor()
            completed = []
            failed = []
            for i, campaign_slug in enumerate(campaigns):
                try:
                    with _status_lock:
                        _processing_status['current_task'] = f'fetch_batch: {campaign_slug} ({i+1}/{len(campaigns)})'
                        _processing_status['last_update'] = time.time()
                    
                    logger.info(f'Batch fetch: {campaign_slug} ({i+1}/{len(campaigns)}) Quarry-style')
                    start_time = time.time()
                    raw_data = query_manager.execute_campaign_quarry_style(
                        campaign_slug,
                        use_analytics=True
                    )
                    query_duration = time.time() - start_time
                    
                    log_query_execution(
                        logger,
                        'campaign_query',
                        query_duration,
                        rows_returned=len(raw_data),
                        campaign_slug=campaign_slug
                    )
                    
                    processed_data = processor.process_campaign_data(
                        raw_data,
                        campaign_slug=campaign_slug
                    )
                    errors = processor.validate_data(processed_data)
                    if errors:
                        logger.warning(f'Validation errors for {campaign_slug}', extra={'errors': errors})
                    
                    output_path = Config().DATA_DIR / f'{campaign_slug}_processed.json'
                    processor.save_processed_data(processed_data, str(output_path))
                    completed.append(campaign_slug)
                    log_processing_complete(
                        logger,
                        campaign_slug=campaign_slug,
                        records_processed=len(raw_data),
                        duration_seconds=time.time() - start_time
                    )
                except CampaignNotFoundError as e:
                    logger.error(f'Campaign not found: {campaign_slug}')
                    failed.append(campaign_slug)
                except Exception as e:
                    logger.error(f'Error fetching campaign {campaign_slug}: {str(e)}', exc_info=True)
                    failed.append(campaign_slug)
            
            with _status_lock:
                _processing_status.update({
                    'is_processing': False,
                    'current_task': None,
                    'last_update': time.time(),
                    'error': None if not failed else f'Failed: {", ".join(failed)}'
                })
            logger.info(f'Batch fetch done: {len(completed)} ok, {len(failed)} failed', extra={
                'completed': completed,
                'failed': failed
            })
        
        thread = threading.Thread(target=process_batch, daemon=True)
        thread.start()
        
        return jsonify({
            'message': f'Batch fetch started for {len(campaigns)} campaigns',
            'campaigns': campaigns,
            'status': 'processing'
        }), 202
    
    @api.route('/fetch/<campaign_slug>', methods=['POST'])
    def fetch_campaign(campaign_slug: str):
        """Fetch data for a specific campaign."""
        logger = get_logger()
        
        with _status_lock:
            if _processing_status['is_processing']:
                return jsonify({
                    'error': 'Processing already in progress',
                    'current_task': _processing_status['current_task']
                }), 409
            
            _processing_status.update({
                'is_processing': True,
                'current_task': f'fetch_{campaign_slug}',
                'start_time': time.time(),
                'last_update': time.time(),
                'error': None
            })
        
        def process_campaign():
            try:
                logger.info(f'Starting data fetch for campaign: {campaign_slug} (Quarry-style)')
                query_manager = get_query_manager()
                processor = get_processor()
                
                # Quarry-style: per-category exact-match queries (fast ~14 sec each)
                start_time = time.time()
                raw_data = query_manager.execute_campaign_quarry_style(
                    campaign_slug,
                    use_analytics=True
                )
                query_duration = time.time() - start_time
                
                log_query_execution(
                    logger,
                    'campaign_query',
                    query_duration,
                    rows_returned=len(raw_data),
                    campaign_slug=campaign_slug
                )
                
                # Process data
                processed_data = processor.process_campaign_data(
                    raw_data,
                    campaign_slug=campaign_slug
                )
                
                # Validate
                errors = processor.validate_data(processed_data)
                if errors:
                    logger.warning(
                        f'Validation errors for {campaign_slug}',
                        extra={'errors': errors}
                    )
                
                # Save processed data
                output_path = Config().DATA_DIR / f'{campaign_slug}_processed.json'
                processor.save_processed_data(processed_data, str(output_path))
                
                duration = time.time() - start_time
                log_processing_complete(
                    logger,
                    campaign_slug=campaign_slug,
                    records_processed=len(raw_data),
                    duration_seconds=duration
                )
                
                with _status_lock:
                    _processing_status.update({
                        'is_processing': False,
                        'current_task': None,
                        'last_update': time.time(),
                        'error': None
                    })
                
            except CampaignNotFoundError as e:
                logger.error(f'Campaign not found: {campaign_slug}')
                with _status_lock:
                    _processing_status.update({
                        'is_processing': False,
                        'current_task': None,
                        'error': str(e)
                    })
            except Exception as e:
                logger.error(f'Error fetching campaign {campaign_slug}: {str(e)}', exc_info=True)
                with _status_lock:
                    _processing_status.update({
                        'is_processing': False,
                        'current_task': None,
                        'error': str(e)
                    })
        
        # Start processing in background thread
        thread = threading.Thread(target=process_campaign, daemon=True)
        thread.start()
        
        return jsonify({
            'message': f'Data fetch started for campaign: {campaign_slug}',
            'status': 'processing'
        }), 202
    
    @api.route('/fetch/<campaign_slug>/<int:year>', methods=['POST'])
    def fetch_campaign_year(campaign_slug: str, year: int):
        """Fetch data for a specific campaign and year."""
        logger = get_logger()
        
        with _status_lock:
            if _processing_status['is_processing']:
                return jsonify({
                    'error': 'Processing already in progress',
                    'current_task': _processing_status['current_task']
                }), 409
            
            _processing_status.update({
                'is_processing': True,
                'current_task': f'fetch_{campaign_slug}_{year}',
                'start_time': time.time(),
                'last_update': time.time(),
                'error': None
            })
        
        def process_campaign_year():
            try:
                logger.info(f'Starting data fetch for {campaign_slug} {year}')
                query_manager = get_query_manager()
                processor = get_processor()
                
                # Execute campaign query for specific year
                start_time = time.time()
                raw_data = query_manager.execute_campaign_query(
                    campaign_slug,
                    year=year,
                    use_analytics=True
                )
                query_duration = time.time() - start_time
                
                log_query_execution(
                    logger,
                    'campaign_year_query',
                    query_duration,
                    rows_returned=len(raw_data),
                    campaign_slug=campaign_slug
                )
                
                # Process data
                processed_data = processor.process_campaign_data(
                    raw_data,
                    campaign_slug=campaign_slug
                )
                
                # Validate
                errors = processor.validate_data(processed_data)
                if errors:
                    logger.warning(
                        f'Validation errors for {campaign_slug} {year}',
                        extra={'errors': errors}
                    )
                
                # Save processed data
                output_path = Config().DATA_DIR / f'{campaign_slug}_{year}_processed.json'
                processor.save_processed_data(processed_data, str(output_path))
                
                duration = time.time() - start_time
                log_processing_complete(
                    logger,
                    campaign_slug=campaign_slug,
                    year=year,
                    records_processed=len(raw_data),
                    duration_seconds=duration
                )
                
                with _status_lock:
                    _processing_status.update({
                        'is_processing': False,
                        'current_task': None,
                        'last_update': time.time(),
                        'error': None
                    })
                
            except Exception as e:
                logger.error(f'Error fetching {campaign_slug} {year}: {str(e)}', exc_info=True)
                with _status_lock:
                    _processing_status.update({
                        'is_processing': False,
                        'current_task': None,
                        'error': str(e)
                    })
        
        # Start processing in background thread
        thread = threading.Thread(target=process_campaign_year, daemon=True)
        thread.start()
        
        return jsonify({
            'message': f'Data fetch started for {campaign_slug} {year}',
            'status': 'processing'
        }), 202
    
    @api.route('/logs', methods=['GET'])
    def logs():
        """Get recent processing logs."""
        try:
            log_file = Config().LOGS_DIR / 'wikiloves_data_fetcher.log'
            if not log_file.exists():
                return jsonify({'logs': [], 'message': 'No logs found'})
            
            # Read last N lines (simple implementation)
            lines = []
            with open(log_file, 'r', encoding='utf-8') as f:
                lines = f.readlines()
            
            # Return last 100 lines
            recent_lines = lines[-100:] if len(lines) > 100 else lines
            
            return jsonify({
                'logs': [line.strip() for line in recent_lines],
                'total_lines': len(lines)
            })
        except Exception as e:
            return jsonify({'error': str(e)}), 500
    
    @api.route('/query/<campaign_slug>', methods=['GET'])
    def query_campaign(campaign_slug: str):
        """
        Execute SQL query for a campaign and return raw results immediately.
        This endpoint runs the SQL query synchronously and returns the data directly.

        Query parameters:
        - year: Optional year filter (e.g., ?year=2025)
        - country: Optional country filter (e.g., ?country=Germany)
        """
        logger = get_logger()

        try:
            year = request.args.get('year', type=int)
            country = request.args.get('country', type=str)
            if country:
                import urllib.parse
                country = urllib.parse.unquote(country).strip() or None

            logger.info(
                f'Executing SQL query for campaign: {campaign_slug}'
                + (f', year: {year}' if year else '')
                + (f', country: {country}' if country else '')
            )

            query_manager = get_query_manager()

            start_time = time.time()
            raw_data = query_manager.execute_campaign_query(
                campaign_slug,
                year=year,
                country=country,
                use_analytics=True
            )
            query_duration = time.time() - start_time

            log_query_execution(
                logger,
                'direct_query',
                query_duration,
                rows_returned=len(raw_data),
                campaign_slug=campaign_slug,
                year=year
            )

            return jsonify({
                'campaign': campaign_slug,
                'year': year,
                'country': country,
                'query_duration_seconds': round(query_duration, 2),
                'rows_returned': len(raw_data),
                'data': raw_data
            })
            
        except CampaignNotFoundError as e:
            logger.error(f'Campaign not found: {campaign_slug}')
            return jsonify({
                'error': 'Campaign not found',
                'message': str(e)
            }), 404
            
        except QueryTimeoutError as e:
            logger.error(f'Query timeout for {campaign_slug}: {str(e)}')
            return jsonify({
                'error': 'Query timeout',
                'message': str(e),
                'hint': 'The database query took too long. Try again in a few minutes.'
            }), 503
            
        except DatabaseError as e:
            logger.error(f'Database error querying {campaign_slug}: {str(e)}', exc_info=True)
            return jsonify({
                'error': 'Database error',
                'message': str(e)
            }), 500
            
        except Exception as e:
            logger.error(f'Error querying {campaign_slug}: {str(e)}', exc_info=True)
            return jsonify({
                'error': 'Query execution error',
                'message': str(e)
            }), 500
    
    app.register_blueprint(api)
