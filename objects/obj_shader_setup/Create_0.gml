var kernel = [
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
global.u_blur_kernel = shader_get_uniform(shd_blur_1d, "u_Coeffs");
global.u_blur_dir = shader_get_uniform(shd_blur_1d, "u_Dir");
shader_set_uniform_f_array(global.u_blur_kernel, kernel);

global.u_shadow_light_pos = shader_get_uniform(shd_shadow_segment, "u_LightPos");

vertex_format_begin();
vertex_format_add_color();
vertex_format_add_texcoord();
vertex_format_add_texcoord();
vertex_format_add_texcoord();
global.format_shadow_segment = vertex_format_end();

global.u_illuminate_normal_map = shader_get_sampler_index(shd_illuminate, "s_NormalMap");
global.u_illuminate_normal_map_offset = shader_get_uniform(shd_illuminate, "u_NormalMapOffset");

global.u_illuminate_num_lights = shader_get_uniform(shd_illuminate, "u_NumLights");
global.u_illuminate_light_shadow_map[0] = shader_get_sampler_index(shd_illuminate, "s_LightShadowMap0");
global.u_illuminate_light_shadow_map[1] = shader_get_sampler_index(shd_illuminate, "s_LightShadowMap1");
global.u_illuminate_light_shadow_map[2] = shader_get_sampler_index(shd_illuminate, "s_LightShadowMap2");
global.u_illuminate_light_shadow_map[3] = shader_get_sampler_index(shd_illuminate, "s_LightShadowMap3");
global.u_illuminate_light_shadow_map[4] = shader_get_sampler_index(shd_illuminate, "s_LightShadowMap4");
global.u_illuminate_light_shadow_map_offset = shader_get_uniform(shd_illuminate, "u_LightShadowMapOffset");
global.u_illuminate_light_shadow_map_scale = shader_get_uniform(shd_illuminate, "u_LightShadowMapScale");
global.u_illuminate_light_coord = shader_get_uniform(shd_illuminate, "u_LightCoord");
global.u_illuminate_light_radius = shader_get_uniform(shd_illuminate, "u_LightRadius");
global.u_illuminate_light_intensity = shader_get_uniform(shd_illuminate, "u_LightIntensity");
global.u_illuminate_light_colour = shader_get_uniform(shd_illuminate, "u_LightColour");
