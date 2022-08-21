#define NUM_LIGHTS (5)

uniform sampler2D s_NormalMap;
uniform vec2 u_NormalMapOffset;

uniform int u_NumLights;
uniform sampler2D s_LightShadowMap0;
uniform sampler2D s_LightShadowMap1;
uniform sampler2D s_LightShadowMap2;
uniform sampler2D s_LightShadowMap3;
uniform sampler2D s_LightShadowMap4;
uniform vec2 u_LightShadowMapScale[NUM_LIGHTS];
uniform vec2 u_LightCoord[NUM_LIGHTS];
uniform float u_LightRadius[NUM_LIGHTS];
uniform float u_LightIntensity[NUM_LIGHTS];
uniform vec4 u_LightColour[NUM_LIGHTS];

varying vec4 v_WorldCoord;
varying vec2 v_TextureCoord;
varying vec4 v_Colour;

vec4 sample_shadow_map(int index, vec2 coord) {
	if (index == 0) {
		return texture2D(s_LightShadowMap0, coord);
	} else if (index == 1) {
		return texture2D(s_LightShadowMap1, coord);
	} else if (index == 2) {
		return texture2D(s_LightShadowMap2, coord);
	} else if (index == 3) {
		return texture2D(s_LightShadowMap3, coord);
	} else if (index == 4) {
		return texture2D(s_LightShadowMap4, coord);
	} else {
		return vec4(1.0, 1.0, 0.0, 1.0);
	}
}

void main()
{
	vec2 normal = 2.0 * (texture2D(s_NormalMap, v_TextureCoord + u_NormalMapOffset).xy - vec2(0.5, 0.5));
	normal.y = -normal.y;
	float normal_len = length(normal);
	vec3 irradiance = vec3(0.0, 0.0, 0.0);
	for (int i = 0; i < u_NumLights; ++i) {
		vec2 r = (u_LightCoord[i] - v_WorldCoord.xy / v_WorldCoord.w) / u_LightRadius[i];
		float mag = length(r);
		vec2 r_unit = r / mag;
		vec3 source = u_LightIntensity[i] * u_LightColour[i].rgb;
		vec2 shadow_coord = -0.5 * r / u_LightShadowMapScale[i] + vec2(0.5, 0.5);
		vec3 shadow = sample_shadow_map(i, shadow_coord).rgb;
		float falloff = clamp((1.0 - mag) * exp(-mag / 0.5), 0.0, 1.0);
		float surface = max(dot(normal, r_unit), 0.0) + 0.3;
		irradiance += source * shadow * falloff * surface;// * surface;
	}
	gl_FragColor = vec4(irradiance, 1.0) * v_Colour * texture2D(gm_BaseTexture, v_TextureCoord);
}
