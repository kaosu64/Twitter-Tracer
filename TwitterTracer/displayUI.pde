/***************************************
| All buttons in mode 0 and its functions
| are created here.
***************************************/

void displayUI()
{
  twitterTextField = cp5.addTextfield("input")
     .setPosition(350, 50)
     .setSize(175, 30)
     .setFont(createFont("arial", 25))
     .setColorBackground(color(0, 100))
     .setColorForeground(color(255, 100));
  
  cp5.addBang("user")
     .setPosition(530, 50)
     .setSize(100, 30)
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
  cp5.getTooltip().register("user","Enters the username to be searched.");

  cp5.addBang("hashtag")
     .setPosition(635, 50)
     .setSize(100, 30)
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
  cp5.getTooltip().register("hashtag","Enters the hashtag to be searched.");
  
  cp5.addBang("previous")
     .setPosition(150, 315)
     .setSize(50, 50)
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
  cp5.getTooltip().register("previous","Show the previous 5 tweets.");
  
  cp5.addBang("next")
     .setPosition(650, 315)
     .setSize(50, 50)
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
  cp5.getTooltip().register("next","Show the next 5 tweets.");
  
  cp5.addBang("displaymap")
     .setPosition(227, 540)
     .setSize(195, 50)
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
  cp5.getTooltip().register("map","Display selected tweets on a map.");
 
  cp5.addBang("timeline")
     .setPosition(430, 540)
     .setSize(195, 50)
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
  cp5.getTooltip().register("timeline","Display selected tweets on a timeline.");
  
  cp5.addTextlabel("labelA")
     .setText("Enter a username or hashtag: ")
     .setPosition(50,50)
     .setColorValue(#ffffff)
     .setFont(createFont("sans-serif",20));
  
  cp5.addTextlabel("labelB")
     .setText("Select a time period: ")
     .setPosition(50,100)
     .setColorValue(#ffffff)
     .setFont(createFont("sans-serif",20));
     
  cp5.addTextlabel("labelC")
     .setText("Select a tweet: ")
     .setPosition(50,150)
     .setColorValue(#ffffff)
     .setFont(createFont("sans-serif",20));
}

public void user()
{
  userSearch = true;
  hashtagSearch = false;
  twitterTextField.submit();
}

public void hashtag()
{
  userSearch = false;
  hashtagSearch = true;
  twitterTextField.submit();
}

public void next()
{
  selection = (selection+5)%buttons.length;
}

public void previous()
{
  selection = ((selection-5)%buttons.length+buttons.length)%buttons.length;
}


public void displaymap()
{
  loc.clear();
  marker.clear();
  
  boolean hasLocations = false;
  
  for(int i = 0; i < tweets.length; i++)
  {
    if(buttons[i].getHighlight() == true && tweets[i].getCoordStatus() == true)
    {
      loc.add(new de.fhpotsdam.unfolding.geo.Location(tweets[i].getLat(), tweets[i].getLon()));

      hasLocations = true;
    }
  }
  
  if(hasLocations == true)
  {
    euclid = GeoUtils.getEuclideanCentroid(loc);
    map.zoomAndPanTo(euclid, 12);
  }
  
  mode = 1;
}

public void timeline()
{
  
}
