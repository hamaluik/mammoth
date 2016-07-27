#ifdef GL_ES
precision mediump float;
#endif

// inputs
attribute vec3 pos;
attribute vec3 norm;

// camera uniforms
uniform mat4 MVP;
uniform mat4 M;

// light uniforms
struct SDirLight {
	vec3 dir;
	vec3 col;
};
uniform SDirLight DirLights[1];

// material uniforms
uniform vec3 diffuseColour;
uniform vec3 ambientColour;

// outputs
varying vec3 colour;

void main() {
	// set the camera-space position of the vertex
	gl_Position = MVP * vec4(pos, 1.0);

	// transform normals into world space
	vec3 worldNorm = (M * vec4(norm, 0.0)).xyz;

	// sun diffuse term
	float dLight0 = clamp(dot(worldNorm, DirLights[0].dir), 0.0, 1.0);
	
	// calculate the diffuse colour
	colour = diffuseColour * DirLights[0].col * dLight0;

	// add some ambient
	colour += diffuseColour * ambientColour;
}