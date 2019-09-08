class Scene7 implements Scene {  
  ArrayList<star> constellation = new ArrayList<star>();
  float n;
  float d;
  boolean shouldDisplayRGB = false;

  public Scene7( ) {
  };

  void closeScene( ) {
    popStyle();
  };

  void initialScene( ) {
    frameRate(60);
    pushStyle();
    n = 200;

    for (int i = 0; i <= n; i++) {
      constellation.add(new star());
    }
    strokeWeight(.75);
    stroke(255);
  }

  void drawScene(SimpleOpenNI kinect, float closestX, float closestY) {
    if (shouldDisplayRGB) {
      image(kinect.rgbImage(), 0, 0, width, height);
    } else {
      background(0);
    }
  
    for (int i = 0; i < constellation.size(); i++) {
      constellation.get(i).update(closestX, closestY);
      for (int j = 0; j < constellation.size(); j++) {
        if (i > j) { // "if (i > j)" => to check one time distance between two stars
          d = constellation.get(i).loc.dist(constellation.get(j).loc); // Distance between two stars
          if (d <= width / 9) { // if d is less than width/10 px, we draw a line between the two stars
            line(constellation.get(i).loc.x, constellation.get(i).loc.y, constellation.get(j).loc.x, constellation.get(j).loc.y);
          }
        }
      }
    }
  }

  void onPressedKey(String k) {
    if (key == 'c') {
      shouldDisplayRGB = !shouldDisplayRGB;
      background(0);
    }
  };

  class star {
    float a = random(3 * TAU);
    float r = random(width * .1, width * .15); // first position will look like a donut
    PVector loc = new PVector(width / 2 + sin(this.a) * this.r, height / 2 + cos(this.a) * this.r);
    PVector speed = PVector.random2D();
    PVector bam = new PVector();
    float m;

    star() { }

    void update(float closestX, float closestY) {
      bam = PVector.random2D(); // movement of star will be a bit erractic
      bam.mult(0.35);
      speed.add(this.bam);
      // speed is done according distance between loc and the mouse :
      m = constrain(map(dist(this.loc.x, this.loc.y, closestX, closestY), 0, width, 8, .05), .05, 8); // constrain => avoid returning "not a number"

      float mg = speed.mag();
      if (mg != 0 && mg != 1) {
        speed.div(mg);
      }
 
      speed.mult(m); // Normalize is missing

      // No colision detection, instead loc is out of bound
      // it reappears on the opposite side :
      if (dist(this.loc.x, this.loc.y, width / 2, height / 2) > (width / 2) * 0.98) {
        if (this.loc.x < width / 2) {
          this.loc.x = width - this.loc.x - 3; // "-4" => avoid blinking stuff
        } else if (this.loc.x > width / 2) {
          this.loc.x = width - this.loc.x + 3; // "+4"  => avoid blinking stuff
        }
        if (this.loc.y < height / 2) {
          this.loc.y = width - this.loc.y - 3;
        } else if (this.loc.x > height / 2) {
          this.loc.y = width - this.loc.y + 3;
        }
      }
      
      loc.add(speed);
    }
  }
}