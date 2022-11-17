import controlP5.*;
ControlP5 cp5;

Button start;
DropdownList list;
Slider maxSteps;
Slider stepRate;
Slider stepSize;
Slider stepScale;
CheckBox toggles;
Textfield seedBox;
boolean started = false;
int x = width/2;
int y = height/2;
float heX, heY;
int count = 0;
HashMap<PVector, Integer> map = new HashMap();
ArrayList<Textlabel> labels = new ArrayList();

//UI components:

void setup()
{
  cp5 = new ControlP5(this);
  size(1200, 800);
  background(200, 200, 200, 0);
  noStroke();
  fill(100, 100, 100);
  rect(0, 0, 200, 800);
  
  start = cp5.addButton("Start")
      .setPosition(10, 10)
      .setColorBackground(color(0,128,0))
      .setSize(90, 30);
   
  list = cp5.addDropdownList("SQUARES")
      .setPosition(10, 60)
      .setItemHeight(40)
      .setBarHeight(35)
      .addItem("SQUARES", 0)
      .addItem("Hexagons", 1)
      .setSize(150, 300)
      .setOpen(false);
      
   maxSteps = cp5.addSlider("maxSteps")
       .setPosition(10, 230)
       .setRange(100, 50000)
       .setCaptionLabel(" ")
       .setSize(130, 25);
   Textlabel temp = new Textlabel(cp5, "Max Steps", 10, 217);
   temp.draw();
   labels.add(temp);
   
   stepRate = cp5.addSlider("stepRate")
       .setPosition(10, 280)
       .setRange(1, 1000)
       .setCaptionLabel(" ")
       .setSize(130, 25); 
    temp = new Textlabel(cp5, "Step Rate", 10, 268);
    temp.draw();
    labels.add(temp);
    
    stepSize = cp5.addSlider("stepSize")
        .setPosition(10, 360)
        .setRange(10, 30)
        .setCaptionLabel(" ")
        .setSize(110, 25);
    temp = new Textlabel(cp5, "Step Size", 10, 348);
    temp.draw();
    labels.add(temp);
    
    stepScale = cp5.addSlider("stepScale")
        .setPosition(10, 415)
        .setRange(1.0, 1.5)
        .setCaptionLabel(" ")
        .setSize(110, 25);
     temp = new Textlabel(cp5, "Step Scale", 10, 402);
     temp.draw();
     labels.add(temp);
    
    toggles = cp5.addCheckBox("toggles")
        .setPosition(10, 455)
        .addItem("Constrain Steps", 0)
        .addItem("Simulate Terrain", 1)
        .addItem("Use Stroke", 2)
        .addItem("Use Random Seed", 3)
        .setSpacingRow(30)
        .setCaptionLabel(" ")
        .setSize(30, 30);
     
   seedBox = cp5.addTextfield("seedBox")
       .setPosition(10, 700)
       .setInputFilter(ControlP5.INTEGER)
       .setSize(55, 30);
}

public class RandomWalkBaseClass 
{
  
  int max, rate, size, seedValue, shapeType;
  float scale;
  boolean stroke, seed, constrain, terrainColor;

  
  public RandomWalkBaseClass()
  {
    max = (int) maxSteps.getValue();
    rate = (int) stepRate.getValue();
    size = (int) stepSize.getValue();
    scale = (int) stepScale.getValue();
    constrain = toggles.getState(0);
    terrainColor = toggles.getState(1);
    stroke = toggles.getState(2);
    seed = toggles.getState(3);
    String value = seedBox.getText();
    try 
    {
      seedValue = Integer.parseInt(value);
    } catch(NumberFormatException ex)
    {
      seedValue = 0;
    }
  }
}

//operations: 

RandomWalkBaseClass someObj = null;

void Start()
  {
    started = true;
    x = width/2;
    y = height/2;
    heX = width/2;
    heY = height/2;
    count = 0;
    map.clear();
    
    background(200, 200, 200, 0);
    noStroke();
    fill(100, 100, 100);
    rect(0, 0, 200, 800);
    
    for(int i = 0; i < labels.size(); i++)
    {
      labels.get(i).draw();
    }
    
    if(toggles.getState(3) && seedBox.getText() != "")
    {
      randomSeed(Integer.parseInt(seedBox.getText()));
    }
  }
  
void draw()
  {
    if(started)
    {
      getShape();
    }
  }
  
void getShape()
  {
    int shapeType = (int) list.getValue();
    if(shapeType == 0)
    {
      //println("making a square");
      someObj = new SquareClass();
    }
    else if(shapeType == 1)
    {
      //println("making a hexagon");
      someObj = new HexagonClass();
    }
  }
  
  
public class SquareClass extends RandomWalkBaseClass
{
  int step = (int)(size * scale);
  int bound = 0;
  
  public SquareClass()
  {
    if(constrain)
    {
      bound = 201;
    }
    if(!terrainColor)
    {
      fill(255, 0, 255);
    }
    Draw();
  }
  
  public void Draw()
  {
    int temp = 0;
    while(temp < max)
    {
      if(stroke)
      {
        stroke(2);
      }
      switch(randomWalk())
      {
        case 0:
        y += step;
        if(y > 800)
        {
          y -= step;
        }
        else 
        {
          squareColor(x, y);
          break;
        }
        
        case 1:
        y -= step;
        if(y < 0)
        {
          y += step;
        }
        else
        {
          squareColor(x, y);
          square(x, y, size);
          break;
        }
        case 2:
        x -= step;
        if(x < bound)
        {
          x += step;
        }
        else
        {
          squareColor(x, y);
          square(x, y, size);
          break;
        }
        
        case 3:
        x += step;
        if(x > width)
        {
          x -= step;
        }
        else
        {
          squareColor(x, y);
          square(x, y, size);
          break;
        }
      }
      temp++;
      if(temp == max)
      {
        started = false;
        break;
      }
    }
  }
  
  public void squareColor(int x, int y)
  {
    int count = 0;
    if(terrainColor)
    {
      PVector vector = new PVector(Math.round(x * 100)/100, Math.round(y * 100)/100);
      
      if(map.get(vector) == null)
      {
        map.put(vector, 1);
      }
      else
      {
        count = map.get(vector);
        count++;
        map.put(vector, count);
      }
      if(count < 4)
      {
        fill(160, 126, 84);
      }
      else if((4 < count) && (count < 7))
      {
        fill(143, 170, 64);
      }
      else if((7 < count) && (count < 10))
      {
        fill(135, 135, 135);
      }
      else
      {
        fill(count * 20, count * 20, count * 20);
      }
    }
  }
  
  public int randomWalk()
  {
    int walk = (int) random(4);
    return walk;
  }
} //end of square class def


public class HexagonClass extends RandomWalkBaseClass
{
  float step = (float) (size * scale * sqrt(3));
  float stepxA = (float)(size * scale * sqrt(3) * cos(radians(-30)));
  float stepyA = (float)(size * scale * sqrt(3) * sin(radians(-30)));
  float stepxB = (float)(size * scale * sqrt(3) * cos(radians(30)));
  float stepyB = (float)(size * scale * sqrt(3) * sin(radians(30)));
  float stepxC = (float)(size * scale * sqrt(3) * cos(radians(150)));
  float stepyC = (float)(size * scale * sqrt(3) * sin(radians(150)));
  float stepxaD = (float)(size * scale * sqrt(3) * cos(radians(-150)));
  float stepyaD = (float)(size * scale * sqrt(3) * sin(radians(-150)));
  int bound = 0;
  int count = 0;
  
  public HexagonClass()
  {
     if(constrain)
     {
       bound = 201;
     }
     
     if(!terrainColor) 
     {
       fill(255, 0, 255);
     }
     Draw();
  }
  
  
  public void Draw()
  {
    int temp = 0;
    while(temp < max)
    {
      if(stroke)
      {
        stroke(2);
      }
      
      switch(randomWalk())
      {
        case 0:
        heY += stepyA;
        heX += stepxA;
        if(heY > 800 || heX > width || heX < bound)
        {
          heY -= stepyA;
          heX -= stepxA;
        }
        else
        {
          colorHex(heX, heY);
          Hexagon(heX, heY, size);
          break;
        }
        
        case 1:
        heY += step;
        if(heY > 800 || heX < bound)
        {
          heY -= step;
        }
        else
        {
          colorHex(heX, heY);
          Hexagon(heX, heY, size);
          break;
        }
        
        case 2:
        heX += stepxaD;
        heY += stepyaD;
        
        if(heY > 800 || heX > width || heX < bound)
        {
          heX -= stepxaD;
          heY -= stepyaD;
        }
        else
        {
          colorHex(heX, heY);
          Hexagon(heX, heY, size);
          break;
        }
        
        case 3:
        heX += stepxC;
        heY += stepyC;
        
        if(heY > 800 || heX > width || heX < bound)
        {
          heX -= stepyC;
          heY -= stepyC;
        }
        else
        {
          colorHex(heX, heY);
          Hexagon(heX, heY, size);
          break;
        }
        
        case 4:
        heY -= step;
        
        if(heY < 0 || heX > width || heX < bound)
        {
          heY += step;
        }
        else
        {
          colorHex(heX, heY);
          Hexagon(heX, heY, size);
          break;
        }
        
        case 5:
        heY += stepyB;
        heX += stepxB;
        
        if(heY > 800 || heX > width || heX < bound)
        {
          heY -= stepyB;
          heX -= stepxB;
        }
        else
        {
          colorHex(heX, heY);
          Hexagon(heX, heY, size);
          break;
        }
      }
      temp++;
      if(temp == max)
      {
        started = false;
        break;
      }
    }
  }
  
  public int randomWalk()
  {
    int walk = (int) random(6);
    return walk;
  }
  
  public void Hexagon(float x, float y, int size)
  {
    beginShape();
    for(float angle = 0; angle < 360; angle += 60)
    {
      float hexX = (x + cos(radians(angle)) * size);
      float hexY = (y + sin(radians(angle)) * size);
      vertex(hexX, hexY);
    }
    endShape(CLOSE);
  }
  
  public void colorHex(float x, float y)
  {
    if(terrainColor)
    {
      PVector vect = new PVector(Math.round(x * 100)/100, Math.round(y * 100)/100);
      
      if(map.get(vect) == null)
      {
        map.put(vect, 1);
      }
      else 
      {
        count = map.get(vect);
        count++;
        map.put(vect, count);
      }
      
      if(count < 4) 
      {
        fill(160, 126, 84);
      }
      else if (4 < count && count < 7)
      {
        fill(143, 170, 64);
      }
      else if(7 < count && count < 10)
      {
        fill(135, 135, 135);
      }
      else
      {
        fill(count * 20, count * 20, count * 20);
      }
    }
  }
} //end of hexagon class def
