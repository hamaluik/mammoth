#ifdef GL_ES
precision mediump float;
#endif

// inputs
attribute vec3 pos;
attribute vec3 norm;
attribute vec2 uv;

// camera uniforms
uniform mat4 MVP;
uniform mat4 M;

// outputs
varying vec3 v_fragPos;
varying vec3 v_normal;
varying vec2 v_uv;

void main() {
	// set the camera-space position of the vertex
	gl_Position = MVP * vec4(pos, 1.0);

	// transform frag coordinates into world space
	v_fragPos = (M * vec4(pos, 1.0)).xyz;

	// transform normals into world space
	v_normal = normalize((M * vec4(norm, 0.0)).xyz);

	// interpolate the UV
	v_uv = uv;
}