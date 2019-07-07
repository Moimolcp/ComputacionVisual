uniform mat4 modelview;
uniform mat4 transform;
uniform mat3 normalMatrix;

uniform int lightCount;
uniform vec4 lightPosition[8];
uniform vec3 lightNormal[8];
uniform vec3 lightDiffuse[8];
uniform vec3 lightSpecular[8]; 

attribute vec4 position;
attribute vec4 color;
attribute vec3 normal;
attribute vec2 texCoord;

varying vec4 vertColor;
varying vec3 ecNormal;
varying vec3 cameraDirection;
varying vec3 lightDir[8];
varying float lightDistance[8];
varying vec3 ecPosition;
varying vec4 vertTexCoord;

void main() {
  gl_Position = transform * position;
  ecPosition = vec3(modelview * position);  
  ecNormal = normalize(normalMatrix * normal);
  
  for(int i = 0; i < lightCount; i++){
  	lightDir[i] = normalize(lightPosition[i].xyz - ecPosition);
  	vec3 lightDirection = normalize(lightPosition[i].xyz - ecPosition);
    lightDistance[i] = distance(lightPosition[i].xyz,ecPosition);
  }  
  cameraDirection = normalize(0 - ecPosition);  

  vertColor = color;
  vertTexCoord = vec4(texCoord, 1.0, 1.0);

}