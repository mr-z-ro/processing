int offsetCircle;
int stepSize;

void setup() {
  size(600, 600);
  stepSize=10;
}

void draw() {
  background(255);
  int d = 5;
  noFill();
  int i = 1;
  offsetCircle = 1;
  while (d < width*sqrt (2)) {
    if (i == offsetCircle && mousePressed) {
      ellipse(mouseX, mouseY, d+2, d+2);
      ellipse(mouseX, height-mouseY, d+2, d+2);
      ellipse(width-mouseX, mouseY, d+2, d+2);
      ellipse(width-mouseX, height-mouseY, d+2, d+2);
      offsetCircle += 1;
    } else {
      ellipse(width/2, height/2, d, d);
    }
    d += stepSize;  
    i += 1;
  }
}

