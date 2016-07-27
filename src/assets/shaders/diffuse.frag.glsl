#ifdef GL_ES
precision mediump float;
#endif

varying vec3 colour;

void main() {
	gl_FragColor = vec4(colour, 1.0);
}