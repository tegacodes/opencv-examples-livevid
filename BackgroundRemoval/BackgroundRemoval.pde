/**Background Removal with OpenCV library and live video capture
 * Tega Brain, 2014.
 *
 * This is a example of background removal using Greg Borenstein's opencv library
 * Similar to Eg. 16.12 in Learning Processing by Daniel Shiffman.
 *
 * You set the background by clicking the mouse
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
PImage  background, current, grayDiff;
PImage colorDiff, binaryDiff, green;

int threshold=35;

void setup() {
  size(640, 480);

  // Start capturing at half resolution
  cam = new Capture(this, 640/2, 480/2);
  cam.start();

  // Create a new OpenCV object
  opencv = new OpenCV(this, cam.width, cam.height);

  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  

  //put a frame from the video in open cv and put into PImage 'background'
  background = opencv.getSnapshot();
}

// New images from camera
void captureEvent(Capture cam) {
  cam.read();
}

void draw() {

  // We have to always "load" the current camera image into OpenCV 
  opencv.loadImage(cam);

  // we then take this snapshot and put it in PImage called current
  current = opencv.getSnapshot();  

  // put the previous video frame, called 'current' into openCV 
  opencv.loadImage(background);

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
  image(background, 0, 0);
  image(current, background.width, 0);
  image(grayDiff, 0, background.height);
  image(binaryDiff, background.width, background.height);

  //write titles
  fill(255);
  text("background", 10, 20);
  text("current", background.width +10, 20);
  text("gray diff", 10, background.height+ 20);
  text("binary diff", background.width + 10, background.height+ 20);

  //do something with the binary diff image - create a green screen
 /*
  //initiate green with whatever is in opencv
   opencv.loadImage(cam);
   green = opencv.getSnapshot(); 
   
   //run through pixels in binaryDiff
   for (int x=0; x<width/2; x++) {
   for (int y=0; y<height/2; y++) {
   
   //is the pixel in binaryDiff black or white?
   if (brightness(binaryDiff.pixels[x + (y * width/2)]) < 127) {  //  and if the brightness is above 127 (in this case, if it is white)
   //opencv = new OpenCV(this, cam.width, cam.height);
   
   //set pixels to green in green PImage at the location of pixels are black
   green.pixels[x + (y * width/2)] = color(0,255,0);
   }
   
   }
   }
   image(green, 0, background.height);
   text("green screen", 10, background.height+ 20);
   */
}


//set the background frame by clicking the mouse
void mouseReleased() {
  // We have to always "load" the current camera image into OpenCV 
  opencv.loadImage(cam);
  background = opencv.getSnapshot();
}

