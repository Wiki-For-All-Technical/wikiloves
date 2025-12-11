import sys
sys.path.insert(0, 'wikiloves-main/backend')
from data.catalog import COMPETITIONS

print(f'Total competitions: {len(COMPETITIONS)}')
print(f'Campaigns with data: {sum(1 for c in COMPETITIONS if c.get("years"))}')
print(f'\nFirst 5 campaigns:')
for i, comp in enumerate(COMPETITIONS[:5], 1):
    years_count = len(comp.get('years', []))
    print(f'{i}. {comp["name"]} - {years_count} years')



