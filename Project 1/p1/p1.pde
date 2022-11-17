import controlP5.*;

ControlP5 cp5;
Button start;
Slider iterate, stepCount;
CheckBox box;
int x, y, step = 1, colormap = 0, iterations, Stroke;
boolean colorToggle = false, gradualToggle = false;

int getNumber()
{
  int step = (int) random(4);
  return step;
}

void setup()
{
  cp5 = new ControlP5(this);
  size(800, 800);
  background(102, 176, 237);
  PFont UIFont = createFont("Arial", 16);
  
  start = cp5.addButton("Start")
    .setPosition(0, 0)
    .setSize(75, 50)
    .setColorLabel(color(214, 52, 15))
    .setFont(UIFont);

  box = cp5.addCheckBox("Toggle")
    .setPosition(85, 0)
    .setSize(30, 30)
    .setColorForeground(color(120))
    .setColorActive(color(255))
    .setColorLabel(color(214, 52, 15))
    .setFont(UIFont)
    .addItem("Color", 0)
    .addItem("Gradual", 1);

  iterate = cp5.addSlider("Iteration")
    .setPosition(180, 10)
    .setSize(300, 30)
    .setFont(UIFont)
    .setColorLabel(color(214, 52, 15))
    .setRange(1000, 500000);

  stepCount = cp5.addSlider("Step Count")
    .setPosition(180, 41)
    .setSize(300, 30)
    .setFont(UIFont)
    .setColorLabel(color(214, 52, 15))
    .setRange(1, 1000);
}

void Start()
{
  background(102, 176, 237);
  colormap = 0;
  colorToggle = false;
  gradualToggle = false;
  
  x = 400;
  y = 400;
  point(x, y);
  
  iterations = (int) iterate.getValue();

  if (box.getState(0)) 
  {
    colorToggle = true;
  }

  if (box.getState(1)) 
  {
    gradualToggle = true;
    draw();
  } 
  else 
  {
    instantDraw();
  }
}

void draw()
{
  if (gradualToggle) 
  {
    int rate = (int) stepCount.getValue();
    if (colormap < iterations) 
    {
      for (int i = 0; i < rate; i++) 
      {
        if (colorToggle) 
        {
          //map the percent of completed iterations from black --> white color.
          Stroke = (int)map(colormap, 0, iterations, 0, 255);
          stroke(Stroke);
        }
        switch(getNumber()) 
        {
        case 0:
          y += step;
          if (y > 800) 
          {
            y -= step;
          } 
          else 
          {
            point(x, y + step);
            break;
          }
        case 1:
          y -= step;
          if (y < 0) 
          {
            y += step;
          } 
          else 
          {
            point(x, y - step);
            break;
          }
        case 2:
          x -= step;
          if (x < 0) 
          {
            x += step;
          } 
          else 
          {
            point(x - step, y);
            break;
          }
        case 3:
          x += step;
          if (x > 800) 
          {
            x -= step;
          } 
          else 
          {
            point(x + step, y);
            break;
          }
        }
        colormap++;
      }
    }
  }
}

void instantDraw()
{
  iterations = (int) iterate.getValue();
  for (int i = 0; i < iterations; i++)
  {
    if (colorToggle) 
    {
      //println(colorToggle);
      int Stroke = (int)map(colormap, 0, iterations, 0, 255);
      stroke(Stroke);
    }
    switch(getNumber())
    {
    case 0:
      y += step;
      if (y > 800) 
      {
        y -= step;
      } 
      else 
      {
        point(x, y + step);
        break;
      }

    case 1:
      y -= step;
      if (y < 0) 
      {
        y += step;
      } 
      else 
      {
        point(x, y - step);
        break;
      }
    case 2:
      x -= step;
      if (x < 0) 
      {
        x += step;
      } 
      else 
      {
        point(x + step, y);
        break;
      }

    case 3:
      x += step;
      if (x > 800) 
      {
        x -= step;
      } 
      else 
      {
        point(x + step, y);
        break;
      }
    }
    colormap++;
  }
}

//void testFunction()
//{
//  boolean temp = box.getState("Gradual");
//  println("Gradual value: ", temp);
  
//  temp = box.getState("COLOR");
//  println("Color value: ", temp);
//}

//void calcFPS()
//{
//  int rate = (int) stepCount.getValue();
//  int iterations = (int)iterate.getValue();
  
//  float frames = iterations/rate;
//  println("Frames: " + frames);
//}
