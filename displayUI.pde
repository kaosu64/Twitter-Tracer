/***************************************
| All buttons in mode 0 and its functions
| are created here.
***************************************/

void displayUI()
{
  twitterTextField = cp5.addTextfield("input")
     .setPosition(500, 50)
     .setSize(175, 30)
     .setFont(createFont("arial", 25))
     .setColorBackground(color(0, 100));
     //.setColorForeground(color(255, 100));
  twitterTextField.getCaptionLabel()
                  .setFont(fontTextfieldLabel);
  
  cp5.addBang("user")
     .setPosition(680, 50)
     .setSize(100, 30)
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                       .setFont(fontButton);
  cp5.getTooltip().register("user","Enters the username to be searched.");

  cp5.addBang("hashtag")
     .setPosition(785, 50)
     .setSize(100, 30)
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                       .setFont(fontButton);
  cp5.getTooltip().register("hashtag","Enters the hashtag to be searched.");
  
  // Date selection
  Group g1 = cp5.addGroup("sinceGroup")
                .setCaptionLabel("since date")
                .setPosition(430,150)
                .setWidth(160)
                .setBarHeight(30)
                .setBackgroundColor(color(0, 200))
                .setBackgroundHeight(110)
                .close();
  cp5.get(Group.class, "sinceGroup").getCaptionLabel()
                                    .align(ControlP5.CENTER, ControlP5.CENTER)
                                    .setFont(fontButton);
  
  cp5.addSlider("sinceYear")
     .setCaptionLabel("year")
     .setPosition(10,10)
     .setSize(100,20)
     .setRange(2006,2026)
     .setValue(currentDate.getYear()+1900-1)
     .setNumberOfTickMarks(21)
     .moveTo(g1);
  cp5.get(Slider.class, "sinceYear").getCaptionLabel().setFont(fontSlider);
  cp5.get(Slider.class, "sinceYear").getValueLabel().setFont(fontSlider);
  
  cp5.addSlider("sinceMonth")
     .setCaptionLabel("month")
     .setPosition(10,40)
     .setSize(100,20)
     .setRange(1,12)
     .setValue(currentDate.getMonth()+1)
     .setNumberOfTickMarks(12)
     .moveTo(g1);
  cp5.get(Slider.class, "sinceMonth").getCaptionLabel().setFont(fontSlider);
  cp5.get(Slider.class, "sinceMonth").getValueLabel().setFont(fontSlider);
  
  cp5.addSlider("sinceDay")
     .setCaptionLabel("day")
     .setPosition(10,70)
     .setSize(100,20)
     .setRange(1,31)
     .setValue(currentDate.getDate())
     .setNumberOfTickMarks(31)
     .moveTo(g1);
  cp5.get(Slider.class, "sinceDay").getCaptionLabel().setFont(fontSlider);
  cp5.get(Slider.class, "sinceDay").getValueLabel().setFont(fontSlider);
  
  Group g2 = cp5.addGroup("untilGroup")
                .setCaptionLabel("until date")
                .setPosition(620,150)
                .setWidth(160)
                .setBarHeight(30)
                .setBackgroundColor(color(0, 200))
                .setBackgroundHeight(110)
                .close();
  cp5.get(Group.class, "untilGroup").getCaptionLabel()
                                    .align(ControlP5.CENTER, ControlP5.CENTER)
                                    .setFont(fontButton);
  
  cp5.addSlider("untilYear")
     .setCaptionLabel("year")
     .setPosition(10,10)
     .setSize(100,20)
     .setRange(2006,2026)
     .setValue(currentDate.getYear()+1900)
     .setNumberOfTickMarks(21)
     .moveTo(g2);
  cp5.get(Slider.class, "untilYear").getCaptionLabel().setFont(fontSlider);
  cp5.get(Slider.class, "untilYear").getValueLabel().setFont(fontSlider);
  
  cp5.addSlider("untilMonth")
     .setCaptionLabel("month")
     .setPosition(10,40)
     .setSize(100,20)
     .setRange(1,12)
     .setValue(currentDate.getMonth()+1)
     .setNumberOfTickMarks(12)
     .moveTo(g2);
  cp5.get(Slider.class, "untilMonth").getCaptionLabel().setFont(fontSlider);
  cp5.get(Slider.class, "untilMonth").getValueLabel().setFont(fontSlider);
  
  cp5.addSlider("untilDay")
     .setCaptionLabel("day")
     .setPosition(10,70)
     .setSize(100,20)
     .setRange(1,31)
     .setValue(currentDate.getDate())
     .setNumberOfTickMarks(31)
     .moveTo(g2);
  cp5.get(Slider.class, "untilDay").getCaptionLabel().setFont(fontSlider);
  cp5.get(Slider.class, "untilDay").getValueLabel().setFont(fontSlider);
  // End date selection
  
  cp5.addBang("previous")
     .setPosition(250, 355)
     .setSize(75, 50)
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                       .setFont(fontButton);
  cp5.getTooltip().register("previous","Show the previous 5 tweets.");
  
  cp5.addBang("next")
     .setPosition(825, 355)
     .setSize(75, 50)
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                       .setFont(fontButton);
  cp5.getTooltip().register("next","Show the next 5 tweets.");
  
  cp5.addBang("displaymap")
     .setCaptionLabel("display map")
     .setPosition(377, 580)
     .setSize(195, 50)
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                       .setFont(fontButton);
  cp5.getTooltip().register("map","Display selected tweets on a map.");
 
  cp5.addBang("timeline")
     .setPosition(580, 580)
     .setSize(195, 50)
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                       .setFont(fontButton);
  cp5.getTooltip().register("timeline","Display selected tweets on a timeline.");
  
  cp5.addTextlabel("labelA")
     .setText("Enter a username or hashtag: ")
     .setPosition(200,50)
     .setColorValue(#ffffff)
     .setFont(createFont("sans-serif",20));
  
  cp5.addTextlabel("labelB")
     .setText("Select a time period: ")
     .setPosition(200,120)
     .setColorValue(#ffffff)
     .setFont(createFont("sans-serif",20));
     
  cp5.addTextlabel("labelC")
     .setText("Select a tweet: ")
     .setPosition(200,190)
     .setColorValue(#ffffff)
     .setFont(createFont("sans-serif",20));
     
  cp5.addTextlabel("labelD")
     .setText("(only applies to User search)")
     .setPosition(200,145)
     .setColorValue(#ffffff)
     .setFont(createFont("sans-serif",14));
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

/*
 * Loads the map for the first time
 */
public void displaymap()
{
  parentLoc.clear();
  childLoc.clear();
  markerParent.clear();
  markerChild.clear();
  retweeters.clear();
  lineMarkers.clear();
  map.getDefaultMarkerManager().clearMarkers();
  
  boolean hasLocations = false;
  
  for(int i = 0; i < tweets.length; i++)
  {
    if(buttons[i].getHighlight() == true)
    {
      
      if(tweets[i].getCoordStatus() == true)
      {
        
        setRetweeters(i);
        
        parentLoc.add(new de.fhpotsdam.unfolding.geo.Location(tweets[i].getLat(), tweets[i].getLon()));
  
        hasLocations = true;
      }
      else if (tweets[i].getCoordStatus() == false)
      {
        userParentLocation(i, tweets[i].getUserLoc());
        
        setRetweeters(i);
        
        parentLoc.add(new de.fhpotsdam.unfolding.geo.Location(tweets[i].getLat(), tweets[i].getLon()));
  
      }
    }
  }
  
  for(int i = 0; i < parentLoc.size(); i++)
  {
    for(int j = 0; j < childLoc.size(); j++)
    {
      SimpleLinesMarker slm = new SimpleLinesMarker(parentLoc.get(i), childLoc.get(j));
      slm.setStrokeWeight(2);
      lineMarkers.add(slm);
    }
  }
  
  map.addMarkers(lineMarkers);
  
  if(hasLocations == true)
  {
    euclid = GeoUtils.getEuclideanCentroid(childLoc);
    
  }
  
  mapLoaded = true;
  mode = 1;
}

/*
 * Loads the timeline for the first time
 */
public void timeline()
{
  // Get first selected tweet
  int n = 0;
  while (n < tweets.length && buttons[n].getHighlight() == false)
  {
    n++;
  }
  
  if (n < tweets.length)
  {
    List<Status> rtw = new ArrayList<Status>();
    Status tw = statuses.get(n);
    try {
      if (tw.isRetweet())
        rtw = twitter.getRetweets(tw.getRetweetedStatus().getId());
      else
        rtw = twitter.getRetweets(tw.getId());
    }
    catch (TwitterException e)
    {
      println("Error: "+e+"\n");
    }
    
    // Initiate float list
    FloatList fl = new FloatList();
    for (int i = 0; i < 12; i++)
    {
      fl.append(0);
    }
    
    // Add data to array of dates of retweets
    ArrayList<Date> dList = new ArrayList<Date>();
    Date dAfter = new Date();
    dAfter.setYear(currentDate.getYear()-1);
    for (Status s : rtw)
    {
      Date dCreated = s.getCreatedAt();
      if (dCreated.after(dAfter))
      {
        fl.add(dCreated.getMonth(), 1);
        rtwDates[dCreated.getMonth()][dCreated.getDate()] += 1.;
      }
    }
    
    FloatList fl2 = new FloatList();
    StringList sl = new StringList();
    // Get last year
    Calendar c = Calendar.getInstance();
    c.add(Calendar.MONTH,-11);
    // Add year with first displayed month
    fl2.append(fl.get(c.get(Calendar.MONTH)));
    sl.append((c.get(Calendar.MONTH)+1)+"\n"+c.get(Calendar.YEAR));
    c.add(Calendar.MONTH,1);
    // Add data to lists
    while (c.before(Calendar.getInstance()))
    {
      fl2.append(fl.get(c.get(Calendar.MONTH)));
      if (c.get(Calendar.MONTH) == 0)  // Add year if first month of year
        sl.append((c.get(Calendar.MONTH)+1)+"\n"+c.get(Calendar.YEAR));
      else
        sl.append(""+(c.get(Calendar.MONTH)+1));
      c.add(Calendar.MONTH,1);
    }
    
    // Save results
    rtwMonths = fl2;
    rtwMonthsLabel = sl;
    // Add to graph
    graph.setPoints(fl2);
    graph.setLabels(sl);
  }
  
  timelineLoaded = true;
  mode = 2;
}
