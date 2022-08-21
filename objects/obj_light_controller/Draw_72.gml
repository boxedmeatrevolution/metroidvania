gpu_push_state();
gpu_set_tex_filter(true);
gpu_set_zwriteenable(true);



// Assign lights to light map.
var camera = view_get_camera(view_current);
var view_x = camera_get_view_x(camera);
var view_y = camera_get_view_y(camera);
var view_width = camera_get_view_width(camera);
var view_height = camera_get_view_height(camera);
global.light_active = [];
for (var iy = 0; iy < global.light_map_size_y; ++iy) {
	for (var ix = 0; ix < global.light_map_size_x; ++ix) {
		global.light_map[iy][ix] = [];
	}
}
with (obj_light_point) {
	var ix_1 = max(0, floor(global.light_map_size_x * (bbox_left - view_x) / view_width));
	var iy_1 = max(0, floor(global.light_map_size_y * (bbox_top - view_y) / view_height));
	var ix_2 = min(global.light_map_size_x, ceil(global.light_map_size_x * (bbox_right - view_x) / view_width));
	var iy_2 = min(global.light_map_size_y, ceil(global.light_map_size_y * (bbox_bottom - view_y) / view_height));
	if (ix_2 > 0 && ix_1 < global.light_map_size_x && iy_2 > 0 || iy_1 < global.light_map_size_y) {
		array_push(global.light_active, self);
		for (var iy = iy_1; iy < iy_2; ++iy) {
			for (var ix = ix_1; ix < ix_2; ++ix) {
				array_push(global.light_map[iy][ix], self);
			}
		}
	}
}



// Draw shadows.
shader_set(shd_shadow_segment);
draw_set_color(c_black);
for (var light_idx = 0; light_idx < array_length(global.light_active); ++light_idx) {
	var light = global.light_active[light_idx];
	if (!surface_exists(light.surface_shadow_map)) {
		light.surface_shadow_map = surface_create(light.surface_width, light.surface_width);
	}
	if (!surface_exists(light.surface_shadow_map_buffer)) {
		light.surface_shadow_map_buffer = surface_create(light.surface_width, light.surface_width);
	}

	// TODO: It would be better to adjust to snap to pixel when possible.
	var origin_x = light.x - 0.5 * light.surface_width_full;//round(light.x * light.surface_scale - 0.5 * light.surface_width) / light.surface_scale;
	var origin_y = light.y - 0.5 * light.surface_width_full;//round(light.y * light.surface_scale - 0.5 * light.surface_width) / light.surface_scale;
	light.surface_transform = [
		1, 0, 0, 0,
		0, 1, 0, 0,
		0, 0, 1, 0,
		-origin_x, -origin_y, 0, 1 / light.surface_scale,
	];
	light.surface_transform_inv = [
		1, 0, 0, 0,
		0, 1, 0, 0,
		0, 0, 1, 0,
		origin_x * light.surface_scale, origin_y * light.surface_scale, 0, light.surface_scale,
	];
	surface_set_target(light.surface_shadow_map);
	matrix_stack_push(light.surface_transform);
	matrix_set(matrix_world, matrix_stack_top());
	draw_clear(c_white);

	shader_set_uniform_f(global.u_shadow_light_pos, light.x, light.y);

	// TODO: For static shadow objects, this buffer can be cached.
	var buffer = vertex_create_buffer();
	vertex_begin(buffer, global.format_shadow_segment);
	with (obj_shadow) {
		var count = array_length(polygon_x);
		for (var i = 0; i < count; ++i) {
			var x1 = image_xscale * polygon_x[i] + x;
			var y1 = image_yscale * polygon_y[i] + y;
			var x2 = image_xscale * polygon_x[(i + 1) % count] + x;
			var y2 = image_yscale * polygon_y[(i + 1) % count] + y;
			var backface = ((x2 - light.x) * (y1 - light.y) - (x1 - light.x) * (y2 - light.y) <= 0);
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

var blur_radius = 8;
for (var light_idx = 0; light_idx < array_length(global.light_active); ++light_idx) {
	var light = global.light_active[light_idx];
	shader_set_uniform_f(global.u_blur_dir, 0, blur_radius * light.surface_scale / light.surface_width);
	surface_set_target(light.surface_shadow_map_buffer);
	draw_surface(light.surface_shadow_map, 0, 0);
	surface_reset_target();

	shader_set_uniform_f(global.u_blur_dir, blur_radius * light.surface_scale / light.surface_width, 0);
	surface_set_target(light.surface_shadow_map);
	draw_surface(light.surface_shadow_map_buffer, 0, 0);
	surface_reset_target();
}

shader_reset();



gpu_pop_state();
