#!/usr/bin/env python3
"""
Test script to diagnose database connection issues on Toolforge.
Run this from the Toolforge server to check database connectivity.
"""

import os
import sys
import pymysql
from pathlib import Path

# Add src to path
sys.path.insert(0, str(Path(__file__).parent))

from config import Config
from database import DatabaseConnection

def check_credentials():
    """Check if credential files exist."""
    print("=" * 60)
    print("Checking credential files...")
    print("=" * 60)
    
    my_cnf = Path.home() / '.my.cnf'
    replica_cnf = Path.home() / 'replica.my.cnf'
    
    print(f"  ~/.my.cnf exists: {my_cnf.exists()}")
    if my_cnf.exists():
        print(f"  Path: {my_cnf}")
        try:
            with open(my_cnf, 'r') as f:
                content = f.read()
                # Don't print password, just show structure
                lines = content.split('\n')
                for line in lines[:10]:  # First 10 lines
                    if 'password' not in line.lower():
                        print(f"    {line}")
                    else:
                        print(f"    [password line hidden]")
        except Exception as e:
            print(f"  Error reading file: {e}")
    
    print(f"\n  ~/replica.my.cnf exists: {replica_cnf.exists()}")
    if replica_cnf.exists():
        print(f"  Path: {replica_cnf}")
        try:
            with open(replica_cnf, 'r') as f:
                content = f.read()
                lines = content.split('\n')
                for line in lines[:10]:
                    if 'password' not in line.lower():
                        print(f"    {line}")
                    else:
                        print(f"    [password line hidden]")
        except Exception as e:
            print(f"  Error reading file: {e}")
    
    print()

def test_connection(use_analytics=False):
    """Test database connection."""
    print("=" * 60)
    print(f"Testing {'analytics' if use_analytics else 'web'} database connection...")
    print("=" * 60)
    
    config = Config()
    db = DatabaseConnection()
    
    host = config.DB_ANALYTICS_HOST if use_analytics else config.DB_WEB_HOST
    print(f"  Host: {host}")
    print(f"  Database: {config.DB_NAME}")
    print(f"  Port: {config.DB_PORT}")
    
    # Get credentials
    credentials = db._get_credentials()
    print(f"  User: {credentials.get('user', 'NOT SET')}")
    print(f"  Password: {'SET' if credentials.get('password') else 'NOT SET'}")
    print(f"  Port from credentials: {credentials.get('port', 'NOT SET')}")
    
    print("\n  Attempting connection...")
    try:
        success, error = db.test_connection(use_analytics=use_analytics)
        if success:
            print("  ✓ Connection successful!")
            return True
        else:
            print(f"  ✗ Connection failed: {error}")
            return False
    except Exception as e:
        print(f"  ✗ Exception: {type(e).__name__}: {e}")
        import traceback
        traceback.print_exc()
        return False

def test_direct_connection():
    """Test direct PyMySQL connection."""
    print("=" * 60)
    print("Testing direct PyMySQL connection...")
    print("=" * 60)
    
    config = Config()
    
    # Try to read credentials
    my_cnf_paths = [
        Path.home() / '.my.cnf',
        Path.home() / 'replica.my.cnf'
    ]
    
    credentials = {}
    my_cnf_path = None
    for path in my_cnf_paths:
        if path.exists():
            my_cnf_path = path
            break
    
    if not my_cnf_path:
        print("  ✗ No credential file found!")
        return False
    
    print(f"  Reading credentials from: {my_cnf_path}")
    
    try:
        with open(my_cnf_path, 'r') as f:
            current_section = None
            for line in f:
                line = line.strip()
                if not line or line.startswith('#'):
                    continue
                if line.startswith('[') and line.endswith(']'):
                    current_section = line[1:-1]
                elif '=' in line and current_section == 'client':
                    key, value = line.split('=', 1)
                    key = key.strip()
                    value = value.strip().strip('"').strip("'")
                    if key == 'user':
                        credentials['user'] = value
                    elif key == 'password':
                        credentials['password'] = value
                    elif key == 'port':
                        try:
                            credentials['port'] = int(value)
                        except ValueError:
                            pass
        
        print(f"  User: {credentials.get('user', 'NOT FOUND')}")
        print(f"  Password: {'SET' if credentials.get('password') else 'NOT FOUND'}")
        
        # Try connecting to web DB
        print("\n  Connecting to web database...")
        conn = pymysql.connect(
            host=config.DB_WEB_HOST,
            port=credentials.get('port', config.DB_PORT),
            user=credentials.get('user'),
            password=credentials.get('password', ''),
            database=config.DB_NAME,
            charset='utf8mb4',
            connect_timeout=10
        )
        
        with conn.cursor() as cursor:
            cursor.execute("SELECT 1 as test")
            result = cursor.fetchone()
            print(f"  ✓ Direct connection successful! Result: {result}")
        
        conn.close()
        return True
        
    except Exception as e:
        print(f"  ✗ Direct connection failed: {type(e).__name__}: {e}")
        import traceback
        traceback.print_exc()
        return False

def main():
    """Run all diagnostic tests."""
    print("\n" + "=" * 60)
    print("Toolforge Database Connection Diagnostic")
    print("=" * 60 + "\n")
    
    # Check credentials
    check_credentials()
    
    # Test web connection
    web_ok = test_connection(use_analytics=False)
    print()
    
    # Test analytics connection
    analytics_ok = test_connection(use_analytics=True)
    print()
    
    # Test direct connection
    direct_ok = test_direct_connection()
    print()
    
    # Summary
    print("=" * 60)
    print("Summary")
    print("=" * 60)
    print(f"  Web DB connection:     {'✓ OK' if web_ok else '✗ FAILED'}")
    print(f"  Analytics DB connection: {'✓ OK' if analytics_ok else '✗ FAILED'}")
    print(f"  Direct connection:    {'✓ OK' if direct_ok else '✗ FAILED'}")
    print()
    
    if not (web_ok or analytics_ok or direct_ok):
        print("Troubleshooting steps:")
        print("1. Check if credential files exist:")
        print("   ls -la ~/.my.cnf ~/replica.my.cnf")
        print("2. If missing, credentials may need to be set up via Toolforge admin")
        print("3. Test manual MySQL connection:")
        print("   mysql -h commonswiki.web.db.svc.wikimedia.cloud commonswiki_p -e 'SELECT 1'")
        print("4. Check Toolforge documentation:")
        print("   https://wikitech.wikimedia.org/wiki/Help:Toolforge/Database")

if __name__ == '__main__':
    main()
