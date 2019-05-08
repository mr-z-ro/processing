import org.openkinect.processing.*; //<>//

// Kinect Library object
Kinect2 kinect2;

// Angle for rotation
float a = 0;
int zoom = -500;

// Draw every 'skip'th pixel
int skip = 3;
int threshMin = 500;
int threshMax = 700;
int sumX;
int sumY;
int minZ;
int numPoints;

void setup() {

  // Rendering in P3D
  size(800, 600, P3D);

  kinect2 = new Kinect2(this);
  kinect2.initDepth();
  kinect2.initDevice();
}


void draw() {
  background(0);

  // Translate and rotate
  pushMatrix();
  translate(width/2, height/2, zoom);
  rotateY(a);

  // Get the raw depth as array of integers
  int[] depth = kinect2.getRawDepth();

  beginShape(POINTS);
  sumX = 0;
  sumY = 0;
  minZ = 4500;
  numPoints = 0;
  for (int x = 0; x < kinect2.depthWidth; x+=skip) {
    for (int y = 0; y < kinect2.depthHeight; y+=skip) {
      int offset = x + y * kinect2.depthWidth;
  
      //calculte the x, y, z camera position based on the depth information
      int d = depth[offset];
      PVector point = depthToPointCloudPos(x, y, d);
       
      if (d > threshMin && d < threshMax) {
        stroke(0, 0, 255);
        sumX += x;
        sumY += y;
        minZ = Math.min(minZ, d);
        numPoints += 1;
      } else {
        stroke(255);
      }
      
      // Draw a point
      vertex(point.x, point.y, point.z);
    }
  }
  endShape();
  popMatrix();
  
  if (numPoints > 0) {
    pushMatrix();
    PVector tracker = depthToPointCloudPos(sumX/numPoints, sumY/numPoints, minZ);
    translate(width/2, height/2, zoom);
    rotateY(a);
    translate(tracker.x, tracker.y, tracker.z);
    fill(0, 255, 0);
    sphere(20);
    popMatrix();
  }

  fill(255, 0, 0);
  int avgX = (numPoints > 0) ? sumX/numPoints : 0;
  int avgY = (numPoints > 0) ? sumY/numPoints : 0;
  text(frameRate + "\n" + numPoints + "\n" + avgX + "," + avgY, 50, 50);
}

void keyPressed() {
  if (key == '2') {
    skip = 2;
  } else if (key == '3') {
    skip = 3;
  } else if (key == '4') {
    skip = 4;
  } else if (key == '5') {
    skip = 5;
  } else if (keyCode == LEFT) {
    a += 0.03f;
  } else if (keyCode == RIGHT) {
    a -= 0.03f;
  } else if (keyCode == DOWN) {
    zoom -= 100;
  } else if (keyCode == UP) {
    zoom += 100;
  }
}

//calculte the xyz camera position based on the depth data
PVector depthToPointCloudPos(int x, int y, float depthValue) {
  PVector point = new PVector();
  point.z = -(depthValue);// / (1.0f); // Convert from mm to meters
  point.x = -(x - CameraParams.cx) * point.z / CameraParams.fx;
  point.y = -(y - CameraParams.cy) * point.z / CameraParams.fy;
  return point;
}