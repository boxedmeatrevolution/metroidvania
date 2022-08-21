vel_x = 0;
vel_y = 0;

STATE_NORMAL = 0;
STATE_TRANSITION = 1;

state = STATE_NORMAL;

// STATE_NORMAL
ascending = false;

// STATE_TRANSITION
transition_zone = noone;
transition_dir_x = 0;
transition_dir_y = 0;

GRAVITY_ASCEND = 1600;
GRAVITY_FALL = 2500;
JUMP_SPEED = 900;

WALK_SPEED_MIN = 120;
WALK_SPEED_MAX = 400;
WALK_ACCEL = 900;
WALK_ACCEL_REVERSE = 1700;
WALK_FRICTION_LOW = 1200;
WALK_FRICTION_HIGH = 2000;

AIR_ACCEL_FORWARD = 1100;
AIR_ACCEL_REVERSE = 800;
AIR_SPEED_MAX = 400;
AIR_FRICTION_LOW = 800;
AIR_FRICTION_HIGH = 1300;

if (variable_global_exists("transition_zone")) {
	with (obj_transition_zone) {
		if (global.transition_zone == transition_zone_id) {
			other.transition_zone = self;
			break;
		}
	}
	if (transition_zone != noone) {
		state = STATE_TRANSITION;
		x = transition_zone.x;
		y = transition_zone.y;
		if (x < 0) {
			move_contact_solid(270, 1000);
			transition_dir_x = 1;
		} else if (x > room_width) {
			move_contact_solid(270, 1000);
			transition_dir_x = -1;
		} else if (y < 0) {
			transition_dir_y = 1;
		} else if (y > room_height) {
			transition_dir_y = -1;
		} else {
			move_contact_solid(270, 1000);
			transition_dir_x = 1;
		}
		state = STATE_TRANSITION;
	}
}
