//var global_light_x = dsin(global_light_theta) * dcos(global_light_phi);
//var global_light_y = dsin(global_light_theta) * dsin(global_light_phi);
//var global_light_z = dcos(global_light_theta);

var normal_map = sprite_get_texture(normal_map_sprite, image_index);
var normal_map_uvs = sprite_get_uvs(normal_map_sprite, image_index);
var sprite_uvs = sprite_get_uvs(sprite_index, image_index);
var normal_map_offset_x = normal_map_uvs[0] - sprite_uvs[0];
var normal_map_offset_y = normal_map_uvs[1] - sprite_uvs[1];

shader_set(shd_light_deferred);
texture_set_stage(uniform_normal_map, normal_map);
shader_set_uniform_f(uniform_normal_map_offset, normal_map_offset_x, normal_map_offset_y);
for (var i = 0; i < 5; ++i) {
	texture_set_stage(uniform_light_map[i], surface_get_texture(obj_light_map.surface_light_map[i]));
}
shader_set_uniform_f(uniform_viewport, camera_get_view_width(view_camera[0]), camera_get_view_height(view_camera[0]));
draw_self();
shader_reset();
