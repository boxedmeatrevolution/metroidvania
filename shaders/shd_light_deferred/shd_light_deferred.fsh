uniform sampler2D s_NormalMap;
uniform vec2 u_NormalMapOffset;

uniform sampler2D s_LightMapHarmonic0;
uniform sampler2D s_LightMapHarmonic1;
uniform sampler2D s_LightMapHarmonic2;
uniform sampler2D s_LightMapHarmonic3;
uniform sampler2D s_LightMapHarmonic4;

uniform vec2 u_Viewport;

varying vec2 v_TextureCoord;
varying vec4 v_Colour;

#define PI 3.1415926538

void main()
{
	vec2 normal = 2.0 * (texture2D(s_NormalMap, v_TextureCoord + u_NormalMapOffset).xy - vec2(0.5, 0.5));
	float normal_len = length(normal);
	float sin_theta = normal.y / normal_len;
	float cos_theta = -normal.x / normal_len;
	float sin_2theta = 2.0 * sin_theta * cos_theta;
	float cos_2theta = cos_theta * cos_theta - sin_theta * sin_theta;
	vec2 light_map_coord = gl_FragCoord.xy / u_Viewport;
	vec3 offset = vec3(-0.5, -0.5, -0.5);
	vec3 harmonic0 = 2.0 * (texture2D(s_LightMapHarmonic0, light_map_coord).rgb + offset);
	vec3 harmonic1 = 2.0 * (texture2D(s_LightMapHarmonic1, light_map_coord).rgb + offset);
	vec3 harmonic2 = 2.0 * (texture2D(s_LightMapHarmonic2, light_map_coord).rgb + offset);
	vec3 harmonic3 = 2.0 * (texture2D(s_LightMapHarmonic3, light_map_coord).rgb + offset);
	vec3 harmonic4 = 2.0 * (texture2D(s_LightMapHarmonic4, light_map_coord).rgb + offset); 
	vec3 irradiance = vec3(0.0, 0.0, 0.0);
	irradiance += (normal_len + 0.0 * sqrt(1.0 - normal_len * normal_len)) * (1.0 / PI) * harmonic0;
	irradiance += normal_len * 0.5 * harmonic1 * sin_theta;
	irradiance += normal_len * 0.5 * harmonic2 * cos_theta;
	irradiance += normal_len * (2.0 / (3.0 * PI)) * harmonic3 * sin_2theta;
	irradiance += normal_len * (2.0 / (3.0 * PI)) * harmonic4 * cos_2theta;
	gl_FragColor = vec4(irradiance, 1.0) * v_Colour * texture2D(gm_BaseTexture, v_TextureCoord);
}
