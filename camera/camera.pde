import processing.video.*;

Capture cam;

void setup() {
  size(640, 480, P3D);

  String[] cameras = Capture.list();
  
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    
    // The camera can be initialized directly using an 
    // element from the array returned by list():
    cam = new Capture(this, cameras[0]);
    cam.start();     
  }      
}

void draw() {
  if (cam.available() == true) {
    cam.read();
  }
  pushMatrix();
  rotateX(map(mouseY, 0, height, HALF_PI/4, -HALF_PI/4));
  rotateY(map(mouseX, 0, width, -HALF_PI/4, HALF_PI/4));
  scale(-1, 1);
  image(cam, -cam.width, 0);
  popMatrix();
  // The following does the same, and is faster when just drawing the image
  // without any additional resizing, transformations, or tint.
  //set(0, 0, cam);
}