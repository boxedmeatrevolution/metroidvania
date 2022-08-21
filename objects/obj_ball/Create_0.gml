//global_light_phi = 0;
//global_light_theta = 45;

normal_map_sprite = spr_ball_normal;
uniform_normal_map = shader_get_sampler_index(shd_light_deferred, "s_NormalMap");
uniform_normal_map_offset = shader_get_uniform(shd_light_deferred, "u_NormalMapOffset");

uniform_light_map[0] = shader_get_sampler_index(shd_light_deferred, "s_LightMapHarmonic0");
uniform_light_map[1] = shader_get_sampler_index(shd_light_deferred, "s_LightMapHarmonic1");
uniform_light_map[2] = shader_get_sampler_index(shd_light_deferred, "s_LightMapHarmonic2");
uniform_light_map[3] = shader_get_sampler_index(shd_light_deferred, "s_LightMapHarmonic3");
uniform_light_map[4] = shader_get_sampler_index(shd_light_deferred, "s_LightMapHarmonic4");
uniform_viewport = shader_get_uniform(shd_light_deferred, "u_Viewport");
