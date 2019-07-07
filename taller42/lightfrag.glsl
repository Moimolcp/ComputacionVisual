uniform int lightCount;
uniform vec4 lightPosition[8];
uniform vec3 lightNormal[8];
uniform vec3 lightDiffuse[8];
uniform vec3 lightSpecular[8]; 
uniform vec3 ambient;
uniform float shininess;
uniform bool bump = false; 

uniform sampler2D BumpMap;

varying vec4 vertColor;
varying vec3 ecNormal;
varying vec4 vertTexCoord;
varying vec3 ecPosition;
varying vec3 cameraDirection;
varying vec3 lightDir[8];
varying float lightDistance[8];

void main() {

  vec3 camera = normalize(cameraDirection);
  vec3 normal = normalize(ecNormal);  
  mat3 TBN = mat3(vec3(1,0,0), vec3(0,1,0), vec3(0,0,1));

  if(bump){
    
    vec3 Q1 = dFdx(ecPosition);
    vec3 Q2 = dFdy(ecPosition);
    vec2 st1 = dFdx(vertTexCoord.xy);
    vec2 st2 = dFdy(vertTexCoord.xy);

    vec3 T = normalize(Q1*st2.t - Q2*st1.t);
    vec3 B = normalize(-Q1*st2.s + Q2*st1.s);
    TBN = mat3(T, B, ecNormal);

    camera = normalize(TBN*camera);
    normal = texture2D(BumpMap, vertTexCoord.xy).rgb*2.0 - 1.0;
    normal = normalize(normal);
    //normal.y = -normal.y;
  }

  vec3 totalDiffuse = vec3(0, 0, 0);
  vec3 totalSpecular = vec3(0, 0, 0);
  for(int i = 0; i < lightCount; i++){

    vec3 lightDirTS = TBN * normalize( lightDir[i] );
    
    float b = 1.0 / (500*500 * 0.9);

    float att = 1.0 / (1.0 + b*lightDistance[i]*lightDistance[i]);
    //float att = 1.0 / (1.0 + 0.00001*lightDistance[i]*lightDistance[i]);

  	vec3 direction_esp = normalize(lightDirTS);
    vec3 ref = reflect( -direction_esp, normal);

  	totalSpecular += lightSpecular[i] * pow(max(0.0, dot(ref, camera)) , shininess)* att;

  	vec3 direction_dif = normalize(lightDirTS);
    totalDiffuse += lightDiffuse[i] * max(0.0, dot(direction_dif, normal)) * att;

  }

  gl_FragColor = (vec4(ambient, 1) + vec4(totalDiffuse, 1) + vec4(totalSpecular, 1) ) * vec4(vertColor.xyz,1);
}