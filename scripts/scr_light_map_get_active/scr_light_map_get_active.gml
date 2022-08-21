function scr_light_map_get_active(left, right, top, bottom) {
	var lights = [];

	// Cells covered by box.
	var camera = view_get_camera(view_current);
	var view_x = camera_get_view_x(camera);
	var view_y = camera_get_view_y(camera);
	var view_width = camera_get_view_width(camera);
	var view_height = camera_get_view_height(camera);
	var ix_1 = max(0, floor(global.light_map_size_x * (left - view_x) / view_width));
	var iy_1 = max(0, floor(global.light_map_size_y * (top - view_y) / view_height));
	var ix_2 = min(global.light_map_size_x, ceil(global.light_map_size_x * (right - view_x) / view_width));
	var iy_2 = min(global.light_map_size_y, ceil(global.light_map_size_y * (bottom - view_y) / view_height));

	if (ix_2 > 0 && ix_1 < global.light_map_size_x && iy_2 > 0 || iy_1 < global.light_map_size_y) {
		for (var iy = iy_1; iy < iy_2; ++iy) {
			for (var ix = ix_1; ix < ix_2; ++ix) {
				var cell_lights = global.light_map[iy][ix];
				// Ensure no duplicates.
				for (var il1 = 0; il1 < array_length(cell_lights); ++il1) {
					var contains = false;
					for (var il2 = 0; il2 < array_length(lights); ++il2) {
						if (lights[il2] == cell_lights[il1]) {
							contains = true;
							break;
						}
					}
					if (!contains) {
						array_push(lights, cell_lights[il1]);
					}
				}
			}
		}
	}
	return lights;
}