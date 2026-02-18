#!/bin/bash
# Deployment script for new /api/query endpoint

echo "Deploying updated routes.py to Toolforge..."

# Copy routes.py to Toolforge
scp toolforge/src/routes.py sanjesh200@login.toolforge.org:~/routes.py

echo "File copied. Now SSH to Toolforge and run:"
echo "  cp ~/routes.py ~/www/python/src/routes.py"
echo "  become wikiloves-data"
echo "  toolforge webservice python3.13 restart"
