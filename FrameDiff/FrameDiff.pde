/**FrameDiff with OpenCV library and live video capture
 * Tega Brain, 2014.
 *
 * This is a example of background removal using Greg Borenstein's opencv library
 * Similar to Eg. 16.14 in Learning Processing by Daniel Shiffman.
 */


//we need the video library
import processing.video.*;
//we need a java library
import java.awt.*;
//we need the open cv library
import gab.opencv.*;

//Capture object
Capture cam;

//Opencv object
OpenCV opencv;

//Pimages to store frames and processe frames.
PImage  previous, current, grayDiff;
PImage colorDiff, binaryDiff, green;

int threshold=40;

void setup() {
  size(640, 480);

  // Start capturing at half resolution
  cam = new Capture(this, 640/2, 480/2);
  cam.start();

  // Create a new OpenCV object
  opencv = new OpenCV(this, cam.width, cam.height);

  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  

  //put a frame from the video in open cv and put into PImage 'previous'
  previous = opencv.getSnapshot();
}

// New images from camera
void captureEvent(Capture cam) {
  cam.read();
}

void draw() {
  // "Load" the current camera image into OpenCV 
  opencv.loadImage(cam);
  // we then take the opencv frame and put it in PImage called current
  current = opencv.getSnapshot();  

  // put the previous video frame, called 'current' into openCV 
  opencv.loadImage(previous);

  //call the diff function that compares what is in openCV 
  //with the current frame called 'current'
  opencv.diff(current);

  //put the opencv frame into grayDiff
  grayDiff = opencv.getSnapshot(); 


  //then perform the function threshold on the opencv frame.
  // this will give us white pixels where a pixel has changed
  opencv.threshold(threshold);  

  //this gives us a binary image
  binaryDiff = opencv.getSnapshot(); 

  //draw our frames to the screen
  image(previous, 0, 0);
  image(current, previous.width, 0);
  image(grayDiff, 0, previous.height);
  image(binaryDiff, previous.width, previous.height);

  //write titles
  fill(255);
  text("previous", 10, 20);
  text("current", previous.width +10, 20);
  text("gray diff", 10, previous.height+ 20);
  text("binary diff", previous.width + 10, previous.height+ 20);

  //do something with the binaryDiff Pimage

  float totalMovt = 0; //variable for total motion
  //run through pixels in binaryDiff
  for (int x=0; x<width/2; x++) {
    for (int y=0; y<height/2; y++) {

      //is the pixel in binaryDiff black or white?
      if (brightness(binaryDiff.pixels[x + (y * width/2)]) > 127) {  //  and if the brightness is above 127 there is movement

        totalMovt++;
      }
    }
  }
  //if total movement is above a threshold
  if (totalMovt>3000) {
    //make screen red
    background(255, 0, 0);
  }

  // "Load" the camera image into OpenCV 
  opencv.loadImage(cam);
  // put the openCV frame into the previous PImage - in the next run of draw this will be
  // the previous frame
  previous = opencv.getSnapshot();
}

