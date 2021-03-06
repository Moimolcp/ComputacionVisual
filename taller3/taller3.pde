import nub.timing.*;
import nub.primitives.*;
import nub.core.*;
import nub.processing.*;

// 1. Nub objects
Scene scene;
Node node;
Vector v1, v2, v3, p;

// timing
TimingTask spinningTask;
boolean yDirection;
// scaling is a power of 2
int n = 4;

// 2. Hints
boolean triangleHint = true;
boolean gridHint = true;
boolean debug = false;
boolean antialiasing = true;

// 3. Use FX2D, JAVA2D, P2D or P3D
String renderer = P3D;

// 4. Window dimension
int dim = 9;

void settings() {
  size(int(pow(2, dim)), int(pow(2, dim)), renderer);
}

void setup() {
  scene = new Scene(this);
  if (scene.is3D())
    scene.setType(Scene.Type.ORTHOGRAPHIC);
  scene.setRadius(width/2);
  scene.fit(1);

  // not really needed here but create a spinning task
  // just to illustrate some nub.timing features. For
  // example, to see how 3D spinning from the horizon
  // (no bias from above nor from below) induces movement
  // on the node instance (the one used to represent
  // onscreen pixels): upwards or backwards (or to the left
  // vs to the right)?
  // Press ' ' to play it
  // Press 'y' to change the spinning axes defined in the
  // world system.
  spinningTask = new TimingTask() {
    @Override
    public void execute() {
      scene.eye().orbit(scene.is2D() ? new Vector(0, 0, 1) :
        yDirection ? new Vector(0, 1, 0) : new Vector(1, 0, 0), PI / 100);
    }
  };
  scene.registerTask(spinningTask);
  
  node = new Node();
  node.setScaling(width/pow(2, n));

  // init the triangle that's gonna be rasterized
  randomizeTriangle();
  println("Anti-aliasing: " + scale + "x");
}

void draw() {
  background(0);
  stroke(0, 255, 0);
  if (gridHint)
    scene.drawGrid(scene.radius(), (int)pow(2, n));
  if (triangleHint)
    drawTriangleHint();
  pushMatrix();
  pushStyle();
  scene.applyTransformation(node);
  triangleRaster();
  popStyle();
  popMatrix();
}

// Implement this function to rasterize the triangle.
// Coordinates are given in the node system which has a dimension of 2^n
int[][] colorV = { {255,0,0},{0,0,255},{0,255,0} };
int scale = 4;
void triangleRaster() {
  // node.location converts points from world to node
  // here we convert v1 to illustrate the idea

  strokeWeight(0);
  rectMode(CENTER);
  
  float sx = width / int(pow(2, n)); 
  float sy = height / int(pow(2, n));
  for (float i = -width/2 + sx/2; i <= width/2; i = i + sx) {
    for (float j = -height/2 +sy/2; j <= height/2; j = j + sy) {
      Vector p = new Vector(i, j);

      // 2. Sombrear su superficie a partir de los colores de sus vértices.
      float area = (edgeFunction(v1, v2, v3));
      float w1 = (edgeFunction(v1, v2, p))/area;
      float w2 = (edgeFunction(v2, v3, p))/area;
      float w3 = (edgeFunction(v3, v1, p))/area;

      int red = int(colorV[0][0]*w1 + colorV[1][0]*w2 + colorV[2][0]*w3);
      int green = int(colorV[0][1]*w1 + colorV[1][1]*w2 + colorV[2][1]*w3);
      int blue = int(colorV[0][2]*w1 + colorV[1][2]*w2 + colorV[2][2]*w3);
      //println("color " + red + " " + green + " " + blue);  

      // 3. Algoritmo de Anti-aliasing
      int sum = 0;
      for (float k = i - sx/2 + sx/(scale*2); k < i + sx/2; k += sx/scale) {
        for (float l = j - sy/2 + sy/(scale*2); l < j + sy/2; l += sy/scale) {
          Vector ps = new Vector(k, l);
          if (inside(v1,v2,v3,ps)) {
            sum += 1;
          }
        }
      }
      int alpha = int(255 * sum / (scale * scale));

      // Draw rect
      fill(red, green, blue, alpha);  
      rect(node.location(p).x(), node.location(p).y(),1,1);
    }
  }
  
  if (debug) {
    pushStyle();
    stroke(255, 255, 0, 125);
    strokeWeight(2);
    point(round(node.location(v1).x()), round(node.location(v1).y()));
    popStyle();
  }
}

float edgeFunction(Vector a, Vector b, Vector c){
    return ((c.x() - a.x()) * (b.y() - a.y()) - (c.y() - a.y()) * (b.x() - a.x()));
}

boolean inside(Vector a, Vector b, Vector c, Vector p){
  boolean b1 = edgeFunction(a, b, p) >= 0;
  boolean b2 = edgeFunction(b, c, p) >= 0;
  boolean b3 = edgeFunction(c, a, p) >= 0;
  return b1 && b2 && b3;
}

void randomizeTriangle() {
  int low = -width/2;
  int high = width/2;
  v1 = new Vector(random(low, high), random(low, high));
  v2 = new Vector(random(low, high), random(low, high));
  v3 = new Vector(random(low, high), random(low, high));
  if(edgeFunction(v1,v2,v3) < 0){
    Vector aux = v1;
    v1 = v2;
    v2 = aux;
  }
}

void drawTriangleHint() {
  pushStyle();
  noFill();
  strokeWeight(2);
  stroke(255, 0, 0);
  triangle(v1.x(), v1.y(), v2.x(), v2.y(), v3.x(), v3.y());
  strokeWeight(5);
  stroke(0, 255, 255);
  point(v1.x(), v1.y());
  point(v2.x(), v2.y());
  point(v3.x(), v3.y());
  popStyle();
}

void keyPressed() {
  if (key == '1') {
    if (scale > 1) scale /= 2;
    println("Anti-aliasing: " + scale + "x");
  }
  if (key == '2') {
    scale *= 2;
    println("Anti-aliasing: " + scale + "x");
  }
  if (key == 'g')
    gridHint = !gridHint;
  if (key == 't')
    triangleHint = !triangleHint;
  if (key == 'd')
    debug = !debug;
  if (key == '+') {
    n = n < 7 ? n+1 : 2;
    node.setScaling(width/pow( 2, n));
  }
  if (key == '-') {
    n = n >2 ? n-1 : 7;
    node.setScaling(width/pow( 2, n));
  }
  if (key == 'r')
    randomizeTriangle();
  if (key == ' ')
    if (spinningTask.isActive())
      spinningTask.stop();
    else
      spinningTask.run(20);
  if (key == 'y')
    yDirection = !yDirection;
}
