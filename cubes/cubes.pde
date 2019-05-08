float maxDistance;

void setup() {
  size(800,800,P3D);
  maxDistance = dist(0,0,width,height);
  fill(20);
}

void draw() {
  lights();
  background(120, 120, 180);
  stroke(130, 130, 190);
  int factor = 1;
  if (mousePressed) {
    factor = -1;
  }
  pushMatrix();
  translate(width/2, height/2);
  rotateX(map(mouseY, 0, height, HALF_PI/4, -HALF_PI/4));
  rotateY(map(mouseX, 0, width, -HALF_PI/4, HALF_PI/4));
  for(int i=-width/2; i<=width/2; i+=20) {
    for (int j=-height/2; j<=height/2; j+=20) {
        float mouseDist = dist(mouseX-width/2, mouseY-width/2, i, j);
        float diameter = constrain((mouseDist/maxDistance) * 80.0, 0, 20);
        pushMatrix();
        translate(i, j, -factor*(abs(i)+abs(j)));
        box(diameter);
        popMatrix();
    }
  }
  popMatrix();
}
