#ifdef GL_ES
precision mediump float;
#endif

uniform sampler2D scene;
uniform vec2 screenSize;

const float ge = 1.0/2.2;

void main() {
	vec4 colour = texture2D(scene, gl_FragCoord.xy / screenSize);
	colour.rgb = pow(colour.rgb, vec3(ge));
	gl_FragColor = colour;
}