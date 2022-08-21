image_xscale = max(abs(image_xscale), abs(image_yscale));
image_yscale = image_xscale;

light_intensity = 1;
light_radius = 0.5 * sprite_width;

surface_shadow_map = noone;
surface_shadow_map_buffer = noone;
surface_scale = 0.25;
surface_padding = 8;
surface_width_full = 2 * (light_radius + surface_padding);
surface_width = ceil(surface_scale * surface_width_full);

surface_transform = matrix_build_identity();
surface_transform_inv = matrix_build_identity();
