#!/usr/bin/env python3
"""
Daily full data refresh job for all Wiki Loves campaigns.
This script is scheduled to run daily via Toolforge Jobs framework.
"""

import sys
import os
from pathlib import Path

# Add src directory to path
sys.path.insert(0, str(Path(__file__).parent))

import time
from queries import get_query_manager
from processor import get_processor
from logger import get_logger, log_processing_start, log_processing_complete, log_query_execution
from config import Config


def main():
    """Execute daily full data refresh."""
    logger = get_logger('daily_refresh')
    logger.info('Starting daily full data refresh')
    
    try:
        query_manager = get_query_manager()
        processor = get_processor()
        
        # Execute unified query
        log_processing_start(logger)
        start_time = time.time()
        
        logger.info('Executing unified query for all campaigns')
        raw_data = query_manager.execute_unified_query(use_analytics=True)
        query_duration = time.time() - start_time
        
        log_query_execution(
            logger,
            'unified_all_campaigns',
            query_duration,
            rows_returned=len(raw_data)
        )
        
        logger.info(f'Query returned {len(raw_data)} rows in {query_duration:.2f} seconds')
        
        # Process data for all campaigns
        logger.info('Processing campaign data')
        processed_data = processor.process_campaign_data(raw_data)
        
        # Validate and save each campaign
        for campaign_slug, campaign_data in processed_data.items():
            logger.info(f'Processing campaign: {campaign_slug}')
            
            # Validate
            errors = processor.validate_data(campaign_data)
            if errors:
                logger.warning(
                    f'Validation errors for {campaign_slug}',
                    extra={'errors': errors}
                )
            else:
                logger.info(f'Validation passed for {campaign_slug}')
            
            # Save processed data
            output_path = Config().DATA_DIR / f'{campaign_slug}_processed.json'
            saved_path = processor.save_processed_data(campaign_data, str(output_path))
            logger.info(f'Saved processed data to: {saved_path}')
        
        duration = time.time() - start_time
        log_processing_complete(
            logger,
            records_processed=len(raw_data),
            duration_seconds=duration
        )
        
        logger.info(f'Daily refresh completed successfully in {duration:.2f} seconds')
        return 0
        
    except Exception as e:
        logger.error(f'Error in daily refresh: {str(e)}', exc_info=True)
        return 1


if __name__ == '__main__':
    import time
    sys.exit(main())
