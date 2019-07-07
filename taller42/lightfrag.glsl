uniform int lightCount;
uniform vec4 lightPosition[8];
uniform vec3 lightNormal[8];
uniform vec3 lightDiffuse[8];
uniform vec3 lightSpecular[8]; 
uniform vec3 ambient;
uniform float shininess;

varying vec4 vertColor;
varying vec3 ecNormal;

varying vec3 cameraDirection;
varying vec3 lightDir[8];
varying vec3 lightDirectionReflected[8];
varying float lightDistance[8];

void main() {
  vec3 camera = normalize(cameraDirection);
  vec3 normal = normalize(ecNormal);

  vec3 totalDiffuse = vec3(0, 0, 0);
  vec3 totalSpecular = vec3(0, 0, 0);
  for(int i = 0; i < lightCount; i++){
    
    float b = 1.0 / (500*500 * 0.9);

    float att = 1.0 / (1.0 + b*lightDistance[i]*lightDistance[i]);
    //float att = 1.0 / (1.0 + 0.00001*lightDistance[i]*lightDistance[i]);

  	vec3 direction_esp = normalize(lightDirectionReflected[i]);  	
  	totalSpecular += lightSpecular[i] * pow(max(0.0, dot(direction_esp, camera)) * att, shininess);

  	vec3 direction_dif = normalize(lightDir[i]);  	
    totalDiffuse += lightDiffuse[i] * max(0.0, dot(direction_dif, normal)) * att;

  }

  gl_FragColor = (vec4(ambient, 1) + vec4(totalDiffuse, 1) + vec4(totalSpecular, 1) ) * vec4(vertColor.xyz,1);
}