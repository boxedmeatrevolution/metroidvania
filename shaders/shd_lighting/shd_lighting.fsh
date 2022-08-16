uniform vec3 u_GlobalLight;

uniform sampler2D s_NormalMap;
uniform sampler2D s_LightMap;
uniform vec2 u_NormalMapOffset;

varying vec2 v_TextureCoord;
varying vec4 v_Colour;

void main()
{
	vec3 normal = 2.0 * (texture2D(s_NormalMap, v_TextureCoord + u_NormalMapOffset).xyz - vec3(0.5, 0.5, 0.5));
	gl_FragColor = dot(normal, u_GlobalLight) * v_Colour * texture2D(gm_BaseTexture, v_TextureCoord);
}
