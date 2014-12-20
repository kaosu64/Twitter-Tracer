/**********************************************************
| The TweetData class stores the data of Twitter users
| based on the tweets displayed. The class stores the users
| tweet, the date it was posted, the number of retweets,
| the location of the user, the users profile picture, and
| the id number of the tweet. It then displays the data in
| main mode within a specific area of the application.
***********************************************************/

class TweetData
{
  //variables for all of the Twitter user's data
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
  
  //default constructor
  TweetData()
  {
    this.username = "";
    this.tweetText = "";
    this.latitude = 0.0;
    this.longitude = 0.0;
    this.hasCoords = false;
  }
  
  //sets the location and size of where to display the data
  void setDimensions(int x, int y, int w, int h)
  {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  //displays data on the screen and within a button box
  void display()
  {
    
    textAlign(LEFT);
    textFont(fontTweets);
    fill(0);
    text(tweetText, x, y, w, h);
    fill(0);
    text("@"+username, x, y+h+2, w/2-34, h-32);
    fill(0);
    text("Retweets: "+retweetCount, x+w/2-32, y+h+2, w/2-67, h-32);
    fill(0);
    text("Date: "+month+"/"+day+"/"+year, x+w/2+87, y+h+2, w/2-85, h-32);
    
    image(profilePic, x-69, y); 
  }
  
  //set username
  void setUser(String username)
  {
    this.username = username;
  }
  
  //sets tweet string
  void setText(String tweetText)
  {
    this.tweetText = tweetText;
  }
  
  //sets user location
  void setUserLoc(String location)
  {
    this.location = location;
  }
  
  //sets users profile pic
  void setProfilePic(String url)
  {
    this.profilePic = loadImage(url, "png");
    this.profilePic.resize(0, 66);
  }
  
  //sets tweet ID
  void setTweetId(long tweetId)
  {
    this.tweetId = tweetId;
  }
  
  //sets retweet count
  void setRetweetCount(int retweetCount)
  {
    this.retweetCount = retweetCount;
  }
  
  //sets coordinate
  void setCoords(double lat, double lon)
  {
    this.latitude = lat;
    this.longitude = lon;
  }
  
  //sets coordinate status
  void setCoordStatus(boolean status)
  {
    this.hasCoords = status;
  }
  
  //sets date of the tweet
  void setDate(int day, int month, int year)
  {
    this.day = day;
    this.month = month;
    this.year = year;
  }
  
  //returns user location
  String getUserLoc()
  {
    return this.location;
  }
  
  //returns the latitude of the user
  double getLat()
  {
    return this.latitude;
  }
  
  //returns the longitude of the user
  double getLon()
  {
    return this.longitude;
  }
  
  //returns the tweet ID
  long getTweetId()
  {
    return this.tweetId;
  }
  
  //returns the coordinate status
  boolean getCoordStatus()
  {
    return this.hasCoords;
  }
  
}
