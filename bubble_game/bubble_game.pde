
/**Adaption of Andy Best Bubble Game tutorial, 2009 with Greg Borenstein's open cv library
 * Te very detailed tutorial for this game is here: http://www.andybest.net/2009/02/processing-opencv-tutorial-2-bubbles
 * 
 * Tega Brain, 2014.
 *
 * This is a example of background removal using Greg Borenstein's opencv library
 * Similar to Eg. 16.14 in Learning Processing by Daniel Shiffman.
 */


import processing.video.*; //we need the video library
import java.awt.*; //we need a java library
import gab.opencv.*; //we need the open cv library

OpenCV opencv;      //  Creates a new OpenCV object
Capture cam;        //Capture object
PImage movementImg, previous, current;      //  Creates a new PImages to hold the movement image, previous frame and current frame
int poppedBubbles;     //  Creates a variable to hold the total number of popped bubbles
ArrayList bubbles;     //  Creates an ArrayList to hold the Bubble objects
PImage bubblePNG;      //  Creates a PImage that will hold the image of the bubble
PFont font;            //  Creates a new font object
int threshold = 40;    // Create variable for sensitivity to movement


void setup()
{
  size(640, 480);                  //  Window size of 640 x 480
  cam = new Capture(this, 640, 480);   //  Sets the capture size
  opencv = new OpenCV(this, cam.width, cam.height);            //  Initialises the OpenCV library
  cam.start();          //start cam

  movementImg = new PImage( 640, 480 );   //  Initialises the PImage that holds the movement image

  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  

  previous = opencv.getSnapshot(); //put a frame from the video in open cv and put into PImage 'before'

  poppedBubbles = 0;              //zero popped to start       

  bubbles = new ArrayList();              //  Initialises the ArrayList to hold bubbles

  bubblePNG = loadImage("bubble.png");    //  Load the bubble image into memory
  font = loadFont("Serif-48.vlw");        //  Load the font file into memory
  textFont(font, 32);
}

//CAMERA FUNCTION
void captureEvent(Capture cam) {  // Read new images from camera
  cam.read();
}

void draw() {
  frame.setLocation(0, 0); //sets position of the frame of your sketch
  bubbles.add(new Bubble( (int)random( 0, width - 40), -bubblePNG.height, bubblePNG.width, bubblePNG.height));   //  Adds a new bubble to the array with a random x position

  opencv.loadImage(cam);               //  Captures a frame from the camera and loads it into openCV buffer
 //opencv.useColor();
  opencv.flip(1);        //  Flips the image horizontally. Input 1 for horizontal flip, 0 for vertical, -1 for both
  current = opencv.getSnapshot(); // put this in the current PImage, this is current frame
  image(current, 0, 0 );              //  Draws the camera image to the screen
  opencv.loadImage(previous);  // put the previous video frame into openCV 
 
  opencv.diff(current);                           //  Creates a difference image between previous frame and the current frame


  opencv.blur(3);                 //  Blur to remove camera noise
  opencv.threshold(threshold);                       //  Thresholds to convert to black and white
  movementImg = opencv.getSnapshot();               //  Puts the OpenCV buffer into the movmement image object

    for ( int i = 0; i < bubbles.size (); i++ ) {    //  For every bubble in the bubbles array
    Bubble _bubble = (Bubble) bubbles.get(i);    //  Copies the current bubble into a temporary object

    if (_bubble.update() == 1) {                  //  If the bubble's update function returns '1' (ie bubble has been popped)
      bubbles.remove(i);                        //  then remove the bubble from the array
      _bubble = null;                           //  and make the temporary bubble object null
      i--;                                      //  since we've removed a bubble from the array, we need to subtract 1 from i, or we'll skip the next bubble
    } else {                                        //  If the bubble's update function doesn't return '1'
      bubbles.set(i, _bubble);                  //  Copys the updated temporary bubble object back into the array
      _bubble = null;                           //  Makes the temporary bubble object null.
    }
  }


  opencv.loadImage(cam); // "Load" the camera image into OpenCV 

  opencv.flip(1);    //  This is previous camera frame so we can generate a difference image . Since we've
  //  flipped the image earlier, we need to flip it here too.
  previous = opencv.getSnapshot();  // put this image into the before PImage - in the next run of draw this will be the previous frame
  
  text("Bubbles popped: " + poppedBubbles, 20, 40);          //  Displays some text showing how many bubbles have been popped
}


// to see movement image as a bug checking thing, press a key
void keyPressed() {
  image(movementImg, 0, 0 );
}

