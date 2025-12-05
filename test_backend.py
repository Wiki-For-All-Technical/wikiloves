"""Test if backend can start and serve data"""
import sys
sys.path.insert(0, 'wikiloves-main/backend')

try:
    from data.catalog import COMPETITIONS
    print(f"✅ Catalog loaded: {len(COMPETITIONS)} campaigns")
    
    from services.catalog import build_competition_summaries, build_navigation
    summaries = build_competition_summaries()
    nav = build_navigation()
    
    print(f"✅ Competition summaries: {len(summaries)}")
    print(f"✅ Navigation items: {len(nav)}")
    print(f"\nFirst 3 campaigns:")
    for comp in summaries[:3]:
        print(f"  - {comp['name']} ({comp['slug']}) - {comp.get('year_count', 0)} years")
    
    print("\n✅ Backend data processing works!")
    
except Exception as e:
    print(f"❌ Error: {e}")
    import traceback
    traceback.print_exc()



