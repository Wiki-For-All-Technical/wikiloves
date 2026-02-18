"""Generate SQL files for Wiki Loves Monuments 2025 per-country categories."""
import os

# Country name -> Commons category suffix (spaces to underscores)
COUNTRIES = [
    "Algeria", "Armenia", "Aruba", "Austria", "Azerbaijan", "Bangladesh", "Belgium",
    "Brazil", "Burundi", "China", "Democratic_Republic_of_the_Congo", "Croatia",
    "Cyprus", "Egypt", "Estonia", "Finland", "France", "Germany", "Ghana", "Greece",
    "Haiti", "India", "Iran", "Iraq", "Ireland", "Italy", "Libya", "Luxembourg",
    "Madagascar", "Malaysia", "Malta", "Moldova", "Nigeria", "Norway", "Pakistan",
    "Palestine", "Peru", "the_Philippines", "Poland", "Portugal", "Russia", "Serbia",
    "Singapore", "Spain", "Sweden", "Taiwan", "Thailand", "Togo", "Tunisia", "Turkey",
    "Uganda", "Ukraine", "United_Arab_Emirates", "United_Kingdom", "United_States",
    "Uruguay", "Uzbekistan", "Zambia",
]

SQL_TEMPLATE = """SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
\t\tp.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
\t\ti.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_{category}'
"""

OUTDIR = os.path.dirname(os.path.abspath(__file__))

def main():
    for country in COUNTRIES:
        category = country  # already with underscores where needed
        fname = f"monuments_2025_in_{country.lower().replace(' ', '_')}.sql"
        if country == "Democratic_Republic_of_the_Congo":
            fname = "monuments_2025_in_democratic_republic_of_the_congo.sql"
        elif country == "the_Philippines":
            fname = "monuments_2025_in_the_philippines.sql"
        elif country == "United_Arab_Emirates":
            fname = "monuments_2025_in_united_arab_emirates.sql"
        elif country == "United_Kingdom":
            fname = "monuments_2025_in_united_kingdom.sql"
        elif country == "United_States":
            fname = "monuments_2025_in_united_states.sql"
        path = os.path.join(OUTDIR, fname)
        with open(path, "w", encoding="utf-8") as f:
            f.write(SQL_TEMPLATE.format(category=category))
        print(path)

if __name__ == "__main__":
    main()
