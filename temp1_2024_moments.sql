-- Albania
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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_Albania';
https://quarry.wmcloud.org/run/1072255/output/0/json

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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_Algeria';
https://quarry.wmcloud.org/run/1072265/output/0/json

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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_Armenia';
https://quarry.wmcloud.org/run/1072267/output/0/json

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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_Austria';
-- not

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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_Azerbaijan';
https://quarry.wmcloud.org/run/1072272/output/0/json

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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_Bangladesh';
https://quarry.wmcloud.org/run/1072274/output/0/json

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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_Belgium';
https://quarry.wmcloud.org/run/1072279/output/0/json

-- Benin
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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_Benin';
https://quarry.wmcloud.org/run/1072282/output/0/json

-- Bosnia and Herzegovina
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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_Bosnia_and_Herzegovina';
https://quarry.wmcloud.org/run/1072285/output/0/json

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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_Brazil';
https://quarry.wmcloud.org/run/1072289/output/0/json

-- Canada
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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_Canada';
https://quarry.wmcloud.org/run/1072293/output/0/json

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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_Croatia';
https://quarry.wmcloud.org/run/1072299/output/0/json

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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_Cyprus';
https://quarry.wmcloud.org/run/1072307/output/0/json

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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_Egypt';
https://quarry.wmcloud.org/run/1072308/output/0/json

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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_Estonia';
https://quarry.wmcloud.org/run/1072311/output/0/json

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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_Finland';
https://quarry.wmcloud.org/run/1072313/output/0/json

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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_Germany';
https://quarry.wmcloud.org/run/1072315/output/0/json

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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_Ghana';

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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_Greece';

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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_India';

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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_Iran';

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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_Ireland';

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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_Italy';

-- Jordan
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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_Jordan';

-- Kosovo
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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_Kosovo';

-- Lebanon
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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_Lebanon';

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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_Libya';

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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_Luxembourg';

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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_Malaysia';

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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_Malta';

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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_Moldova';

-- Morocco
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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_Morocco';

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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_Nigeria';

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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_Norway';

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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_Pakistan';

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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_Palestine';

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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_Peru';

-- Philippines
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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_Philippines';

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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_Poland';

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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_Portugal';

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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_Russia';

-- Rwanda
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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_Rwanda';

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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_Serbia';

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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_Spain';

-- Suriname
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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_Suriname';

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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_Sweden';

-- Syria
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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_Syria';

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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_Taiwan';

-- Tanzania
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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_Tanzania';

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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_Thailand';

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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_Togo';

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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_Uganda';

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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_Ukraine';

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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_United_Arab_Emirates';

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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_United_Kingdom';

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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_United_States';

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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_Uzbekistan';

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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2024_in_Zambia';
