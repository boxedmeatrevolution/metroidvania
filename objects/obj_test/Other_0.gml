var padding = 64;
if (x > room_width + padding) {
	x -= room_width + 2 * padding;
}
if (x < -padding) {
	x += room_width + 2 * padding;
}
if (y > room_height + padding) {
	y -= room_height + 2 * padding;
}
if (y < -padding) {
	y += room_height + 2 * padding;
}
