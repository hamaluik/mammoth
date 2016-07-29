#ifdef GL_ES
precision mediump float;
#endif

// vertex shader outputs
varying vec2 v_uv;

// material uniforms
uniform vec3 colour;
uniform sampler2D tex;

void main() {
	gl_FragColor = texture2D(tex, v_uv) * vec4(colour, 1.0);
}