import nub.primitives.*;
import nub.core.*;
import nub.processing.*;


PShape can;
float angle;
PShader lightShader;
int detail = 20;

Scene scene;
Node l1, l2;
color c1 = color(255, 0, 0), c2 = color(0, 0, 255);
boolean drawAxes = false, bullseye = true;

void setup() {
  size(800, 800, P3D);
  scene = new Scene(this);
  scene.setFrustum(new Vector(0, 0, 0), new Vector(width, height, 800));
  scene.togglePerspective();
  scene.fit();
   
  l1 = new Sphere(scene, c1, 50);
  l2 = new Sphere(scene, c2, 50);
  l1.setPosition(new Vector(width/2, height/4, 0));
  l2.setPosition(new Vector(width/2, 3*height/4, 0));
  l1.setPickingThreshold(50);
  l2.setPickingThreshold(50);
   
  can = createCan(100, 200, detail);
  lightShader = loadShader("lightfrag.glsl", "lightvert.glsl");
}

void draw() {    
  background(127);
  scene.drawAxes();
  scene.render();
  
  Vector light1 = l1.position();
  Vector light2 = l2.position();

  shader(lightShader);
  lightShader.set("numLight",2);
  lightShader.set("ambiental",0.01);
  pointLight(255, 255, 255, light1.x(), light1.y(), light1.z());
  pointLight(255, 255, 255, light2.x(), light2.y(), light2.z());
  
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

void mouseMoved() {
  scene.cast();
}

void mouseDragged() {
  if (mouseButton == LEFT)
    scene.spin();
  else if (mouseButton == RIGHT)
    scene.translate();
  else
    scene.scale(mouseX - pmouseX);
}

void mouseWheel(MouseEvent event) {
  scene.moveForward(event.getCount() * 20);
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
