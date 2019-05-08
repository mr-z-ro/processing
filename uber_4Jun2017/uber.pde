/**
* Subject: Uber Pickup Locations
* Author: @msgrasser
* Data Source: https://github.com/fivethirtyeight/uber-tlc-foil-response
*/

/* Declare data containers */
Table table;
Loc[] d;

/* Initialize clock */
int min = 0;
int hr = 0;
int day = 0;

/* Initialize pickups for a given minute */
int n_min = 0;

/* Initialize viewport */
int centerOffsetX = 0;
int centerOffsetY = 0;
int initialMouseX = 0;
int initialMouseY = 0;
int delX = 0;
int delY = 0;
float mouseLat;
float mouseLon;
float fov = PI/3.0; // default cam field of vision angle
float cameraZ;
float minmapZ;
float mapZ;

/* 
*  Set up bounding geocoordinates:
*  Used http://boundingbox.klokantech.com for NYC bounding box
*  which is -74.4669476748,40.5663004507,-73.4694536924,40.98787416
*/
float lat_min = 40.5663004507;
float lat_max = 40.98787416;
float lon_min = -74.4669476748;
float lon_max = -73.4694536924;

/* Declare graphics layers */
PGraphics z;
PGraphics m;
PGraphics s;
PGraphics b;
PGraphics t;
PGraphics c;

void setup() {
  background(0); // set bg
  
  /* Import the csv, load the data */
  table = loadTable("ubermod.csv", "header");
  d = new Loc[table.getRowCount()];
  int i=0;
  for (TableRow row : table.rows()) { 
   float lat = row.getFloat("lat");
   float lon = row.getFloat("lon");
   Integer mow = row.getInt("mow");
   
   d[i] = new Loc(lat, lon, mow);
   i++;
  }
  
  /* Set up the drawing params and surfaces */
  size(640, 360, P3D);
  frameRate(60); // 1 sec of video = 1 hour of data
  noCursor();
  smooth(4);
  z = createGraphics(width, 10);
  m = createGraphics(10*width, 10*height, P3D);
  s = createGraphics(width, 30);
  b = createGraphics(width, 10);
  t = createGraphics(width, 10);
  c = createGraphics(width, height);
  
  cameraZ = (height/2.0) / tan(fov/2.0); // default camera z pos
  minmapZ = -cameraZ * 10;
  mapZ = minmapZ;
  perspective(fov, float(width)/float(height), cameraZ/10.0, -minmapZ);
}

void draw() {
  /* Reset the pickup count for this minute */
  n_min = 0;
  
  /* Create the map surface and draw pickup locations to it */
  m.beginDraw();
  if (min % (60*24) == 0) {
    m.background(0);
  }
  setColors(m);
  for(Loc l : d) {
    l.draw();
  }
  m.endDraw();
  
  /* Draw the map layer */
  pushMatrix();
  resetMatrix();
  setmapZPan();
  translate(centerOffsetX, centerOffsetY, mapZ);
  image(m, -m.width/2, -m.height/2);
  popMatrix();
  
  /* Create and draw layer to display mapZ/pan params */
  z.beginDraw();
  z.background(0);
  z.fill(200, 50, 50);
  z.textSize(8);
  z.text("Lat: " + mouseLat + " | Lon: " + mouseLon, 0, 10);
  z.text("mapZ: " + mapZ + " | camZ: " + cameraZ, z.width-200, 10);
  z.endDraw();
  image(z, 0, 0);
  
  /* Create and draw the stats chart layer */
  s.beginDraw();
  setColors(s);
  s.line(map(min, 0, 10080, 0, s.width), s.height, map(min, 0, 10080, 0, s.width), map(n_min, 0, 263, s.height, 0));  
  s.endDraw();
  image(s, 0, height - 40);
  
  /* Create and draw the stats text layer */
  t.beginDraw();
  t.background(0);
  t.fill(200, 50, 50);
  t.textSize(8);
  t.text("DAY " + day + " | HOUR " + hr + " | MINUTE " + (min%60), 5+map(min, 0, 10080, 0, t.width), 10);
  t.endDraw();
  image(t, 0, height-10);
  
  /* Create and draw the progress bar layer */
  b.beginDraw();
  b.fill(40);
  b.stroke(200, 50, 50);
  b.rect(0, 0, map(min, 0, 10080, 0, b.width), 10);
  b.endDraw();
  image(b, 0, height-10);
  
  /* Create cursor layer and draw lines to it */
  c.beginDraw();
  c.clear();
  c.stroke(50);
  c.line(0, mouseY, c.width, mouseY);
  c.line(mouseX, 0, mouseX, c.height);
  c.endDraw();
  image(c, 0, 0);
  
  /* Set the coordinates */
  printCoords();
  
  /* Update the clock */
  if (min % (60*24) == 0) {
    day++;
    hr=0;
  } else if (min % (60*4) == 0) {
    hr++;
  } else if (min % 60 == 0) {
    hr++;
  }
  min++;
  
  /* Save the frame for creation of a movie */
  //saveFrame("frames/####.png");
}

void setColors(PGraphics l) {
  if (hr % 3 == 0) {
    l.stroke(200, 80, 80, 100);
    l.fill(200, 80, 80, 100);
  } else if (hr % 3 == 1) {
    l.stroke(80, 200, 80, 100);
    l.fill(80, 200, 80, 100);
  } else {
    l.stroke(80, 80, 200, 100);
    l.fill(80, 80, 200, 100);
  }
}

void setmapZPan() {
  if (mousePressed) { // pan
    if(initialMouseX == 0) {
      initialMouseX = mouseX;
    }
    delX = mouseX - initialMouseX;
    centerOffsetX = centerOffsetX + delX/2;
    if (initialMouseY == 0) {
      initialMouseY = mouseY;
    }
    delY = mouseY - initialMouseY;
    centerOffsetY = centerOffsetY + delY/2;
  } else { // mapZ
    if (keyPressed == true && key == CODED) {
      if (keyCode == UP) {
        mapZ = constrain(mapZ + 10, minmapZ, -cameraZ);
      } else if (keyCode == DOWN) {
        mapZ = constrain(mapZ - 10, minmapZ, -cameraZ);
      }
    } else {
      initialMouseX = 0;
      initialMouseY = 0;
    }
  }
}

public void printCoords() {
  float mouseCenterX = mouseX-width/2.0-centerOffsetX; // xpos in view plane
  float mouseCenterY = mouseY-height/2.0-centerOffsetY; // ypos in view plane
  float mouseMapCenterX = abs(mapZ)/cameraZ * mouseCenterX; // xpos in map plane
  float mouseMapCenterY = abs(mapZ)/cameraZ * mouseCenterY; // ypos in map plane
  float mouseMapX = mouseMapCenterX + m.width/2;
  float mouseMapY = mouseMapCenterY + m.height/2;
  mouseLon = map(mouseMapX, 0, m.width, lon_min, lon_max);
  mouseLat = map(mouseMapY, m.height, 0, lat_min, lat_max);
  
  //println("Mc:" + m.width + "," + m.height);
  //println("Mm:" + mouseMapCenterX + "," + mouseMapCenterY);
  //println("Ma:" + mouseMapX + "," + mouseMapY);
  //println("Ml:" + mouseLat + "," + mouseLon);
  //println("C_:" + centerOffsetX + "," + centerOffsetY);
}

class Loc {
  float lat;
  float lon;
  int mow;
  
  public Loc(float lat, float lon, int mow) {
    this.lat = lat;
    this.lon = lon;
    this.mow = mow;
  }
  
  public void draw() {
    if (this.mow == min) {
      int x = floor(map(this.lon, lon_min, lon_max, 0, m.width));
      int y = floor(map(this.lat, lat_min, lat_max, m.height, 0));
      m.ellipse(x, y, 3, 3);
      n_min++;
    }
  }
}

/*

To Export: (https://trac.ffmpeg.org/wiki/Create%20a%20video%20slideshow%20from%20images)
ffmpeg -framerate 60 -start_number 17 -i frames/%04d.png -c:v libx264 -r 60 -pix_fmt yuv420p out.mp4

To Add Audio:
http://superuser.com/questions/590201/add-audio-to-video-using-ffmpeg
ffmpeg -i out.mp4 -i "/Users/matt/Downloads/Radiators From Space, The/Sound City Beat/13 - Morning Dew.mp3" -c copy -map 0:0 -map 1:0 output.mp4
*/