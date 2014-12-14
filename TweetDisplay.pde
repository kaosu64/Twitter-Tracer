
class TweetDisplay
{
  private int x;
  private int y;
  private int w;
  private int h;
  private int day;
  private int month;
  private int year;
  private int retweetCount;
  private String username;
  private String tweetText;
  private String location;
  private double latitude;
  private double longitude;
  private long tweetId;
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
    //String s = "testetererear";
    //println(x + " " + y + " " + w + " " + h);
    /*fill(0);
    text(s, x, y, w, h);*/
    textAlign(LEFT);
    textSize(10);
    fill(0);
    text(tweetText, x, y, w, h);
    fill(0);
    text("@"+username, x, y+h+2, w/2-34, h-32);
    fill(0);
    text("Retweets: "+retweetCount, x+w/2-32, y+h+2, w/2-67, h-32);
    fill(0);
    text("Date: "+month+"/"+day+"/"+year, x+w/2+87, y+h+2, w/2-85, h-32);
    //rect(x+w/2+87, y+h+2, w/2-85, h-32);
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
  
  void setUserLoc(String location)
  {
    this.location = location;
  }
  
  void setProfilePic(String url)
  {
    this.profilePic = loadImage(url, "png");
    this.profilePic.resize(0, 66);
  }
  
  void setTweetId(long tweetId)
  {
    this.tweetId = tweetId;
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
  
  void setDate(int day, int month, int year)
  {
    this.day = day;
    this.month = month;
    this.year = year;
  }
  String getUserLoc()
  {
    return this.location;
  }
  
  double getLat()
  {
    return this.latitude;
  }
  
  double getLon()
  {
    return this.longitude;
  }
  
  long getTweetId()
  {
    return this.tweetId;
  }
  
  boolean getCoordStatus()
  {
    return this.hasCoords;
  }
  
}
