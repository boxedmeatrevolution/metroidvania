normal_map_sprite = spr_test_soft_normal_map;
uniform_normal_map = shader_get_sampler_index(shd_light_forward, "s_NormalMap");
uniform_normal_map_offset = shader_get_uniform(shd_light_forward, "u_NormalMapOffset");

uniform_num_lights = shader_get_uniform(shd_light_forward, "u_NumLights");
uniform_light_shadow_map[0] = shader_get_sampler_index(shd_light_forward, "s_LightShadowMap0");
uniform_light_shadow_map[1] = shader_get_sampler_index(shd_light_forward, "s_LightShadowMap1");
uniform_light_shadow_map[2] = shader_get_sampler_index(shd_light_forward, "s_LightShadowMap2");
uniform_light_shadow_map[3] = shader_get_sampler_index(shd_light_forward, "s_LightShadowMap3");
uniform_light_shadow_map[4] = shader_get_sampler_index(shd_light_forward, "s_LightShadowMap4");
uniform_light_shadow_map_offset = shader_get_uniform(shd_light_forward, "u_LightShadowMapOffset");
uniform_light_shadow_map_scale = shader_get_uniform(shd_light_forward, "u_LightShadowMapScale");
uniform_light_coord = shader_get_uniform(shd_light_forward, "u_LightCoord");
uniform_light_radius = shader_get_uniform(shd_light_forward, "u_LightRadius");
uniform_light_intensity = shader_get_uniform(shd_light_forward, "u_LightIntensity");
uniform_light_colour = shader_get_uniform(shd_light_forward, "u_LightColour");

hspeed = random(1) - 0.5;
vspeed = random(1) - 0.5;
