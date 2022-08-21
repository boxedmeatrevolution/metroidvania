frames += 1;
var elapsed = (get_timer() - time_start) / 1000000;
if (elapsed > 0.5) {
	measured_fps = frames / elapsed;
	frames = 0;
	time_start = get_timer();
}
draw_set_color(c_red);
draw_text(5, 5, string(measured_fps));
