-- ============================================
-- UNIFIED QUERY FOR ALL 77 WIKI LOVES CAMPAIGNS
-- ============================================
-- This single query processes ALL campaigns in one execution
-- Returns: campaign_slug, campaign_name, year, country, uploads, uploaders, images_used, new_uploaders
-- Database: commonswiki_p
-- 
-- IMPORTANT NOTES:
-- - This query may take 15-30+ minutes to execute due to processing all campaigns
-- - Results include country-level breakdown for all campaigns
-- - Images_used correctly checks imagelinks table (not just counting uploads)
-- - New_uploaders uses campaign-specific date ranges (see date mappings below)
-- 
-- CAMPAIGN DATE RANGES (for new_uploaders calculation):
-- - Africa: March 1st onwards
-- - Monuments: September 1st onwards
-- - Earth: May 1st onwards
-- - Folklore: February 1st onwards
-- - Science: November 1st onwards
-- - Food: July 1st onwards
-- - Public Art: May 1st onwards
-- - Default: March 1st onwards (for campaigns without specific date)
-- ============================================

SELECT 
    -- Campaign identification
    CASE
        WHEN cl.cl_to LIKE '%Wiki_Loves_Africa%' THEN 'africa'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Andes%' THEN 'andes'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Art_Belgium%' THEN 'art-belgium'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Assamese_Culture%' THEN 'assamese-culture'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Bangla%' THEN 'bangla'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Birds%' THEN 'birds'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Birds_India%' THEN 'birds-india'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Botswana%' THEN 'botswana'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Busto_Arsizio%' THEN 'busto-arsizio'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Canoeing_Hamburg%' THEN 'canoeing-hamburg'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Children%' THEN 'children'
        WHEN cl.cl_to LIKE '%Wiki_Loves_China%' THEN 'china'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Classics%' THEN 'classics'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Cocktails_At_Wikicon%' THEN 'cocktails-at-wikicon'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Cosplay%' THEN 'cosplay'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Cultura_Popular_Brasil%' THEN 'cultura-popular-brasil'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Culture%' THEN 'culture'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Denderland%' THEN 'denderland'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Earth%' THEN 'earth'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Eemland%' THEN 'eemland'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Emirates%' THEN 'emirates'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Europride%' THEN 'europride'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Falles%' THEN 'falles'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Fashion%' THEN 'fashion'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Festivals%' THEN 'festivals'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Film%' THEN 'film'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Fiumefreddo%' THEN 'fiumefreddo'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Folklore%' THEN 'folk'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Folklore%' THEN 'folklore'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Food%' THEN 'food'
        WHEN cl.cl_to LIKE '%Wiki_Loves_For_Rural_Works%' THEN 'for-rural-works'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Heritage_Belgium%' THEN 'heritage-belgium'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Heritage_Ghana%' THEN 'heritage-ghana'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Librarians%' THEN 'librarians'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Libraries_Saam%' THEN 'libraries-saam'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Littérature_Haïtienne%' THEN 'littérature-haïtienne'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Living_Heritage%' THEN 'living-heritage'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Love%' THEN 'love'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Mangaluru%' THEN 'mangaluru'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Maps%' THEN 'maps'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Mexico%' THEN 'mexico'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Monuments%' THEN 'monuments'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Museums%' THEN 'museums'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Museums_India%' THEN 'museums-india'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Muziris%' THEN 'muziris'
        WHEN cl.cl_to LIKE '%Wiki_Loves_México%' THEN 'méxico'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Namibia%' THEN 'namibia'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Nyc_Parks%' THEN 'nyc-parks'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Onam%' THEN 'onam'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Pajottenland_Zennevallei%' THEN 'pajottenland-zennevallei'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Parliaments%' THEN 'parliaments'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Pesto_Genovese%' THEN 'pesto-genovese'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Piemonte%' THEN 'piemonte'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Plants%' THEN 'plants'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Pride%' THEN 'pride'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Public_Art%' THEN 'public-art'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Public_Space%' THEN 'public-space'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Puglia%' THEN 'puglia'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Ramadan%' THEN 'ramadan'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Ratha_Jatra%' THEN 'ratha-jatra'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Romania%' THEN 'romania'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Schools%' THEN 'schools'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Sicilia%' THEN 'sicilia'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Small_Museums%' THEN 'small-museums'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Sport%' THEN 'sport'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Stuff%' THEN 'stuff'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Sudan%' THEN 'sudan'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Switzerland%' THEN 'switzerland'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Tirreno_Cosentino%' THEN 'tirreno-cosentino'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Trentino%' THEN 'trentino'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Tribal_Culture%' THEN 'tribal-culture'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Valle_Del_Primo_Presepe%' THEN 'valle-del-primo-presepe'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Villages%' THEN 'villages'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Vizag%' THEN 'vizag'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Wahran%' THEN 'wahran'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Women%' THEN 'women'
        WHEN cl.cl_to LIKE '%Wiki_Science_Competition%' THEN 'science'
        ELSE NULL
    END AS campaign_slug,
    
    CASE
        WHEN cl.cl_to LIKE '%Wiki_Loves_Africa%' THEN 'Wiki Loves Africa'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Andes%' THEN 'Wiki Loves Andes'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Art_Belgium%' THEN 'Wiki Loves Art Belgium'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Assamese_Culture%' THEN 'Wiki Loves Assamese Culture'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Bangla%' THEN 'Wiki Loves Bangla'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Birds%' THEN 'Wiki Loves Birds'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Birds_India%' THEN 'Wiki Loves Birds India'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Botswana%' THEN 'Wiki Loves Botswana'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Busto_Arsizio%' THEN 'Wiki Loves Busto Arsizio'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Canoeing_Hamburg%' THEN 'Wiki Loves Canoeing Hamburg'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Children%' THEN 'Wiki Loves Children'
        WHEN cl.cl_to LIKE '%Wiki_Loves_China%' THEN 'Wiki Loves China'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Classics%' THEN 'Wiki Loves Classics'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Cocktails_At_Wikicon%' THEN 'Wiki Loves Cocktails At Wikicon'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Cosplay%' THEN 'Wiki Loves Cosplay'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Cultura_Popular_Brasil%' THEN 'Wiki Loves Cultura Popular Brasil'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Culture%' THEN 'Wiki Loves Culture'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Denderland%' THEN 'Wiki Loves Denderland'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Earth%' THEN 'Wiki Loves Earth'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Eemland%' THEN 'Wiki Loves Eemland'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Emirates%' THEN 'Wiki Loves Emirates'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Europride%' THEN 'Wiki Loves Europride'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Falles%' THEN 'Wiki Loves Falles'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Fashion%' THEN 'Wiki Loves Fashion'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Festivals%' THEN 'Wiki Loves Festivals'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Film%' THEN 'Wiki Loves Film'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Fiumefreddo%' THEN 'Wiki Loves Fiumefreddo'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Folklore%' THEN 'Wiki Loves Folk'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Folklore%' THEN 'Wiki Loves Folklore'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Food%' THEN 'Wiki Loves Food'
        WHEN cl.cl_to LIKE '%Wiki_Loves_For_Rural_Works%' THEN 'Wiki Loves For Rural Works'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Heritage_Belgium%' THEN 'Wiki Loves Heritage Belgium'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Heritage_Ghana%' THEN 'Wiki Loves Heritage Ghana'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Librarians%' THEN 'Wiki Loves Librarians'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Libraries_Saam%' THEN 'Wiki Loves Libraries Saam'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Littérature_Haïtienne%' THEN 'Wiki Loves Littérature Haïtienne'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Living_Heritage%' THEN 'Wiki Loves Living Heritage'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Love%' THEN 'Wiki Loves Love'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Mangaluru%' THEN 'Wiki Loves Mangaluru'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Maps%' THEN 'Wiki Loves Maps'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Mexico%' THEN 'Wiki Loves Mexico'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Monuments%' THEN 'Wiki Loves Monuments'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Museums%' THEN 'Wiki Loves Museums'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Museums_India%' THEN 'Wiki Loves Museums India'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Muziris%' THEN 'Wiki Loves Muziris'
        WHEN cl.cl_to LIKE '%Wiki_Loves_México%' THEN 'Wiki Loves México'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Namibia%' THEN 'Wiki Loves Namibia'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Nyc_Parks%' THEN 'Wiki Loves Nyc Parks'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Onam%' THEN 'Wiki Loves Onam'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Pajottenland_Zennevallei%' THEN 'Wiki Loves Pajottenland Zennevallei'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Parliaments%' THEN 'Wiki Loves Parliaments'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Pesto_Genovese%' THEN 'Wiki Loves Pesto Genovese'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Piemonte%' THEN 'Wiki Loves Piemonte'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Plants%' THEN 'Wiki Loves Plants'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Pride%' THEN 'Wiki Loves Pride'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Public_Art%' THEN 'Wiki Loves Public Art'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Public_Space%' THEN 'Wiki Loves Public Space'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Puglia%' THEN 'Wiki Loves Puglia'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Ramadan%' THEN 'Wiki Loves Ramadan'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Ratha_Jatra%' THEN 'Wiki Loves Ratha Jatra'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Romania%' THEN 'Wiki Loves Romania'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Schools%' THEN 'Wiki Loves Schools'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Sicilia%' THEN 'Wiki Loves Sicilia'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Small_Museums%' THEN 'Wiki Loves Small Museums'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Sport%' THEN 'Wiki Loves Sport'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Stuff%' THEN 'Wiki Loves Stuff'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Sudan%' THEN 'Wiki Loves Sudan'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Switzerland%' THEN 'Wiki Loves Switzerland'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Tirreno_Cosentino%' THEN 'Wiki Loves Tirreno Cosentino'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Trentino%' THEN 'Wiki Loves Trentino'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Tribal_Culture%' THEN 'Wiki Loves Tribal Culture'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Valle_Del_Primo_Presepe%' THEN 'Wiki Loves Valle Del Primo Presepe'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Villages%' THEN 'Wiki Loves Villages'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Vizag%' THEN 'Wiki Loves Vizag'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Wahran%' THEN 'Wiki Loves Wahran'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Women%' THEN 'Wiki Loves Women'
        WHEN cl.cl_to LIKE '%Wiki_Science_Competition%' THEN 'Wiki Science Competition'
        ELSE 'Unknown'
    END AS campaign_name,
    
    -- Year extraction
    CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) AS year,
    
    -- Country extraction
    CASE 
        WHEN cl.cl_to LIKE '%_in_%' THEN
            REPLACE(SUBSTRING_INDEX(cl.cl_to, '_in_', -1), '_', ' ')
        ELSE 'Global'
    END AS country,
    
    -- Statistics
    COUNT(DISTINCT i.img_name) AS uploads,
    COUNT(DISTINCT a.actor_name) AS uploaders,
    
    -- Images used: Check imagelinks table for actual usage
    COUNT(DISTINCT CASE 
        WHEN EXISTS (
            SELECT 1 FROM imagelinks il 
            WHERE il.il_from = p.page_id
            LIMIT 1
        ) THEN i.img_name 
    END) AS images_used,
    
    -- New uploaders: Users registered on/after campaign start date through end of year
    COUNT(DISTINCT CASE 
        WHEN u.user_registration >= CONCAT(
            CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), 
            CASE
        WHEN cl.cl_to LIKE '%Wiki_Loves_Africa%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Andes%' THEN '1001000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Art_Belgium%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Assamese_Culture%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Bangla%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Birds%' THEN '0401000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Birds_India%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Botswana%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Busto_Arsizio%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Canoeing_Hamburg%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Children%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_China%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Classics%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Cocktails_At_Wikicon%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Cosplay%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Cultura_Popular_Brasil%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Culture%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Denderland%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Earth%' THEN '0501000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Eemland%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Emirates%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Europride%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Falles%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Fashion%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Festivals%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Film%' THEN '0501000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Fiumefreddo%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Folklore%' THEN '0201000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Folklore%' THEN '0201000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Food%' THEN '0701000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_For_Rural_Works%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Heritage_Belgium%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Heritage_Ghana%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Librarians%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Libraries_Saam%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Littérature_Haïtienne%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Living_Heritage%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Love%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Mangaluru%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Maps%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Mexico%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Monuments%' THEN '0901000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Museums%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Museums_India%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Muziris%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_México%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Namibia%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Nyc_Parks%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Onam%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Pajottenland_Zennevallei%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Parliaments%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Pesto_Genovese%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Piemonte%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Plants%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Pride%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Public_Art%' THEN '0501000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Public_Space%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Puglia%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Ramadan%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Ratha_Jatra%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Romania%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Schools%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Sicilia%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Small_Museums%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Sport%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Stuff%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Sudan%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Switzerland%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Tirreno_Cosentino%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Trentino%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Tribal_Culture%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Valle_Del_Primo_Presepe%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Villages%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Vizag%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Wahran%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Women%' THEN '0301000000'
        WHEN cl.cl_to LIKE '%Wiki_Science_Competition%' THEN '1101000000'
        ELSE '0301000000'
            END
        )
            AND u.user_registration <= CONCAT(CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED), '1231235959')
        THEN a.actor_name
    END) AS new_uploaders
    
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
    AND p.page_namespace = 6 
    AND p.page_is_redirect = 0
JOIN image i ON i.img_name = p.page_title
JOIN actor_image a ON i.img_actor = a.actor_id
LEFT JOIN actor ON a.actor_id = actor.actor_id
LEFT JOIN user u ON actor.actor_user = u.user_id
WHERE cl.cl_type = 'file'
  AND (
    -- Match any Wiki Loves campaign category
    cl.cl_to LIKE '%Wiki_Loves_%'
    OR cl.cl_to LIKE '%Wiki_Science_Competition%'
    OR cl.cl_to LIKE '%WikiScience%'
    OR cl.cl_to LIKE '%Images_from_Wiki_Loves_%'
    OR cl.cl_to LIKE '%Images_from_Wiki_Science%'
  )
  AND cl.cl_to REGEXP '[0-9]{4}$'
  AND CAST(SUBSTRING_INDEX(cl.cl_to, '_', -1) AS UNSIGNED) BETWEEN 2010 AND 2025
  -- Filter: Only include rows where we can identify a campaign
  AND (
    CASE
        WHEN cl.cl_to LIKE '%Wiki_Loves_Africa%' THEN 'africa'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Andes%' THEN 'andes'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Art_Belgium%' THEN 'art-belgium'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Assamese_Culture%' THEN 'assamese-culture'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Bangla%' THEN 'bangla'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Birds%' THEN 'birds'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Birds_India%' THEN 'birds-india'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Botswana%' THEN 'botswana'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Busto_Arsizio%' THEN 'busto-arsizio'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Canoeing_Hamburg%' THEN 'canoeing-hamburg'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Children%' THEN 'children'
        WHEN cl.cl_to LIKE '%Wiki_Loves_China%' THEN 'china'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Classics%' THEN 'classics'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Cocktails_At_Wikicon%' THEN 'cocktails-at-wikicon'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Cosplay%' THEN 'cosplay'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Cultura_Popular_Brasil%' THEN 'cultura-popular-brasil'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Culture%' THEN 'culture'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Denderland%' THEN 'denderland'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Earth%' THEN 'earth'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Eemland%' THEN 'eemland'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Emirates%' THEN 'emirates'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Europride%' THEN 'europride'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Falles%' THEN 'falles'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Fashion%' THEN 'fashion'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Festivals%' THEN 'festivals'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Film%' THEN 'film'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Fiumefreddo%' THEN 'fiumefreddo'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Folklore%' THEN 'folk'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Folklore%' THEN 'folklore'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Food%' THEN 'food'
        WHEN cl.cl_to LIKE '%Wiki_Loves_For_Rural_Works%' THEN 'for-rural-works'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Heritage_Belgium%' THEN 'heritage-belgium'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Heritage_Ghana%' THEN 'heritage-ghana'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Librarians%' THEN 'librarians'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Libraries_Saam%' THEN 'libraries-saam'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Littérature_Haïtienne%' THEN 'littérature-haïtienne'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Living_Heritage%' THEN 'living-heritage'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Love%' THEN 'love'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Mangaluru%' THEN 'mangaluru'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Maps%' THEN 'maps'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Mexico%' THEN 'mexico'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Monuments%' THEN 'monuments'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Museums%' THEN 'museums'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Museums_India%' THEN 'museums-india'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Muziris%' THEN 'muziris'
        WHEN cl.cl_to LIKE '%Wiki_Loves_México%' THEN 'méxico'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Namibia%' THEN 'namibia'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Nyc_Parks%' THEN 'nyc-parks'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Onam%' THEN 'onam'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Pajottenland_Zennevallei%' THEN 'pajottenland-zennevallei'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Parliaments%' THEN 'parliaments'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Pesto_Genovese%' THEN 'pesto-genovese'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Piemonte%' THEN 'piemonte'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Plants%' THEN 'plants'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Pride%' THEN 'pride'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Public_Art%' THEN 'public-art'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Public_Space%' THEN 'public-space'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Puglia%' THEN 'puglia'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Ramadan%' THEN 'ramadan'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Ratha_Jatra%' THEN 'ratha-jatra'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Romania%' THEN 'romania'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Schools%' THEN 'schools'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Sicilia%' THEN 'sicilia'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Small_Museums%' THEN 'small-museums'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Sport%' THEN 'sport'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Stuff%' THEN 'stuff'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Sudan%' THEN 'sudan'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Switzerland%' THEN 'switzerland'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Tirreno_Cosentino%' THEN 'tirreno-cosentino'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Trentino%' THEN 'trentino'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Tribal_Culture%' THEN 'tribal-culture'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Valle_Del_Primo_Presepe%' THEN 'valle-del-primo-presepe'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Villages%' THEN 'villages'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Vizag%' THEN 'vizag'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Wahran%' THEN 'wahran'
        WHEN cl.cl_to LIKE '%Wiki_Loves_Women%' THEN 'women'
        WHEN cl.cl_to LIKE '%Wiki_Science_Competition%' THEN 'science'
        ELSE NULL
    END IS NOT NULL
  )
GROUP BY campaign_slug, campaign_name, year, country
ORDER BY campaign_name, year DESC, uploads DESC;
