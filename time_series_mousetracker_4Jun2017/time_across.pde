int[] y;

void setup() {
  size(100,100);
  y = new int[width];
}

void draw() {
  background(204);
  for(int i= y.length-1; i > 0; i--) {
    y[i] = y [i-1];
  }
  y[0] = mouseY;
  for(int i=1; i<y.length; i++) {
    line(i, y[i], i-1, y[i-1]);
  }
}