class Scene1 implements Scene {  
  Particle p = new Particle();
  final int LIGHT_FORCE_RATIO = 5;  
  final int  LIGHT_DISTANCE= 75 * 75;  
  final int  BORDER = 400;  
  
  float baseRed, baseGreen, baseBlue;  
  float baseRedAdd, baseGreenAdd, baseBlueAdd;  
  
  final float RED_ADD = 1.2;   
  final float GREEN_ADD = 1.7;  
  final float BLUE_ADD = 2.3;  
  
  boolean shouldDisplayRGB = false;

  public Scene1( ) {
  };

  void closeScene( ) {
  };

  void initialScene( ) {
    frameRate(30);
    background(0);
    baseRed = 0;
    baseRedAdd = RED_ADD;

    baseGreen = 0;
    baseGreenAdd = GREEN_ADD;

    baseBlue = 0;
    baseBlueAdd = BLUE_ADD;
  };

  void drawScene(SimpleOpenNI kinect, float closestX, float closestY) {
    if (shouldDisplayRGB) {
      image(kinect.rgbImage(), 0, 0, width, height);
    }
    
    baseRed += baseRedAdd;
    baseGreen += baseGreenAdd;
    baseBlue += baseBlueAdd;
    colorOutCheck();

    p.move(closestX, closestY);

    int tRed = (int)baseRed;
    int tGreen = (int)baseGreen;
    int tBlue = (int)baseBlue;

    tRed *= tRed;
    tGreen *= tGreen;
    tBlue *= tBlue;


    loadPixels();

    int left = max(0, p.x - BORDER);
    int right = min(width, p.x + BORDER);
    int top = max(0, p.y - BORDER);
    int bottom = min(height, p.y + BORDER);


    for (int y = top; y < bottom; y++) {
      for (int x = left; x < right; x++) {
        int pixelIndex = x + y * width;

        int r = pixels[pixelIndex] >> 16 & 0xFF;
        int g = pixels[pixelIndex] >> 8 & 0xFF;
        int b = pixels[pixelIndex] & 0xFF;


        int dx = x - p.x;
        int dy = y - p.y;
        int distance = (dx * dx) + (dy * dy);  


        if (distance < LIGHT_DISTANCE) {
          int fixFistance = distance * LIGHT_FORCE_RATIO;

          if (fixFistance == 0) {
            fixFistance = 1;
          }   
          r = r + tRed / fixFistance;
          g = g + tGreen / fixFistance;
          b = b + tBlue / fixFistance;
        }
        pixels[x + y * width] = color(r, g, b);
      }
    }

    updatePixels();
  };

  void colorOutCheck() {
    if (baseRed < 10) {
      baseRed = 10;
      baseRedAdd *= -1;
    } else if (baseRed > 255) {
      baseRed = 255;
      baseRedAdd *= -1;
    }

    if (baseGreen < 10) {
      baseGreen = 10;
      baseGreenAdd *= -1;
    } else if (baseGreen > 255) {
      baseGreen = 255;
      baseGreenAdd *= -1;
    }

    if (baseBlue < 10) {
      baseBlue = 10;
      baseBlueAdd *= -1;
    } else if (baseBlue > 255) {
      baseBlue = 255;
      baseBlueAdd *= -1;
    }
  }

  void onPressedKey(String k) {
    if (key == 'c') {
      shouldDisplayRGB = !shouldDisplayRGB;
      background(0);
    }
  };

  class Particle {
    int x, y;        
    float vx, vy;    
    float slowLevel;


    Particle() {
      x = (int)random(width);
      y = (int)random(height);
      slowLevel = random(100) + 5;
    }

    void move(float targetX, float targetY) {
      vx = (targetX - x) ;
      vy = (targetY - y) ;

      x = (int)(x + vx);
      y = (int)(y + vy);
    }
  }
}