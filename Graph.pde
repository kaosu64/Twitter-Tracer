/**********************************************************
| Graph class for timeline display. This creates a graph
| and draws trendlines depending on how many tweets are
| retweeted over a given amount of time.
***********************************************************/

class Graph
{
  //variables for graph location and dimensions
  //variables for trendline and twitter data
  private float x;
  private float y;
  private float w;
  private float h;
  private color clBG;
  private color clAxis;
  private color clLine;
  private FloatList points;
  private StringList xLabels;
  private boolean bMonth;
  
  //default constructor
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
    xLabels = null;
    bMonth = true;
  }
  
  //draws graph with different trend lines
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
    xLabels = null;
    bMonth = true;
  }
  
  //sets x position on screen
  void setXPos(float n)
  {
    x = n;
  }
  
  //sets y position on screen
  void setYPos(float n)
  {
    y = n;
  }
  
  //sets width size of graph
  void setWidth(float n)
  {
    w = n;
  }
  
  //sets height size of graph
  void setHeight(float n)
  {
    h = n;
  }
  
  //sets background color
  void setBGColor(int r, int g, int b)
  {
    clBG = color(r,g,b);
  }
  
  //sets axis color
  void setAxisColor(int r, int g, int b)
  {
    clAxis = color(r,g,b);
  }
  
  //sets trendline color
  void setLineColor(int r, int g, int b)
  {
    clLine = color(r,g,b);
  }
  
  //sets points on graph
  void setPoints(FloatList l)
  {
    points = l;
  }
  
  //adds a point to graph
  void addPoint(float n)
  {
    points.append(n);
  }
  
  //remove a point from graph
  float removePoint(int i)
  {
    return points.remove(i);
  }
  
  //labels the graph
  void setLabels(StringList l)
  {
    xLabels = l;
  }
  
  //displays graph based on month
  void monthsMode()
  {
    bMonth = true;
  }
  
  //displays graph based on days
  void daysMode()
  {
    bMonth = false;
  }
  
  //draws graph on screen
  void drawGraph()
  {
    drawBase();
    drawPoints();
    drawLabels();
  }
  
  //draws base of the graph
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
  
  //draws each point on the graph
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
  
  //draws the axis labels
  private void drawLabels()
  {
    fill(clAxis);
    textAlign(CENTER);
    textFont(fontGraph);
    textSize(14);
    
    // X-axis labels
    if (bMonth)
    {
      text("Month:",x-50,y+h+30);
    }
    else
    {
      text("Day:",x-40,y+h+30);
      textSize(12);
    }
    float xdiff = w / (points.size()-1),
          inc = 0;
    for (int i=0; i<points.size(); i++)
    {
      if (xLabels == null || xLabels.get(i) == null)
        text(i+1,x+inc,y+h+20);
      else
        text(xLabels.get(i),x+inc,y+h+20);
      inc+=xdiff;
    }
    
    textSize(14);
    // Y-axis labels
    text("Retweets",x-40,y);
    float ydiff = h / 100;
    for (int i=0; i<100; i+=10)
    {
      text(i,x-20,y+h-ydiff*i);
    }
  }
}
