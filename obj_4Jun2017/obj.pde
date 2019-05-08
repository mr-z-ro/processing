PShape obj;

void setup() {
  size(100,100,P3D);
  obj = loadShape("test.obj");
  shapeMode(CENTER);
}

void draw() {
  background(0);
  lights();
  float scalar = 1.5;
  translate(height/2, width/2);
  scale(map(mouseY, 0, height, 0.5, 4));
  rotateY(map(mouseX, 0, width, 0, TWO_PI));
  rotateZ(PI);
  shape(obj, 20, obj.height*scalar/2, obj.width*scalar, obj.height*scalar);
}
