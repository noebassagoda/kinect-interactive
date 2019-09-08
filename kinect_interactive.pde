import SimpleOpenNI.*;

interface Scene { 
 void initialScene( );
 void drawScene(SimpleOpenNI kinect, float x, float y);
 void closeScene( );
 void onPressedKey(String k);
}

class SceneManager{
  Scene[] scenes;  
  Scene actualScene;
  SceneManager( ) {
    Scene[] allScenes = {  new Scene1(), new Scene2(), new Scene3() , new Scene4(), new Scene5(), new Scene6(), new Scene7() };
    scenes = allScenes;
    scenes[0].initialScene(); // initialize first scene
    actualScene = scenes[0];
  }
  
  void activate(int sceneNr){ // activate new scene
    actualScene.closeScene();
    actualScene = scenes[sceneNr];
    actualScene.initialScene();
    println("Escena activada "+sceneNr);
 }
 
 void pressedKey(String pKey){
    actualScene.onPressedKey(pKey); // activate keyboard events to manage active scene
 }
}