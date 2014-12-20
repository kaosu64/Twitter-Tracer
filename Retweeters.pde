/**********************************************************
| The retweeter class stores all the data of twitter users
| who have retweeted a specific tweet. It stores their
| location by coordinates and the coordinates of the user
| it's been retweeted from.
***********************************************************/

class Retweeters
{
  //coordinate variables and parent coordinate variables
  private double latitude;
  private double longitude;
  private double parentLat;
  private double parentLon;
  private String username;
  private boolean hasLoc;
  
  //default constructor
  Retweeters()
  {
    this.latitude = 0.0;
    this.longitude = 0.0;
    this.parentLat = 0.0;
    this.parentLon = 0.0;
    this.username = "";
    this.hasLoc = false;
  }
  
  //sets the coordinates of the retweeter
  void setCoords(double lat, double lon)
  {
    this.latitude = lat;
    this.longitude = lon;
  }
  
  //sets the coordinates of where it's been retweeted from
  void setParentCoords(double lat, double lon)
  {
    this.parentLat = lat;
    this.parentLon = lon;
  }
  
  //sets the username of the retweeter
  void setUsername(String user)
  {
    this.username = user;
  }
  
  //sets the status of whether the retweeter has a location
  void setLocStatus(boolean locStatus)
  {
    this.hasLoc = locStatus;
  }
  
  //returns the latitude
  double getLat()
  {
    return this.latitude;
  }
  
  //returns the longitude
  double getLon()
  {
    return this.longitude;
  }
  
  //returns parent latitude
  double getParentLat()
  {
    return this.parentLat;
  }
  
  //returns parent longitude
  double getParentLon()
  {
    return this.parentLon;
  }
  
  //returns location status
  boolean getLocStatus()
  {
    return this.hasLoc;
  }
}
