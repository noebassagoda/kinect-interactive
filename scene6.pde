/**
 * reflection and fragmentation
 *
 * @author aa_debdeb
 * @date 2016/05/24
 */

class Scene6 implements Scene {  

  boolean shouldDisplayRGB = false;
  ArrayList<Particle> particles;
  float gravity = -0.1; 

  public Scene6( ) {
  };

  void closeScene( ) {
  };

  void initialScene( ) {
    frameRate(15);
    kinect.enableUser();
    particles = new ArrayList<Particle>();
    sphereDetail(16);
  };

  void onPressedKey(String k) {
    if (key == 'c') {
      shouldDisplayRGB = !shouldDisplayRGB;
      background(0);
    }
  };

  void drawScene(SimpleOpenNI kinect, float closestX, float closestY) {
    background(0);

    if (shouldDisplayRGB) {
      image(kinect.rgbImage(), 0, 0, width, height);
    }

    translate(width / 2, height * 3.0 / 4, -300);
    lights();
    rotateX(map(closestY, 0, height, PI / 2 - PI / 6, PI / 2 + PI / 6));
    rotateZ(map(closestX, 0, width, -PI / 4, PI / 4));
    noStroke();
    fill(255, 30);
    rect(-width / 2, -height / 2, width, height);
    stroke(255);
    for (int w = -width / 2; w <= width / 2; w += 50) {
      line(w, -height / 2, 0, w, height / 2, 0);
    }
    for (int h = -height / 2; h <= height / 2; h += 50) {
      line(-width / 2, h, 0, width / 2, h, 0);
    }

    noStroke();
    fill(0, 255, 255);
    ArrayList<Particle> nextParticles = new ArrayList<Particle>();
    for (Particle particle : particles) {
      particle.display();
      particle.update();
      if (!particle.isOut()) { 
        if (particle.isDivided()) {
          for (Particle p : particle.divide ()) {
            nextParticles.add(p);
          }
        } else {
          nextParticles.add(particle);
        }
      }
    }
    particles = nextParticles;

    if (random(1) < 1.0) {
      particles.add(new Particle());
    }
  }

  void onNewUser(SimpleOpenNI curContext, int userId)
  {
    println("onNewUser - userId: " + userId);
    println("\tstart tracking skeleton");

    curContext.startTrackingSkeleton(userId);
  }

  void onLostUser(SimpleOpenNI curContext, int userId)
  {
    println("onLostUser - userId: " + userId);
  }

  void onVisibleUser(SimpleOpenNI curContext, int userId)
  {
    //println("onVisibleUser - userId: " + userId);
  }

class Particle {
  PVector pos, vel;
  float size;

  Particle() {
    float x = random(-width / 2, width / 2);
    float y = random(-height / 2, height / 2);
    float z = random(500, 800);
    pos = new PVector(x, y, z);
    vel = new PVector(0, 0, 0);
    size = 10;
  }

  Particle(PVector pos, PVector vel, float size) {
    this.pos = pos;
    this.vel = vel;
    this.size = size;
  }

  void display() {
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    sphere(size);
    popMatrix();
  }

  void update() {
    vel.z += gravity;
    pos.add(vel);
    if (pos.z < size / 2) {
      pos.z = size / 2;
      vel.z *= -0.5;
    }
  }

  boolean isDivided() {
    return size >= 2 && pos.z == size / 2;
  }

  boolean isOut() {
    return !(-width / 2 <= pos.x && pos.x <= width / 2 && -height / 2 <= pos.y && pos.y <= height / 2);
  }

  ArrayList<Particle> divide() {
    ArrayList<Particle> children = new ArrayList<Particle>();
    for (int i = 0; i < 4; i++) {
      PVector cpos = new PVector(pos.x, pos.y, pos.z);
      PVector cvel = new PVector(vel.x + random(-3, 3), vel.y + random(-3, 3), vel.z);
      float csize = pow(size, 0.5);  
      Particle child = new Particle(cpos, cvel, csize);
      children.add(child);
    }
    return children;
  }
}
}