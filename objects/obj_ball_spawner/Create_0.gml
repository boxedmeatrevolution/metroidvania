var obje = choose(obj_ball_forward, obj_ball_deferred);
for (var i = 0; i < 20; ++i) {
	var ball = instance_create_layer(random(room_width), random(room_height), layer, obje);
	ball.image_xscale = random(1) + 0.2;
	ball.image_yscale = ball.image_xscale;
}
