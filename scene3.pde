class Scene3 implements Scene {  

  boolean shouldDisplayRGB = true;

  color[] userClr = new color[] { 
    color(255, 0, 0), 
    color(0, 255, 0), 
    color(0, 0, 255), 
    color(255, 255, 0), 
    color(255, 0, 255), 
    color(0, 255, 255)
  };
  PVector com = new PVector();                                   
  PVector com2d = new PVector();  

  public Scene3( ) {
  };

  void closeScene( ) {
  };

  void initialScene( ) {
    kinect.enableUser();
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
      image(kinect.userImage(), 0, 0, width, height);
    }

    int[] userList = kinect.getUsers();
    for (int i=0; i<userList.length; i++) {
      if (kinect.isTrackingSkeleton(userList[i])) {
        stroke(userClr[ (userList[i] - 1) % userClr.length ] );
        drawSkeleton(kinect, userList[i]);
      }      

      // draw the center of mass
      if (kinect.getCoM(userList[i], com)) {
        kinect.convertRealWorldToProjective(com, com2d);
        stroke(100, 255, 0);
        strokeWeight(1);
        beginShape(LINES);
        vertex(com2d.x, com2d.y - 5);
        vertex(com2d.x, com2d.y + 5);

        vertex(com2d.x - 5, com2d.y);
        vertex(com2d.x + 5, com2d.y);
        endShape();

        fill(0, 255, 100);
        text(Integer.toString(userList[i]), com2d.x, com2d.y);
      }
    }
  }

  // draw the skeleton with the selected joints
  void drawSkeleton(SimpleOpenNI kinect, int userId) {

    kinect.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);

    kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
    kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
    kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);

    kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
    kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
    kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);

    kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
    kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);

    kinect.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
    kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
    kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);

    kinect.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
    kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
    kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);
  }
}