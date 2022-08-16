//
// Simple passthrough fragment shader
//
varying vec2 v_TextureCoord;
varying vec4 v_Colour;

void main()
{
	vec2 r = 2.0 * (v_TextureCoord - vec2(0.5, 0.5));
	float irradiance = clamp((1.0 - length(r)) * exp(-length(r) / 0.3), 0.0, 1.0) * texture2D(gm_BaseTexture, v_TextureCoord).r;
    gl_FragColor = vec4(irradiance, irradiance, irradiance, 1.0);
}
