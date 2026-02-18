"""
Job management utilities for Toolforge scheduled jobs.
"""

import os
import subprocess
from typing import Optional
from logger import get_logger

logger = get_logger('jobs')


def schedule_job(script_path: str, schedule: str, job_name: Optional[str] = None) -> bool:
    """
    Schedule a job using Toolforge Jobs framework.
    
    Args:
        script_path: Path to job script.
        schedule: Cron schedule string (e.g., "0 2 * * *").
        job_name: Optional job name.
    
    Returns:
        True if successful, False otherwise.
    """
    try:
        cmd = ['toolforge', 'jobs', 'schedule', script_path, '--schedule', schedule]
        if job_name:
            cmd.extend(['--name', job_name])
        
        result = subprocess.run(cmd, capture_output=True, text=True)
        
        if result.returncode == 0:
            logger.info(f'Job scheduled: {script_path} with schedule {schedule}')
            return True
        else:
            logger.error(f'Failed to schedule job: {result.stderr}')
            return False
    
    except Exception as e:
        logger.error(f'Error scheduling job: {str(e)}', exc_info=True)
        return False


def list_jobs() -> list:
    """
    List all scheduled jobs.
    
    Returns:
        List of job information dictionaries.
    """
    try:
        result = subprocess.run(
            ['toolforge', 'jobs', 'list'],
            capture_output=True,
            text=True
        )
        
        if result.returncode == 0:
            # Parse output (format may vary)
            jobs = []
            for line in result.stdout.split('\n'):
                if line.strip():
                    jobs.append({'info': line.strip()})
            return jobs
        else:
            logger.error(f'Failed to list jobs: {result.stderr}')
            return []
    
    except Exception as e:
        logger.error(f'Error listing jobs: {str(e)}', exc_info=True)
        return []


def delete_job(job_name: str) -> bool:
    """
    Delete a scheduled job.
    
    Args:
        job_name: Name of job to delete.
    
    Returns:
        True if successful, False otherwise.
    """
    try:
        result = subprocess.run(
            ['toolforge', 'jobs', 'delete', job_name],
            capture_output=True,
            text=True
        )
        
        if result.returncode == 0:
            logger.info(f'Job deleted: {job_name}')
            return True
        else:
            logger.error(f'Failed to delete job: {result.stderr}')
            return False
    
    except Exception as e:
        logger.error(f'Error deleting job: {str(e)}', exc_info=True)
        return False
