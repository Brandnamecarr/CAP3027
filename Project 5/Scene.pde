class Scene
{
  // TODO: Write this class!
  BufferedReader inFile;  //Txt
  PVector bg = new PVector();  //Background color
  int shapeNum = 0;  //Number of shapes
  String shapeNames[];  //Name of Shapes
  float spos[][];  //Shape position
  int scolor[][];  //Shape color
  int lnum=0;  //Number of lights
  float lpos[][];  //light position
  int lcolor[][];  //light color
  
  
  //copied below:
  Scene(BufferedReader inFileName) 
  {
    this.inFile = inFileName; 
  }

   void Update() 
   {
    try 
    {
      //Get background color 1's line
      String line = inFile.readLine();  
      String value[] = line.split(",");  
      bg.add(Integer.parseInt(value[0]), Integer.parseInt(value[1]), Integer.parseInt(value[2]));  
      line = inFile.readLine();
      shapeNum = Integer.parseInt(line);   
      shapeNames=new String[shapeNum];  
      spos=new float[shapeNum][3];  
      scolor=new int[shapeNum][3];  
      for(int i = 0; i < shapeNum; i++)
      {  
        line = inFile.readLine();
        value = line.split(",");
        shapeNames[i] = value[0];  
        spos[i][0]=Float.parseFloat(value[1]);  
        spos[i][1]=Float.parseFloat(value[2]); 
        spos[i][2]=Float.parseFloat(value[3]); 
        scolor[i][0]=Integer.parseInt(value[4]);  
        scolor[i][1]=Integer.parseInt(value[5]); 
        scolor[i][2]=Integer.parseInt(value[6]);  
      }  
      line = inFile.readLine();
      lnum = Integer.parseInt(line);  
    
      lpos=new float[lnum][3]; 
      lcolor=new int[lnum][3];  
      for(int i = 0; i < lnum; i++)
      { 
        line = inFile.readLine();
        value = line.split(",");
        lpos[i][0]=Float.parseFloat(value[0]); 
        lpos[i][1]=Float.parseFloat(value[1]);  
        lpos[i][2]=Float.parseFloat(value[2]);  
        lcolor[i][0]=Integer.parseInt(value[3]);  
        lcolor[i][1]=Integer.parseInt(value[4]);  
        lcolor[i][2]=Integer.parseInt(value[5]);
      }
    }
    catch(IOException e) 
    {
      e.printStackTrace();
    }   
  }

  void DrawScene()
  {
    // TODO: Draw all the information in this scene
    background(bg.x, bg.y, bg.z);
    
    for(int i = 0; i < lnum; i++)
    {
      pointLight(lcolor[i][0],lcolor[i][1],lcolor[i][2],lpos[i][0],lpos[i][1],lpos[i][2]);
    }
    
    for(int j = 0; j < shapeNum; j++)
    {
      PShape model=loadShape("models/"+shapeNames[j]+".obj"); 
      
      pushMatrix();
      model.setFill(true);  
      model.setFill(color(scolor[j][0],scolor[j][1],scolor[j][2]));
      model.setStroke(false);
      model.translate(spos[j][0], spos[j][1], spos[j][2]); 
      shape(model);
      popMatrix();
    }
  }


  int GetShapeCount() 
  {
    return shapeNum;
  }

  int GetLightCount() 
  {
    return lnum;
  }
} //end of Scene class.
