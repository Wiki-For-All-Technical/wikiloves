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
                logger.info(f'Starting data fetch for campaign: {campaign_slug}')
                query_manager = get_query_manager()
                processor = get_processor()
                
                # Execute campaign query
                start_time = time.time()
                raw_data = query_manager.execute_campaign_query(
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
        """
        logger = get_logger()
        
        try:
            # Get optional year parameter
            year = request.args.get('year', type=int)
            
            logger.info(f'Executing SQL query for campaign: {campaign_slug}' + (f', year: {year}' if year else ''))
            
            query_manager = get_query_manager()
            
            # Execute campaign query synchronously
            start_time = time.time()
            raw_data = query_manager.execute_campaign_query(
                campaign_slug,
                year=year,
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
            
            # Return raw SQL results
            return jsonify({
                'campaign': campaign_slug,
                'year': year,
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
