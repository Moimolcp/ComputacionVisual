int illusion = 1;
PImage img_1, img_2, img_1_n, img_2_n;

void setup() {
  size(800, 800);
  img_1 = loadImage("1.jpg");
  img_2 = loadImage("2.jpg");
  img_1.resize(width, height);
  img_2.resize(width, height);
  img_1_n = loadImage("1.jpg");
  img_2_n = loadImage("2.jpg");
  img_1_n.resize(width, height);
  img_2_n.resize(width, height);
  for (int i = 0; i < img_1.pixels.length ; i++) {
      int g = int((red(img_1.pixels[i]) + green(img_1.pixels[i]) + blue(img_1.pixels[i]))/3);
      img_1.pixels[i] = color(g);
      img_1_n.pixels[i] = color(map(g, 0, 255, 255, 0));
      g = int((red(img_2.pixels[i]) + green(img_2.pixels[i]) + blue(img_2.pixels[i]))/3);
      img_2.pixels[i] = color(g);
      img_2_n.pixels[i] = color(map(g, 0, 255, 255, 0));     
  }
}

void draw() {
  switch (illusion) {
    case 1:
      cafe_wall();
      break;
    case 2:
      foot_steps();
      break;
    case 3:
      ebbinghaus_illusion();
      break;
    case 4:
      mot_reversePhi();
      break;
    case 5:
      col_whiteXmas();
      break;
    case 6:
      break;
  }
}

// https://michaelbach.de/ot/col-whiteXmas/index.html
void col_whiteXmas(){
  fill(0);
  rect(0, 0, width/2, height);
  noStroke();

  fill(0, 0, 255);
  triangle(75, 0, 0, 300, 150, 300);
  int w = 30;
  rect(75-w/2, 300, w, w*2);
  
  // Black and White background
  int lines = 20;
  int size = height / (lines * 2);
  for(int i = 0; i < lines; i++) {
    fill(255);
    rect(0, size * (i * 2), width/2, size);
  }
  
  fill(255);
  rect(width/2, 0, width/2, height);
  noStroke();

  fill(0, 0, 255);
  triangle(75 + width/2, 0, 0 + width/2, 300, 150 + width/2, 300);
  rect(75-w/2 + width/2, 300, w, w*2);
  
  // Black and White background
  for(int i = 0; i < lines && mousePressed == false; i++) {
    fill(0);
    rect(width/2, size * (i * 2)+size, width/2, size);
  } 

}

// https://michaelbach.de/ot/mot-reversePhi/index.html
int state = 0;
void mot_reversePhi(){
  frameRate(14);
  switch(state) {
    case 0:
      image(img_1_n, 0, 0);
      state = (state + 1) % 4;
      break;
    case 1:
      image(img_2_n, 0, 0);
      state = (state + 1) % 4;
      break;
    case 2:
      image(img_1, 0, 0);
      state = (state + 1) % 4;
      break;
    case 3:
      image(img_2, 0, 0);
      state = (state + 1) % 4;
      break;
  }
}


// Movement
// http://anstislab.ucsd.edu/illusions/footsteps/
int x1 = 0, x2 = 0;
int y1 = 330, y2 = 470;
int xplus = 1;
void foot_steps() {
  background(255);
  noStroke();
  
  // Black and White background
  int lines = 20;
  int size = height / (lines * 2);
  for(int i = 0; i < lines && mousePressed == false; i++) {
    fill(0);
    rect(0, size * (i * 2), width, size);
  }
  
  // Yellow rect 
  fill(255, 255, 0);
  rect(y1, x1, size * 2, size * 4);
  
  // Blue rect 
  fill(0, 0, 102);
  rect(y2, x2, size * 2, size * 4);
  
  // Movement
  if (y1 + size * 4 > width || y1 < 0) xplus *= -1;
  x1 += xplus;
  x2 += xplus;
}

// Geometrical-Interactive
// https://en.wikipedia.org/wiki/Caf%C3%A9_wall_illusion
void cafe_wall() {
  frameRate(60);
  background(255);
  stroke(127);
  
  int n_reacts = 20;
  int size = width / n_reacts;
  for(int i = 0; i < n_reacts; i++) {
    for (int j = 0; j < n_reacts; j++) {
      if (i % 2 == 0) {
        if (j % 2 == 0) fill(0); else fill(255);
        rect(size * j, size * i , size, size);
      } else {
        if (j % 2 == 0) fill(255); else fill(0);
        float offSet = map(mouseX, 10, width - 10, 0, size);
        rect(size * j + offSet, size * i , size, size);
        if (size * j + offSet + size > width) rect(0, size * i , (size * j + offSet + size - width), size);
      }
    }
  }
  
}

// https://www.illusionsindex.org/ir/ebbinghaus-illusion
void ebbinghaus_illusion() {
  background(255);
  noStroke();
  
  // Orange circles
  fill(231, 128, 64);
  int size = 70;
  ellipse(270, 400, size, size);
  ellipse(670, 400, size, size);
  
  // Blue Circles
  if (mousePressed == false) {
    fill(146, 165, 187);
    
    // Left Circles
    int size_1 = 150;
    ellipse(190, 270, size_1, size_1);
    ellipse(350, 270, size_1, size_1);
    ellipse(190, 530, size_1, size_1);
    ellipse(350, 530, size_1, size_1);
    ellipse(100, 400, size_1, size_1);
    ellipse(440, 400, size_1, size_1);
    
    // Right Circles
    int size_2 = 40;
    ellipse(605, 400, size_2, size_2);
    ellipse(735, 400, size_2, size_2);
    ellipse(670, 465, size_2, size_2);
    ellipse(670, 335, size_2, size_2);
    ellipse(620, 450, size_2, size_2);
    ellipse(720, 450, size_2, size_2);
    ellipse(620, 350, size_2, size_2);
    ellipse(720, 350, size_2, size_2);
  }
}

void keyPressed() {
  if (key == '1') {
    illusion = 1;
  }
  
  if (key == '2') {
    illusion = 2;
  }
  
  if (key == '3') {
    illusion = 3;
  }
  
  if (key == '4') {
    illusion = 4;
  }
  
  if (key == '5') {
    illusion = 5;
  }
  
  if (key == '6') {
    illusion = 6;
  }
}
