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

ToponymSearchCriteria searchCriteria = new ToponymSearchCriteria();
ArrayList<Retweeters> retweeters = new ArrayList<Retweeters>();

de.fhpotsdam.unfolding.geo.Location euclid;

List<de.fhpotsdam.unfolding.geo.Location> parentLoc 
= new ArrayList<de.fhpotsdam.unfolding.geo.Location>();

List<de.fhpotsdam.unfolding.geo.Location> childLoc 
= new ArrayList<de.fhpotsdam.unfolding.geo.Location>();

List<de.fhpotsdam.unfolding.geo.Location> hashtagLoc
= new ArrayList<de.fhpotsdam.unfolding.geo.Location>();

List<ScreenPosition> markerParent = new ArrayList<ScreenPosition>();
List<ScreenPosition> markerChild = new ArrayList<ScreenPosition>();
List<Marker> lineMarkers = new ArrayList<Marker>();

UnfoldingMap map;

ControlP5 cp5, cp6, cp7;
Textfield twitterTextField, hashtagMapTextField;
Textlabel myTextlabelA, myTextlabelB, myTextlabelC;

Button[] buttons;
TweetDisplay[] tweets;
Graph graph;

List<Status> statuses = null;
Twitter twitter;
Query query;
Paging page;

int sinceYear, sinceMonth, sinceDay,
    untilYear, untilMonth, untilDay;
Date dateSince = new Date();
Date dateUntil = new Date();

PImage logo;
int mode = 0, selection = 0;
boolean userSearch = true, hashtagSearch = false;
boolean mapLoaded = false, timelineLoaded = false;
String user = "mindenigma", hashtag = "coco", hashtagMap;

void setup()
{
  size(1152, 720, OPENGL);
  smooth();
  frameRate(500);
  
  WebService.setUserName("mindbeef");
  //WebService.setUserName("haalbaar");
  
  logo = loadImage("data/twitterLogo.png");
  logo.resize(0, height-100);
  
  ConfigurationBuilder cb = new ConfigurationBuilder();
  //cb.setOAuthConsumerKey("xxxx");
  //cb.setOAuthConsumerSecret("xxxx");
  //cb.setOAuthAccessToken("xxxx");
  //cb.setOAuthAccessTokenSecret("xxxx");
 
  twitter = new TwitterFactory(cb.build()).getInstance();
  
  page = new Paging (1,20);
  
  try
  {
    statuses = twitter.getUserTimeline(user, page);
    
    buttons = new Button[statuses.size()];
    tweets = new TweetDisplay[statuses.size()];
    
    for (int i=0; i<statuses.size(); i++) 
    {
      buttons[i] = new Button();
      tweets[i] = new TweetDisplay();
      
      Status status = (Status)statuses.get(i);
      
      tweets[i].setUser(status.getUser().getScreenName());
      tweets[i].setText(status.getText());
      tweets[i].setProfilePic(status.getUser().getBiggerProfileImageURL());
      tweets[i].setRetweetCount(status.getRetweetCount());
      tweets[i].setTweetId(status.getId());
      tweets[i].setUserLoc(status.getUser().getLocation());
      
      Date dtemp = status.getCreatedAt();
      tweets[i].setDate(dtemp.getDate(), dtemp.getMonth()+1, dtemp.getYear()+1900);
      
     // List<Status> test = twitter.getRetweets(tweets[i].getTweetId());
      //println(status.getUser().getLocation());
      //println("Tweet " + i + ": " + status.getText() + "\t ID: " + status.getId());
      
      if (status.getGeoLocation() != null)
      {
        tweets[i].setCoordStatus(true);
        tweets[i].setCoords(status.getGeoLocation().getLatitude(), status.getGeoLocation().getLongitude());
      }
      else
      {
        userParentLocation(i, tweets[i].getUserLoc());
        //println("from main: " + tweets[i].getLat() + " " + tweets[i].getLon() + "\n");
      }
    }
  }
  catch(TwitterException e)
  {
    println("Error\n");
  }
  
  graph = new Graph(100,100,650,350);
  
  map = new UnfoldingMap(this, 10, 50, width-20, height-60, new StamenMapProvider.WaterColor());
  //map = new UnfoldingMap(this, new StamenMapProvider.WaterColor());
  map.setTweening(true);
  MapUtils.createDefaultEventDispatcher(this, map);
  map.zoomAndPanTo(new de.fhpotsdam.unfolding.geo.Location(0.0,0.0), 2);
  //map.setScaleRange(1400.0, 1000.0);
  
  cp5 = new ControlP5(this);
  cp6 = new ControlP5(this);
  cp7 = new ControlP5(this);
  
  displayUI();
  displayMapUI();
  displayTimelineUI();
}

void draw()
{
  background(0, 58, 88);
  
  if (mode == 0)
  {
    image(logo, 200, 50);
    cp5.show();
    cp6.hide();
    cp7.hide();
    
    int counter = 0;
    int num = selection;
    /*fill(205);
    rect(225, 150, 400, 377);
    fill(0,58,88, 150);
    rect(227, 152, 396, 73);
    fill(0,58,88, 50);
    rect(227, 152+75, 396, 73);
    fill(0,58,88, 50);
    rect(227, 152+150, 396, 73);
    fill(0,58,88, 50);
    rect(227, 152+225, 396, 73);
    fill(0,58,88, 50);
    rect(227, 152+300, 396, 73);
    
    fill(205);
    rect(300, 156, 319, 48);
    fill(205);
    rect(425, 246, 125, 16);
    fill(0);
    text("123456789012345",425, 246, 150, 16);
    fill(205);
    rect(552, 246, 92, 16);*/
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
  else if (mode == 1)
  {
    cp5.hide();
    map.draw();
    cp6.show();
    cp7.hide();
   
    for (int i = 0; i < childLoc.size(); i++)
    {
      //markerChild.add(map.getScreenPosition(childLoc.get(i)));
      //fill(0, 100, 0, 150);
      //ellipse(markerChild.get(i).x, markerChild.get(i).y, 10, 10);
      
      ScreenPosition child = map.getScreenPosition(childLoc.get(i));
      fill(0, 100, 0, 150);
      ellipse(child.x, child.y, 10, 10);
    }
    for (int i = 0; i < parentLoc.size(); i++)
    {
      //markerParent.add(map.getScreenPosition(parentLoc.get(i)));
      //fill(255, 0, 0);
      //ellipse(markerParent.get(i).x, markerParent.get(i).y, 10, 10);
      
      ScreenPosition parent = map.getScreenPosition(parentLoc.get(i));
      fill(255, 0, 0);
      ellipse(parent.x, parent.y, 10, 10);
    }
    for(int i = 0; i < hashtagLoc.size(); i++)
    {
      ScreenPosition hash = map.getScreenPosition(hashtagLoc.get(i));
      fill(102, 51, 255, 180);
      ellipse(hash.x, hash.y, 10, 10);
    }
  }
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
  if (mode == 0)
  {
     if ((mouseX > 352 && mouseX < 798) && (mouseY > 192 && mouseY < 265))
    {
      buttons[selection].click();
    }
    //click box of thumbnail 2
    else if ((mouseX > 352 && mouseX < 798) && (mouseY > 267 && mouseY < 340))
    {
      int temp = (selection+1)%buttons.length;
      buttons[temp].click();
    } 
    //click box of thumbnail 3
    else if ((mouseX > 352 && mouseX < 798) && (mouseY > 342 && mouseY < 415))
    {
      int temp = (selection+2)%buttons.length;
      buttons[temp].click();
    } 
    //click box of thumbnail 4
    else if ((mouseX > 352 && mouseX < 798) && (mouseY > 417 && mouseY < 490))
    {
      int temp = (selection+3)%buttons.length;
      buttons[temp].click();
    } 
    //click box of thumbnail 5
    else if ((mouseX > 352 && mouseX < 798) && (mouseY > 492 && mouseY < 565))
    {
      int temp = (selection+4)%buttons.length;
      buttons[temp].click();
    }
  }
}

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

void displayUser(String user)
{
  statuses.clear();
  
  try
  {
    //statuses = twitter.getUserTimeline(user, page);
    //println(statuses + "\n");
    
    // Begin search by date
    statuses = new ArrayList<Status>();
    List<Status> temp = twitter.getUserTimeline(user, page);
    
    dateSince.setYear(sinceYear-1900);
    dateSince.setMonth(sinceMonth-1);
    dateSince.setDate(sinceDay);
    
    dateUntil.setYear(untilYear-1900);
    dateUntil.setMonth(untilMonth-1);
    dateUntil.setDate(untilDay);
    
    for (int i=0; i < temp.size(); i++) 
    {
      Date d = temp.get(i).getCreatedAt();
      if (d.after(dateSince) && d.before(dateUntil))
      {
        statuses.add(temp.get(i));
      }
    }
    // End search by date
    
    for (int i=0; i<statuses.size(); i++) 
    {
      buttons[i] = new Button();
      tweets[i] = new TweetDisplay();
      
      Status status = (Status)statuses.get(i);
      
      tweets[i].setUser(status.getUser().getScreenName());
      tweets[i].setText(status.getText());
      tweets[i].setProfilePic(status.getUser().getBiggerProfileImageURL());
      tweets[i].setRetweetCount(status.getRetweetCount());
      tweets[i].setTweetId(status.getId());
      tweets[i].setUserLoc(status.getUser().getLocation());
      
      Date dtemp = status.getCreatedAt();
      tweets[i].setDate(dtemp.getDate(), dtemp.getMonth()+1, dtemp.getYear()+1900);
      
      println("Tweet " + i + ": " + status.getText() + "\t ID: " + status.getId());
      
      
      
      if (status.getGeoLocation() != null)
      {
        tweets[i].setCoordStatus(true);
        tweets[i].setCoords(status.getGeoLocation().getLatitude(), status.getGeoLocation().getLongitude());
        println("Enabled " + i + " " + status.getUser().getScreenName()); 
      }
      else
      {
        //userParentLocation(i, tweets[i].getUserLoc());
        //println(status.getUser().getLocation());
        //println(i + " from main: " + tweets[i].getLat() + " " + tweets[i].getLon() + "\n");
        //tweets[i].setCoordStatus(false);
      }
    }
  }
  catch(TwitterException e)
  {
    println("Error\n");
  }
}

void displayHashtag(String hashtag)
{
  markerParent.clear();
  markerChild.clear();
  query = new Query("#" + hashtag);
  query.setCount(20);
  
  try
  {
    QueryResult result = twitter.search(query);
    statuses = result.getTweets();
    
    for (int i=0; i<statuses.size(); i++) 
    {
      buttons[i] = new Button();
      tweets[i] = new TweetDisplay();
      
      Status status = (Status)statuses.get(i);
      
      tweets[i].setUser(status.getUser().getScreenName());
      tweets[i].setText(status.getText());
      tweets[i].setProfilePic(status.getUser().getBiggerProfileImageURL());
      tweets[i].setRetweetCount(status.getRetweetCount());
      tweets[i].setTweetId(status.getId());
      tweets[i].setUserLoc(status.getUser().getLocation());
      
      Date dtemp = status.getCreatedAt();
      tweets[i].setDate(dtemp.getDate(), dtemp.getMonth()+1, dtemp.getYear()+1900);
      
      if (status.getGeoLocation() != null)
      {
        tweets[i].setCoordStatus(true);
        tweets[i].setCoords(status.getGeoLocation().getLatitude(), status.getGeoLocation().getLongitude());
        println("Enabled " + i + " " + status.getUser().getScreenName());
      }
      else
      {
        //userParentLocation(i, tweets[i].getUserLoc());
        //println(tweets[i].getUserLoc());
        //println(status.getUser().getLocation());
        //println(i + " from main: " + tweets[i].getLat() + " " + tweets[i].getLon() + "\n");
        //tweets[i].setCoordStatus(false);
      }
    }
  }
  catch(TwitterException e)
  {
    println("Error\n");
  }
}

