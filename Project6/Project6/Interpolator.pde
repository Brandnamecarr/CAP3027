abstract class Interpolator
{
  Animation animation;
  
  // Where we at in the animation?
  float currentTime = 0;
  
  // To interpolate, or not to interpolate... that is the question
  boolean snapping = false;
  
  void SetAnimation(Animation anim)
  {
    animation = anim;
  }
  
  void SetFrameSnapping(boolean snap)
  {
    snapping = snap;
  }
  
  void UpdateTime(float time)
  {
    // TODO: Update the current time
    // Check to see if the time is out of bounds (0 / Animation_Duration)
    // If so, adjust by an appropriate amount to loop correctly
    float duration = animation.GetDuration();
    
    if(currentTime + time < 0)
    {
      currentTime = duration;
    }
    else if(currentTime + time > duration)
    {
      currentTime = 0;
    }
    else
    {
      currentTime += time;
    }
  }
  
  float ratio(float curr, float start, float end)
  {
    float r = (curr-start)/(end-start);
    if(r > 1)
    {
      return currentTime/end;
    }
    else
    {
      return r;
    }
  }
  // Implement this in derived classes
  // Each of those should call UpdateTime() and pass the time parameter
  // Call that function FIRST to ensure proper synching of animations
  abstract void Update(float time);
}

class ShapeInterpolator extends Interpolator
{
  // The result of the data calculations - either snapping or interpolating
  PShape currentShape;
  
  // Changing mesh colors
  color fillColor;
  
  PShape GetShape()
  {
    return currentShape;
  }
  
  void Update(float time)
  {
    // TODO: Create a new PShape by interpolating between two existing key frames
    // using linear interpolation
    UpdateTime(time);
    KeyFrame prev = null;
    KeyFrame next = null;
    float ratio = 0.0;
    if(time > 0)
    {
      if(currentTime < animation.keyFrames.get(0).time)
      {
        next = animation.keyFrames.get(0);
        prev = animation.keyFrames.get(animation.keyFrames.size() - 1);
        ratio = currentTime / abs(next.time);
      }
      else
      {
        for(int i = 0; i < animation.keyFrames.size(); i++)
        {
          if(currentTime >= animation.keyFrames.get(i).time && currentTime <= animation.keyFrames.get(i+1).time)
          {
            prev = animation.keyFrames.get(i);
            next = animation.keyFrames.get(i+1);
            ratio = abs(currentTime - prev.time) / abs(next.time - prev.time);
          }
        }
      }
      ArrayList<PVector> verts = new ArrayList<>();
      for(int i = 0; i < prev.points.size(); i++)
      {
        if(snapping)
        {
          verts.add(new PVector(prev.points.get(i).x, prev.points.get(i).y, prev.points.get(i).z));
        }
        else
        {
          PVector temp = new PVector();
          temp.x = lerp(prev.points.get(i).x, next.points.get(i).x, ratio);
          temp.y = lerp(prev.points.get(i).y, next.points.get(i).y, ratio);
          temp.z = lerp(prev.points.get(i).z, next.points.get(i).z, ratio);
          verts.add(temp);
        }
      }
      currentShape = createShape();
      currentShape.beginShape(TRIANGLE);
      currentShape.fill(fillColor);
      currentShape.noStroke();
      for(PVector pv : verts)
      {
        currentShape.vertex(pv.x, pv.y, pv.z);
      }
      currentShape.endShape();
    }
    else
    {
      if(currentTime < animation.keyFrames.get(0).time)
      {
        next = animation.keyFrames.get(animation.keyFrames.size() - 1);
        prev = animation.keyFrames.get(0);
        ratio = currentTime/abs(prev.time);
      }
      else
      {
        for(int i = animation.keyFrames.size() - 1; i >= 0; i--)
        {
          if(currentTime <= animation.keyFrames.get(i).time && currentTime >= animation.keyFrames.get(i-1).time)
          {
            prev = animation.keyFrames.get(i);
            next = animation.keyFrames.get(i-1);
            ratio = abs(currentTime - prev.time) / abs(next.time - prev.time);
          }
        }
      }
      ArrayList<PVector> verts = new ArrayList<>();
      for(int i = 0; i < prev.points.size(); i++)
      {
        if(snapping)
        {
          verts.add(new PVector(prev.points.get(i).x, prev.points.get(i).y, prev.points.get(i).z));
        }
        PVector v = new PVector();
        v.x = lerp(prev.points.get(i).x, next.points.get(i).x, ratio);
        v.y = lerp(prev.points.get(i).y, next.points.get(i).y, ratio);
        v.z = lerp(prev.points.get(i).z, next.points.get(i).z, ratio);
        verts.add(v);
      }
        currentShape = createShape();
        currentShape.beginShape(TRIANGLE);
        currentShape.fill(fillColor);
        currentShape.noStroke();
        for(PVector ve : verts)
        {
          currentShape.vertex(ve.x, ve.y, ve.z);
        }
        currentShape.endShape();
      }
    }
  }

class PositionInterpolator extends Interpolator
{
  PVector currentPosition;
  
  void Update(float time)
  {

    // The same type of process as the ShapeInterpolator class... except
    // this only operates on a single point
        // The same type of process as the ShapeInterpolator class... except
    // this only operates on a single point
    UpdateTime(time); 
    KeyFrame[] frame = animation.surroundingFrames(currentTime);
    //Get ratio
    float rat = ratio(currentTime, frame[0].time, frame[1].time);

    //Snapping one frame at a time
    if (snapping) 
     {
      if (frame[1].time>=(currentTime+0.001)) 
      {
        currentPosition = frame[1].points.get(0);
        return;
      }
    }

    PVector pPos=frame[0].points.get(0);  //previous position
    PVector nPos=frame[1].points.get(0);  //next position

    //Set position
    float x = nPos.x - pPos.x;
    float y = nPos.y - pPos.y;
    float z = nPos.z - pPos.z;

    currentPosition = new PVector(pPos.x + (rat * x), pPos.y + (rat * y), pPos.z + (rat * z));
  }
}
