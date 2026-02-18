https://quarry.wmcloud.org/run/1072322/output/0/json

-- Algeria
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_Algeria';

-- Armenia
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_Armenia';

-- Aruba
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_Aruba';

-- Austria
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_Austria';

-- Azerbaijan
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_Azerbaijan';

-- Bangladesh
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_Bangladesh';

-- Belgium
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_Belgium';

-- Brazil
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_Brazil';

-- Burundi
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_Burundi';

-- China
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_China';

-- Croatia
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_Croatia';

-- Cyprus
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_Cyprus';

-- Democratic Republic of the Congo
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_Democratic_Republic_of_the_Congo';

-- Egypt
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_Egypt';

-- Estonia
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_Estonia';

-- Finland
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_Finland';

-- France
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_France';

-- Germany
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_Germany';

-- Ghana
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_Ghana';

-- Greece
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_Greece';

-- Haiti
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_Haiti';

-- India
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_India';

-- Iran
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_Iran';

-- Iraq
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_Iraq';

-- Ireland
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_Ireland';

-- Italy
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_Italy';

-- Libya
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_Libya';

-- Luxembourg
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_Luxembourg';

-- Madagascar
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_Madagascar';

-- Malaysia
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_Malaysia';

-- Malta
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_Malta';

-- Moldova
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_Moldova';

-- Nigeria
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_Nigeria';

-- Norway
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_Norway';

-- Pakistan
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_Pakistan';

-- Palestine
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_Palestine';

-- Peru
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_Peru';

-- the Philippines
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_the_Philippines';

-- Poland
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_Poland';

-- Portugal
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_Portugal';

-- Russia
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_Russia';

-- Serbia
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_Serbia';

-- Singapore
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_Singapore';

-- Spain
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_Spain';

-- Sweden
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_Sweden';

-- Taiwan
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_Taiwan';

-- Thailand
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_Thailand';

-- Togo
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_Togo';

-- Tunisia
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_Tunisia';

-- Turkey
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_Turkey';

-- Uganda
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_Uganda';

-- Ukraine
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_Ukraine';

-- United Arab Emirates
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_United_Arab_Emirates';

-- United Kingdom
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_United_Kingdom';

-- United States
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_United_States';

-- Uruguay
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_Uruguay';

-- Uzbekistan
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_Uzbekistan';

-- Zambia
SELECT cl.cl_from, cl.cl_to, cl.cl_sortkey,
		p.page_title as File, 
        left(i.img_timestamp,8) as imgdate,
		i.img_timestamp, i.img_size, i.img_width, i.img_height,
        a.actor_name, a.actor_user
FROM categorylinks cl
JOIN page p ON cl.cl_from = p.page_id
JOIN image i ON i.img_name = p.page_title AND p.page_namespace = 6 AND p.page_is_redirect=0
JOIN actor_image a ON i.img_actor = a.actor_id
WHERE cl.cl_type = 'file'
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_Zambia';
