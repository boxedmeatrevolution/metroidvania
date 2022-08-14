normal_map_index = shader_get_sampler_index(shd_lighting, "u_NormalMap");
normal_map = sprite_get_texture("spr_test_normal_map", 0);
texture_set_stage(normal_map_index, normal_map);
