import json
import os
import glob
from collections import defaultdict

# Get all Earth campaign uploader files
files = sorted(glob.glob('quarry_data/uploaders/earth_*_users.json'))

# Organize data by year, then by country
data_by_year_country = defaultdict(lambda: defaultdict(list))

for f in files:
    with open(f, 'r', encoding='utf-8') as file:
        users = json.load(file)
    
    filename = os.path.basename(f)
    parts = filename.replace('_users.json', '').split('_')
    year = int(parts[1])
    country = '_'.join(parts[2:])
    
    for user in users:
        data_by_year_country[year][country].append(user)

print("=" * 120)
print("EARTH CAMPAIGN UPLOADERS - TABLE VIEW (BY YEAR AND COUNTRY)")
print("=" * 120)
print()

# Create a table format
print(f"{'Year':<6} {'Country/Region':<50} {'Uploaders':>10} {'Images':>10} {'Images Used':>12}")
print("-" * 120)

# Display organized by year (descending), then by country
for year in sorted(data_by_year_country.keys(), reverse=True):
    countries = data_by_year_country[year]
    
    # Sort countries by number of uploaders (descending)
    sorted_countries = sorted(countries.items(), key=lambda x: len(x[1]), reverse=True)
    
    for country, users in sorted_countries:
        total_images = sum(u.get('images', 0) for u in users)
        total_images_used = sum(u.get('images_used', 0) for u in users)
        uploader_count = len(users)
        
        # Truncate long country names
        country_display = country[:48] + ".." if len(country) > 50 else country
        
        print(f"{year:<6} {country_display:<50} {uploader_count:>10} {total_images:>10} {total_images_used:>12}")

print("-" * 120)

# Calculate totals
total_uploaders = sum(len(users) for countries in data_by_year_country.values() for users in countries.values())
total_images = sum(
    sum(u.get('images', 0) for u in users)
    for countries in data_by_year_country.values()
    for users in countries.values()
)
total_images_used = sum(
    sum(u.get('images_used', 0) for u in users)
    for countries in data_by_year_country.values()
    for users in countries.values()
)
total_countries = len(set(
    country
    for countries in data_by_year_country.values()
    for country in countries.keys()
))

print(f"{'TOTAL':<6} {'All Countries/Regions':<50} {total_uploaders:>10} {total_images:>10} {total_images_used:>12}")
print("=" * 120)

# Detailed breakdown by year
print("\n\nDETAILED BREAKDOWN BY YEAR:\n")
for year in sorted(data_by_year_country.keys(), reverse=True):
    countries = data_by_year_country[year]
    year_uploaders = sum(len(users) for users in countries.values())
    year_images = sum(sum(u.get('images', 0) for u in users) for users in countries.values())
    
    print(f"Year {year}: {year_uploaders} uploaders, {year_images} images, {len(countries)} countries/regions")
    
    # Show top 3 countries for this year
    sorted_countries = sorted(countries.items(), key=lambda x: len(x[1]), reverse=True)
    for country, users in sorted_countries[:3]:
        uploader_count = len(users)
        images = sum(u.get('images', 0) for u in users)
        print(f"  • {country}: {uploader_count} uploaders, {images} images")
    
    if len(sorted_countries) > 3:
        print(f"  ... and {len(sorted_countries) - 3} more countries/regions")
    print()





