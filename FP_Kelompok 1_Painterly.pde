String[] imgNames = {"1.jpg", "2.jpg", "3.jpg", "4.jpg", "5.jpg"};
PImage img;
int imgIndex = 0;

void nextImage() {
  background(255);
  loop();
  frameCount = 0;
  
  img = loadImage(imgNames[imgIndex]);
  img.loadPixels();
  
  imgIndex += 1;
  if (imgIndex >= imgNames.length) {
    imgIndex = 0;
  }
}

void setup(){
  size(1300, 700);
  nextImage();
}

void paint(float strokeLength, color strokeColor, int strokeThickness) {

  float stepLength = strokeLength/4.0;

  float tangent1 = 0;
  float tangent2 = 0;
  
  float acc = random(1.0);
  
  
  if (acc < 0.7) {
  
    tangent1 = random(-strokeLength, strokeLength);
    tangent2 = random(-strokeLength, strokeLength);
    
  }
  
  noFill();
  stroke(strokeColor);
  strokeWeight(strokeThickness);
  curve(tangent1, -stepLength*2, 0, -stepLength, 0, stepLength, tangent2, stepLength*2);
  
  int z = 1;
  

  for (int num = strokeThickness; num > 0; num --){
 

    float offset = random(-50, 25);
    color newColor = color(red(strokeColor)+offset,green(strokeColor)+offset,blue(strokeColor)+offset, random(100,255));
    
    stroke(newColor);
    strokeWeight((int)random(0, 3));
    curve(tangent1, -stepLength*2, z-strokeThickness/2, -stepLength*random(0.9, 1.1), z-strokeThickness/2, stepLength*random(0.9, 1.1), tangent2, stepLength*2);
    
    z +=1;
  }

  
}

void draw(){

  translate(width/2, height/2);
  
  int index = 0;
  
  for (int y = 0; y < img.height; y+=1){
    for (int x = 0; x < img.width; x+=1){
      
      int acc = (int)random(20000);
      
      if (acc < 1){
      
        color pixelColor = img.pixels[index];
        pixelColor = color(red(pixelColor), green(pixelColor), blue(pixelColor), 100);
        
        pushMatrix();
        translate(x-img.width/2, y-img.height/2);
        rotate(radians(random(-90, 90)));
        
        if (frameCount < 5){
        
          paint(250, pixelColor, 40);
          
        }
        
        if (frameCount < 10){
        
          paint(150, pixelColor, 20);
          
        }
        
        if (frameCount < 100){
        
          paint(random(75, 120), pixelColor, (int)random(8, 12));
          
        }
        
        if (frameCount < 200){
        
          paint(random(30, 60), pixelColor, (int)random(1, 4));
          
        }
        
        if (frameCount < 600){
        
          paint(random(5, 20), pixelColor, (int)random(5, 15));
          
        }
        
        popMatrix();
      
      }
      
      index += 1;
      
    }
  }
  
  if (frameCount > 600) {
    noLoop();
  }
}

void mousePressed() {
  nextImage();
}
