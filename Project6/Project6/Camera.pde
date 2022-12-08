//Camera class
public class Camera {
  //Global Variable
  float x, y, z, theta, phi, scaleFactor = 0, zooming = 1;
  int radius = 200;

  //Constructor
  public void Camera() {}

  public void Update() 
  {
    CycleTarget();
   
    theta = radians(map(mouseY, 0, width-1, 0, 360));
    phi = radians(map(mouseX, 0, height-1, 1, 179));
  
    cameraPosition.x = vec.x + radius*cos(phi)*sin(theta); 
    cameraPosition.y = vec.y + radius*cos(theta); 
    cameraPosition.z = vec.z + radius*sin(theta)*sin(phi); 

    camera(cameraPosition.x*abs(Zoom(scaled)), cameraPosition.y*abs(Zoom(scaled)), cameraPosition.z*abs(Zoom(scaled)), vec.x, vec.y, vec.z, 0, 1, 0); 
  }

 
  public void AddLookAtTarget(PVector vec) 
  {
    vec.mult(0);
    if (temp == 5) 
    {
      temp = 1;
    }
    
    switch(temp) 
    {
    case 1: 
      vec.add(-100, 0, 0);
      break;
    case 2:
      vec.add(-50, 0, 0);
      break;
    case 3:
      vec.add(0, 0, 0);
      break;
    case 4:
      vec.add(75, 0, 0);
      break;
    }
  };

  public void CycleTarget() 
  {
    if (pressed) 
    {
      AddLookAtTarget(vec);
      temp++;
      pressed=false;
    }
  };

  //Zoom to target
  public float Zoom(float scaled) 
  {
    if (wheeled) 
    {
      zooming += scaled*0.2;
      wheeled = false;
      return zooming;
    } 
    else 
    {
      return zooming;
    }
  };
}
