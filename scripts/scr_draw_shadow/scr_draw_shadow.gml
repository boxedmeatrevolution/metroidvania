function scr_draw_shadow(light_x, light_y, light_radius, seg_x1, seg_y1, seg_x2, seg_y2) {
	// Backface culling.
	var cross = (light_x - seg_x1) * (light_y - seg_y2) - (light_x - seg_x2) * (light_y - seg_y1);
	if (cross < 0) {
		return;
	}
	
	var distance1 = sqrt(sqr(seg_x1 - light_x) + sqr(seg_y1 - light_y));
	var distance2 = sqrt(sqr(seg_x2 - light_x) + sqr(seg_y2 - light_y));
	var far_x1 = seg_x1 + (seg_x1 - light_x) * light_radius / distance1;
	var far_y1 = seg_y1 + (seg_y1 - light_y) * light_radius / distance1;
	var far_x2 = seg_x2 + (seg_x2 - light_x) * light_radius / distance2;
	var far_y2 = seg_y2 + (seg_y2 - light_y) * light_radius / distance2;
	draw_primitive_begin(pr_trianglestrip);
	draw_vertex(seg_x2, seg_y2);
	draw_vertex(seg_x1, seg_y1);
	draw_vertex(far_x2, far_y2);
	draw_vertex(far_x1, far_y1);
	draw_primitive_end();
}
