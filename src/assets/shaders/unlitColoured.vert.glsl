#ifdef GL_ES
precision mediump float;
#endif

// inputs
attribute vec3 pos;

// camera uniforms
uniform mat4 MVP;

void main() {
	// set the camera-space position of the vertex
	gl_Position = MVP * vec4(pos, 1.0);
}