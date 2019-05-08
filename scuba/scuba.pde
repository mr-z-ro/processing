import processing.pdf.*;

boolean record;

float xnoise = 0.0;
float ynoise = 0.0;
float inc = 0.01;
float yOffset = 0.0;
int gridSize = 2;

void setup() {
  size(600, 600, P3D);
  smooth(8);
}

void draw() {
  if (record) {
    // Note that #### will be replaced with the frame number. Fancy!
    beginRaw(PDF, "frame-####.pdf"); 
  }
  
  background(40, 40, 80);
  
  xnoise = 0.0;
  ynoise = yOffset;
  
  translate(0, 200, -200);
  rotateX(1.1);
  
  for (int y=height/gridSize; y > 0; y--) {
    noFill();
    beginShape();
    for (int x = 0; x < width/gridSize; x++) {
      float z = noise(xnoise, ynoise) * 255.0;
      float alpha = map(y, 0, 60, 0, 255);
      stroke(100, 100, 150, alpha);
      vertex(x*gridSize, y*gridSize, z);
      xnoise = xnoise + inc;
    }
    xnoise = 0.0;
    ynoise = ynoise + inc;
    endShape();
  }
  
  yOffset += inc/6.0;
  
  if (record) {
    endRaw();
    record = false;
  }
}

// Use a keypress so thousands of files aren't created
void mousePressed() {
  record = true;
}
