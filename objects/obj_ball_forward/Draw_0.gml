var normal_map = sprite_get_texture(normal_map_sprite, image_index);
var normal_map_uvs = sprite_get_uvs(normal_map_sprite, image_index);
var sprite_uvs = sprite_get_uvs(sprite_index, image_index);
var normal_map_offset_x = normal_map_uvs[0] - sprite_uvs[0];
var normal_map_offset_y = normal_map_uvs[1] - sprite_uvs[1];

shader_set(shd_light_forward);
texture_set_stage(uniform_normal_map, normal_map);
shader_set_uniform_f(uniform_normal_map_offset, normal_map_offset_x, normal_map_offset_y);

var num_lights = instance_number(obj_light_point);
var arr_shadow_map_scale = array_create(2 * num_lights);
var arr_light_coord = array_create(2 * num_lights);
var arr_light_radius = array_create(num_lights);
var arr_light_intensity = array_create(num_lights, 1);
var arr_light_colour = array_create(4 * num_lights);

var i = 0;
with (obj_light_point) {
	texture_set_stage(other.uniform_light_shadow_map[i], surface_get_texture(surface_shadow_map));
	arr_shadow_map_scale[2 * i + 0] = surface_width_full / (2 * light_radius);
	arr_shadow_map_scale[2 * i + 1] = surface_width_full / (2 * light_radius);
	arr_light_coord[2 * i + 0] = x;
	arr_light_coord[2 * i + 1] = y;
	arr_light_radius[i] = light_radius;
	arr_light_intensity[i] = light_intensity;
	arr_light_colour[4 * i + 0] = 1;
	arr_light_colour[4 * i + 1] = 1;
	arr_light_colour[4 * i + 2] = 1;
	arr_light_colour[4 * i + 3] = 1;
	i += 1;
}

shader_set_uniform_i(uniform_num_lights, num_lights);
shader_set_uniform_f_array(uniform_light_shadow_map_scale, arr_shadow_map_scale);
shader_set_uniform_f_array(uniform_light_coord, arr_light_coord);
shader_set_uniform_f_array(uniform_light_radius, arr_light_radius);
shader_set_uniform_f_array(uniform_light_intensity, arr_light_intensity);
shader_set_uniform_f_array(uniform_light_colour, arr_light_colour);

draw_self();
shader_reset();
