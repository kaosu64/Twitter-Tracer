/***************************************
| Team Name: mindBeef
| Team Members: Eric Chu, Kason Soohoo
| Course: CSC690
| Assignment: Final Project - Twitter Tracer
| Description: 
|
| Milestone 1 - Grabbed a status from a twitter
| user and centralized the location of the tweet
| onto a map.
|
| Milestone 2 - Created a UI to display and select
| tweets from a twitter user. Added buttons to 
| jump into map display mode or timeline display
| mode. Added search by date.
|
| Milestone 3 - Map now displays selected tweets,
| retweeters. Implemented GeoNames API. Functionality
| has slowed down tremendously causing the application
| to lag. Added a minimal timeline that displays the 
| months on which the last 100 retweets of the first 
| selected tweet were created.
|
| Milestone 4 - Connected a line from a main tweet to its
| retweeters. Fixed the issue where the markers were in a
| fixed location and woudn't move with the map. Added a
| feature where the user can display on the map the
| locations of certain hashtags. Also increased the size
| of the application. 
***************************************/
import org.geonames.*;

import controlP5.*;

import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.utils.*;
import de.fhpotsdam.unfolding.providers.*;
import de.fhpotsdam.unfolding.data.*;
import de.fhpotsdam.unfolding.marker.*;

import twitter4j.util.*;
import twitter4j.management.*;
import twitter4j.api.*;
import twitter4j.conf.*;
import twitter4j.json.*;
import twitter4j.auth.*;
import twitter4j.*;

import java.util.*;

//search criterias for unfolding maps
ToponymSearchCriteria searchCriteria = new ToponymSearchCriteria();

//list of retweeters data
ArrayList<Retweeters> retweeters = new ArrayList<Retweeters>();

//list of parent tweet locations
List<de.fhpotsdam.unfolding.geo.Location> parentLoc 
= new ArrayList<de.fhpotsdam.unfolding.geo.Location>();

//list of retweeter locations
List<de.fhpotsdam.unfolding.geo.Location> childLoc 
= new ArrayList<de.fhpotsdam.unfolding.geo.Location>();

//list of hashtag users locations
List<de.fhpotsdam.unfolding.geo.Location> hashtagLoc
= new ArrayList<de.fhpotsdam.unfolding.geo.Location>();

//list of markers to be displayed on the map
List<ScreenPosition> markerParent = new ArrayList<ScreenPosition>();
List<ScreenPosition> markerChild = new ArrayList<ScreenPosition>();
List<Marker> lineMarkers = new ArrayList<Marker>();

//setting up libraries
UnfoldingMap map;

ControlP5 cp5, cp6, cp7;
Textfield twitterTextField, hashtagMapTextField;
Textlabel myTextlabelA, myTextlabelB, myTextlabelC;
PFont fontTweets, fontTextfieldLabel, fontButton, fontGraph, fontSlider;

Button[] buttons;
TweetData[] tweets;
Graph graph;
float[][] rtwDates = new float[12][32];
FloatList rtwMonths = new FloatList();
StringList rtwMonthsLabel = new StringList();

List<Status> statuses = null;
Twitter twitter;
Query query;
Paging page;

int sinceYear, sinceMonth, sinceDay,
    untilYear, untilMonth, untilDay,
    tlYear, tlMonth, tlDay;
Date dateSince = new Date();
Date dateUntil = new Date();
Date currentDate = new Date();

PImage logo;
PFont twitterFont;

int mode = 0, selection = 0;
boolean userSearch = true, hashtagSearch = false;
boolean mapLoaded = false, timelineLoaded = false;
String user = "mindenigma", hashtag = "coco", hashtagMap;

void setup()
{
  size(1152, 720, OPENGL);
  smooth();
  frameRate(500);
  
  //GeoNames account
  WebService.setUserName("mindbeef");
  
  //background image
  logo = loadImage("data/twitterLogo.png");
  logo.resize(0, height-100);
  
  //Twitter API setup
  ConfigurationBuilder cb = new ConfigurationBuilder();
  //cb.setOAuthConsumerKey("xxxx");
  //cb.setOAuthConsumerSecret("xxxx");
  //cb.setOAuthAccessToken("xxxx");
  //cb.setOAuthAccessTokenSecret("xxxx");
  
  twitter = new TwitterFactory(cb.build()).getInstance();
  
  //sets amount of tweets to pull
  page = new Paging (1,20);
  
  
  try
  {
    //pulls recent tweets from users account
    statuses = twitter.getUserTimeline(user, page);
    
    //sets up buttons and twitter display in main UI
    buttons = new Button[statuses.size()];
    tweets = new TweetData[statuses.size()];
    
    //extracting data and storing it
    for (int i=0; i<statuses.size(); i++) 
    {
      buttons[i] = new Button();
      tweets[i] = new TweetData();
      
      //storing status metadata
      Status status = (Status)statuses.get(i);
      
      //checks if tweet is a retweet from another user
      if(status.isRetweet())
      {
        //stores parent user's location ID and location
        tweets[i].setTweetId(status.getRetweetedStatus().getId());
        tweets[i].setUserLoc(status.getRetweetedStatus().getUser().getLocation());
        
        //checks if parent user has locations enabled
        if (status.getRetweetedStatus().getGeoLocation() != null)
        {
          //stores geolocation if applicable
          tweets[i].setCoordStatus(true);
          tweets[i].setCoords(status.getRetweetedStatus().getGeoLocation().getLatitude(), 
                              status.getRetweetedStatus().getGeoLocation().getLongitude());
        }
      }
      else
      {
        //stores users ID and location
        tweets[i].setTweetId(status.getId());
        tweets[i].setUserLoc(status.getUser().getLocation());
        
        //checks if user has locations enabled
        if (status.getGeoLocation() != null)
        {
          //stores geolocation if applicable
          tweets[i].setCoordStatus(true);
          tweets[i].setCoords(status.getGeoLocation().getLatitude(), status.getGeoLocation().getLongitude());
        }
      }
      
      //stores rest of user data
      tweets[i].setUser(status.getUser().getScreenName());
      tweets[i].setText(status.getText());
      tweets[i].setProfilePic(status.getUser().getBiggerProfileImageURL());
      tweets[i].setRetweetCount(status.getRetweetCount());
      
      //pulls the creation date of each tweet
      Date dtemp = status.getCreatedAt();
      
      //stores the creation date of each tweet
      tweets[i].setDate(dtemp.getDate(), dtemp.getMonth()+1, dtemp.getYear()+1900);
    }
  }
  catch(TwitterException e)
  {
    println("Error: "+e+"\n");
  }
  
  //setting up map for display and panning to the middle of map
  map = new UnfoldingMap(this, 10, 60, width-20, height-70, new StamenMapProvider.WaterColor());
  map.setTweening(true);
  MapUtils.createDefaultEventDispatcher(this, map);
  map.zoomAndPanTo(new de.fhpotsdam.unfolding.geo.Location(0.0,0.0), 2);
  
  // Sets the size of the graph in the timeline
  graph = new Graph(120,100,width-200,height-250);
  
  // Initializes array of dates
  for (int i=0; i<12; i++)
  {
    for (int j=0; j<31; j++)
    {
      rtwDates[i][j]=0.;
    }
  }
  
  //UI button setup
  cp5 = new ControlP5(this);
  cp6 = new ControlP5(this);
  cp7 = new ControlP5(this);
  
  // Set fonts for UI
  fontTweets = loadFont("LucidaSans-11.vlw");
  fontTextfieldLabel = loadFont("LucidaSans-12.vlw");
  fontButton = loadFont("LucidaSans-Demi-14.vlw");
  fontGraph = loadFont("LucidaSans-Demi-14.vlw");
  fontSlider = loadFont("LucidaSans-11.vlw");
  
  displayUI();
  displayMapUI();
  displayTimelineUI();
}

void draw()
{
  background(0, 58, 88);
  
  //main display mode
  if (mode == 0)
  {
    //displays twitter logo in background
    image(logo, 200, 50);
    
    //display main UI
    cp5.show();
    cp6.hide();
    cp7.hide();
    
    int counter = 0;
    int num = selection;
    
    //loops through data for display
    if(userSearch != false || hashtagSearch != false)
    {
      while(counter < 5)
      {
        buttons[num].setDimensions(352, 192+(counter*75), 446, 73);
        buttons[num].display();
        tweets[num].setDimensions(425, 196+(counter*75), 369, 48);
        tweets[num].display();
        num = (num+1)%buttons.length;
        counter++;
      }
    }
  }
  
  //map display mode
  else if (mode == 1)
  {
    cp5.hide();
    map.draw();
    cp6.show();
    cp7.hide();
   
    //draws markers on map for retweet locations
    for (int i = 0; i < childLoc.size(); i++)
    {
      ScreenPosition child = map.getScreenPosition(childLoc.get(i));
      fill(0, 100, 0, 150);
      ellipse(child.x, child.y, 10, 10);
    }
    
    //draws markers on map for parent tweet locations
    for (int i = 0; i < parentLoc.size(); i++)
    {
      ScreenPosition parent = map.getScreenPosition(parentLoc.get(i));
      fill(255, 0, 0);
      ellipse(parent.x, parent.y, 10, 10);
    }
    
    //draws markers on map for hashtag locations
    for(int i = 0; i < hashtagLoc.size(); i++)
    {
      ScreenPosition hash = map.getScreenPosition(hashtagLoc.get(i));
      fill(102, 51, 255, 180);
      ellipse(hash.x, hash.y, 10, 10);
    }
  }
  
  //timeline display mode
  else if (mode == 2)
  {
    cp5.hide();
    cp6.hide();
    cp7.show();
    graph.drawGraph();
  }
}

void mousePressed()
{
  //clickable areas in main display mode
  //'highlights' tweets as it is clicked
  if (mode == 0)
  {
     if ((mouseX > 352 && mouseX < 798) && (mouseY > 192 && mouseY < 265))
    {
      buttons[selection].click();
    }
    //click box of box 2
    else if ((mouseX > 352 && mouseX < 798) && (mouseY > 267 && mouseY < 340))
    {
      int temp = (selection+1)%buttons.length;
      buttons[temp].click();
    } 
    //click box of box 3
    else if ((mouseX > 352 && mouseX < 798) && (mouseY > 342 && mouseY < 415))
    {
      int temp = (selection+2)%buttons.length;
      buttons[temp].click();
    } 
    //click box of box 4
    else if ((mouseX > 352 && mouseX < 798) && (mouseY > 417 && mouseY < 490))
    {
      int temp = (selection+3)%buttons.length;
      buttons[temp].click();
    } 
    //click box of box 5
    else if ((mouseX > 352 && mouseX < 798) && (mouseY > 492 && mouseY < 565))
    {
      int temp = (selection+4)%buttons.length;
      buttons[temp].click();
    }
  }
}

//string reciever from text box
//takes in a user input to be handled by the twitter API
void controlEvent(ControlEvent theEvent)
{
  if(userSearch == true && hashtagSearch == false && mapLoaded == false)
  {
    if(theEvent.isAssignableFrom(Textfield.class))
    {
      user = theEvent.getStringValue();
      displayUser(user);
      
    }
  } 
  else if (userSearch == false && hashtagSearch == true && mapLoaded == false)
  {
    if(theEvent.isAssignableFrom(Textfield.class))
    {
      hashtag = theEvent.getStringValue();
      displayHashtag(hashtag);
    }
  }
  else if (mapLoaded == true)
  {
    if(theEvent.isAssignableFrom(Textfield.class))
    {
      hashtagMap = theEvent.getStringValue();
      addHashtag(hashtagMap);
    }
  }
}

//Twitter user search and displays on UI
void displayUser(String user)
{
  statuses.clear();
  
  try
  {
    
    // Begin search by date
    statuses = new ArrayList<Status>();
    List<Status> temp = twitter.getUserTimeline(user, page);
    
    //start date of user's tweets
    dateSince.setYear(sinceYear-1900);
    dateSince.setMonth(sinceMonth-1);
    dateSince.setDate(sinceDay);
    
    //end date of user's tweets
    dateUntil.setYear(untilYear-1900);
    dateUntil.setMonth(untilMonth-1);
    dateUntil.setDate(untilDay);
    
    //add users tweets based on specified date range
    for (int i=0; i < temp.size(); i++) 
    {
      Date d = temp.get(i).getCreatedAt();
      if (d.after(dateSince) && d.before(dateUntil))
      {
        statuses.add(temp.get(i));
      }
    }
    // End search by date
    
    //extracting user data and storing it
    for (int i=0; i<statuses.size(); i++) 
    {
      buttons[i] = new Button();
      tweets[i] = new TweetData();
      
      Status status = (Status)statuses.get(i);
      
      //checks if tweet is a retweet from another user
      if(status.isRetweet())
      {
        //stores parent user's location ID and location
        tweets[i].setTweetId(status.getRetweetedStatus().getId());
        tweets[i].setUserLoc(status.getRetweetedStatus().getUser().getLocation());
        
        //checks if parent user has locations enabled
        if (status.getRetweetedStatus().getGeoLocation() != null)
        {
          //stores geolocation if applicable
          tweets[i].setCoordStatus(true);
          tweets[i].setCoords(status.getRetweetedStatus().getGeoLocation().getLatitude(), 
                              status.getRetweetedStatus().getGeoLocation().getLongitude());
        }
      }
      else
      {
        //stores users ID and location
        tweets[i].setTweetId(status.getId());
        tweets[i].setUserLoc(status.getUser().getLocation());
        
        //checks if user has locations enabled
        if (status.getGeoLocation() != null)
        {
          //stores geolocation if applicable
          tweets[i].setCoordStatus(true);
          tweets[i].setCoords(status.getGeoLocation().getLatitude(), status.getGeoLocation().getLongitude());
        }
      }
      
      //stores rest of user data
      tweets[i].setUser(status.getUser().getScreenName());
      tweets[i].setText(status.getText());
      tweets[i].setProfilePic(status.getUser().getBiggerProfileImageURL());
      tweets[i].setRetweetCount(status.getRetweetCount());
      
      //pulls the creation date of each tweet
      Date dtemp = status.getCreatedAt();
      
      //stores the creation date of each tweet
      tweets[i].setDate(dtemp.getDate(), dtemp.getMonth()+1, dtemp.getYear()+1900);
    }
  }
  catch(TwitterException e)
  {
    println("Error: "+e+"\n");
  }
}

void displayHashtag(String hashtag)
{
  markerParent.clear();
  markerChild.clear();
  
  //queries Twitter for hashtag search
  query = new Query("#" + hashtag);
  query.setCount(20);
  
  //stores user data based on hashtag
  try
  {
    QueryResult result = twitter.search(query);
    statuses = result.getTweets();
    
    //extracting data and storing it
    for (int i=0; i<statuses.size(); i++) 
    {
      buttons[i] = new Button();
      tweets[i] = new TweetData();
      
      //storing status metadata  
      Status status = (Status)statuses.get(i);
      
      //checks if tweet is a retweet from another user
      if(status.isRetweet())
      {
        //stores parent user's location ID and location
        tweets[i].setTweetId(status.getRetweetedStatus().getId());
        tweets[i].setUserLoc(status.getRetweetedStatus().getUser().getLocation());
        
        //checks if parent user has locations enabled
        if (status.getRetweetedStatus().getGeoLocation() != null)
        {
          //stores geolocation if applicable
          tweets[i].setCoordStatus(true);
          tweets[i].setCoords(status.getRetweetedStatus().getGeoLocation().getLatitude(), 
                              status.getRetweetedStatus().getGeoLocation().getLongitude());
        }
      }
      else
      {
        //stores users ID and location
        tweets[i].setTweetId(status.getId());
        tweets[i].setUserLoc(status.getUser().getLocation());
        
        //checks if user has locations enabled
        if (status.getGeoLocation() != null)
        {
          //stores geolocation if applicable
          tweets[i].setCoordStatus(true);
          tweets[i].setCoords(status.getGeoLocation().getLatitude(), status.getGeoLocation().getLongitude());
        }
      }
      
      //stores rest of user data
      tweets[i].setUser(status.getUser().getScreenName());
      tweets[i].setText(status.getText());
      tweets[i].setProfilePic(status.getUser().getBiggerProfileImageURL());
      tweets[i].setRetweetCount(status.getRetweetCount());
      
      //pulls the creation date of each tweet
      Date dtemp = status.getCreatedAt();
      
      //stores the creation date of each tweet
      tweets[i].setDate(dtemp.getDate(), dtemp.getMonth()+1, dtemp.getYear()+1900);
    }
  }
  catch(TwitterException e)
  {
    println("Error: "+e+"\n");
  }
}

