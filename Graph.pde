/* 
 * Class for creating and drawing the graph for the timeline
 */
class Graph
{
  private float x;
  private float y;
  private float w;
  private float h;
  private color clBG;
  private color clAxis;
  private color clLine;
  private FloatList points;
  
  Graph()
  {
    x = 0;
    y = 0;
    w = 0;
    h = 0;
    clBG = color(0,0,0);
    clAxis = color(255,255,255);
    clLine = color(255,255,255);
    points = new FloatList();
  }
  
  Graph(float nx, float ny, float nw, float nh)
  {
    x = nx;
    y = ny;
    w = nw;
    h = nh;
    clBG = color(0,0,0);
    clAxis = color(255,255,255);
    clLine = color(0,255,255);
    points = new FloatList();
  }
  
  void setXPos(float n)
  {
    x = n;
  }
  
  void setYPos(float n)
  {
    y = n;
  }
  
  void setWidth(float n)
  {
    w = n;
  }
  
  void setHeight(float n)
  {
    h = n;
  }
  
  void setBGColor(int r, int g, int b)
  {
    clBG = color(r,g,b);
  }
  
  void setAxisColor(int r, int g, int b)
  {
    clAxis = color(r,g,b);
  }
  
  void setLineColor(int r, int g, int b)
  {
    clLine = color(r,g,b);
  }
  
  void setPoints(FloatList l)
  {
    points = l;
  }
  
  void addPoint(float n)
  {
    points.append(n);
  }
  
  float removePoint(int i)
  {
    return points.remove(i);
  }
  
  void drawGraph()
  {
    drawBase();
    drawPoints();
    drawLabels();
  }
  
  private void drawBase()
  {
    fill(clBG);
    strokeWeight(0);
    rect(x,y,w,h);
    stroke(clAxis);
    strokeWeight(2);
    line(x,y,x,y+h);
    line(x,y+h,x+w,y+h);
  }
  
  private void drawPoints()
  {
    stroke(clLine);
    strokeWeight(1);
    float ydiff = h / 100;
    if (points.size() > 1)  // More than one point
    {
      float xdiff = w / (points.size()-1),
            inc = 0;
      for (int i=0; i<points.size()-1; i++)
      {
        line(x+inc,y+h-points.get(i)*ydiff,x+inc+xdiff,y+h-points.get(i+1)*ydiff);
        inc+=xdiff;
      }
    }
    else if (points.size() == 1)  // Only one point
    {
      line(x,y+h-points.get(0)*ydiff,x+w,y+h-points.get(0)*ydiff);
    }
    else  // No points
    {
      fill(clLine);
      textAlign(CENTER);
      textFont(fontGraph, 16);
      text("No retweets found.",x+w/2,y+h/2);
    }
  }
  
  private void drawLabels()
  {
    fill(clAxis);
    textAlign(CENTER);
    textFont(fontGraph, 14);
    
    // X-axis labels
    text("Month",x+20,y+h+40);
    float xdiff = w / (points.size()-1),
          inc = 0;
    for (int i=0; i<points.size(); i++)
    {
      text(i+1,x+inc,y+h+20);
      inc+=xdiff;
    }
    
    // Y-axis labels
    text("Retweets",x-40,y);
    float ydiff = h / 100;
    for (int i=0; i<100; i+=10)
    {
      text(i,x-20,y+h-ydiff*i);
    }
  }
}
