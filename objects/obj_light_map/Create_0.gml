kernel = [
	0.0797,
	0.0781,
	0.0736,
	0.0666,
	0.0579,
	0.0484,
	0.0389,
	0.0300,
	0.0223,
	0.0159,
	0.0109,
	0.0071,
	0.0045,
	0.0027,
	0.0016,
	0.0009,
	0.0005,
	0.0003,
];
uniform_kernel = shader_get_uniform(shd_blur_1d, "u_Coeffs");
uniform_dir = shader_get_uniform(shd_blur_1d, "u_Dir");

uniform_light_pos = shader_get_uniform(shd_shadow_segment, "u_LightPos");


vertex_format_begin();
vertex_format_add_color();
vertex_format_add_texcoord();
vertex_format_add_texcoord();
vertex_format_add_texcoord();
format_shadow_segment = vertex_format_end();

light_active = [];
light_map_size_x = 6;
light_map_size_y = 6;
for (var ix = 0; ix < light_map_size_x; ++ix) {
	for (var iy = 0; iy < light_map_size_y; ++iy) {
		light_map[iy][ix] = [];
	}
}
