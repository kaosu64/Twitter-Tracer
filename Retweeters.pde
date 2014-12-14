class Retweeters
{
  private double latitude;
  private double longitude;
  private double parentLat;
  private double parentLon;
  private String username;
  private boolean hasLoc;
  
  Retweeters()
  {
    this.latitude = 0.0;
    this.longitude = 0.0;
    this.parentLat = 0.0;
    this.parentLon = 0.0;
    this.username = "";
    this.hasLoc = false;
  }
  
  void setCoords(double lat, double lon)
  {
    this.latitude = lat;
    this.longitude = lon;
  }
  
  void setParentCoords(double lat, double lon)
  {
    this.parentLat = lat;
    this.parentLon = lon;
  }
  
  void setUsername(String user)
  {
    this.username = user;
  }
  
  void setLocStatus(boolean locStatus)
  {
    this.hasLoc = locStatus;
  }
  
  double getLat()
  {
    return this.latitude;
  }
  
  double getLon()
  {
    return this.longitude;
  }
  
  double getParentLat()
  {
    return this.parentLat;
  }
  
  double getParentLon()
  {
    return this.parentLon;
  }
  
  boolean getLocStatus()
  {
    return this.hasLoc;
  }
}

void setRetweeters(int num)
{
  //WebService.setUserName("mindbeef");
  
  try
  {
    Retweeters tempRetweeter = new Retweeters();
    List<Status> tempTweet = twitter.getRetweets(tweets[num].getTweetId());
    
    for(int i = 0; i < tempTweet.size(); i++)
    {
      Status tempStatus = (Status)tempTweet.get(i);
      println(tempStatus.getUser().getLocation());
      
      
      if (tempStatus.getGeoLocation() != null)
      {
        tempRetweeter.setCoords(tempStatus.getGeoLocation().getLatitude(), tempStatus.getGeoLocation().getLongitude());
      }
      else
      {
        searchCriteria.setQ(tempStatus.getUser().getLocation());
        
        try
        {
          ToponymSearchResult searchResult = WebService.search(searchCriteria);
          
          List<Toponym> toponym = searchResult.getToponyms();
          //toponym.clear();
          
          tempRetweeter.setCoords(toponym.get(0).getLatitude(), toponym.get(0).getLongitude());
          tempRetweeter.setLocStatus(true);
          
          println(toponym.get(0).getName());
          println(num + " from method : " + toponym.get(0).getLatitude() + " " + toponym.get(0).getLongitude());
  
        }
        catch(Exception e)
        {
          tempRetweeter.setCoords(0.0, 0.0);
          tempRetweeter.setLocStatus(false);
        }
      }
      
      println(tempRetweeter.getLat() + " " + tempRetweeter.getLon());
      tempRetweeter.setParentCoords(tweets[num].getLat(), tweets[num].getLon());
      retweeters.add(tempRetweeter);
      if (retweeters.get(i).getLocStatus() == true)
      {
        childLoc.add(new de.fhpotsdam.unfolding.geo.Location(retweeters.get(i).getLat(),
                                                        retweeters.get(i).getLon()));
      }
    }
  }
  catch(TwitterException e)
  {
    println("Error\n");
  }
}
