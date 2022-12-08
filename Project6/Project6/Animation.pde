// Snapshot in time of some amount of data
class KeyFrame
{
  // Where does this thing occur in the animation?
  public float time;
  
  // Because translation and vertex positions are the same thing, this can
  // be reused for either. An array of one is perfectly viable.
  public ArrayList<PVector> points = new ArrayList<PVector>();
  
  public KeyFrame() {}
  
  public KeyFrame(float time, PVector vect)
  {
    this.time = time;
    // Might not need the following line:
    //this.points = new ArrayList<>();
    points.add(vect);
  }
  
  public KeyFrame(float time, ArrayList<PVector> vect)
  {
    this.time = time;
    this.points = vect;
  }
} // End of KF Class

class Animation
{
  // Animations start at zero, and end... here
  float GetDuration()
  {
    return keyFrames.get(keyFrames.size()-1).time;
  }
  
  ArrayList<KeyFrame> keyFrames = new ArrayList<KeyFrame>();
  
  public Animation() {}
  
  public Animation(ArrayList<KeyFrame> keyFrames)
  {
    this.keyFrames = keyFrames;
  }
  
  public KeyFrame[] surroundingFrames(float time)
  {
    KeyFrame[] frames = new KeyFrame[2];
    KeyFrame next = keyFrames.get(0);
    KeyFrame prev = keyFrames.get(keyFrames.size() - 1);
    
    if(next.time < time)
    {
      for(KeyFrame k : keyFrames)
      {
        next = k;
        if(k.time > time && time > prev.time)
        {
          break;
        }
        else
        {
          prev = k;
        }
      }
    }
    
    frames[0] = prev;
    frames[1] = next;
    return frames;
  }
} //End of Anim class.
