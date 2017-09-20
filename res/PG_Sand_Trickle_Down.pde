
//==========================================================
// sketch: PG_Sand_Trickle_Down.pde - by Gerd Platl
//
// Basic code by C.Reas and B.Fry, Processing. page 340
//
// v1.0  2014-07-30  inital release
// v1.1  2014-11-18  Android version
// v1.2  2015-05-24  bug correction for JavaScript
// v1.3  2015-12-03  dynamic increase of particles
//       2015-12-03  working on...
//
// tags: faces, animation, simulation, pixel, trickle down, sand, famous
//
// tested with:   processing v1.5.1, v2.2.1, v3.0.1
//==========================================================
/** 
 Sand trickle down over famous faces.
 Move mouse up and down to change speed of falling sand. 
 Click to change face.
 Note: use Java mode to increase animation quality! 
*/

/* @pjs preload="maestros/apj.png" */   
/* @pjs preload="maestros/rabindranath.png" */   
/* @pjs preload="maestros/swami.png" */   
/* @pjs preload="maestros/tata.png" */   
/* @pjs preload="maestros/rk.png" */   
/* @pjs preload="maestros/homi.png" */   
    
final boolean AndroidMode = false;
boolean debug = false;
boolean showFPS = false;  // show frames per second

int num = 42000;    // max. number of sand particles
int usedParticles = 8000;
int[] x = new int[num];
int[] y = new int[num]; 
int picIndex, maxpixel;
int startMouseX = 0;
color sandColor = color (255);
PImage img;
String names[] = 
{
  "maestros/apj.png", 
  "maestros/rabindranath.png",
  "maestros/swami.png", 
  "maestros/tata.png",
  "maestros/rk.png", 
  "maestros/homi.png"
};
int pictures = names.length;

//--------------------------------------
void setup()
{
  //size (displayWidth, displayHeight, P2D); 
  size(480, 600);    // for PC
  frameRate(60);

  maxpixel = height * width;
  if (debug) println ("pixels: "+maxpixel);
  selectPicture(0); 
  textSize (14);
}
//--------------------------------------
void setting()   // v3.0
{
  if (AndroidMode)
  { orientation(PORTRAIT); // for Android, crashes with JavaScript!
    noSmooth();
    usedParticles = 4000;
    frameRate(30);
  }
}
//--------------------------------------
void draw()
{
  background(40);
  loadPixels();
  int offset = 0;
  float speedFactor = 6 + (mouseY * 16.0) / height;
  for (int si = 0; si < usedParticles; si++)
  {
    color c = img.get(x[si], y[si]); 
    float b = 0.8 - brightness(c) / 222.0;           
    y[si] += int((0.05 + b*b) * speedFactor);                 

    offset = y[si]*width + x[si];
    if (offset < maxpixel)
      pixels[offset] = sandColor;  // move sand
    else
    { // create new random position 
      x[si] = round(random(width));
      y[si] = round(random(height));
    }
  }
  updatePixels();
  // increase used particles ?
  if (   (frameCount > 120) 
      && (round(frameRate) > 60) 
      && (usedParticles + 1000 <= num))     usedParticles += 1000;
  if (showFPS) text (round(frameRate) + " fps   p=" + usedParticles, 10,20); 
  if(frameCount%600==0)changePicture(+1);
}
//--------------------------------------
void restart()
{
  if (debug) println ("restart");
  // set new random points
  for (int si = 0; si < num; si++)
  {  
    x[si] = round(random(width));
    y[si] = round(random(height));
  }
  stroke(255);
}
//--------------------------------------
void selectPicture (int index)
{
  picIndex = (index + pictures) % pictures;
  String filename = names[picIndex];
  if (debug) println ("loading "+picIndex+"  " +filename);
  img = loadImage(filename);
  if ((img.width != width)
   || (img.height != height))
    img.resize (width, height);
  restart();
}
//--------------------------------------
void changePicture (int delta)
{
  //-- create dynamic file list -- 
//  File file = new File(dataPath(""));
//  names = file.list();
 
  selectPicture (picIndex + delta);
}
//--------------------------------------
void mousePressed()
{
  startMouseX = mouseX;
}
//--------------------------------------
void mouseReleased()
{
  if (mouseY < 40) 
  { showFPS = mouseX < width/2;
    if (!showFPS)
      restart();
    return;
  }
  // phone wipe ?
  int dx = mouseX - startMouseX;
  if      (dx < -60) changePicture(+1);
  else if (dx > +60) changePicture(-1);
}
//--------------------------------------
void keyPressed()
{
  //println ((int)key);
  if ((key >= '0') && (key <= '9'))
    selectPicture (key - 48);

  else if (key == 'd') debug = !debug;
  else if (key == 'f') showFPS = !showFPS;
  else if (key == 'r') restart();
  else if (key == 8) changePicture(-1); 
  else changePicture(+1);
}