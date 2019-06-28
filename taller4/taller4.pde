import processing.video.*;
Movie myMovie;

PGraphics c_img;
PGraphics c_edit;
PImage img, img2;

int histo[] = new int[256];

int minMouse = 0;
int maxMouse = 0;

int maxGray = 255;
int minGray = 0;

int histoX = 615;
int histoY = 570;

float kerneli[][] = {{0,0,0},{0,1,0},{0,0,0}};                   //identidad
float kernel1[][] = {{-1,-1,-1},{-1,8,-1},{-1,-1,-1}};           //Edge Detection
float kernel2[][] = {{0,-1,0},{-1,5,-1},{0,-1,0}};               //Sharpen
float kernel3[][] = {{0.111,0.111,0.111},{0.111,0.111,0.111},{0.111,0.111,0.111}}; //Box blur
float kernel4[][] = {{0.0625,0.125,0.0625},{0.125,0.24,0.125},{0.0625,0.125,0.0625}}; //Gaussian blur

float kerneliv[] = {0,0,0,0,1,0,0,0,0};                   //identidad
float kernel1v[] = {-1,-1,-1,-1,8,-1,-1,-1,-1};           //Edge Detection
//float kernel1v[] = {0,0,0,0,1,0,0,0,0};
float kernel2v[] = {0,-1,0,-1,5,-1,0,-1,0};               //Sharpen
float kernel3v[] = {0.111,0.111,0.111,0.111,0.111,0.111,0.111,0.111,0.111}; //Box blur
float kernel4v[] = {0.0625,0.125,0.0625,0.125,0.24,0.125,0.0625,0.125,0.0625}; //Gaussian blur



boolean gray = false;
boolean kernelb = true;
boolean histobool = true;
boolean video = false;

PImage shimg;
boolean shaderbool = false;
int shaderindex = 0;
PShape window;
PShader sh;

class Button{
  int x,y,f;
  String text;
  Button(int x, int y,int f, String text){    
    this.x = x;
    this.y = y;
    this.f = f;
    this.text = text;
  }
  boolean click(){
    boolean bx = x < mouseX && x + 150 > mouseX;
    boolean by = y < mouseY && y + 50 > mouseY;
    return bx && by?true:false;
  }
  void draw(PGraphics p){
    fill(255);
    p.rect(x, y, 150, 50, 7);
    p.textSize(12);
    fill(0, 0, 0);
    p.text(text,x+25,y+30);   
    fill(255);
  }
}


int w = 555;
int h = 312;

void setup() {
  size(1200, 600, P2D);
  myMovie = new Movie(this, "test.mkv");
  c_img = createGraphics(w,h, P2D);
  c_edit = createGraphics(w,h, P2D);
  c_edit.beginDraw();
  c_edit.endDraw();  
  img = loadImage("img.jpg");
  img.resize(w,h);
  window = createWindow(w,h,img,100);
  sh = loadShader("maskfrag.glsl");
  
}

void histo(int x,int y){  
  if(gray){
    for (int i = 0; i < histo.length; i ++) {  
      int aux = int(map(histo[i],0,max(histo),0, 213));
      if(i <= maxGray && i >= minGray)stroke(12);
      else stroke(255);
      line(x+i*2, y, x+i*2, y-aux);
    }
    stroke(0);
  }
}

Button b1 = new Button(150, 380,1, "Video");
Button b2 = new Button(350, 380,1, "Hardware");
Button b3 = new Button(150, 440,1, "Edge");
Button b4 = new Button(350, 440,1, "Sharpen");
Button b5 = new Button(150, 500,1, "Box blur");
Button b6 = new Button(350, 500,1, "Gaussian blur");

void upText(){
  background(209);
  fill(0);
  text("FrameRate: " + frameRate/60 * 100 + " %", 615, 352);
  
  b1.draw(g);
  b2.draw(g);
  b3.draw(g);
  b4.draw(g);
  b5.draw(g);
  b6.draw(g);
}

void upCanvas(){
  c_img.beginDraw();
  if (video) {
    if(myMovie.available()){
      myMovie.read();
      shimg = myMovie;
      c_img.image(shimg,0,0,w,h);
    }    
  }else {
    shimg = img;
    c_img.image(shimg,0,0,w,h);
  }
  c_img.endDraw();
  c_edit.loadPixels();
  c_img.loadPixels();
}

void grayf(){
   if(gray){
      histo = new int[256];
      for (int i = 0; i < c_edit.pixels.length ; i++) {
        int g = int((red(c_img.pixels[i]) + green(c_img.pixels[i]) + blue(c_img.pixels[i]))/3);
        if(g <= maxGray && g >= minGray){
          c_edit.pixels[i] = color(g);
        }else{
          c_img.pixels[i] = color(0,0,0);
          c_edit.pixels[i] = color(0,0,0);
        }
        histo[g] = histo[g]+1;
      }
   }
}

void kernelf(){
  if(kernelb){
    if(shaderbool){
      shader(sh);
      sh.set("mask",kerneliv);
      sh.set("mtexture",shimg);
      shape(window,615, 30);
      resetShader();
      //println("Hard");
    }else{
      //println("Soft");
      for (int i = 0; i < c_edit.height ; i++) {
        for (int j = 0; j < c_edit.width; j++) {
          float accR=0,accG=0,accB=0;
          for (int ki = 0; ki < kerneli.length; ki++) {
            for (int kj = 0; kj < kerneli.length; kj++) {
              int x = i + ki - kerneli.length/2;
              int y = j + kj - kerneli.length/2;
              if(!(x >= c_img.height || x < 0 || y < 0 || y >= w)){
                int index = x*c_img.width + y;
                int g = int((red(c_img.pixels[index]) + green(c_img.pixels[index]) + blue(c_img.pixels[index]))/3);
                accR += red(c_img.pixels[index]) * kerneli[ki][kj];
                accG += green(c_img.pixels[index])* kerneli[ki][kj];
                accB += blue(c_img.pixels[index])* kerneli[ki][kj];
              }
            }
          }
         c_edit.pixels[i*c_edit.width + j] = color(accR,accG,accB);
        }      
      }
    }
  }
}

void update(){
  
  c_edit.updatePixels();
  c_img.updatePixels();
  image(c_img, 30, 30);
  if(!shaderbool)image(c_edit, 615, 30);
}

void draw() {
  upText();
  upCanvas();
  
  grayf();
  
  kernelf();
  
  update();
  
  histo(histoX,histoY);
}


void mousePressed(){
  minMouse = mouseX;
}

void mouseReleased(){
  maxMouse = mouseX;
  if(width/2 < mouseX){    
    minGray = (minMouse - histoX)/2;
    maxGray = (maxMouse - histoX)/2;
  }
 
  if(b1.click()){
    video = !video;
    if (b1.text == "Video") {
      b1.text = "Imagen";
      myMovie.loop();
    } else {
      b1.text = "Video";
      myMovie.loop();
    }
  }
  if(b2.click()){
    shaderbool = !shaderbool;
    if (shaderbool) {
      b2.text = "Software";
    } else {
      b2.text = "Hardware";
    }    
    //gray = true;
  }
  if(b3.click()){
    kerneli = kernel1;
    kerneliv = kernel1v;
    kernelb = true;
    gray = false;
  }
  if(b4.click()){
    kerneli = kernel2;
    kerneliv = kernel2v;
    kernelb = true;
    gray = false;
  }
  if(b5.click()){
    kerneli = kernel3;
    kerneliv = kernel3v;
    kernelb = true;
    gray = false;
  }
  if(b6.click()){
    kerneli = kernel4;
    kerneliv = kernel4v;
    kernelb = true;
    gray = false;
  }  
  
}


void keyPressed(){
  if(key == 'a'){
    gray = !gray;    
  }else if(key == 's') {    
    kernelb = !kernelb;
  }
}

PShape createWindow(int imageW, int imageH,PImage img, int detail) {
  
  PShape wd = createShape();
  
  wd.beginShape(QUAD_STRIP); // First 4 coordinates generate an rectangle the next two too.
  wd.noStroke();
  wd.textureMode(NORMAL); // Normalize the coordinates in texture [0,1]
  wd.texture(img);
  for (float i = 0; i <= detail; i++) {
    float u = i / detail;
    float x = (float(imageW) / detail) * i;    
    wd.vertex(x, 0, u, 0);
    wd.vertex(x, imageH, u, 1);
  }
  wd.endShape();  
  return wd;
}
