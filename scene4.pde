class Scene4 implements Scene {  

  final float g = 0.1;
  Body bs[];
  PVector com = new PVector();                                   
  PVector com2d = new PVector();  
  boolean shouldDisplayRGB = true;

  public Scene4( ) {
  };

  void closeScene( ) {
    popStyle();
  };

  void initialScene( ) {
    pushStyle();
    frameRate(60);
    colorMode(HSB, 1);
    background(0);
    fill(0, 0.25);

    bs = new Body[1200];
    for (int i = 0; i < bs.length; i++) {
      bs[i] = new Body(1, new PVector(random(width), random(height)));
    }
  };

  void onPressedKey(String k) {
    if (key == 'c') {
      shouldDisplayRGB = !shouldDisplayRGB;
      background(0);
    }
  };

  void drawScene(SimpleOpenNI kinect, float closestX, float closestY) {
    noStroke();

    if (shouldDisplayRGB) {
      image(kinect.rgbImage(), 0, 0, width, height);
    } else {
      background(0);
    }

    for (int i = 0; i < bs.length; i++) {
      stroke(0.0002 * i, 0.5, 1);
      Body b = bs[i];
      b.show();
      float r = 100 * sin(frameCount * 0.05);
      float a = sin(frameCount * 0.005) * TWO_PI;
      b.attract(new Body(-1000, new PVector(closestX + r * cos(a), closestY + r * sin(a))));
      r = 100 * sin(frameCount * 0.03);
      a = 1 + sin(frameCount * 0.005) * TWO_PI;
      b.attract(new Body(1000, new PVector(closestX + r * sin(a), closestY + r * cos(a))));
      r = 100 * sin(frameCount * 0.01);
      a = 2 + sin(frameCount * 0.005) * TWO_PI;
      b.attract(new Body(1000, new PVector(closestX + r * sin(a), closestY + r * cos(a))));
      b.update();
    }
  }

  class Body {
    float m;
    PVector p, q, s;

    Body(float m, PVector p) {
      this.m = m;
      this.p = p;
      q = p;
      this.s = new PVector(0, 0);
    }

    void update() {
      s.mult(0.98);
      p = PVector.add(p, s);
    }

    void attract(Body b) {
      float d = constrain(PVector.dist(p, b.p), 10, 100);
      PVector f = PVector.mult(PVector.sub(b.p, p), b.m * m * g / (d * d));
      PVector a = PVector.div(f, m);
      s.add(a);
    }

    void show() {
      line(p.x, p.y, q.x, q.y);
      q = p;
    }
  }
}