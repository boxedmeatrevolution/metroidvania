//
// Simple passthrough fragment shader
//
const int M = 17;
const float sigma =	5.0;

varying vec2 v_TextureCoord;
varying vec4 v_Colour;
uniform vec2 u_Dir;
uniform float u_Coeffs[M + 1];
//const float coeffs[M + 1] = float[](0.0003, 0.0005, 0.0009, 0.0016, 0.0027, 0.0045, 0.0071, 0.0109, 0.0159, 0.0223, 0.0300, 0.0389, 0.0484, 0.0579, 0.0666, 0.0736, 0.0781, 0.0797);

void main()
{
	vec4 sum = u_Coeffs[0] * texture2D(gm_BaseTexture, v_TextureCoord);
	for (int i = 1; i < M; i += 1) {
		sum += u_Coeffs[i] * texture2D(gm_BaseTexture, v_TextureCoord + float(i) / sigma * u_Dir);
		sum += u_Coeffs[i] * texture2D(gm_BaseTexture, v_TextureCoord - float(i) / sigma * u_Dir);
	}
    gl_FragColor = v_Colour * sum;
}
