attribute vec4 in_Colour;                    // (r,g,b,a)
attribute vec2 in_Endpoint1;                 // (u,v)
attribute vec2 in_Endpoint2;                 // (u,v)
attribute vec2 in_TextureCoord;              // (u,v)

uniform vec2 u_LightPos;

varying vec2 v_TextureCoord;
varying vec4 v_Colour;

void main()
{
	vec2 near_pos = mix(in_Endpoint1, in_Endpoint2, in_TextureCoord.x);
    vec4 object_space_pos = vec4(
		near_pos.x + (in_TextureCoord.y - 1.0) * u_LightPos.x,
		near_pos.y + (in_TextureCoord.y - 1.0) * u_LightPos.y,
		0.0,
		in_TextureCoord.y);

    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;

    v_Colour = in_Colour;
    v_TextureCoord = in_TextureCoord;
}
