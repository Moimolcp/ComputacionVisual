uniform int numLight;
uniform int ambiental;

varying vec4 vertColor;
varying vec3 cameraDirection;
varying vec3[8] lightDirectionReflected;

varying vec3 ecNormal;
varying vec3[8] lightDir;

void main() {
  vec3 camera = normalize(cameraDirection);
  vec3 normal = normalize(ecNormal);
  gl_FragColor = vec4(ambiental, ambiental, ambiental, 1) * vertColor; 
  for(int i = 0; i <  min(numLight,8); i++){

  	vec3 direction_esp = normalize(lightDirectionReflected[i]);  	
  	float intensity_esp = max(0.0, dot(direction_esp, camera));

  	vec3 direction_dif = normalize(lightDir[i]);  	
  	float intensity_dif = max(0.0, dot(direction_dif, normal));

  	gl_FragColor = gl_FragColor + vec4(intensity_esp, intensity_esp, intensity_esp, 1) * vertColor;
  	gl_FragColor = gl_FragColor + vec4(intensity_dif, intensity_dif, intensity_dif, 1) * vertColor;

  }
}