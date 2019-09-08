class Scene2 implements Scene {  
  ArrayList<Particle> particles;
  boolean[][] occupied;
  Particle[][] reference;
  float pclosestX;
  float pclosestY;

  PVector mouse;
  PVector pmouse;
  PVector mouseV;
  Particle[] field;
  
  boolean shouldDisplayRGB = false;

  public Scene2( ) {
  };

  void closeScene( ) {
  };

  void initialScene( ) {
    frameRate(30);
    background(0);
    particles = new ArrayList<Particle>();
    occupied = new boolean[width][height];
    reference = new Particle[width][height];
    int boxSize = 250;
    field = new Particle[boxSize*boxSize];
    for (int i=0; i<field.length; i++) {
      int x = width/2-boxSize/2+i%boxSize;
      int y = height/2-boxSize/2+i/boxSize;
      field[i] = new Particle(x, y, color(random(0, 255), random(0, 255), random(0, 255)));
    }
  };

  void onPressedKey(String k) {
    if (key == 'c') {
      shouldDisplayRGB = !shouldDisplayRGB;
      background(0);
    }
  };

  void drawScene(SimpleOpenNI kinect, float closestX, float closestY) {
    if (shouldDisplayRGB) {
      image(kinect.rgbImage(), 0, 0, width, height);
    } else {
      background(0);
    }
    
    pushStyle();
    fill(255, 0, 0);
    ellipse(closestX, closestY, 2, 2);
    popStyle();
    
    pmouse = new PVector(pclosestX, pclosestY);
    mouse = new PVector(closestX, closestY);

    pclosestX = closestX;
    pclosestY = closestY;

    mouseV = PVector.sub(mouse, pmouse);
    for (int i=0; i<field.length; i++) {
      field[i].update();
      set(round(field[i].location.x), round(field[i].location.y), field[i].clr);
    }
  }

  class Particle {
    PVector location;
    PVector velocity;
    int impatience = 0;
    color clr;
    
    Particle(int x, int y, color clr) {
      location = new PVector(x, y);
      velocity = new PVector();
      this.clr = clr;
      occupied[x][y] = true;
      reference[x][y] = this;
    }
    
    void update() {
      int px = round(location.x);
      int py = round(location.y);
      PVector newLoc = PVector.add(location, velocity);
      int nx = round(newLoc.x);
      int ny = round(newLoc.y);
      if ((px==nx&&py==ny)==false) {
        if (nx<0||nx>=width) {
          velocity.x *= -0.5;
        } else if (ny<0||ny>=height) {
          velocity.y *= -0.5;
        } else {
          if (occupied[nx][ny]) {
            PVector delta = PVector.sub(reference[nx][ny].velocity, velocity);
            delta.mult(0.8);
            float heat = impatience/3f;
            delta.add(new PVector(random(-heat, heat), random(-heat, heat)));
            velocity.add(delta);
            reference[nx][ny].velocity.sub(delta);
            impatience++;
            if (impatience>4) {
              impatience = 4;
            }
          } else {
            occupied[px][py] = false;
            occupied[nx][ny] = true;
            reference[nx][ny] = this;
            location = newLoc;
            impatience = 0;
          }
        }
      }
      if (true) {
        PVector arm = PVector.sub(mouse, location);
        float rad = 64;
        if (arm.mag()<rad) {
          PVector delta = PVector.sub(mouseV, velocity);
          delta.mult((1-arm.mag()/rad)*0.5);
          velocity.add(delta);
        }
      }
      velocity.y += 0.1;
    }
  }
}