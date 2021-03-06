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

boolean gray = true;
boolean kernelb = false;
boolean histobool = true;
boolean video = false;

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
  c_img = createGraphics(w,h);
  c_edit = createGraphics(w,h);
  c_edit.beginDraw();
  c_edit.endDraw();  
  img = loadImage("img.jpg");
  img.resize(w,h);
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
Button b2 = new Button(350, 380,1, "Gray");
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
    c_img.image(myMovie.get(),0,0,w,h);
  }else {
    c_img.image(img,0,0);
  }
  c_img.endDraw();
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
    for (int i = 0; i < c_edit.height ; i++) {
      for (int j = 0; j < c_edit.width; j++) {
        float accR=0,accG=0,accB=0;
        for (int ki = 0; ki < kerneli.length; ki++) {
          for (int kj = 0; kj < kerneli.length; kj++) {
            int x = i + ki - kerneli.length/2;
            int y = j + kj - kerneli.length/2;
            if(!(x >= c_img.height || x < 0 || y < 0 || y >= c_img.width)){
              int index = x*c_img.width + y;
              int g = int((red(c_img.pixels[index]) + green(c_img.pixels[index]) + blue(c_img.pixels[index]))/3);
              accR += red(c_img.pixels[index]) * kerneli[ki][kj];
              accG += green(c_img.pixels[index])* kerneli[ki][kj];
              accB += blue(c_img.pixels[index])* kerneli[ki][kj];
            }
          }
        }
       c_edit.pixels[i*c_img.width + j] = color(accR,accG,accB);
      }      
    }    
  }
}

void update(){
  c_edit.updatePixels();
  c_img.updatePixels(); 
  
  image(c_img, 30, 30);
  image(c_edit, 615, 30);
}

void draw() {
  upText();
  upCanvas();
  
  grayf();
  
  kernelf();
  
  update();
  
  histo(histoX,histoY);
}

void movieEvent(Movie m) {
  m.read();
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
      myMovie.stop();
    }
  }
  if(b2.click()){
    kernelb = false;
    gray = true;

  }
  if(b3.click()){
    kerneli = kernel1;
    kernelb = true;
    gray = false;
  }
  if(b4.click()){
    kerneli = kernel2;
    kernelb = true;
    gray = false;
  }
  if(b5.click()){
    kerneli = kernel3;
    kernelb = true;
    gray = false;
  }
  if(b6.click()){
    kerneli = kernel4;
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
