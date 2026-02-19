"""
Configuration for Toolforge data fetcher.
"""

import os
from pathlib import Path

class Config:
    """Application configuration."""
    
    # Database configuration
    DB_ANALYTICS_HOST = "commonswiki.analytics.db.svc.wikimedia.cloud"
    DB_WEB_HOST = "commonswiki.web.db.svc.wikimedia.cloud"
    DB_NAME = "commonswiki_p"
    DB_PORT = 3306
    
    # Credentials are read from $HOME/.my.cnf automatically by Toolforge
    # No need to specify here
    
    # Paths
    BASE_DIR = Path(__file__).parent  # src/ directory
    SHARED_STORAGE = Path(os.environ.get('HOME', '/data/project/wikiloves-data')) / 'shared'
    LOGS_DIR = SHARED_STORAGE / 'logs'
    DATA_DIR = SHARED_STORAGE / 'data'
    
    # Ensure directories exist
    LOGS_DIR.mkdir(parents=True, exist_ok=True)
    DATA_DIR.mkdir(parents=True, exist_ok=True)
    
    # Query files - deployed directly to src/ directory on Toolforge
    # unified_all_campaigns_query.sql should be in src/ directory
    UNIFIED_QUERY_FILE = BASE_DIR / 'unified_all_campaigns_query.sql'
    
    # Campaign metadata - deployed directly to src/ directory on Toolforge
    # campaigns_metadata.py should be in src/ directory
    CAMPAIGNS_METADATA_FILE = BASE_DIR / 'campaigns_metadata.py'
    
    # Processing settings
    MAX_QUERY_TIME = 10800  # 3 hours in seconds (for analytics DB)
    MAX_WEB_QUERY_TIME = 300  # 5 minutes for web DB

    # Uploaders cache: serve from file after first successful query (fast subsequent loads)
    UPLOADERS_CACHE_DIR = DATA_DIR / 'uploaders'
    UPLOADERS_CACHE_TTL_SEC = 24 * 3600  # 24 hours
    # Country detail cache: same idea so /api/data/<campaign>/<year>/<country> is instant
    COUNTRY_DETAIL_CACHE_DIR = DATA_DIR / 'country_detail'
    COUNTRY_DETAIL_CACHE_TTL_SEC = 24 * 3600  # 24 hours
    
    # Job settings
    DAILY_REFRESH_HOUR = 2  # UTC hour for daily refresh
    INCREMENTAL_INTERVAL_HOURS = 6  # Hours between incremental updates
    
    # Campaign settings
    RECENT_YEARS_THRESHOLD = 2  # Years to check in incremental updates
    
    # Logging
    LOG_LEVEL = os.environ.get('LOG_LEVEL', 'INFO')
    LOG_FORMAT = 'json'  # Use JSON format for structured logging
    
    # API settings
    API_TIMEOUT = 300  # 5 minutes timeout for API endpoints
