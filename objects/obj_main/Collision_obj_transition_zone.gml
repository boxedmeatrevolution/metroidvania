if (state != STATE_TRANSITION) {
	room_goto(other.room_target);
	global.transition_zone = other.transition_zone_target;
}
