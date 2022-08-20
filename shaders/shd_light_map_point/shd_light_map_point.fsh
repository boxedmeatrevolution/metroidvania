varying vec2 v_TextureCoord;
varying vec4 v_Colour;

uniform sampler2D s_Blend;

uniform float u_LightIntensity;
uniform float u_LightRadiusFraction;
uniform int u_HarmonicOrder;
uniform vec2 u_Viewport;

#define PI 3.1415926538

void main()
{
	vec2 r = 2.0 * (v_TextureCoord - vec2(0.5, 0.5)) / u_LightRadiusFraction;
	float mag = length(r);
	float sin_theta = r.y / mag;
	float cos_theta = r.x / mag;
	float irradiance = u_LightIntensity * clamp((1.0 - mag) * exp(-mag / 0.5), 0.0, 1.0);
	vec4 shadow = texture2D(gm_BaseTexture, v_TextureCoord);
	float harmonic;
	if (u_HarmonicOrder == 0) {
		harmonic = irradiance / PI;
	} else if (u_HarmonicOrder == 1) {
		harmonic = -0.5 * irradiance * sin_theta;
	} else if (u_HarmonicOrder == 2) {
		harmonic = 0.5 * irradiance * cos_theta;
	} else if (u_HarmonicOrder == 3) {
		harmonic = -(2.0 * irradiance) / (3.0 * PI) * (2.0 * sin_theta * cos_theta);
	} else if (u_HarmonicOrder == 4) {
		harmonic =(2.0 * irradiance) / (3.0 * PI) * (cos_theta * cos_theta - sin_theta * sin_theta);
	}
    gl_FragColor.xyz = clamp(shadow.xyz * v_Colour.xyz * harmonic, -0.5, 0.5) + texture2D(s_Blend, gl_FragCoord.xy / u_Viewport).xyz;
	gl_FragColor.a = 1.0;
}
