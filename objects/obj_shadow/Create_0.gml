var offset_x = sprite_get_xoffset(sprite_index);
var offset_y = sprite_get_yoffset(sprite_index);
var width = sprite_get_width(sprite_index);
var height = sprite_get_height(sprite_index);
polygon_x = [ offset_x, offset_x + width, offset_x + width, offset_x ];
polygon_y = [ offset_y, offset_y, offset_y + height, offset_y + height ];
