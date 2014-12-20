/**********************************************************
| This file sets up the main UI functions of the map 
| display mode. It allows the user to jump back 
| to the main menu or into timeline mode. It also allows the 
| user to display on the map, the location of users based on 
| the hashtag they tweeted.
***********************************************************/

void displayMapUI()
{
  
  //textfield to take in hashtag string
  hashtagMapTextField = cp6.addTextfield("hashtag")
     .setPosition(450, 10)
     .setSize(250, 30)
     .setFont(createFont("arial", 25))
     .setColorBackground(color(0, 100));
  hashtagMapTextField.getCaptionLabel()
                     .setFont(fontTextfieldLabel);
  
  //main menu button
  cp6.addBang("main_menu")
     .setCaptionLabel("main menu")
     .setPosition(10, 10)
     .setSize(200, 30)
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                       .setFont(fontButton);
  cp6.getTooltip().register("main_menu","Return to the main menu.");

  //timeline button
  cp6.addBang("display_timeline")
     .setCaptionLabel("display timeline")
     .setPosition(220, 10)
     .setSize(200, 30)
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                       .setFont(fontButton);
  cp6.getTooltip().register("display_timeline","Display tweets in a timeline.");
  
  //input button for hashtag search
  cp6.addBang("inputHashtag")
     .setCaptionLabel("input hashtag")
     .setPosition(730, 10)
     .setSize(200, 30)
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                       .setFont(fontButton);
  cp6.getTooltip().register("inputHashtag","Display on map the locations of specific hashtags.");
  
  //clears the hashtag textfield
  cp6.addBang("clear")
     .setCaptionLabel("reset hashtag list")
     .setPosition(940, 10)
     .setSize(200, 30)
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                       .setFont(fontButton);
  cp6.getTooltip().register("clear","Clear the list of hashtags.");
  
}

//submits the string input from hashtag textfield
public void inputHashtag()
{
  hashtagMapTextField.submit();
}

//retrieves the Twitter data of users based on the hashtag they tweeted
public void addHashtag(String tag)
{
  //starts a query based on a hashtag
  Query query = new Query("#"+tag);
  
  //max number of tweets we want
  int numberOfTweets = 120;
  long lastID = Long.MAX_VALUE;
  List<Status> tweetsTemp = new ArrayList<Status>();
  
  while (tweetsTemp.size () < numberOfTweets) 
  {
    if (numberOfTweets - tweetsTemp.size() > 100)
      query.setCount(100);
    else 
      query.setCount(numberOfTweets - tweetsTemp.size());
      
    try 
    {
      QueryResult result = twitter.search(query);
      tweetsTemp.addAll(result.getTweets());
      
      println("Gathered " + tweetsTemp.size() + " tweets");
      
      for (Status t: tweetsTemp) 
        if(t.getId() < lastID) lastID = t.getId();

    }

    catch (TwitterException te) 
    {
      println("Couldn't connect: " + te);
    }; 
    
    //sets the last id that was searched to the front
    query.setMaxId(lastID-1);
  }
  
  //stores the location of where the hashtag was tweeted from
  for (int i = 0; i < tweetsTemp.size(); i++)
  {
    Status t = (Status) tweetsTemp.get(i);
    
    if(t.getGeoLocation() != null)
    {
      hashtagLoc.add(new de.fhpotsdam.unfolding.geo.Location(
      t.getGeoLocation().getLatitude(), 
      t.getGeoLocation().getLongitude()));
    }
    else
    {
      userTagLocation(i, t.getUser().getLocation());
    }
  }
}

//clears textfield
public void clear()
{
  hashtagLoc.clear();
}

//returns to main menu
public void main_menu()
{
  mapLoaded = false;
  timelineLoaded = false;
  mode = 0;
}

//jumps to timeline display
public void display_timeline()
{
  if (!timelineLoaded)
    timeline();
  mode = 2;
}

