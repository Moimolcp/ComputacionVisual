import nub.primitives.*;
import nub.core.*;
import nub.processing.*;

Scene scene;
boolean drawAxes = false, bullseye = true;

PShape can, sphere;
float angle;
PShader lightShader;
int detail = 20;

void setup() {
  size(800, 800, P3D);
  scene = new Scene(this);
  scene.setFrustum(new Vector(0, 0, 0), new Vector(800, 800, 800));
  scene.togglePerspective();
  scene.fit();
   
  l1 = new Sphere(scene, c1, 50);
  l2 = new Sphere(scene, c2, 50);
  l1.setPosition(new Vector(width/4, height/4, 300));
  l2.setPosition(new Vector(3*width/4, 3*height/4, 300));
  l1.setPickingThreshold(50);
  l2.setPickingThreshold(50);
   
  lightShader = loadShader("lightfrag.glsl", "lightvert.glsl");
  can = createCan(100, 200, detail);
  sphere = createShape(SPHERE, 200);
}


float shininess = 1.0;
color ambient = color(32, 64, 32);
Node l1, l2;
color c1 = color(255, 0, 0); 
color c2 = color(0, 0, 255);
void draw() {    
  background(127);
  
  // Draw axes and light circles
  scene.drawAxes();
  scene.render();
  
  Vector light1 = l1.position();
  Vector light2 = l2.position();
  
  shader(lightShader);
  lightShader.set("shininess", shininess);
  // Ambient Light (Green)
  lightShader.set( "ambient", new PVector(red(ambient), green(ambient), blue(ambient)).div(255) );
  // Light1 (Red)
  lightSpecular(255, 255, 255);
  pointLight(red(c1), green(c1), blue(c1), light1.x(), light1.y(), light1.z());
  // Light2 (Blue)
  lightSpecular(255, 255, 255);
  pointLight(red(c2), green(c2), blue(c2), light2.x(), light2.y(), light2.z());
  
  // Draw the shape
  pushMatrix();
  translate(width/2, height/2);
  rotateY(angle);
  shape(sphere);
  angle += 0.01;
  popMatrix();
  
  resetShader();
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
  if(key == '1'){
   shininess = max(1, shininess/2);
  }
  if(key == '2'){
   shininess = min(128, shininess*2);
  }
}
