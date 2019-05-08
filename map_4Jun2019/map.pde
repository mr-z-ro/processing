PShape map;

void setup() {
  size(400,400);
  map = loadShape("map.svg");
  shapeMode(CENTER);
}

void draw() {
  background(200, 250, 255);
  map.disableStyle();
  fill(200);
  stroke(50);
  translate(width/2,height/2);
  float scalar = map(mouseY, 0, height, 0.1, 2.5);
  scale(scalar);
  float pan = map(mouseX, 0, width, -map.width, map.width);
  translate(pan, 0);
  shape(map, 0, 0);
}
