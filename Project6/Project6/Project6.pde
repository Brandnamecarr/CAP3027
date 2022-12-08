// VertexAnimation Project - Student Version
import java.io.*;
import java.util.*;

/*========== Monsters ==========*/
Animation monsterAnim;
ShapeInterpolator monsterForward = new ShapeInterpolator();
ShapeInterpolator monsterReverse = new ShapeInterpolator();
ShapeInterpolator monsterSnap = new ShapeInterpolator();

/*========== Sphere ==========*/
Animation sphereAnim; // Load from file
Animation spherePos; // Create manually
ShapeInterpolator sphereForward = new ShapeInterpolator();
PositionInterpolator spherePosition = new PositionInterpolator();

// TODO: Create animations for interpolators
ArrayList<PositionInterpolator> cubes = new ArrayList<PositionInterpolator>();
ShapeInterpolator cubeShape = new ShapeInterpolator();

Camera cam = null;

PVector cameraPosition = new PVector(0, 0, 0);
PVector vec = new PVector(0, 0, 0);
int temp = 0;
boolean wheeled = false, pressed = false;
float scaled = 0;

void setup()
{
  pixelDensity(2);
  size(1200, 800, P3D);

  /*====== Load Animations ======*/
  monsterAnim = ReadAnimationFromFile("monster.txt");
  sphereAnim = ReadAnimationFromFile("sphere.txt");

  monsterForward.SetAnimation(monsterAnim);
  monsterReverse.SetAnimation(monsterAnim);
  monsterSnap.SetAnimation(monsterAnim);
  monsterSnap.SetFrameSnapping(true);

  sphereForward.SetAnimation(sphereAnim);

  /*====== Create Animations For Cubes ======*/
  // When initializing animations, to offset them
  // you can "initialize" them by calling Update()
  // with a time value update. Each is 0.1 seconds
  // ahead of the previous one

  ArrayList<KeyFrame> cubePos = new ArrayList<KeyFrame>();
  cubePos.add(new KeyFrame(0.5f, new PVector(0, 0, 0)));
  cubePos.add(new KeyFrame(1.0f, new PVector(0, 0, -100)));
  cubePos.add(new KeyFrame(1.5f, new PVector(0, 0, 0)));
  cubePos.add(new KeyFrame(2.0f, new PVector(0, 0, 100)));

  Animation cube = new Animation(cubePos);
  cubeShape.SetAnimation(cube);
  for(int i = 0; i < 11; i++)
  {
    PositionInterpolator pi = new PositionInterpolator();
    pi.SetAnimation(cube);

    if(i % 2 == 1)
    {
      pi.SetFrameSnapping(true);
    }
    //pi.Update(0.1f*i);
    cubes.add(pi);
  }

  /*====== Create Animations For Spheroid ======*/
  Animation spherePos = new Animation(sphereAnim.keyFrames);
  // Create and set keyframes
  spherePosition.SetAnimation(spherePos);

  cam = new Camera();
}

void draw()
{
  lights();
  background(0);
  perspective(radians(90f), width/(float)height, 0.1, 1000);
  DrawGrid();

  float playbackSpeed = 0.005f;
  cam.Update();

  /*====== Draw Forward Monster ======*/
  pushMatrix();
  translate(-40, 0, 0);
  monsterForward.fillColor = color(128, 200, 54);
  monsterForward.Update(playbackSpeed);
  shape(monsterForward.currentShape);
  popMatrix();

  /*====== Draw Reverse Monster ======*/
  pushMatrix();
  translate(40, 0, 0);
  monsterReverse.fillColor = color(220, 80, 45);
  monsterReverse.Update(-playbackSpeed);
  shape(monsterReverse.currentShape);
  popMatrix();

  /*====== Draw Snapped Monster ======*/
  pushMatrix();
  translate(0, 0, -60);
  monsterSnap.fillColor = color(160, 120, 85);
  monsterSnap.Update(playbackSpeed);
  shape(monsterSnap.currentShape);
  popMatrix();

  /*====== Draw Spheroid ======*/
  
  //sphere position is a position interpolator.
  spherePosition.Update(playbackSpeed);
  sphereForward.fillColor = color(39, 110, 190);
  sphereForward.Update(playbackSpeed);
  PVector pos = spherePosition.currentPosition;
  pushMatrix();
  translate(pos.x, pos.y, pos.z);
  shape(sphereForward.currentShape);
  popMatrix();

  /*====== TODO: Update and draw cubes ======*/
  // For each interpolator, update/draw
  for(int i = 0; i < cubes.size(); i++)
  {
    cubes.get(i).Update(playbackSpeed);
    cubeShape.Update(playbackSpeed);
    cubeShape.fillColor = color(39, 110, 190);
    PVector position = cubes.get(i).currentPosition;
    pushMatrix();
    translate(position.x, position.y, position.z);
    shape(cubeShape.GetShape());
    popMatrix();
  }
}

void mouseWheel(MouseEvent event)
{
  float e = event.getCount();
  // Zoom the camera
  wheeled = true;
  cam.Zoom(e);
}

// Create and return an animation object
Animation ReadAnimationFromFile(String fileName)
{
  Animation animation = new Animation();
  
  String line;
  String values[];
  try
  {
    BufferedReader reader = createReader(fileName);
    int numFrames = parseInt(reader.readLine());
    int numVertices = parseInt(reader.readLine());
    for (int i = 0; i < numFrames; i++)
    {
      KeyFrame frame = new KeyFrame();
      float time = parseFloat(reader.readLine());
      frame.time = time;
      for (int j = 0; j < numVertices; j++)
      {
        line = reader.readLine();
        values = line.split(" ");
        PVector vec = new PVector(parseFloat(values[0]), parseFloat(values[1]), parseFloat(values[2]));
        frame.points.add(vec);
      }
      animation.keyFrames.add(frame);
    }
  }
  catch (FileNotFoundException ex)
  {
    println("File not found: " + fileName);
  }
  catch (IOException ex)
  {
    ex.printStackTrace();
  }
  return animation;
}

void DrawGrid()
{
  // TODO: Draw the grid
  // Dimensions: 200x200 (-100 to +100 on X and Z)
  stroke(255);
  for (int i = -100; i <= 100; i+= 10)
  {
    line(i, 0, -100, i, 0, 100);

    line(-100, 0, i, 100, 0, i);
  }
  stroke(255, 0, 0);
  line(-100, 0, 0, 100, 0, 0);
  stroke(0, 255, 0);
  line(0, 0, -100, 0, 0, 100);
}
