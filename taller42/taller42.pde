import nub.primitives.*;
import nub.core.*;
import nub.processing.*;

Scene scene;
boolean drawAxes = false, bullseye = false;

PShape can, sphere,box;
float angle;
PShader lightShader;
int detail = 20;

Node[] lights = new Node[8];
color[] colors = new color[8];
int nlights = 2;


void setup() {
  size(800, 800, P3D);
  scene = new Scene(this);
  scene.setFrustum(new Vector(0, 0, 0), new Vector(800, 800, 800));
  scene.togglePerspective();
  scene.fit();
  
  colors[0] = color(255, 0, 0); 
  colors[1] = color(0, 0, 255);  
  for(int i = 2;i < 8;i++){
    colors[i] = color(random(255), random(255), random(255));
  }   
  for(int i = 0;i < 8;i++){
    lights[i] = new Sphere(scene, colors[i], 50);
    lights[i].setPosition(new Vector(random(-2*width/4,2*width/4), random(-height/2,height/2), 300));
    lights[i].setPickingThreshold(50);
    lights[i].cull(true);
  }  
  
  lightShader = loadShader("lightfrag.glsl", "lightvert.glsl");
  can = createCan(100, 200, detail);
  noStroke();
  sphere = createShape(SPHERE, 200);
  box = createShape(BOX, 400);
}


float shininess = 1.0;
color ambient = color(32, 64, 32);

void draw() {    
  background(127);
  
  // Draw axes and light circles
  scene.drawAxes();
  scene.render();
  
  shader(lightShader);
  lightShader.set("shininess", shininess);
  // Ambient Light (Green)
  lightShader.set( "ambient", new PVector(red(ambient), green(ambient), blue(ambient)).div(255) );
  // Light1 (Red)
  
  for(int i = 0;i < nlights;i++){
    lights[i].cull(false);
    Vector lightv = lights[i].position();
    lightSpecular(red(colors[i]), green(colors[i]), blue(colors[i]));
    pointLight(red(colors[i]), green(colors[i]), blue(colors[i]), lightv.x(), lightv.y(), lightv.z());
  }
  
  // Draw the shape
  pushMatrix();
  translate(width/2, height/2);
  shape(sphere);
  translate(width, 0);
  shape(box);
  
  translate(-2*width, 0);
  rotateY(angle);
  shape(can);
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
  if(key == 'w'){
    nlights += 1;
    nlights = min(nlights,8);
    for(int i = 0;i < 8;i++){
      if(nlights <= i){
        lights[i].cull(true);  
      }else{
        lights[i].cull(false);
      }
    }
    
  }
  if(key == 's'){
    nlights -= 1;
    nlights = max(nlights,2);
    for(int i = 0;i < 8;i++){
      if(nlights <= i){
        lights[i].cull(true);  
      }else{
        lights[i].cull(false);
      }
    }
  }
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
