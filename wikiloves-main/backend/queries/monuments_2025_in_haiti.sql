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
AND cl.cl_to = 'Images_from_Wiki_Loves_Monuments_2025_in_Haiti'
