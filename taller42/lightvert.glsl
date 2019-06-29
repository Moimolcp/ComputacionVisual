uniform mat4 modelview;
uniform mat4 transform;
uniform mat3 normalMatrix;

uniform vec4[8] lightPosition;

uniform int numLight;
uniform int ambiental;


attribute vec4 position;
attribute vec4 color;
attribute vec3 normal;

varying vec4 vertColor;
varying vec3 ecNormal;
varying vec3[8] lightDir;

varying vec3 cameraDirection;
varying vec3[8] lightDirectionReflected;


void main() {
  gl_Position = transform * position;
  vec3 ecPosition = vec3(modelview * position);  
  ecNormal = normalize(normalMatrix * normal);
  
  for(int i = 0; i < min(numLight,8); i++){
  	lightDir[i] = normalize(lightPosition[i].xyz - ecPosition);
  	vec3 lightDirection = normalize(lightPosition[i].xyz - ecPosition);
  	lightDirectionReflected[i] = reflect(-lightDirection, ecNormal);
  }  
  cameraDirection = normalize(0 - ecPosition);  

  vertColor = color;
}