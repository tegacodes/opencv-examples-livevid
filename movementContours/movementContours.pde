import gab.opencv.*;
import processing.video.*;

Capture video;
OpenCV opencv;

void setup() {
  size(640, 480);
  //video = new Movie(this, "street.mov");
    video = new Capture(this, 640, 480);
  opencv = new OpenCV(this, 640, 480);
  
  opencv.startBackgroundSubtraction(5, 3, 0.5);
  
  //video.loop();
  //video.play();
  video.start();
}

//FUNCTION TO CAPTURE VIDEO
void captureEvent(Capture c) {
  c.read();
}


void draw() {
  
  image(video, 0, 0);   // draw current camera image to screen
  //comment out above line if you want to build up movement contours
  
  opencv.loadImage(video); //load current frame to opencv buffer
  
  opencv.updateBackground();
  
  //process the frame in opencv a bit
  opencv.dilate();
  opencv.erode();

  noFill();
  stroke(255, 0, 0);
  strokeWeight(3);
  
  //this is the function that finds the contours.
  for (Contour contour : opencv.findContours()) {
    contour.draw(); //draw them to the screen
  }
}



