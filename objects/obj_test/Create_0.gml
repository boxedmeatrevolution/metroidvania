global_light_phi = 0;
global_light_theta = 45;

normal_map_sprite = spr_test_normal_map;
uniform_normal_map = shader_get_sampler_index(shd_lighting, "s_NormalMap");
uniform_global_light = shader_get_uniform(shd_lighting, "u_GlobalLight");
uniform_normal_map_offset = shader_get_uniform(shd_lighting, "u_NormalMapOffset");
