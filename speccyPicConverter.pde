PImage input;
import processing.video.*;

Capture cam;


PImage zxImage;
int xMax = 256;
int yMax = 192;
boolean bw = false;
ZXImageConverter z;

void settings() {
  input = loadImage("data\\IMG_1059.JPG");
  
  
  size(512*2, 192*2);
}


void setup() {
  //noLoop();
  //image(input, 0, 0);
   String[] cameras = Capture.list();
    cam = new Capture(this,xMax, yMax, cameras[0]);
    cam.start();     
}
void mouseClicked() {

  //ZXImageConverter z;
  //z=new ZXImageConverter(input);
  //zxImage=z.convert();

  //image(zxImage,input.width,0);

  //println(zxMagenta>zxCyan);
}
void draw() {
  
  if (cam.available() == true) {
    cam.read();
  }
  //cam.resize(512,192*2);  
  PImage cloneThis = cam.copy(); //blurThis(blurThis(blurThis(cam)));
  PImage showThis = cam.copy();//cam.resize(512,192*2);
  showThis.resize(512,192*2);
  image(showThis, 0, 0);
  z=new ZXImageConverter(cloneThis);
  z.bw=bw;
  zxImage=z.convert();
  zxImage.resize(512,192*2);
  image(zxImage, 512, 0);
}

void keyPressed() {
  println(key);
  if (key == 's' || key=='S') {
    ZXImageConverter z;
    z=new ZXImageConverter(input);
    z.bw=bw;
    zxImage=z.convert();
    zxImage.save("d:\\Documents\\speccyPicConverter\\data\\zxImage.png");
  } else if (key=='b') {
    bw=!bw;
  }
}


PImage blurThis(PImage t) {
  PImage rtrn = new PImage(t.width, t.height);
  t.loadPixels();
  rtrn.loadPixels();
  for (int index=0; index<t.pixels.length; index++) {
    getTemplate(t, index, rtrn);
  }
  rtrn.updatePixels();
  t.updatePixels();
  return rtrn;
}
void getTemplate(PImage t, int index, PImage nw) {
  IntList temp = new IntList();
  //return a list 9 in length of pixels surrounding the index.
  //if the index value < width or > pixels.length -width then ignore outside pixels
  if (index>t.width && index<t.pixels.length-t.width-1) {
    temp.append(t.pixels[index - t.width -1]);
    temp.append(t.pixels[index - t.width]);
    temp.append(t.pixels[index - t.width + 1]);
    temp.append(t.pixels[index - 1]);
    temp.append(t.pixels[index]);
    temp.append(t.pixels[index+1]);
    temp.append(t.pixels[index + t.width -1]);
    temp.append(t.pixels[index + t.width]);
    temp.append(t.pixels[index + t.width +1]);
  }
  int totalRed = 0;
  int totalGreen = 0;
  int totalBlue = 0;
  for (int count = 0; count < temp.size(); count ++) {
    totalRed +=red(temp.get(count));
    totalGreen +=green(temp.get(count));
    totalBlue +=blue(temp.get(count));
  }
  float averageRed = 0;
  float averageGreen = 0;
  float averageBlue = 0;
  temp.clear();
  averageRed = totalRed/9;
  averageGreen = totalGreen/9;
  averageBlue = totalBlue/9;
  color average = color(averageRed, averageGreen, averageBlue);
  if (index>t.width && index<t.pixels.length-t.width-1) {
    nw.pixels[index] =(int)average;

  }
}
