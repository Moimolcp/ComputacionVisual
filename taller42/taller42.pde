PShape can;
float angle;

PShader lightShader;

int detail = 20;

void setup() {
  size(640, 360, P3D);
  can = createCan(100, 200, detail);
  lightShader = loadShader("lightfrag.glsl", "lightvert.glsl");
}

void draw() {    
  background(0);

  shader(lightShader);
  lightShader.set("numLight",2);
  lightShader.set("ambiental",0.01);
  pointLight(0, 0, 0, width, 1.5*height, -200);
  pointLight(0, 0, 0, width/2, 2*height, 200);
  
  translate(width/2, height/2);
  translate(-150,0,0);
  rotateY(angle);  
  shape(can);
  rotateY(-angle);
  translate(300,0,0);
  rotateY(-angle);
  shape(can);
  
  angle += 0.01;
}

PShape createCan(float r, float h, int detail) {
  textureMode(NORMAL);
  PShape sh = createShape();
  sh.beginShape(QUAD_STRIP);
  sh.noStroke();
  for (int i = 0; i <= detail; i++) {
    float angle = TWO_PI / detail;
    float x = sin(i * angle);
    float z = cos(i * angle);
    float u = float(i) / detail;
    sh.normal(x, 0, z);
    sh.vertex(x * r, -h/2, z * r, u, 0);
    sh.vertex(x * r, +h/2, z * r, u, 1);    
  }
  sh.endShape(); 
  return sh;
}

void keyPressed(){
  if(key == '+'){
    detail = min(200,detail+10);
    can = createCan(100, 200, detail);
  }
  if(key == '-'){
    detail = max(5,detail-10);
    can = createCan(100, 200, detail);
  }
}
