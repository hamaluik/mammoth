#ifdef GL_ES
precision mediump float;
#endif

varying vec3 colour;
varying vec2 v_uv;

uniform sampler2D tex;

void main() {
	gl_FragColor = texture2D(tex, v_uv) * vec4(colour, 1.0);
}