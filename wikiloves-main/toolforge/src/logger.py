"""
Logging module for Toolforge data fetcher.
Provides structured JSON logging to Toolforge shared storage.
"""

import json
import logging
import os
from pathlib import Path
from datetime import datetime
from typing import Dict, Any, Optional
from logging.handlers import RotatingFileHandler

from config import Config


class JSONFormatter(logging.Formatter):
    """Custom formatter that outputs JSON logs."""
    
    def format(self, record: logging.LogRecord) -> str:
        """Format log record as JSON."""
        log_data = {
            'timestamp': datetime.utcnow().isoformat() + 'Z',
            'level': record.levelname,
            'logger': record.name,
            'message': record.getMessage(),
            'module': record.module,
            'function': record.funcName,
            'line': record.lineno,
        }
        
        # Add exception info if present
        if record.exc_info:
            log_data['exception'] = self.formatException(record.exc_info)
        
        # Add extra fields
        if hasattr(record, 'extra'):
            log_data.update(record.extra)
        
        return json.dumps(log_data, ensure_ascii=False)


def setup_logger(
    name: str = 'wikiloves_data_fetcher',
    log_level: Optional[str] = None,
    log_file: Optional[str] = None
) -> logging.Logger:
    """
    Set up logger with JSON formatting and file rotation.
    
    Args:
        name: Logger name.
        log_level: Log level (DEBUG, INFO, WARNING, ERROR, CRITICAL).
        log_file: Log file path (optional, defaults to shared storage).
    
    Returns:
        Configured logger instance.
    """
    config = Config()
    
    logger = logging.getLogger(name)
    logger.setLevel(getattr(logging, log_level or config.LOG_LEVEL, logging.INFO))
    
    # Remove existing handlers
    logger.handlers.clear()
    
    # Console handler (for development)
    console_handler = logging.StreamHandler()
    console_handler.setLevel(logging.INFO)
    console_formatter = logging.Formatter(
        '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
    )
    console_handler.setFormatter(console_formatter)
    logger.addHandler(console_handler)
    
    # File handler with rotation (for production)
    if log_file is None:
        log_file = config.LOGS_DIR / f'{name}.log'
    
    log_file = Path(log_file)
    log_file.parent.mkdir(parents=True, exist_ok=True)
    
    file_handler = RotatingFileHandler(
        log_file,
        maxBytes=10 * 1024 * 1024,  # 10MB
        backupCount=30,  # Keep 30 days of logs
        encoding='utf-8'
    )
    file_handler.setLevel(logging.DEBUG)
    
    if config.LOG_FORMAT == 'json':
        file_formatter = JSONFormatter()
    else:
        file_formatter = logging.Formatter(
            '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
        )
    
    file_handler.setFormatter(file_formatter)
    logger.addHandler(file_handler)
    
    return logger


def log_processing_start(
    logger: logging.Logger,
    campaign_slug: Optional[str] = None,
    year: Optional[int] = None
) -> None:
    """Log start of data processing."""
    extra = {}
    if campaign_slug:
        extra['campaign_slug'] = campaign_slug
    if year:
        extra['year'] = year
    
    logger.info('Processing started', extra=extra)


def log_processing_complete(
    logger: logging.Logger,
    campaign_slug: Optional[str] = None,
    year: Optional[int] = None,
    records_processed: int = 0,
    duration_seconds: float = 0.0
) -> None:
    """Log completion of data processing."""
    extra = {
        'records_processed': records_processed,
        'duration_seconds': round(duration_seconds, 2)
    }
    if campaign_slug:
        extra['campaign_slug'] = campaign_slug
    if year:
        extra['year'] = year
    
    logger.info('Processing completed', extra=extra)


def log_query_execution(
    logger: logging.Logger,
    query_type: str,
    duration_seconds: float,
    rows_returned: int = 0,
    campaign_slug: Optional[str] = None,
    error: Optional[str] = None
) -> None:
    """Log query execution."""
    extra = {
        'query_type': query_type,
        'duration_seconds': round(duration_seconds, 2),
        'rows_returned': rows_returned
    }
    if campaign_slug:
        extra['campaign_slug'] = campaign_slug
    if error:
        extra['error'] = error
    
    if error:
        logger.error('Query execution failed', extra=extra)
    else:
        logger.info('Query executed successfully', extra=extra)


def log_validation_results(
    logger: logging.Logger,
    campaign_slug: str,
    errors: list,
    warnings: Optional[list] = None
) -> None:
    """Log data validation results."""
    extra = {
        'campaign_slug': campaign_slug,
        'error_count': len(errors),
        'errors': errors
    }
    if warnings:
        extra['warning_count'] = len(warnings)
        extra['warnings'] = warnings
    
    if errors:
        logger.warning('Data validation found errors', extra=extra)
    else:
        logger.info('Data validation passed', extra=extra)


# Global logger instance
_logger_instance: Optional[logging.Logger] = None


def get_logger(name: str = 'wikiloves_data_fetcher') -> logging.Logger:
    """Get global logger instance."""
    global _logger_instance
    if _logger_instance is None:
        _logger_instance = setup_logger(name)
    return _logger_instance
