harmonic_order = 2;
surface_light_map = array_create(2 * harmonic_order + 1, noone);
surface_light_map_buffer = noone;

surface_width_full = camera_get_view_width(view_camera[0]);
surface_height_full = camera_get_view_height(view_camera[1]);
surface_scale = 0.5;
surface_width = ceil(surface_scale * surface_width_full);
surface_height = ceil(surface_scale * surface_height_full);

surface_transform = matrix_build_identity();
surface_transform_inv = matrix_build_identity();

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

uniform_light_intensity = shader_get_uniform(shd_light_map_point, "u_LightIntensity");
uniform_light_radius_fraction = shader_get_uniform(shd_light_map_point, "u_LightRadiusFraction");
uniform_harmonic_order = shader_get_uniform(shd_light_map_point, "u_HarmonicOrder");
uniform_viewport = shader_get_uniform(shd_light_map_point, "u_Viewport");
uniform_blend = shader_get_sampler_index(shd_light_map_point, "s_Blend");

vertex_format_begin();
vertex_format_add_color();
vertex_format_add_texcoord();
vertex_format_add_texcoord();
vertex_format_add_texcoord();
format_shadow_segment = vertex_format_end();
