#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;
uniform sampler2D mtexture;
uniform vec2 texOffset; // Passing by processing. That's mean (1/width, 1/height)

uniform float[] mask;

varying vec4 vertColor;
varying vec4 vertTexCoord;

void main() {
  
  vec2 tc0 = vertTexCoord.st + vec2(-texOffset.s, -texOffset.t);
  vec2 tc1 = vertTexCoord.st + vec2(         0.0, -texOffset.t);
  vec2 tc2 = vertTexCoord.st + vec2(+texOffset.s, -texOffset.t);
  vec2 tc3 = vertTexCoord.st + vec2(-texOffset.s,          0.0);
  vec2 tc4 = vertTexCoord.st + vec2(         0.0,          0.0);
  vec2 tc5 = vertTexCoord.st + vec2(+texOffset.s,          0.0);
  vec2 tc6 = vertTexCoord.st + vec2(-texOffset.s, +texOffset.t);
  vec2 tc7 = vertTexCoord.st + vec2(         0.0, +texOffset.t);
  vec2 tc8 = vertTexCoord.st + vec2(+texOffset.s, +texOffset.t);
  
  vec4 col0 = texture2D(mtexture, tc0)*mask[0];
  vec4 col1 = texture2D(mtexture, tc1)*mask[1];
  vec4 col2 = texture2D(mtexture, tc2)*mask[2];
  vec4 col3 = texture2D(mtexture, tc3)*mask[3];
  vec4 col4 = texture2D(mtexture, tc4)*mask[4];
  vec4 col5 = texture2D(mtexture, tc5)*mask[5];
  vec4 col6 = texture2D(mtexture, tc6)*mask[6];
  vec4 col7 = texture2D(mtexture, tc7)*mask[7];
  vec4 col8 = texture2D(mtexture, tc8)*mask[8];

  vec4 sum =  texture2D(mtexture, vertTexCoord.st)* vertColor ;
  sum = col4 + col0 + col1 + col2 + col3 + col5 + col6 + col7 + col8;
  
  gl_FragColor = vec4(sum.rgb, 1.0);
}