var deferred = choose(false, true);
if (deferred) {
	for (var i = 0; i < 20; ++i) {
		var ball = instance_create_layer(random(room_width), random(room_height), layer, obj_ball_deferred);
		ball.image_xscale = random(1) + 0.2;
		ball.image_yscale = ball.image_xscale;
	}
	var wall = instance_create_layer(0, 0, layer, obj_wall_deferred);
	wall.image_xscale = room_width / wall.sprite_width;
	wall.image_yscale = room_height / wall.sprite_height;
} else {
	for (var i = 0; i < 20; ++i) {
		var ball = instance_create_layer(random(room_width), random(room_height), layer, obj_ball_forward);
		ball.image_xscale = random(1) + 0.2;
		ball.image_yscale = ball.image_xscale;
	}
	var wall = instance_create_layer(0, 0, layer, obj_wall_forward);
	wall.image_xscale = room_width / wall.sprite_width;
	wall.image_yscale = room_height / wall.sprite_height;
}
