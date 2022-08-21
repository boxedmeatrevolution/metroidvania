var lights = scr_light_map_get_active(bbox_left, bbox_right, bbox_top, bbox_bottom);
scr_illuminate_draw_sprite(lights, sprite_index, spr_wall_normal, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
