if (!surface_exists(surface_light_map)) {
	surface_light_map = surface_create(2 * light_radius, 2 * light_radius);
}

// Draw lightmap.
draw_set_color(c_blue);
draw_circle(light_radius, light_radius, light_radius, false);
draw_set_color(c_white);

// Draw shadows.
with (obj_shadow) {
	for (var i = 0; i < array_length(polygon_x); ++i) {
		var j = (i + 1) % array_length(polygon_x);
		var x1 = image_xscale * polygon_x[i] + x;
		var y1 = image_yscale * polygon_y[i] + y;
		var x2 = image_xscale * polygon_x[j] + x;
		var y2 = image_yscale * polygon_y[j] + y;
		scr_draw_shadow(other.x, other.y, other.light_radius, x1, y1, x2, y2);
	}
}
