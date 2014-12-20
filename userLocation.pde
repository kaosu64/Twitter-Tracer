/**********************************************************
| This file locates and stores all the users locations. The
| location of a user is based off of what they specified on
| their Twitter homepage. It is stored as a string and then
| processed through GeoNames API to match a coordinate with
| the user's location. Not all users have geolocations
| enabled and not all users have a correct location
| specified. Therefore, some users locations may not be
| accurate. *Note* Some users have set their locations to
| random text such as "EVERYWHERE" or "The greatest city on
| earth". GeoNames tries to match a city or country that
| closely resembles that. So "EVERYWHERE" would be matched 
| to 'Everywhere', a South African farm. 
***********************************************************/

//searchs the location of a parent tweet
void userTweetLocation(int num, String searchName)
{
  
  //sets the location name to be searched
  searchCriteria.setQ(searchName);
  
  try
  {
    
    //matches a coordinate as closely as possible based on the location name given
    ToponymSearchResult searchResult = WebService.search(searchCriteria);
    
    //lists the coordinates of each match
    List<Toponym> toponym = searchResult.getToponyms();
    
    //grabs the first location and sets the coordinates to tweetdata
    tweets[num].setCoords(toponym.get(0).getLatitude(), toponym.get(0).getLongitude());
    tweets[num].setCoordStatus(true);
    
  }
  catch (Exception e) 
  {
    //sets coordinates to 0 if theres an error
    tweets[num].setCoords(0.0, 0.0);
    tweets[num].setCoordStatus(false);
  }
}

//searches the location of a retweet
void userRetweetLocation(int num)
{
  
  try
  {
    //create a temp object to store retweet data
    Retweeters tempRetweeter = new Retweeters();
    
    //grabs the list of users who retweeted a selected tweet
    List<Status> tempTweet = twitter.getRetweets(tweets[num].getTweetId());
    
    //stores the location of each retweeter
    for(int i = 0; i < tempTweet.size(); i++)
    {
      
      //stores the list of retweet statuses
      Status tempStatus = (Status)tempTweet.get(i);
      println(tempStatus.getUser().getLocation());
      
      //checks if the retweeter has a location enabled
      if (tempStatus.getGeoLocation() != null)
      {
        tempRetweeter.setCoords(tempStatus.getGeoLocation().getLatitude(), tempStatus.getGeoLocation().getLongitude());
      }
      
      //otherwise, use GeoNames API to grab a location
      else
      {
        
        //sets the location name to be searched
        searchCriteria.setQ(tempStatus.getUser().getLocation());
        
        try
        {
          
          //matches a coordinate as closely as possible to the location name given
          ToponymSearchResult searchResult = WebService.search(searchCriteria);
          
          //list all the matches
          List<Toponym> toponym = searchResult.getToponyms();
          
          //stores the coordinates of the first location on the list
          tempRetweeter.setCoords(toponym.get(0).getLatitude(), toponym.get(0).getLongitude());
          tempRetweeter.setLocStatus(true);
          
          println(toponym.get(0).getName());
          println(num + " from method : " + toponym.get(0).getLatitude() + " " + toponym.get(0).getLongitude());
  
        }
        catch(Exception e)
        {
          //sets coordinates to 0 if theres an error
          tempRetweeter.setCoords(0.0, 0.0);
          tempRetweeter.setLocStatus(false);
        }
      }
      
      println(tempRetweeter.getLat() + " " + tempRetweeter.getLon());
      
      //sets the location of the tweet it was retweeted from
      tempRetweeter.setParentCoords(tweets[num].getLat(), tweets[num].getLon());
      
      //add to list of retweeters
      retweeters.add(tempRetweeter);
      
      //checks if location was enabled
      if (retweeters.get(i).getLocStatus() == true)
      {
        //add location of the retweeter
        childLoc.add(new de.fhpotsdam.unfolding.geo.Location(retweeters.get(i).getLat(),
                                                        retweeters.get(i).getLon()));
                                               
        //draws a line from a tweet to all the locations of where it's been retweeted from                                          
        SimpleLinesMarker slm = new SimpleLinesMarker(parentLoc.get(parentLoc.size()-1), childLoc.get(childLoc.size()-1));
        slm.setStrokeWeight(1);
        lineMarkers.add(slm);
      }
    }
  }
  catch(TwitterException e)
  {
    println("Error: "+e+"\n");
  }
}

//searches the location of users who tweeted out a certain hashtag
void userTagLocation(int num, String searchName)
{
  
  //sets the location name to be searched
  searchCriteria.setQ(searchName);
  
  try
  {
    //matches a coordinate as closely as possible to the location name given
    ToponymSearchResult searchResult = WebService.search(searchCriteria);
    
    //list all the matches
    List<Toponym> toponym = searchResult.getToponyms();
    
    //add location of the hashtag location
    hashtagLoc.add(new de.fhpotsdam.unfolding.geo.Location(
      toponym.get(0).getLatitude(), 
      toponym.get(0).getLongitude()));
  }
  catch (Exception e) 
  {
    println(num + " unable");
  }
}
