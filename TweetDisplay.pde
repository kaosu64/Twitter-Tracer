
class TweetDisplay
{
  private int x;
  private int y;
  private int w;
  private int h;
  private int retweetCount;
  private String username;
  private String tweetText;
  private double latitude;
  private double longitude;
  private boolean hasCoords;
  private PImage profilePic;
  
  
  TweetDisplay()
  {
    this.username = "";
    this.tweetText = "";
    this.latitude = 0.0;
    this.longitude = 0.0;
    this.hasCoords = false;
  }
  
  void setDimensions(int x, int y, int w, int h)
  {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  void display()
  {
    String s = "testetererear";
    //println(x + " " + y + " " + w + " " + h);
    /*fill(0);
    text(s, x, y, w, h);*/
    fill(0);
    text(tweetText, x, y, w, h);
    fill(0);
    text("@"+username, x, y+h+2, w/2-9, h-32);
    fill(0);
    text("Retweets: "+retweetCount, x+w/2-7, y+h+2, w/2+8, h-32);
    
    image(profilePic, x-69, y); 
  }
  
  void setUser(String username)
  {
    this.username = username;
  }
  
  void setText(String tweetText)
  {
    this.tweetText = tweetText;
  }
  
  void setProfilePic(String url)
  {
    profilePic = loadImage(url, "png");
    profilePic.resize(0, 66);
  }
  
  void setRetweetCount(int retweetCount)
  {
    this.retweetCount = retweetCount;
  }
  
  void setCoords(double lat, double lon)
  {
    this.latitude = lat;
    this.longitude = lon;
  }
  
  void setCoordStatus(boolean status)
  {
    this.hasCoords = status;
  }
  
  double getLat()
  {
    return this.latitude;
  }
  
  double getLon()
  {
    return this.longitude;
  }
  
  boolean getCoordStatus()
  {
    return this.hasCoords;
  }
  
}
