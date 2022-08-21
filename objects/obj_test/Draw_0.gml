var lights = scr_light_map_get_active(bbox_left, bbox_right, bbox_top, bbox_bottom);
scr_illuminate_draw_sprite(lights, sprite_index, spr_test_soft_normal_map, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
