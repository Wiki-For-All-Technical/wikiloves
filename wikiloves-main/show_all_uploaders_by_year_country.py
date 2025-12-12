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

print("=" * 100)
print("ALL EARTH CAMPAIGN UPLOADERS - ORGANIZED BY YEAR AND COUNTRY")
print("=" * 100)
print()

# Display organized by year (descending)
for year in sorted(data_by_year_country.keys(), reverse=True):
    countries = data_by_year_country[year]
    
    # Calculate totals for this year
    year_total_uploaders = sum(len(users) for users in countries.values())
    year_total_images = sum(
        sum(u.get('images', 0) for u in users) 
        for users in countries.values()
    )
    
    print(f"\n{'='*100}")
    print(f"YEAR {year}")
    print(f"Total: {year_total_uploaders} uploaders, {year_total_images} images across {len(countries)} countries/regions")
    print(f"{'='*100}")
    
    # Sort countries by number of uploaders (descending)
    sorted_countries = sorted(countries.items(), key=lambda x: len(x[1]), reverse=True)
    
    for country, users in sorted_countries:
        # Sort users by images (descending)
        users_sorted = sorted(users, key=lambda x: x.get('images', 0), reverse=True)
        
        total_images = sum(u.get('images', 0) for u in users_sorted)
        total_images_used = sum(u.get('images_used', 0) for u in users_sorted)
        
        print(f"\n  📍 {country}")
        print(f"     {len(users_sorted)} uploaders | {total_images} images ({total_images_used} used)")
        print(f"     {'-'*94}")
        
        for i, user in enumerate(users_sorted, 1):
            username = user.get('username', 'Unknown')
            images = user.get('images', 0)
            images_used = user.get('images_used', 0)
            registration = user.get('registration', '')
            
            reg_info = f" | Registered: {registration}" if registration else ""
            print(f"     {i:2}. {username:<45} {images:>4} images ({images_used} used){reg_info}")

# Summary statistics
print(f"\n\n{'='*100}")
print("SUMMARY STATISTICS")
print(f"{'='*100}")

all_years = sorted(data_by_year_country.keys())
all_countries = set()
total_all_uploaders = 0
total_all_images = 0

for year in all_years:
    for country, users in data_by_year_country[year].items():
        all_countries.add(country)
        total_all_uploaders += len(users)
        total_all_images += sum(u.get('images', 0) for u in users)

print(f"\nYears: {min(all_years)} - {max(all_years)}")
print(f"Total Years: {len(all_years)}")
print(f"Total Countries/Regions: {len(all_countries)}")
print(f"Total Uploaders: {total_all_uploaders}")
print(f"Total Images: {total_all_images}")

# Top countries by uploader count
print(f"\n{'='*100}")
print("TOP COUNTRIES/REGIONS BY UPLOADER COUNT")
print(f"{'='*100}")

country_stats = defaultdict(lambda: {'uploaders': 0, 'images': 0, 'years': set()})

for year in all_years:
    for country, users in data_by_year_country[year].items():
        country_stats[country]['uploaders'] += len(users)
        country_stats[country]['images'] += sum(u.get('images', 0) for u in users)
        country_stats[country]['years'].add(year)

sorted_countries = sorted(country_stats.items(), key=lambda x: x[1]['uploaders'], reverse=True)

for i, (country, stats) in enumerate(sorted_countries[:10], 1):
    years_str = ', '.join(map(str, sorted(stats['years'])))
    print(f"{i:2}. {country:<50} {stats['uploaders']:>3} uploaders, {stats['images']:>4} images (Years: {years_str})")





