const int M = 17;
const float sigma =	5.0;

varying vec2 v_TextureCoord;
varying vec4 v_Colour;
uniform vec2 u_Dir;
uniform float u_Coeffs[M + 1];

void main()
{
	vec4 sum = u_Coeffs[0] * texture2D(gm_BaseTexture, v_TextureCoord);
	for (int i = 1; i < M; i += 1) {
		sum += u_Coeffs[i] * texture2D(gm_BaseTexture, v_TextureCoord + float(i) / sigma * u_Dir);
		sum += u_Coeffs[i] * texture2D(gm_BaseTexture, v_TextureCoord - float(i) / sigma * u_Dir);
	}
    gl_FragColor = v_Colour * sum;
}
