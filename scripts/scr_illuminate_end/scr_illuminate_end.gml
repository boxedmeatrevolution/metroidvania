function scr_illuminate_end() {
	if (event_type == ev_draw && event_number == 0) {
		gpu_pop_state();
		shader_reset();
	}
}