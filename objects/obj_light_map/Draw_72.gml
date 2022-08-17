shader_set(shd_shadow_segment);
draw_set_color(c_black);
with (obj_light_point) {
	if (!surface_exists(surface_shadow_map)) {
		surface_shadow_map = surface_create(surface_width, surface_width);
	}
	if (!surface_exists(surface_shadow_map_buffer)) {
		surface_shadow_map_buffer = surface_create(surface_width, surface_width);
	}

	var origin_x = round(x * surface_scale - 0.5 * surface_width) / surface_scale;
	var origin_y = round(y * surface_scale - 0.5 * surface_width) / surface_scale;
	surface_transform = [
		1, 0, 0, 0,
		0, 1, 0, 0,
		0, 0, 1, 0,
		-origin_x, -origin_y, 0, 1 / surface_scale,
	];
	surface_transform_inv = [
		1, 0, 0, 0,
		0, 1, 0, 0,
		0, 0, 1, 0,
		origin_x * surface_scale, origin_y * surface_scale, 0, surface_scale,
	];
	surface_set_target(surface_shadow_map);
	matrix_stack_push(surface_transform);
	matrix_set(matrix_world, matrix_stack_top());
	draw_clear(c_white);

	shader_set_uniform_f(other.uniform_light_pos, x, y);

	// TODO: For static shadow objects, this buffer can be cached.
	var buffer = vertex_create_buffer();
	vertex_begin(buffer, other.format_shadow_segment);
	with (obj_shadow) {
		var count = array_length(polygon_x);
		for (var i = 0; i < count; ++i) {
			var x1 = image_xscale * polygon_x[i] + x;
			var y1 = image_yscale * polygon_y[i] + y;
			var x2 = image_xscale * polygon_x[(i + 1) % count] + x;
			var y2 = image_yscale * polygon_y[(i + 1) % count] + y;
			var backface = ((x2 - other.x) * (y1 - other.y) - (x1 - other.x) * (y2 - other.y) <= 0);
			if (!backface) {
				vertex_color(buffer, c_black, 1);
				vertex_texcoord(buffer, x1, y1);
				vertex_texcoord(buffer, x2, y2);
				vertex_texcoord(buffer, 0, 0);

				vertex_color(buffer, c_black, 1);
				vertex_texcoord(buffer, x1, y1);
				vertex_texcoord(buffer, x2, y2);
				vertex_texcoord(buffer, 1, 0);

				vertex_color(buffer, c_black, 1);
				vertex_texcoord(buffer, x1, y1);
				vertex_texcoord(buffer, x2, y2);
				vertex_texcoord(buffer, 0, 1);

				vertex_color(buffer, c_black, 1);
				vertex_texcoord(buffer, x1, y1);
				vertex_texcoord(buffer, x2, y2);
				vertex_texcoord(buffer, 0, 1);

				vertex_color(buffer, c_black, 1);
				vertex_texcoord(buffer, x1, y1);
				vertex_texcoord(buffer, x2, y2);
				vertex_texcoord(buffer, 1, 0);

				vertex_color(buffer, c_black, 1);
				vertex_texcoord(buffer, x1, y1);
				vertex_texcoord(buffer, x2, y2);
				vertex_texcoord(buffer, 1, 1);
			}
		}
	}
	vertex_end(buffer);
	vertex_submit(buffer, pr_trianglelist, sprite_get_texture(spr_block, 0));
	vertex_delete_buffer(buffer);

	matrix_stack_pop();
	matrix_set(matrix_world, matrix_stack_top());
	surface_reset_target();
}
draw_set_color(c_white);
shader_reset();

// Blur shadow maps.
shader_set(shd_blur_1d);
shader_set_uniform_f_array(uniform_kernel, kernel);

gpu_set_tex_filter(true);
with (obj_light_point) {
	shader_set_uniform_f(other.uniform_dir, 0, 8 * surface_scale / surface_width);
	surface_set_target(surface_shadow_map_buffer);
	draw_surface(surface_shadow_map, 0, 0);
	surface_reset_target();

	shader_set_uniform_f(other.uniform_dir, 8 * surface_scale / surface_width, 0);
	surface_set_target(surface_shadow_map);
	draw_surface(surface_shadow_map_buffer, 0, 0);
	surface_reset_target();
}
gpu_set_tex_filter(false);

shader_reset();

// Composite shadow maps to create light maps.
if (!surface_exists(surface_light_map)) {
	surface_light_map = surface_create(room_width, room_height);
}

surface_set_target(surface_light_map);
shader_set(shd_light_map_point);

gpu_set_tex_filter(true);
with (obj_light_point) {
	matrix_stack_push(surface_transform_inv);
	matrix_set(matrix_world, matrix_stack_top());
	shader_set_uniform_f(other.uniform_light_radius_fraction, 2 * light_radius * surface_scale / surface_width);
	draw_surface(surface_shadow_map, 0, 0);
	matrix_stack_pop();
	matrix_set(matrix_world, matrix_stack_top());
}
gpu_set_tex_filter(false);

shader_reset();
surface_reset_target();

// Draw to room.
draw_surface(surface_light_map, 0, 0);
