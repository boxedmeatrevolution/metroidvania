var layer_illum = layer_get_id("Illuminate");
for (var i = 0; i < 20; ++i) {
	var ball = instance_create_layer(random(room_width), random(room_height), layer_illum, obj_test);
	ball.image_xscale = random(1) + 0.2;
	ball.image_yscale = ball.image_xscale;
}
var wall = instance_create_layer(0, 0, layer_illum, obj_background_wall);
wall.image_xscale = room_width / wall.sprite_width;
wall.image_yscale = room_height / wall.sprite_height;
