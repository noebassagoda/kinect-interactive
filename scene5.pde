class Scene5 implements Scene { 
  star neuerStern;
  ArrayList<star> starArray = new ArrayList<star>();
  float h2;//=height/2
  float w2;//=width/2
  float d2;//=diagonal/2
  int numberOfStars = 20000;
  int newStars =50;
  PVector mouse;

  public Scene5( ) {
  };

  void closeScene( ) {
    popStyle();
  };

  void initialScene( ) {
    pushStyle();
    w2= width/2;
    h2= height/2;
    d2 = dist(0, 0, w2, h2);
    noStroke();
    neuerStern= new star();
    frameRate(60);
    background(0);
  };

  void drawScene(SimpleOpenNI kinect, float closestX, float closestY) {
    if (shouldDisplayRGB) {
      image(kinect.rgbImage(), 0, 0, width, height);
    }
    
    mouse = new PVector(closestX, closestY);
    fill(0, map(dist(mouse.x, mouse.y, w2, h2), 0, d2, 255, -10));
    rect(0, 0, width, height);
    fill(random(255),random(255),random(255));
    neuerStern.render();
    for (int i = 0; i<newStars; i++) {   // star init
      starArray.add(new star());
    }
 
 
    for (int i = 0; i<starArray.size(); i++) {
      if (starArray.get(i).x<0||starArray.get(i).x>width||starArray.get(i).y<0||starArray.get(i).y>height) starArray.remove(i);
      starArray.get(i).move(mouse, w2, h2);
      starArray.get(i).render();
    }
    if (starArray.size()>numberOfStars) {//
      for (int i = 0; i<newStars; i++) {
        starArray.remove(i);
      }
    }
 };

  void onPressedKey(String k) {
    if (key == 'c') {
      shouldDisplayRGB = !shouldDisplayRGB;
      background(0);
    }
  };
}

class star {
  float x, y, speed, d, age, sizeIncr;
  int wachsen;
  
  star() {
    x = random(width);
    y = random(height);
    speed = random(0.2, 5);
    wachsen= int(random(0, 2));
    if (wachsen==1)d = 0;
    else {
      d= random(0.2, 3);
    }
    age=0;
    sizeIncr= random(0, 0.03);
  }
  
  void render() {
    age++;
    if (age<200) {
      if (wachsen==1) {
        d+=sizeIncr;
        if (d>3||d<-3) d=3;
      } else {
        if (d>3||d<-3) d=3;
        d= d+0.2-0.6*noise(x, y, frameCount);
      }
    } else {
      if (d>3||d<-3) d=3;
    }

    ellipse(x, y, d*(map(noise(x, y, 0.001*frameCount), 0, 1, 0.2, 1.5)), d*(map(noise(x, y, 0.001*frameCount), 0, 1, 0.2, 1.5)));
  }
  
  void move(PVector mouse, float w2, float h2) {
    x =x-map(mouse.x, 0, width, -0.05*speed, 0.05*speed)*(w2-x);
    y =y-map(mouse.y, 0, height, -0.05*speed, 0.05*speed)*(h2-y);
  }
}