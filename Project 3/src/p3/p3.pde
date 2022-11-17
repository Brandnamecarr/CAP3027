import controlP5.*;
ControlP5 cp5;

PVector vector = new PVector(0, 0, 0);
PVector cameraPos = new PVector(0, 0, 0);
boolean wheeled = false;
boolean pressed = false;
int temp = 0;
int scaled = 0;
cam object = null;
int xx = 0;

void setup()
{
  cp5 = new ControlP5(this);
  size(1600, 1000, P3D);
  
  perspective(-radians(50.0f), width/(float)height, 0.1, 1000);
  translate(width * 0.5, height * 0.5, 0);
  object = new cam();
}

void draw()
{
  colorMode(RGB, 255);
  background(155);
  //Change all these lines:
  grid();
  mon();
  cubes();
  fans();
  object.Update();
}

void grid()
{
  pushMatrix();
  
  for(int i = 0; i < 21; i++)
  {
    stroke(255);
    line(-100, 0, -100+10*i, 100, 0, -100 + 10*i);
    line(-100+10*i, 0, -100, -100+10*i, 0, 100);
  }
  
  stroke(255, 0, 0);
  line(-100, 0, 0, 100, 0, 0);
  stroke(0, 0, 255);
  line(0, 0, -100, 0, 0, 100);
  popMatrix();
}

void keyPressed()
{
  if (key == 32)
  {
    pressed = true;
    println("Spaced bar pressed");
  }
  if(key == 81)
  {
    xx++;
    print(xx+",");
  }
}

void mouseWheel(MouseEvent event)
{
  wheeled = true;
  scaled = event.getCount();
}

public class cam
{
  float x, y, z, theta, phi, scaleFactor = 0;
  int radius = 200;
  float zooming = 1;
  
  public cam() {}
  
  public void Update()
  {
    CycleTarget();
    theta = radians(map(mouseY, 0, width-1, 0, 360));
    phi = radians(map(mouseX, 0, height-1, 1, 179));
    
    cameraPos.x = vector.x + radius * cos(phi)*sin(theta);
    cameraPos.y = vector.y + radius * cos(theta);
    cameraPos.z = vector.z + radius * sin(theta)*sin(phi);
    
    camera(cameraPos.x * abs(Zoom(scaled)), cameraPos.y*abs(Zoom(scaled)), cameraPos.z*abs(Zoom(scaled)), vector.x, vector.y, vector.z, 0, 1, 0);
  }
  
  public void AddLookAtTarget(PVector v)
  {
    v.mult(0);
    
    if(temp == 5)
    {
      temp = 1;
    }
    
    switch(temp)
    {
      case 1:
      v.add(-100, 0, 0);
      break;
      
      case 2:
      v.add(-50, 0, 0);
      break;
      
      case 3:
      v.add(0, 0, 0);
      break;
      
      case 4:
      v.add(75, 0, 0);
      break;
    }
    print(v);
  }

  public void CycleTarget()
  {
    if(pressed)
    {
      AddLookAtTarget(vector);
      temp++;
      pressed = false;
    }
  }
  
  public float Zoom(float scaled)
  {
    if(wheeled)
    {
      zooming += scaled * 0.2;
      wheeled = false;
      return zooming;
    }
    else
    {
      return zooming;
    }
  }
}; //end of CAM class.


void mon()
{
  PShape monster = loadShape("monster.obj");
  pushMatrix();
  monster.setFill(true);
  monster.setFill(color(0, 0, 0, 0));
  monster.setStroke(true);
  monster.setStroke(color(0));
  monster.setStrokeWeight(1.5f);
  monster.scale(1, 1, -1);
  monster.translate(75, 0, 0);
  shape(monster);
  popMatrix();
  pushMatrix();
  monster.setStroke(true);
  monster.setStroke(color(190, 230, 60));
  monster.setFill(true);
  monster.translate(-75, 0, 0);
  monster.scale(0.5);
  shape(monster);
  popMatrix();
}

void cubes()
{
  translate(-100, 0, 0);
  
  pushMatrix();
  translate(-10, 0, 0);
  cubeshape();
  popMatrix();
  
  pushMatrix();
  scale(5, 5, 5);
  cubeshape();
  popMatrix();
  
  pushMatrix();
  translate(10, 0, 0);
  scale(10, 20, 10);
  cubeshape();
  popMatrix();
  translate(100, 0, 0);
}

void cubeshape()
{
  beginShape(TRIANGLE);
  noStroke();
  fill(255, 255, 0);
  vertex(-0.5, -0.5, -0.5);
  vertex(-0.5, 0.5, -0.5);
  vertex(0.5, -0.5, -0.5);
  
  fill(0, 255, 0);
  vertex(-0.5, 0.5, -0.5);
  vertex(0.5, -0.5, -0.5);
  vertex(0.5, 0.5, -0.5);
  
  fill(160, 60, 179);
  vertex(-0.5, -0.5, 0.5);
  vertex(-0.5, 0.5, 0.5);
  vertex(0.5, 0.5, 0.5);
  
  fill(160, 209, 182);
  vertex(-0.5, -0.5, 0.5);
  vertex(0.5, 0.5, 0.5);
  vertex(0.5, -0.5, 0.5);
  
  fill(247, 107, 0);
  vertex(-0.5, 0.5, 0.5);
  vertex(0.5, 0.5, -0.5);
  vertex(-0.5, 0.5, -0.5);
  
  fill(254, 60, 39);
  vertex(0.5, 0.5, 0.5);
  vertex(0.5, -0.5, 0.5);
  vertex(0.5, 0.5, -0.5);
  
  fill(75, 128, 199);
  vertex(0.5, -0.5, 0.5);
  vertex(0.5, 0.5, -0.5);
  vertex(0.5, -0.5, -0.5);
  
  fill(254, 0, 0);
  vertex(-0.5, -0.5, -0.5);
  vertex(-0.5, -0.5, -0.5);
  vertex(-0.5, -0.5, -0.5);
  
  fill(250, 2, 251);
  vertex(-0.5, -0.5, 0.5);
  vertex(-0.5, -0.5, -0.5);
  vertex(0.5, -0.5, -0.5);
  
  fill(102, 102, 222);
  vertex(-0.5, 0.5, 0.5);
  vertex(-0.5, -0.5, 0.5);
  vertex(-0.5, -0.5, -0.5);
  
  fill(180, 180, 150);
  vertex(-0.5, 0.5, 0.5);
  vertex(-0.5, -0.5, -0.5);
  vertex(-0.5, 0.5, -0.5);
  endShape();
}

void fans()
{
  translate(-50, 0, 0);
  scale(-1, 1, 1);
  pushMatrix();
  translate(10, 0, 0);
  fanshape(20);
  popMatrix();
  pushMatrix();
  translate(-10, 0, 0);
  fanshape(6);
  popMatrix();
}

void fanshape(int segment)
{
  int col = 0;
  pushMatrix();
  colorMode(HSB, 360, 100, 100);
  beginShape(TRIANGLE_FAN);
  stroke(2);
  int i = 10;
  fill(col, 100, 100);
  vertex(0, i, 0);
  for(float angle = 0; angle <= 360; angle += 360/segment)
  {
    float vx = i + cos(radians(angle)) * i;
    float vy = i + sin(radians(angle)) * i;
    
    col += 360/segment;
    fill(col, 100, 100);
    vertex(vx, vy);
  }
  popMatrix();
  endShape();
}
