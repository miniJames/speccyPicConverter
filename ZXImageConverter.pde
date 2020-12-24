int zxbk=0;
int zxbl=1;
int zxrd=2;
int zxmg=3;
int zxgn=4;
int zxcy=5;
int zxyw=6;
int zxwh=7;
int zxbbk=8;
int zxbbl=9;
int zxbrd=10;
int zxbmg=11;
int zxbgn=12;
int zxbcy=13;
int zxbyw=14;
int zxbwh=15;

int brightThreshold=225;

color zxRed= color(brightThreshold, 0, 0);
color zxYellow=color(brightThreshold, brightThreshold, 0);
color zxBlue=color(0, 0, brightThreshold);
color zxGreen=color(0, brightThreshold, 0);
color zxCyan= color(0, brightThreshold, brightThreshold);
color zxMagenta=color(brightThreshold, 0, brightThreshold);
color zxWhite= color(brightThreshold, brightThreshold, brightThreshold);
color zxBlack=color(0, 0, 0);

color zxBrightRed=color(255, 0, 0);
color zxBrightYellow=color(255, 255, 0);
color zxBrightBlue= color(0, 0, 255);
color zxBrightGreen=color(0, 255, 0);
color zxBrightCyan= color(0, 255, 255);
color zxBrightMagenta=color(255, 0, 255);
color zxBrightWhite=color(255, 255, 255);
color zxBrightBlack=color(0, 0, 0);

color zxSpectrumColors(int zxColor) {


  if (zxColor==zxwh) {
    return zxWhite;
  } else if (zxColor==zxbl) {
    return zxBlue;
  } else if (zxColor==zxyw) {
    return zxYellow;
  } else if (zxColor==zxmg) {
    return zxMagenta;
  } else if (zxColor==zxcy) {
    return zxCyan;
  } else if (zxColor==zxgn) {
    return zxGreen;
  } else if (zxColor == zxbl) {
    return zxBlue;
  } else if (zxColor==zxrd) {
    return zxRed;
  } else {
    return zxBlack;
  }
}


float getPixelFromXY(float x, float y, float w) {
  float rtrn;

  rtrn=(y*w)+x;

  return rtrn;
}
PVector getXYFromPixel(float index, float h) {

  PVector rtrn=new PVector();

  rtrn.x=index%h;
  rtrn.y=(index-rtrn.x)/h;

  return rtrn;
}

class ZXImageConverter {
  boolean bw=false;

  PImage source;
  float threshold=map(mouseX, 0, width, 0, 255);
  ZXImageConverter(PImage s) {
    source =s;
  }

  PImage convert() {
    color[][][] colors;
    colors=new color[32][24][64];

    PImage rtrn = new PImage(xMax, yMax);
    for (int i =0; i<source.pixels.length; i++) {
      color p=source.pixels[i];
      rtrn.pixels[i]=setColorAttribute(p);
    }
    if (true) {
      for (int y=0; y<yMax; y+=8) {
        for (int x=0; x<xMax; x+=8) {
          int startX=x;
          int startY=y;
          for (int y1=startY; y1<startY+8; y1++) {
            for (int x1=startX; x1<startX+8; x1++) {
              //println((x1)+":"+(y1)); 
              //println((y1-y)*8+"::"+(x1-x));
              colors[x/8][y/8][((y1-y)*8)+(x1-x)]=rtrn.pixels[(int)getPixelFromXY(x1, y1, source.width)];
            }
          }
        }
      }


      for (int y=0; y<yMax/8; y++) {
        for (int x=0; x<xMax/8; x++) {
          int[] colorCount;
          colorCount=new int[16];
          for (int c=0; c<64; c++) {
            color col;
            col=colors[x][y][c];
            if (col==zxWhite) {
              colorCount[zxwh]+=1;
            } else if (col==zxBlack) {
              colorCount[zxbk]+=1;
            } else if (col==zxYellow) {
              colorCount[zxyw]+=1;
            } else if (col==zxMagenta) {
              colorCount[zxmg]+=1;
            } else if (col==zxCyan) {
              colorCount[zxcy]+=1;
            } else if (col==zxGreen) {
              colorCount[zxgn]+=1;
            } else if (col == zxBlue) {
              colorCount[zxbl]+=1;
            } else if (col==zxRed) {
              colorCount[zxrd]+=1;
            } else if (col==zxWhite) {
              colorCount[zxwh]+=1;
            } else if (col==zxBrightYellow) {
              colorCount[zxbyw]+=1;
            } else if (col==zxBrightMagenta) {
              colorCount[zxbmg]+=1;
            } else if (col==zxBrightCyan) {
              colorCount[zxbcy]+=1;
            } else if (col==zxBrightGreen) {
              colorCount[zxbgn]+=1;
            } else if (col == zxBrightBlue) {
              colorCount[zxbbl]+=1;
            } else if (col==zxBrightRed) {
              colorCount[zxbrd]+=1;
            } else if (col==zxBrightWhite) {
              colorCount[zxbwh]+=1;
            }
          }
          int largestForeground=0;
          for (int z=1; z<colorCount.length; z++) {
            if (colorCount[z]>colorCount[largestForeground]) {
              largestForeground=z;
            }
          }
          int secondLargestForeground=0;
          int start=1;
          if (secondLargestForeground==largestForeground) {
            secondLargestForeground++;
            start++;
          }

          for (int z=start; z<colorCount.length; z++) {

            if (colorCount[z]>colorCount[secondLargestForeground]  && colorCount[z]<colorCount[largestForeground]) {
              secondLargestForeground=z;
            }
          }
          color ink;
          color paper;

          if (!bw) {
            ink=zxSpectrumColors(largestForeground);
            paper=zxSpectrumColors(secondLargestForeground);
          } else {
            ink=zxBlack;
            paper=zxWhite;
          }
          for (int cy=0; cy<8; cy++) {
            for (int cx=0; cx<8; cx++) {
              color currentPixel= rtrn.pixels[(int)getPixelFromXY((x*8)+cx, (y*8)+cy, source.width)];
              if (paper<ink) {
                if (currentPixel>=ink) {
                  rtrn.pixels[(int)getPixelFromXY((x*8) +cx, (y*8)+cy, source.width)]=ink;
                } else {
                  rtrn.pixels[(int)getPixelFromXY((x*8) +cx, (y*8)+cy, source.width)]=paper;
                }
              } else {
                if (currentPixel<=ink) {
                  rtrn.pixels[(int)getPixelFromXY((x*8) +cx, (y*8)+cy, source.width)]=ink;
                } else {

                  rtrn.pixels[(int)getPixelFromXY((x*8) +cx, (y*8)+cy, source.width)]=paper;
                }
              }
            }
          }
        }
      }
    }
    return rtrn;
  }


  color setColorAttribute(color c) {
    color rtrn;

    rtrn=color(setColorAttribute(red(c)), setColorAttribute(green(c)), setColorAttribute(blue(c)));

    return rtrn;
  }
  float setColorAttribute(float c) {
    float rtrn;
    if (c>threshold) {
      //if (c>brightThreshold) {
      //  rtrn=255;
      //} else {
      rtrn=brightThreshold;
      //}
    } else {
      rtrn=0;
    }
    return rtrn;
  }
  //float getAvg(color c) {
  //  float rtrn;
  //  rtrn = (red(c)+green(c)+blue(c))/3;
  //  return rtrn;
  //}
  color getColorFromIndex(int i) {

    color rtrn;
    if (i==zxwh) {
      rtrn= zxWhite;
    } else if (i==zxrd) {
      rtrn= zxRed;
    } else if (i==zxgn) {
      rtrn= zxGreen;
    } else if (i==zxbl) {
      rtrn= zxBlue;
    } else if (i==zxcy) {
      rtrn= zxCyan;
    } else if (i==zxbk) {
      rtrn= zxBlack;
    } else if (i==zxmg) {
      rtrn= zxMagenta;
    } else if (i==zxyw) {
      rtrn= zxYellow;
    } else {
      rtrn=zxBlack;
    }
    return rtrn;
  }
  String getColor(color c) {
    String rtrn;
    rtrn= new String();
    if (c==zxWhite) {
      rtrn="White";
    } else if (c==zxBlack) {
      rtrn="Black";
    } else if (c==zxRed) {
      rtrn="Red";
    }

    return rtrn;
  }

  void saveZXImage() {
  }
}
