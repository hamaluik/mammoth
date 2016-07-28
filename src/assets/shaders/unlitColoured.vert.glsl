#ifdef GL_ES
precision mediump float;
#endif

// inputs
attribute vec3 pos;
attribute vec2 uv;

// camera uniforms
uniform mat4 MVP;

// outputs
varying vec2 v_uv;

void main() {
	// set the camera-space position of the vertex
	gl_Position = MVP * vec4(pos, 1.0);

	// interpolate the UV
	v_uv = uv;
}