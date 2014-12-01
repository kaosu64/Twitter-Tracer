class Button
{
  private int x;
  private int y;
  private int w;
  private int h;
  private boolean highlight;
  
  Button()
  {
    highlight = false;
  }
  
  void click()
  {
    highlight = !highlight;
  }
  
  void display()
  {
    fill(205);
    rect((x-2), (y-2), (w+4), (h+4));
    
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
  
  void setDimensions(int x, int y, int w, int h)
  {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  boolean getHighlight()
  {
    return highlight;
  }
}
  
  
