import processing.sound.*;

FFT fft;
AudioIn in;
int bands = 1024;
float[] spectrum = new float[bands];

void setup() {
  size(1024, 360);
  background(0);
    
  // Create an Input stream which is routed into the Amplitude analyzer
  fft = new FFT(this, bands);
  in = new AudioIn(this, 0);
  
  // start the Audio Input
  in.start();
  in.play();
  
  stroke(255);
  
  // patch the AudioIn
  fft.input(in);
}      

void draw() { 
  background(0);
  fft.analyze(spectrum);

  for(int i = 0; i < bands; i++){
  // The result of the FFT is normalized
  // draw the line for frequency band i scaling it up by 5 to get more amplitude.
  int n = 5*(i/5);
  line(i-1, height - spectrum[Math.max(i-1,0)]*height*100, i, height - spectrum[i]*height*100);
  line( i, height, i, height - spectrum[n]*height*100 );
  } 
}