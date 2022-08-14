uniform sampler2D u_NormalMap;
uniform vec2 u_GlobalLight;
varying vec2 v_TextureCoord;
varying vec4 v_Colour;

void main()
{
    //gl_FragColor = v_Colour * texture2D(gm_BaseTexture, v_TextureCoord);
	vec2 normal = 2 * (texture2D(u_NormalMap, v_TextureCoord).xy - vec2(0.5, 0.5));
	gl_FragColor = dot(normal, u_GlobalLight) * v_Colour * texture2D(gm_BaseTexture, v_TextureCoord);
	
}
