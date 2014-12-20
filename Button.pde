/**********************************************************
| Button class for main display. This creates a box image
| to house the twitter data thats being displayed. It 
| also highlights whenever a specified location is clicked.
***********************************************************/

class Button
{
  //variables for box location and dimensions
  private int x;
  private int y;
  private int w;
  private int h;
  private boolean highlight;
  
  //default constructor
  Button()
  {
    highlight = false;
  }
  
  //turns on or off the highlight
  void click()
  {
    highlight = !highlight;
  }
  
  //in main display, draws boxes to house tweets
  void display()
  {
    noStroke();
    fill(205);
    rect((x-2), (y-2), (w+4), (h+4));
    
    //highlights tweets or not
    if (highlight)
    {
      fill(0,58,88, 100);
    }
    else
    {
      fill(0,58,88, 50);
    }
    rect(x,y,w,h);
  }
  
  //sets up dimensions and location of box
  void setDimensions(int x, int y, int w, int h)
  {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  //returns true/false if box is highlighted or not
  boolean getHighlight()
  {
    return highlight;
  }
}
  
  
