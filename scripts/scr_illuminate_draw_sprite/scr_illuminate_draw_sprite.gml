function scr_illuminate_draw_sprite(lights, sprite, sprite_normal_map, subimg, x, y, xscale, yscale, rot, col, alpha) {
	var num_lights = array_length(lights);
	if (num_lights == 0) {
		return;
	}
	if (num_lights > 5) {
		// TODO: Figure it out.
	}

	var normal_map = sprite_get_texture(sprite_normal_map, subimg);
	var normal_map_uvs = sprite_get_uvs(sprite_normal_map, subimg);
	var sprite_uvs = sprite_get_uvs(sprite, subimg);
	var normal_map_offset_x = normal_map_uvs[0] - sprite_uvs[0];
	var normal_map_offset_y = normal_map_uvs[1] - sprite_uvs[1];

	texture_set_stage(global.u_illuminate_normal_map, normal_map);
	shader_set_uniform_f(global.u_illuminate_normal_map_offset, normal_map_offset_x, normal_map_offset_y);

	var arr_shadow_map_offset = array_create(2 * num_lights);
	var arr_shadow_map_scale = array_create(2 * num_lights);
	var arr_light_coord = array_create(2 * num_lights);
	var arr_light_radius = array_create(num_lights);
	var arr_light_intensity = array_create(num_lights, 1);
	var arr_light_colour = array_create(4 * num_lights);

	for (var i = 0; i < num_lights; ++i) {
		var light = lights[i];
		texture_set_stage(global.u_illuminate_light_shadow_map[i], surface_get_texture(light.surface_shadow_map));
		arr_shadow_map_scale[2 * i + 0] = light.surface_width_full / (2 * light.light_radius);
		arr_shadow_map_scale[2 * i + 1] = light.surface_width_full / (2 * light.light_radius);
		arr_light_coord[2 * i + 0] = light.x;
		arr_light_coord[2 * i + 1] = light.y;
		arr_light_radius[i] = light.light_radius;
		arr_light_intensity[i] = light.light_intensity;
		arr_light_colour[4 * i + 0] = 1;
		arr_light_colour[4 * i + 1] = 1;
		arr_light_colour[4 * i + 2] = 1;
		arr_light_colour[4 * i + 3] = 1;
	}

	shader_set_uniform_i(global.u_illuminate_num_lights, num_lights);
	shader_set_uniform_f_array(global.u_illuminate_light_shadow_map_offset, arr_shadow_map_offset);
	shader_set_uniform_f_array(global.u_illuminate_light_shadow_map_scale, arr_shadow_map_scale);
	shader_set_uniform_f_array(global.u_illuminate_light_coord, arr_light_coord);
	shader_set_uniform_f_array(global.u_illuminate_light_radius, arr_light_radius);
	shader_set_uniform_f_array(global.u_illuminate_light_intensity, arr_light_intensity);
	shader_set_uniform_f_array(global.u_illuminate_light_colour, arr_light_colour);

	draw_sprite_ext(sprite, subimg, x, y, xscale, yscale, rot, col, alpha);
}