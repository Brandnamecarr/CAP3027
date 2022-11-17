import controlP5.*;

ControlP5 cp5;
boolean start = false;
Camera camera = new Camera();
Grid grid = null;
PImage hMap = null;

void setup()
{
  background(0);
  size(1200, 800, P3D);
  perspective(radians(90), (float) width/(float) height, 0.1, 1000);
  initUI();
}

void initUI()
{
  cp5 = new ControlP5(this);

  cp5.addSlider("rows")
    .setPosition(10, 10)
    .setSize(150, 10)
    .setRange(1, 100);

  cp5.addSlider("columns")
    .setPosition(10, 30)
    .setSize(150, 10)
    .setRange(1, 100);

  cp5.addSlider("terrainSize")
    .setPosition(10, 50)
    .setSize(150, 10)
    .setRange(20, 50)
    .setCaptionLabel("terrain size");

  cp5.addButton("generate")
    .setPosition(10, 80)
    .setSize(80, 20);

  cp5.addTextfield("filename")
    .setCaptionLabel("load from file")
    .setPosition(10, 110)
    .setSize(250, 20)
    .setValue("terrain0")
    .setAutoClear(false);

  cp5.addToggle("stroke")
    .setPosition(300, 10)
    .setSize(40, 20)
    .setValue(true);

  cp5.addToggle("color")
    .setPosition(350, 10)
    .setSize(40, 20)
    .setCaptionLabel("color");

  cp5.addToggle("blend")
    .setPosition(400, 10)
    .setSize(40, 20);

  cp5.addSlider("heightMod")
    .setPosition(300, 60)
    .setSize(100, 10)
    .setRange(-5, 5)
    .setValue(0)
    .setCaptionLabel("height modifier");

  cp5.addSlider("snowThresh")
    .setPosition(300, 80)
    .setSize(100, 10)
    .setRange(1, 5)
    .setCaptionLabel("snow threshold");
}

void draw()
{
  background(0);
  camera.Update();
  perspective(radians(90), (float)width /(float)height, 0.1, 1000);
  camera(camera.camX, camera.camY, camera.camZ, camera.tempX, camera.tempY, camera.tempZ, 0, 1, 0);

  if (start == true)
  {
    grid.Draw();
  }
  camera();
  perspective();
}

void mouseWheel(MouseEvent event)
{
  float ev = event.getCount();
  camera.Zoom(ev);
}

void keyReleased()
{
  if (key == ENTER)
  {
    generate();
  }
}

void mouseDragged()
{
  if (cp5.isMouseOver())
  {
    return;
  } else
  {
    float deltaX = (mouseX - pmouseX) * 0.01f;
    float deltaY = (mouseY - pmouseY) * 0.01f;

    camera.phi += deltaX;
    if (degrees(camera.theta) - degrees(deltaY) > 180 && degrees(camera.theta) - degrees(deltaY) < 269)
    {
      camera.theta -= deltaY;
    }
  }
}


void generate()
{
  grid = null;
  hMap = null;
  grid = new Grid();

  String filename = cp5.get(Textfield.class, "filename").getText() + ".png";
  //check if index is in range 0-7 .charAt(8).
  char c = filename.charAt(7);
  if ( c - '0' > 6)
  {
    StringBuilder temp = new StringBuilder(filename);
    temp.setCharAt(7, '0');
    filename = temp.toString();
    String correctString = temp.substring(0, temp.length() - 4);
    cp5.get(Textfield.class, "filename").setText(correctString);
  }
  hMap = loadImage("../data/" + filename);
  grid.generateHeight();
  start = true;
}

class Camera
{
  float camX, camY, camZ, radius, theta, phi, tempX, tempY, tempZ;

  Camera()
  {
    theta = 5.5 * PI/4;
    phi = 3 * PI/2;
    radius = 15;//10-200
    tempX = 0;
    tempY = 0;
    tempZ = 0;
  }

  void Update()
  {
    camX = radius * cos(phi) * sin(theta) + tempX;
    camY = radius * cos(theta) + tempY;
    camZ = radius * sin(theta) * sin(phi) + tempZ;
  }

  void Zoom(float zoom)
  {
    if (zoom > 0)
    {
      if (radius < 200)
      {
        radius += 5;
      }
    } else if (zoom < 0)
    {
      if (radius > 10)
      {
        radius -= 5;
      }
    }
  }
} //end of camera class.

class Grid
{
  int rows;
  int columns;
  float gridSize;
  ArrayList<PVector> vertices;
  ArrayList<Integer> triangles;
  color snow = color(255, 255, 255);
  color grass = color(143, 170, 64);
  color rock = color(135, 135, 135);
  color dirt = color(160, 126, 84);
  color water = color(0, 75, 200);

  Grid()
  {
    rows = int(cp5.getController("rows").getValue());
    columns = int(cp5.getController("columns").getValue());
    gridSize = cp5.getController("terrainSize").getValue();
    vertices = new ArrayList<PVector>();
    triangles = new ArrayList<Integer>();
    makeVertices();
    makeTriangles();
  }

  void makeVertices()
  {
    float tempRows = -gridSize/2;
    for (int r = 0; r <= rows; r++)
    {
      float tempCols = -gridSize/2;
      for (int c = 0; c <= columns; c++)
      {
        PVector temp = new PVector(tempCols, 0, tempRows);
        vertices.add(temp);
        tempCols += gridSize/columns;
      }
      tempRows += gridSize/rows;
    }
  }

  void makeTriangles()
  {
    int verticesrow = columns + 1;
    for (int r = 0; r < rows; r++)
    {
      for (int c = 0; c < columns; c++)
      {
        int startIndex = r * verticesrow + c;
        triangles.add(startIndex);
        triangles.add(startIndex + 1);
        triangles.add(startIndex + verticesrow);

        triangles.add(startIndex + 1);
        triangles.add(startIndex + verticesrow + 1);
        triangles.add(startIndex + verticesrow);
      }
    }
  }

  void generateHeight()
  {
    for (int r = 0; r <= rows; r++)
    {
      for (int c = 0; c <= columns; c++)
      {
        float x_index = map(c, 0, columns + 1, 0, hMap.width);
        float y_index = map(r, 0, rows + 1, 0, hMap.height);
        int colorz = hMap.get(int(x_index), int(y_index));
        float heightFromColor = map(red(colorz), 0, 255, 0, 1.0f);
        int vertex_index = r * (columns + 1) + c;
        vertices.get(vertex_index).y = -heightFromColor;
      }
    }
  }

  void Draw()
  {
    if (cp5.getController("stroke").getValue() != 1)
    {
      noStroke();
    } 
    else
    {
      stroke(0);
    }
    fill(255, 255, 255);
    float heightMod = cp5.getController("heightMod").getValue();
    float snowThresh = cp5.getController("snowThresh").getValue();

    beginShape(TRIANGLES);
    for (int i=0; i < triangles.size(); i++)
    {
      int vertIndex = triangles.get(i);
      PVector vert = vertices.get(vertIndex);

      if (cp5.getController("color").getValue() == 1)
      {
        float relativeHeight = abs(vert.y) * heightMod / snowThresh;
        if (0.8 < relativeHeight)
        {
          if (cp5.getController("blend").getValue() == 1)
          {
            float ratio = (relativeHeight - 0.8f)/0.2f;
            fill(lerpColor(rock, snow, ratio));
          } 
          else
          {
            fill(snow);
          }
        }
        if (0.4 < relativeHeight && relativeHeight < 0.8)
        {
          if (cp5.getController("blend").getValue() == 1)
          {
            float ratio = (relativeHeight - 0.4f) / 0.4f;
            fill(lerpColor(grass, rock, ratio));
          } 
          else
          {
            fill(rock);
          }
        }
        if (0.2 < relativeHeight && relativeHeight < 0.4)
        {
          if (cp5.getController("blend").getValue() == 1)
          {
            float ratio = (relativeHeight - 0.2f) / 0.2f;
            fill(lerpColor(dirt, grass, ratio));
          } 
          else
          {
            fill(grass);
          }
        } 
        else if (relativeHeight < 0.2)
        {
          if (cp5.getController("blend").getValue() == 1)
          {
            float ratio = relativeHeight / 0.2f;
            fill(lerpColor(water, dirt, ratio));
          } 
          else
          {
            fill(water);
          }
        }
      }
      vertex(vert.x, vert.y * heightMod, vert.z);
    }
    endShape();
  }
} //end of grid class.
