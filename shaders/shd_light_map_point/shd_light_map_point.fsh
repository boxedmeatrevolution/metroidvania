varying vec2 v_TextureCoord;
varying vec4 v_Colour;

uniform sampler2D s_Blend;

uniform float u_LightIntensity;
uniform float u_LightRadiusFraction;
uniform int u_HarmonicOrder;
uniform vec2 u_Viewport;

void main()
{
	vec2 r = 2.0 * (v_TextureCoord - vec2(0.5, 0.5)) / u_LightRadiusFraction;
	float mag = length(r);
	float sin_theta = r.y / mag;
	float cos_theta = r.x / mag;
	float irradiance = u_LightIntensity * clamp(1.0 - mag, 0.0, 1.0);//clamp((1.0 - mag) * exp(-mag / 0.5), 0.0, 1.0);
	vec4 shadow = texture2D(gm_BaseTexture, v_TextureCoord);
	float harmonic;
	if (u_HarmonicOrder == 0) {
		harmonic = irradiance;
	} else if (u_HarmonicOrder == 1) {
		harmonic = irradiance * sin_theta;
	} else if (u_HarmonicOrder == 2) {
		harmonic = irradiance * cos_theta;
	} else if (u_HarmonicOrder == 3) {
		harmonic = irradiance * (2.0 * sin_theta * cos_theta);
	} else if (u_HarmonicOrder == 4) {
		harmonic = irradiance * (cos_theta * cos_theta - sin_theta * sin_theta);
	}
    gl_FragColor.xyz = clamp(shadow.rgb * v_Colour.rgb * 0.5 * harmonic, -0.5, 0.5) + texture2D(s_Blend, gl_FragCoord.xy / u_Viewport).xyz;
	gl_FragColor.a = 1.0;
}
