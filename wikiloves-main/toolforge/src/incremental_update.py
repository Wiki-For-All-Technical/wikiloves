#!/usr/bin/env python3
"""
Incremental update job for recent Wiki Loves campaigns.
This script checks for new data in recent campaigns (last 2 years).
Scheduled to run every 6 hours via Toolforge Jobs framework.
"""

import sys
import os
from pathlib import Path
from datetime import datetime

# Add src directory to path
sys.path.insert(0, str(Path(__file__).parent))

from queries import get_query_manager
from processor import get_processor
from logger import get_logger, log_processing_start, log_processing_complete, log_query_execution
from config import Config


def main():
    """Execute incremental update for recent campaigns."""
    logger = get_logger('incremental_update')
    logger.info('Starting incremental update for recent campaigns')
    
    try:
        config = Config()
        query_manager = get_query_manager()
        processor = get_processor()
        
        # Get current year and calculate recent years threshold
        current_year = datetime.now().year
        recent_years = list(range(
            current_year - config.RECENT_YEARS_THRESHOLD + 1,
            current_year + 1
        ))
        
        logger.info(f'Checking campaigns for years: {recent_years}')
        
        # Get all campaigns
        sys.path.insert(0, str(Config().BASE_DIR.parent / 'backend'))
        try:
            from data.campaigns_metadata import ALL_CAMPAIGNS
            campaigns = list(ALL_CAMPAIGNS.keys())
        except ImportError:
            logger.warning('Could not load campaign metadata, using default campaigns')
            campaigns = ['earth', 'monuments', 'africa', 'folklore', 'science', 'food', 'public_art']
        
        log_processing_start(logger)
        start_time = time.time()
        
        total_processed = 0
        for campaign_slug in campaigns:
            logger.info(f'Processing incremental update for: {campaign_slug}')
            
            for year in recent_years:
                try:
                    # Execute campaign query for specific year
                    query_start = time.time()
                    raw_data = query_manager.execute_campaign_query(
                        campaign_slug,
                        year=year,
                        use_analytics=False  # Use web DB for faster queries
                    )
                    query_duration = time.time() - query_start
                    
                    if not raw_data:
                        logger.debug(f'No data found for {campaign_slug} {year}')
                        continue
                    
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
                    
                    if not processed_data:
                        continue
                    
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
                    
                    total_processed += len(raw_data)
                    logger.info(
                        f'Updated {campaign_slug} {year}: {len(raw_data)} records'
                    )
                    
                except Exception as e:
                    logger.error(
                        f'Error processing {campaign_slug} {year}: {str(e)}',
                        exc_info=True
                    )
                    continue
        
        duration = time.time() - start_time
        log_processing_complete(
            logger,
            records_processed=total_processed,
            duration_seconds=duration
        )
        
        logger.info(
            f'Incremental update completed: {total_processed} records in {duration:.2f} seconds'
        )
        return 0
        
    except Exception as e:
        logger.error(f'Error in incremental update: {str(e)}', exc_info=True)
        return 1


if __name__ == '__main__':
    import time
    sys.exit(main())
