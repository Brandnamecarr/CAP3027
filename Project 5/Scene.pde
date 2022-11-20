// TODO: Write this class!

class Scene
{
  BufferedReader inFile;  
  PVector bg = new PVector(); 
  int shapeNum = 0, lightNum = 0; 
  String shapeNames[]; 
  float shapeCoords[][];  
  int shapeColor[][];   
  float lightCoords[][];  
  int lightColor[][];  
  
  public Scene(BufferedReader inFileName) 
  {
    this.inFile = inFileName; 
  }

  public void Update() 
   {
    try 
    {
      String line = inFile.readLine();  
      String value[] = line.split(",");  
      bg.add(Integer.parseInt(value[0]), Integer.parseInt(value[1]), Integer.parseInt(value[2]));  
      line = inFile.readLine();
      shapeNum = Integer.parseInt(line);   
      shapeNames = new String[shapeNum];  
      shapeCoords = new float[shapeNum][3];  
      shapeColor = new int[shapeNum][3];  
      for(int i = 0; i < shapeNum; i++)
      {  
        line = inFile.readLine();
        value = line.split(",");
        shapeNames[i] = value[0];  
        shapeCoords[i][0] = Float.parseFloat(value[1]);  
        shapeCoords[i][1] = Float.parseFloat(value[2]); 
        shapeCoords[i][2] = Float.parseFloat(value[3]); 
        shapeColor[i][0] = Integer.parseInt(value[4]);  
        shapeColor[i][1] = Integer.parseInt(value[5]); 
        shapeColor[i][2] = Integer.parseInt(value[6]);  
      }  
      line = inFile.readLine();
      lightNum = Integer.parseInt(line);  
    
      lightCoords = new float[lightNum][3]; 
      lightColor = new int[lightNum][3];  
      for(int i = 0; i < lightNum; i++)
      { 
        line = inFile.readLine();
        value = line.split(",");
        lightCoords[i][0] = Float.parseFloat(value[0]); 
        lightCoords[i][1] = Float.parseFloat(value[1]);  
        lightCoords[i][2] = Float.parseFloat(value[2]);  
        lightColor[i][0] = Integer.parseInt(value[3]);  
        lightColor[i][1] = Integer.parseInt(value[4]);  
        lightColor[i][2] = Integer.parseInt(value[5]);
      }
    }
    catch(IOException e) 
    {
      e.printStackTrace();
    }  
    catch(NumberFormatException nf)
    {
      nf.printStackTrace();
    }
  }

  void DrawScene()
  {
    // TODO: Draw all the information in this scene
    background(bg.x, bg.y, bg.z);
    
    for(int i = 0; i < lightNum; i++)
    {
      pointLight(lightColor[i][0],lightColor[i][1],lightColor[i][2],lightCoords[i][0],lightCoords[i][1],lightCoords[i][2]);
    }
    
    for(int j = 0; j < shapeNum; j++)
    {
      PShape model = loadShape("models/" + shapeNames[j] + ".obj"); 
      
      pushMatrix();
      model.setFill(true);  
      model.setFill(color(shapeColor[j][0],shapeColor[j][1],shapeColor[j][2]));
      model.setStroke(false);
      model.translate(shapeCoords[j][0], shapeCoords[j][1], shapeCoords[j][2]); 
      shape(model);
      popMatrix();
    }
  }

 public int GetShapeCount() 
  {
    return shapeNum;
  }

 public int GetLightCount() 
  {
    return lightNum;
  }
} //end of Scene class.
