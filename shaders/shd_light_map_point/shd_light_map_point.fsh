varying vec2 v_TextureCoord;
varying vec4 v_Colour;

uniform float u_LightRadiusFraction;

void main()
{
	float r = 2.0 * length(v_TextureCoord - vec2(0.5, 0.5)) / u_LightRadiusFraction;
	float irradiance = clamp((1.0 - r) * exp(-r / 0.5), 0.0, 1.0) * texture2D(gm_BaseTexture, v_TextureCoord).r;
    gl_FragColor = vec4(irradiance, irradiance, irradiance, 1.0);
}
