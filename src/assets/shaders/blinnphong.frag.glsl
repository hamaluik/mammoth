#ifdef GL_ES
precision mediump float;
#endif

#define NUM_DIR_LIGHTS 1
#define NUM_POINT_LIGHTS 4
#define NUM_SPOT_LIGHTS 2

struct DirLight {
	vec3 direction;
	vec3 colour;
};

struct PointLight {
	vec3 position;
	float dist;
	vec3 colour;
};

struct SpotLight {
	vec3 position;
	vec3 direction;
    float cutOff;
    float outerCutOff;
	float dist;
	vec3 colour;
};

varying vec3 v_fragPos;
varying vec3 v_normal;
varying vec2 v_uv;

uniform vec3 viewPos;
uniform vec3 ambientLight;
uniform DirLight dirLights[NUM_DIR_LIGHTS];
uniform PointLight pointLights[NUM_POINT_LIGHTS];
uniform SpotLight spotLights[NUM_SPOT_LIGHTS];

uniform sampler2D materialDiffuse;
uniform sampler2D materialSpecular;
uniform float materialShininess;

vec3 diffuse(vec3 lightDir, vec3 lightColour, vec3 norm, vec3 texDiffuse) {
	return lightColour * max(dot(norm, lightDir), 0.0) * texDiffuse;
}

vec3 specular(vec3 lightDir, vec3 norm, vec3 viewDir, vec3 texSpecular) {
	vec3 halfwayDir = normalize(lightDir + viewDir);
	float spec = pow(max(dot(norm, halfwayDir), 0.0), materialShininess);
	return spec * texSpecular;
}

float attenuation(vec3 lightPos, vec3 fragPos, float lightDistance) {
	float dist = length(lightPos - fragPos);
    /*float attenuation = clamp(1.0 - dist * dist / (lightDistance * lightDistance), 0.0, 1.0);
    return (attenuation * attenuation);*/
    return 1.0 / dist;
}

vec3 calcDirLight(DirLight light, vec3 norm, vec3 viewDir, vec3 texDiffuse, vec3 texSpecular) {
	return diffuse(light.direction, light.colour, norm, texDiffuse)
	     + specular(light.direction, norm, viewDir, texSpecular);
}

vec3 calcPointLight(PointLight light, vec3 norm, vec3 fragPos, vec3 viewDir, vec3 texDiffuse, vec3 texSpecular) {
	vec3 lightDir = normalize(light.position - fragPos);
	float att = attenuation(light.position, fragPos, light.dist);
	return (diffuse(lightDir, light.colour, norm, texDiffuse)
	      + specular(lightDir, norm, viewDir, texSpecular)) * att;
}

vec3 calcSpotLight(SpotLight light, vec3 norm, vec3 fragPos, vec3 viewDir, vec3 texDiffuse, vec3 texSpecular) {
	vec3 lightDir = normalize(light.position - fragPos);
	float att = attenuation(light.position, fragPos, light.dist);
	vec3 diff = diffuse(lightDir, light.colour, norm, texDiffuse);
	vec3 spec = specular(lightDir, norm, viewDir, texSpecular);

    // spotlight
    float theta = dot(lightDir, normalize(light.direction));
    float epsilon = light.cutOff - light.outerCutOff;
    float intensity = clamp((theta - light.outerCutOff) / epsilon, 0.0, 1.0);

    return (diff + spec) * att * intensity;
}

const float gamma = 2.2;

void main() {
	vec3 viewDir = normalize(viewPos - v_fragPos);

	vec3 texDiffuse = pow(texture2D(materialDiffuse, v_uv).rgb, vec3(gamma));
	vec3 texSpecular = pow(texture2D(materialSpecular, v_uv).rgb, vec3(gamma));

	vec3 result = ambientLight * texDiffuse;
	for(int i = 0; i < NUM_DIR_LIGHTS; i++) {
		result += calcDirLight(dirLights[i], v_normal, viewDir, texDiffuse, texSpecular);
	}
	for(int i = 0; i < NUM_POINT_LIGHTS; i++) {
		result += calcPointLight(pointLights[i], v_normal, v_fragPos, viewDir, texDiffuse, texSpecular);
	}
	for(int i = 0; i < NUM_SPOT_LIGHTS; i++) {
		result += calcSpotLight(spotLights[i], v_normal, v_fragPos, viewDir, texDiffuse, texSpecular);
	}
	gl_FragColor = vec4(result, 1.0);
}