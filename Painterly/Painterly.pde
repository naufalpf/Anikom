PImage source, reference, canvas;

// It's possible to perform a convolution
// the image with different matrices

float[][] matrix = { { 0.015625, 0.015625, 0.015625, 0.015625, 0.015625, 0.015625, 0.015625, 0.015625 },
                     { 0.015625, 0.015625, 0.015625, 0.015625, 0.015625, 0.015625, 0.015625, 0.015625 },
                     { 0.015625, 0.015625, 0.015625, 0.015625, 0.015625, 0.015625, 0.015625, 0.015625 },
                     { 0.015625, 0.015625, 0.015625, 0.015625, 0.015625, 0.015625, 0.015625, 0.015625 },
                     { 0.015625, 0.015625, 0.015625, 0.015625, 0.015625, 0.015625, 0.015625, 0.015625 },
                     { 0.015625, 0.015625, 0.015625, 0.015625, 0.015625, 0.015625, 0.015625, 0.015625 },
                     { 0.015625, 0.015625, 0.015625, 0.015625, 0.015625, 0.015625, 0.015625, 0.015625 },
                     { 0.015625, 0.015625, 0.015625, 0.015625, 0.015625, 0.015625, 0.015625, 0.015625 } };

void setup() {
  size(1024, 768);
  source = loadImage("Kucing.jpg");
  reference = createImage(source.width, source.height, RGB);
  canvas = createImage(source.width, source.height, RGB);
}

void draw() {
  canvas.loadPixels();
  // Begin our loop for every pixel
  for (int x = 0; x < source.width; x++) {
    for (int y = 0; y < source.height; y++ ) {
      // Each pixel location (x,y) gets passed into a function called convolution() 
      // which returns a new color value to be displayed.
      int loc = x + y*source.width;
      canvas.pixels[loc] = color(255,255,255);
    }
  }
  canvas.updatePixels();
  
  int matrixsize = 8;
  source.loadPixels();
  // Begin our loop for every pixel
  for (int x = 0; x < source.width; x++) {
    for (int y = 0; y < source.height; y++ ) {
      // Each pixel location (x,y) gets passed into a function called convolution() 
      // which returns a new color value to be displayed.
      color c = convolution(x,y,matrix,matrixsize,source);
      int loc = x + y*source.width;
      reference.pixels[loc] = c;
    }
  }
  reference.updatePixels();
  //image(reference,0,0);
  
  float [][] Diff = new float [source.width][source.height];
  canvas.loadPixels();
  reference.loadPixels();
  for (int x = 0; x < source.width; x+=matrixsize) {
    for (int y = 0; y < source.height; y+=matrixsize ) {
      // Each pixel location (x,y) gets passed into a function called convolution() 
      // which returns a new color value to be displayed.
      int loc = x + y*source.width;
      Diff[x][y] =sqrt(pow(red(canvas.pixels[loc])-red(reference.pixels[loc]),2)+pow(green(canvas.pixels[loc])-green(reference.pixels[loc]),2)+pow(blue(canvas.pixels[loc])-blue(reference.pixels[loc]),2));
    }
  }
  
  // Menggambar di canvas
  for (int x = 0; x < source.width; x++) {
    for (int y = 0; y < source.height; y++ ) {
      // Each pixel location (x,y) gets passed into a function called convolution() 
      // which returns a new color value to be displayed.
      int xkiri = x - matrixsize/2; int xkanan = x + matrixsize/2;
      int yatas = y - matrixsize/2; int ybawah = y + matrixsize/2;
      if (xkiri < 0) xkiri=0;
      if (xkanan > source.width -1) xkanan=source.width -1;
      if (yatas < 0) yatas=0;
      if (ybawah > source.height -1) ybawah=source.height -1;
      println("x =", x);
      println("y =", y);
      println("xkiri =", xkiri);
       println("xkanan =", xkanan);
        println("yatas =", yatas);
         println("ybawah =", ybawah);
      float areaError = 0;
      float maxError=-1; 
      int posx=0, posy=0;
      for (int i=xkiri; i<=xkanan; i++) {
        for (int j=yatas; j<=ybawah; j++) {
          areaError = areaError + Diff[i][j];
          if (maxError==-1) { maxError=Diff[i][j]; posx=i; posy=j; }
          else {
            if (maxError < Diff[i][j]) { maxError=Diff[i][j]; posx=i; posy=j; }
          }
          
        }
      }
      areaError = areaError/pow(matrixsize,2);
      println("Maxerror=", maxError);
      println("posx=", posx);
      println("posy=", posy);
      //int loc = posx + posy*reference.width;
      stroke(0);
      //fill(red(reference.pixels[loc]),green(reference.pixels[loc]),blue(reference.pixels[loc])); 
      noFill();
      //rectMode(CORNERS);
      rect(xkiri,yatas,xkanan-xkiri,ybawah-yatas);
    }
  }
  //noStroke();
  //fill(255,255,255); 
  //rectMode(CORNERS);
  //rect(0,0,50,50);
}

color convolution(int x, int y, float[][] matrix, int matrixsize, PImage img) {
  float rtotal = 0.0;
  float gtotal = 0.0;
  float btotal = 0.0;
  int offset = matrixsize / 2;
  // Loop through convolution matrix
  for (int i = 0; i < matrixsize; i++){
    for (int j= 0; j < matrixsize; j++){
      // What pixel are we testing
      int xloc = x+i-offset;
      int yloc = y+j-offset;
      int loc = xloc + img.width*yloc;
      // Make sure we have not walked off the edge of the pixel array
      loc = constrain(loc,0,img.pixels.length-1);
      // Calculate the convolution
      // We sum all the neighboring pixels multiplied by the values in the convolution matrix.
      rtotal += (red(img.pixels[loc]) * matrix[i][j]);
      gtotal += (green(img.pixels[loc]) * matrix[i][j]);
      btotal += (blue(img.pixels[loc]) * matrix[i][j]);
    }
  }
  // Make sure RGB is within range
  rtotal = constrain(rtotal,0,255);
  gtotal = constrain(gtotal,0,255);
  btotal = constrain(btotal,0,255);
  // Return the resulting color
  return color(rtotal,gtotal,btotal);
}
