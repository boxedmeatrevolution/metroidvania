function scr_illuminate_begin() {
	if (event_type == ev_draw && event_number == 0) {
		shader_set(shd_illuminate);
		gpu_push_state();
		gpu_set_tex_filter(true);
	}
}