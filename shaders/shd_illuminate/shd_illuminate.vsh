attribute vec3 in_Position;                  // (x,y,z)
//attribute vec3 in_Normal;                  // (x,y,z)     unused in this shader.
attribute vec4 in_Colour;                    // (r,g,b,a)
attribute vec2 in_TextureCoord;              // (u,v)

varying vec4 v_WorldCoord;
varying vec2 v_TextureCoord;
varying vec4 v_Colour;

void main()
{
	v_WorldCoord = vec4(in_Position.x, in_Position.y, in_Position.z, 1.0);
	gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * v_WorldCoord;
    
    v_Colour = in_Colour;
    v_TextureCoord = in_TextureCoord;
}
