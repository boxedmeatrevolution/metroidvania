// Get normal map.
var normal_map = sprite_get_texture(normal_map_sprite, image_index);
var normal_map_uvs = sprite_get_uvs(normal_map_sprite, image_index);
var sprite_uvs = sprite_get_uvs(sprite_index, image_index);
var normal_map_offset_x = normal_map_uvs[0] - sprite_uvs[0];
var normal_map_offset_y = normal_map_uvs[1] - sprite_uvs[1];

// Find active lights.
var camera = view_get_camera(view_current);
var view_x = camera_get_view_x(camera);
var view_y = camera_get_view_y(camera);
var view_width = camera_get_view_width(camera);
var view_height = camera_get_view_height(camera);
var light_active = [];
var ix_1 = max(0, floor(obj_light_map.light_map_size_x * (bbox_left - view_x) / view_width));
var iy_1 = max(0, floor(obj_light_map.light_map_size_y * (bbox_top - view_y) / view_height));
var ix_2 = min(obj_light_map.light_map_size_x, ceil(obj_light_map.light_map_size_x * (bbox_right - view_x) / view_width));
var iy_2 = min(obj_light_map.light_map_size_y, ceil(obj_light_map.light_map_size_y * (bbox_bottom - view_y) / view_height));
if (ix_2 > 0 && ix_1 < obj_light_map.light_map_size_x && iy_2 > 0 || iy_1 < obj_light_map.light_map_size_y) {
	for (var iy = iy_1; iy < iy_2; ++iy) {
		for (var ix = ix_1; ix < ix_2; ++ix) {
			var cell_lights = obj_light_map.light_map[iy][ix];
			for (var il1 = 0; il1 < array_length(cell_lights); ++il1) {
				var contains = false;
				for (var il2 = 0; il2 < array_length(light_active); ++il2) {
					if (light_active[il2] == cell_lights[il1]) {
						contains = true;
						break;
					}
				}
				if (!contains) {
					array_push(light_active, cell_lights[il1]);
				}
			}
		}
	}
}

var num_lights = array_length(light_active);
if (num_lights == 0) {
	draw_set_color(c_yellow);
	draw_circle(x, y, 16, false);
	draw_set_color(c_white);
	exit;
}

shader_set(shd_light_forward);
texture_set_stage(uniform_normal_map, normal_map);
shader_set_uniform_f(uniform_normal_map_offset, normal_map_offset_x, normal_map_offset_y);


var arr_shadow_map_offset = array_create(2 * num_lights);
var arr_shadow_map_scale = array_create(2 * num_lights);
var arr_light_coord = array_create(2 * num_lights);
var arr_light_radius = array_create(num_lights);
var arr_light_intensity = array_create(num_lights, 1);
var arr_light_colour = array_create(4 * num_lights);

for (var i = 0; i < num_lights; ++i) {
	var light = light_active[i];
	texture_set_stage(uniform_light_shadow_map[i], surface_get_texture(light.surface_shadow_map));
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

shader_set_uniform_i(uniform_num_lights, num_lights);
shader_set_uniform_f_array(uniform_light_shadow_map_offset, arr_shadow_map_offset);
shader_set_uniform_f_array(uniform_light_shadow_map_scale, arr_shadow_map_scale);
shader_set_uniform_f_array(uniform_light_coord, arr_light_coord);
shader_set_uniform_f_array(uniform_light_radius, arr_light_radius);
shader_set_uniform_f_array(uniform_light_intensity, arr_light_intensity);
shader_set_uniform_f_array(uniform_light_colour, arr_light_colour);

draw_self();
shader_reset();
