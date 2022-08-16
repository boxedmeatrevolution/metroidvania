// Draw shadow maps for each light.
draw_set_color(c_black);
with (obj_light_point) {
	if (!surface_exists(surface_shadow_map)) {
		surface_shadow_map = surface_create(2 * light_radius, 2 * light_radius);
	}
	if (!surface_exists(surface_shadow_map_buffer)) {
		surface_shadow_map_buffer = surface_create(2 * light_radius, 2 * light_radius);
	}

	surface_set_target(surface_shadow_map);

	draw_clear(c_white);

	var x_offset = x - light_radius;
	var y_offset = y - light_radius;
	with (obj_shadow) {
		// Draw shadow front.
		draw_primitive_begin(pr_trianglefan);
		var count = array_length(polygon_x);
		var backface_idx_1 = noone;
		var backface_idx_2 = noone;
		var backface_prev;
		var x_prev = image_xscale * polygon_x[count - 1] + x;
		var y_prev = image_yscale * polygon_y[count - 1] + y;
		draw_vertex(x + 0.5 * image_xscale * 64 - x_offset, y + 0.5 * image_yscale * 64 - y_offset);
		for (var i = 0; i < count + 1; ++i) {
			var first = (i == 0);
			// TODO: Add rotation support.
			var x_next = image_xscale * polygon_x[i % count] + x;
			var y_next = image_yscale * polygon_y[i % count] + y;
			var backface_next = ((x_next - other.x) * (y_prev - other.y) - (x_prev - other.x) * (y_next - other.y) < 0);
			if (!first) {
				if (!backface_next && backface_prev) {
					backface_idx_2 = i - 1;
				}
				if (backface_next && !backface_prev) {
					backface_idx_1 = i - 1;
				}
				if (!backface_next || !backface_prev) {
					draw_vertex(x_prev - x_offset, y_prev - y_offset);
				}
			}
			backface_prev = backface_next;
			x_prev = x_next;
			y_prev = y_next;
		}
		draw_primitive_end();
	
		if (backface_idx_1 == noone || backface_idx_2 == noone) {
			// Light is encased in the object, should be turned off.
			draw_clear(c_black);
			break;
		}
	
		// Draw shadow box.
		draw_primitive_begin(pr_trianglestrip);
		var x1 = image_xscale * polygon_x[backface_idx_1] + x;
		var y1 = image_yscale * polygon_y[backface_idx_1] + y;
		var x2 = image_xscale * polygon_x[backface_idx_2] + x;
		var y2 = image_yscale * polygon_y[backface_idx_2] + y;
		var distance_1 = sqrt(sqr(x1 - other.x) + sqr(y1 - other.y));
		var distance_2 = sqrt(sqr(x2 - other.x) + sqr(y2 - other.y));
		var x3 = other.x + (x1 - other.x) * other.light_radius / distance_1;
		var y3 = other.y + (y1 - other.y) * other.light_radius / distance_1;
		var x4 = other.x + (x2 - other.x) * other.light_radius / distance_2;
		var y4 = other.y + (y2 - other.y) * other.light_radius / distance_2;
		var xc = 0.5 * (x3 + x4);
		var yc = 0.5 * (y3 + y4);
		var distance_c = sqrt(sqr(xc - other.x) + sqr(yc - other.y));
		var x5 = x3 + (xc - other.x) * other.light_radius / distance_c;
		var y5 = y3 + (yc - other.y) * other.light_radius / distance_c;
		var x6 = x4 + (xc - other.x) * other.light_radius / distance_c;
		var y6 = y4 + (yc - other.y) * other.light_radius / distance_c;
		draw_vertex(x1 - x_offset, y1 - y_offset);
		draw_vertex(x2 - x_offset, y2 - y_offset);
		draw_vertex(x3 - x_offset, y3 - y_offset);
		draw_vertex(x4 - x_offset, y4 - y_offset);
		draw_vertex(x5 - x_offset, y5 - y_offset);
		draw_vertex(x6 - x_offset, y6 - y_offset);
		draw_primitive_end();
	}
	
	surface_reset_target();
}
draw_set_color(c_white);

// Blur shadow maps.
shader_set(shd_blur_1d);
shader_set_uniform_f_array(uniform_kernel, kernel);
with (obj_light_point) {
	shader_set_uniform_f(other.uniform_dir, 0, 16 / (2 * light_radius));
	surface_set_target(surface_shadow_map_buffer);
	draw_surface(surface_shadow_map, 0, 0);
	surface_reset_target();

	shader_set_uniform_f(other.uniform_dir, 16 / (2 * light_radius), 0);
	surface_set_target(surface_shadow_map);
	draw_surface(surface_shadow_map_buffer, 0, 0);
	surface_reset_target();
}
shader_reset();

// Composite shadow maps to create light maps.
if (!surface_exists(surface_light_map)) {
	surface_light_map = surface_create(room_width, room_height);
}

surface_set_target(surface_light_map);
shader_set(shd_light_map_point);

with (obj_light_point) {
	var x_offset = x - light_radius;
	var y_offset = y - light_radius;
	draw_surface(surface_shadow_map, x_offset, y_offset);
}

shader_reset();
surface_reset_target();

// Draw to room.
draw_surface(surface_light_map, 0, 0);
