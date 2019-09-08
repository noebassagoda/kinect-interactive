import SimpleOpenNI.*;
SimpleOpenNI kinect;
import java.util.Map;
import java.util.Iterator;

// kinect vars
int closestValue;
int closestX;
int closestY;
int pclosestX;
int pclosestY;

SceneManager manager;
boolean shouldDisplayRGB = false;
boolean shouldDrawAnyways = true;
boolean mirrorMode = false;

int handVecListSize = 10;
Map<Integer, ArrayList<PVector>>  handPathList = new HashMap<Integer, ArrayList<PVector>>();

void setup() {
  size(640, 480, P3D);
  manager = new SceneManager();  // inicializamos el SceneManager

    //Kinect Init 
  kinect = new SimpleOpenNI(this);
  kinect.setMirror(true);
  kinect.enableDepth(); 
  kinect.enableRGB();
  kinect.enableHand();
  kinect.startGesture(SimpleOpenNI.GESTURE_WAVE);
  smooth();
}

void draw() {
  // START KINECT
  kinect.update();

  if (handPathList.size() > 0) {    
    Iterator itr = handPathList.entrySet().iterator();     
    while (itr.hasNext ()) {
      Map.Entry mapEntry = (Map.Entry)itr.next(); 
      int handId = (Integer) mapEntry.getKey();
      ArrayList<PVector> vecList = (ArrayList<PVector>)mapEntry.getValue();
      PVector p2d = new PVector();
      PVector p = vecList.get(0);
      kinect.convertRealWorldToProjective(p, p2d);
      manager.actualScene.drawScene(kinect, (mirrorMode ? (640 - p2d.x) : p2d.x) * width / 640, p2d.y * height / 480); 
    }
  } else {
    manager.actualScene.drawScene(kinect, width, height);
  }
}

// hand events
void onNewHand(SimpleOpenNI curContext, int handId, PVector pos)
{
  println("onNewHand - handId: " + handId + ", pos: " + pos);

  ArrayList<PVector> vecList = new ArrayList<PVector>();
  vecList.add(pos);

  handPathList.put(handId, vecList);
}

void onTrackedHand(SimpleOpenNI curContext, int handId, PVector pos)
{

  ArrayList<PVector> vecList = handPathList.get(handId);
  if (vecList != null)
  {
    vecList.add(0, pos);
    if (vecList.size() >= handVecListSize)
      vecList.remove(vecList.size()-1);
  }
}

void onLostHand(SimpleOpenNI curContext, int handId)
{
  println("onLostHand - handId: " + handId);
  handPathList.remove(handId);
}

void onCompletedGesture(SimpleOpenNI curContext, int gestureType, PVector pos)
{
  println("onCompletedGesture - gestureType: " + gestureType + ", pos: " + pos);
  int handId = kinect.startTrackingHand(pos);
  println("hand stracked: " + handId);
}

void keyReleased() {
  if (key == '1') { 
    manager.activate(0);
  } else if (key == '2') { 
    manager.activate(1);
  } else if (key == '3') {
    manager.activate(2);
  } else if (key == '4') {
    manager.activate(3);
  } else if (key == '5') {
    manager.activate(4);
  } else if (key == '6') {
    manager.activate(5);
  } else if (key == '7') {
    manager.activate(6);
  } else if (key == ' ') {
    kinect.setMirror(mirrorMode);
    mirrorMode = !mirrorMode;
  } else {
    manager.pressedKey(String.valueOf(key));
  }
}