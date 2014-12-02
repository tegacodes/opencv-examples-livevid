<h1>Basic Computer Vision Examples with Greg Borenstein's openCV library for Processing</h1>  
A few classic processing examples using  with live video capture.  

His openCV library is here: https://github.com/atduskgreg/opencv-processing  

Some of the functions from the open cv library used here:  


<code>opencv.loadImage(cam); </code>  
loadImage loads frame of video or a PImage into the opencv buffer.
  
<code>opencv.getSnapshot();</code>   
getSnapshot creates a PImage of whatever is in your opencv buffer. So usually you would have something like  
<code>diffImage = opencv.getSnapshot();</code> where diffImage is a PImage you have declared earlier.
  
<code>opencv.diff(current); </code>   
diff creates a difference image between whatever is in your opencv buffer and the PImage you have input as your argument, in this case the PImage, current.  

<code>opencv.blur(3);</code>  
Applys a blur to whatever is in your opencv buffer

<code>opencv.threshold(value); </code>  
Creates a PImage that is a binary image. The argument 'value', means that pixels are evaluated in the opencv buffer as having changed more or less than this set threshold. This function create a binary movement image in these examples.

<code>opencv.flip(1);</code>   
Flips the opencv buffer   
1 - horizonal flip  
0 - vertical flip  
-1 - flips both  
  
<code>opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE); </code>   





Tega Brain, 2014.
