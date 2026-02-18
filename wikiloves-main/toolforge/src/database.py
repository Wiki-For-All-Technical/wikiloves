"""
Database connection module for Toolforge.
Handles connections to Wikimedia Commons database replicas.
"""

import pymysql
import os
from typing import List, Dict, Optional, Any
from contextlib import contextmanager
import time

from config import Config
from errors import DatabaseError, QueryTimeoutError


class DatabaseConnection:
    """Manages database connections to Wikimedia replicas."""
    
    def __init__(self):
        self.config = Config()
        self._connection_pool = {}
    
    def _get_credentials(self) -> Dict[str, str]:
        """
        Read database credentials from $HOME/.my.cnf or $HOME/replica.my.cnf.
        Toolforge automatically configures these files.
        """
        # Check both .my.cnf and replica.my.cnf (Toolforge uses replica.my.cnf)
        my_cnf_paths = [
            os.path.expanduser('~/.my.cnf'),
            os.path.expanduser('~/replica.my.cnf')
        ]
        credentials = {}
        
        my_cnf_path = None
        for path in my_cnf_paths:
            if os.path.exists(path):
                my_cnf_path = path
                break
        
        if my_cnf_path:
            try:
                with open(my_cnf_path, 'r') as f:
                    current_section = None
                    for line in f:
                        line = line.strip()
                        if not line or line.startswith('#'):
                            continue
                        if line.startswith('[') and line.endswith(']'):
                            current_section = line[1:-1]
                        elif '=' in line:
                            key, value = line.split('=', 1)
                            key = key.strip()
                            value = value.strip().strip('"').strip("'")
                            if current_section == 'client':
                                if key == 'user':
                                    credentials['user'] = value
                                elif key == 'password':
                                    credentials['password'] = value
                                elif key == 'host':
                                    credentials['host'] = value
                                elif key == 'port':
                                    try:
                                        credentials['port'] = int(value)
                                    except ValueError:
                                        pass
            except Exception as e:
                # Log error but continue with defaults
                import logging
                logging.warning(f"Error reading .my.cnf: {e}")
        
        # Default values if not found
        credentials.setdefault('user', os.environ.get('DB_USER', 'tools.wikiloves-data'))
        credentials.setdefault('password', os.environ.get('DB_PASSWORD', ''))
        credentials.setdefault('port', 3306)
        
        return credentials
    
    @contextmanager
    def get_connection(self, use_analytics: bool = True, timeout: int = 30):
        """
        Get a database connection context manager.
        
        Args:
            use_analytics: If True, use analytics DB (for long queries up to 3 hours).
                         If False, use web DB (for quick queries).
            timeout: Connection timeout in seconds.
        
        Yields:
            pymysql.Connection: Database connection object.
        """
        credentials = self._get_credentials()
        
        if use_analytics:
            host = self.config.DB_ANALYTICS_HOST
            max_execution_time = self.config.MAX_QUERY_TIME
        else:
            host = self.config.DB_WEB_HOST
            max_execution_time = self.config.MAX_WEB_QUERY_TIME
        
        connection = None
        try:
            connection = pymysql.connect(
                host=host,
                port=credentials.get('port', self.config.DB_PORT),
                user=credentials.get('user'),
                password=credentials.get('password'),
                database=self.config.DB_NAME,
                charset='utf8mb4',
                connect_timeout=timeout,
                read_timeout=max_execution_time,
                write_timeout=max_execution_time,
                cursorclass=pymysql.cursors.DictCursor
            )
            
            # Set session max_execution_time if supported (MySQL 8.0.3+).
            # Analytics replica may not support it; skip without failing.
            try:
                if use_analytics:
                    with connection.cursor() as cursor:
                        cursor.execute("SET SESSION max_execution_time = %s", (max_execution_time * 1000,))
            except pymysql.Error:
                # Unknown system variable 'max_execution_time' on older replicas - ignore
                pass
            
            yield connection
            
        except pymysql.Error as e:
            raise DatabaseError(f"Database connection error: {str(e)}") from e
        finally:
            if connection:
                connection.close()
    
    def execute_query(
        self,
        query: str,
        use_analytics: bool = True,
        params: Optional[tuple] = None,
        timeout: Optional[int] = None
    ) -> List[Dict[str, Any]]:
        """
        Execute a SQL query and return results as a list of dictionaries.
        
        Args:
            query: SQL query string.
            use_analytics: Use analytics DB for long queries.
            params: Query parameters for parameterized queries.
            timeout: Query timeout in seconds (overrides default).
        
        Returns:
            List of dictionaries, each representing a row.
        
        Raises:
            DatabaseError: If query execution fails.
            QueryTimeoutError: If query exceeds timeout.
        """
        max_time = timeout or (self.config.MAX_QUERY_TIME if use_analytics else self.config.MAX_WEB_QUERY_TIME)
        start_time = time.time()
        
        try:
            with self.get_connection(use_analytics=use_analytics, timeout=30) as conn:
                with conn.cursor() as cursor:
                    if params:
                        cursor.execute(query, params)
                    else:
                        cursor.execute(query)
                    
                    # Fetch all results
                    results = cursor.fetchall()
                    
                    # Convert to list of dicts if needed
                    if results and isinstance(results[0], dict):
                        return list(results)
                    else:
                        # Convert tuple results to dicts using column names
                        columns = [desc[0] for desc in cursor.description] if cursor.description else []
                        return [dict(zip(columns, row)) for row in results]
        
        except pymysql.OperationalError as e:
            if 'timeout' in str(e).lower() or 'timed out' in str(e).lower():
                elapsed = time.time() - start_time
                raise QueryTimeoutError(
                    f"Query exceeded timeout of {max_time}s (elapsed: {elapsed:.2f}s)"
                ) from e
            raise DatabaseError(f"Query execution error: {str(e)}") from e
        
        except pymysql.Error as e:
            raise DatabaseError(f"Database error: {str(e)}") from e
    
    def execute_campaign_query(
        self,
        campaign_slug: str,
        year: Optional[int] = None,
        use_analytics: bool = True
    ) -> List[Dict[str, Any]]:
        """
        Execute a campaign-specific query.
        
        Args:
            campaign_slug: Campaign slug (e.g., 'earth', 'monuments').
            year: Optional year filter.
            use_analytics: Use analytics DB.
        
        Returns:
            Query results as list of dictionaries.
        """
        # This will be implemented with query generation system
        # For now, placeholder
        raise NotImplementedError("Campaign queries will be implemented in queries.py")
    
    def test_connection(self, use_analytics: bool = True) -> tuple[bool, Optional[str]]:
        """
        Test database connection.
        
        Args:
            use_analytics: Test analytics or web connection.
        
        Returns:
            Tuple of (success: bool, error_message: Optional[str])
        """
        try:
            with self.get_connection(use_analytics=use_analytics) as conn:
                with conn.cursor() as cursor:
                    cursor.execute("SELECT 1")
                    cursor.fetchone()
            return True, None
        except Exception as e:
            return False, str(e)


# Global database instance
_db_instance: Optional[DatabaseConnection] = None


def get_db() -> DatabaseConnection:
    """Get global database connection instance."""
    global _db_instance
    if _db_instance is None:
        _db_instance = DatabaseConnection()
    return _db_instance
