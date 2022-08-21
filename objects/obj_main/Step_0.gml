var delta_t = game_get_speed(gamespeed_microseconds) / 1000000;

var input_left = keyboard_check(vk_left);
var input_right = keyboard_check(vk_right);
var input_jump = keyboard_check_pressed(ord("Z"));
var input_jump_hold = keyboard_check(ord("Z"));

var grounded = !place_free(x, y + 1);

if (state == STATE_NORMAL) {
	var move_dir = input_right - input_left;
	if (grounded) {
		ascending = false;
		if (move_dir != 0) {
			if (sign(vel_x) == -move_dir) {
				vel_x += WALK_ACCEL_REVERSE * move_dir * delta_t;
			} else if (abs(vel_x) < WALK_SPEED_MIN) {
				vel_x = WALK_SPEED_MIN * move_dir;
			} else if (abs(vel_x) < WALK_SPEED_MAX) {
				vel_x += WALK_ACCEL * move_dir * delta_t;
				if (abs(vel_x) > WALK_SPEED_MAX) {
					vel_x = WALK_SPEED_MAX * sign(vel_x);
				}
			}
		}
		if (move_dir == 0 && abs(vel_x) <= WALK_SPEED_MAX) {
			var delta_vel_x = WALK_FRICTION_LOW * delta_t;
			if (vel_x < 0) {
				vel_x = min(0, vel_x + delta_vel_x);
			} else if (vel_x > 0) {
				vel_x = max(0, vel_x - delta_vel_x);
			}
		}
		if (abs(vel_x) > WALK_SPEED_MAX) {
			vel_x -= sign(vel_x) * WALK_FRICTION_HIGH * delta_t;
		}
		if (input_jump) {
			vel_y = -JUMP_SPEED;
			ascending = true;
		}
		sprite_index = spr_main_walk;
		if (move_dir != 0) {
			image_xscale = abs(image_xscale) * move_dir;
		}
		image_speed = abs(vel_x) / WALK_SPEED_MAX;
		if (vel_x == 0) {
			image_index = 0;
		}
	} else {
		if (!input_jump_hold || vel_y > 0) {
			ascending = false;
			if (vel_y < 0) {
				vel_y *= 0.9;
			}
		}
		if (move_dir != 0) {
			if (abs(vel_x) <= AIR_SPEED_MAX) {
				vel_x += AIR_ACCEL_FORWARD * move_dir * delta_t;
				if (abs(vel_x) > AIR_SPEED_MAX) {
					vel_x = AIR_SPEED_MAX * sign(vel_x);
				}
			}
		}
		if (move_dir == 0 && abs(vel_x) <= AIR_SPEED_MAX) {
			var delta_vel_x = AIR_FRICTION_LOW * delta_t;
			if (vel_x < 0) {
				vel_x = min(0, vel_x + delta_vel_x);
			} else if (vel_x > 0) {
				vel_x = max(0, vel_x - delta_vel_x);
			}
		}
		if (abs(vel_x) > AIR_SPEED_MAX) {
			vel_x -= sign(vel_x) * AIR_FRICTION_HIGH * delta_t;
		}
		if (ascending) {
			vel_y += GRAVITY_ASCEND * delta_t;
		} else {
			vel_y += GRAVITY_FALL * delta_t;
		}
		sprite_index = spr_main_jump;
		image_speed = 0;
	}
} else if (state == STATE_TRANSITION) {
	if (transition_dir_x != 0) {
		sprite_index = spr_main_walk;
		image_xscale = abs(image_xscale) * transition_dir_x;
		image_speed = abs(vel_x) / WALK_SPEED_MAX;
		vel_x = transition_dir_x * WALK_SPEED_MAX;
	}
	if (transition_dir_y != 0) {
		sprite_index = spr_main_jump;
		image_speed = 0;
		vel_y = transition_dir_y * WALK_SPEED_MAX;
	}
	if (!place_meeting(x - 32 * transition_dir_x, y - 32 * transition_dir_y, transition_zone)) {
		state = STATE_NORMAL;
	}
}

if (abs(vel_x) != 0) {
	move_contact_solid(vel_x > 0 ? 0 : 180, abs(vel_x) * delta_t);
}
if (abs(vel_y) != 0) {
	move_contact_solid(vel_y > 0 ? 270 : 90, abs(vel_y) * delta_t);
}

if (!place_free(x + sign(vel_x), y)) {
	vel_x = 0;
}
if (!place_free(x, y + sign(vel_y))) {
	vel_y = 0;
}
