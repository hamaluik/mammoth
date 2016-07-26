#ifdef GL_ES
precision mediump float;
#endif

// material uniforms
uniform vec3 colour;

void main() {
	gl_FragColor = vec4(colour, 1.0);
}