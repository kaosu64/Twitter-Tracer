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
ArrayList<ScreenPosition> markerParent = new ArrayList<ScreenPosition>();
ArrayList<ScreenPosition> markerChild = new ArrayList<ScreenPosition>();

UnfoldingMap map;

ControlP5 cp5, cp6, cp7;
Textfield twitterTextField;
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
String user = "shaq", hashtag = "coco";

void setup()
{
  size(800, 600, OPENGL);
  smooth();
  frameRate(500);
  
  
  logo = loadImage("data/twitterLogo.png");
  logo.resize(0, height-100);
  
  WebService.setUserName("mindbeef");
  
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
  
  map = new UnfoldingMap(this, 10, 50, width-20, height-60, new StamenMapProvider.TonerLite());
  MapUtils.createDefaultEventDispatcher(this, map);

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
    image(logo, 100, 50);
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
    rect(300, 206, 150, 16);
    fill(205);
    rect(452, 206, 167, 16);*/
    if(userSearch != false || hashtagSearch != false)
    {
      while(counter < 5)
      {
        buttons[num].setDimensions(227, 152+(counter*75), 396, 73);
        buttons[num].display();
        tweets[num].setDimensions(300, 156+(counter*75), 319, 48);
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
    
    for (int i = 0; i < parentLoc.size(); i++)
    {
      markerParent.add(map.getScreenPosition(parentLoc.get(i)));
      fill(200, 0, 0);
      ellipse(markerParent.get(i).x, markerParent.get(i).y, 5, 5);
    }
    for (int i = 0; i < childLoc.size(); i++)
    {
      markerChild.add(map.getScreenPosition(childLoc.get(i)));
      fill(0, 200, 0);
      ellipse(markerChild.get(i).x, markerChild.get(i).y, 5, 5);
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
     if ((mouseX > 227 && mouseX < 623) && (mouseY > 152 && mouseY < 225))
    {
      buttons[selection].click();
    }
    //click box of thumbnail 2
    else if ((mouseX > 227 && mouseX < 623) && (mouseY > 227 && mouseY < 300))
    {
      int temp = (selection+1)%buttons.length;
      buttons[temp].click();
    } 
    //click box of thumbnail 3
    else if ((mouseX > 227 && mouseX < 623) && (mouseY > 302 && mouseY < 375))
    {
      int temp = (selection+2)%buttons.length;
      buttons[temp].click();
    } 
    //click box of thumbnail 4
    else if ((mouseX > 227 && mouseX < 623) && (mouseY > 377 && mouseY < 450))
    {
      int temp = (selection+3)%buttons.length;
      buttons[temp].click();
    } 
    //click box of thumbnail 5
    else if ((mouseX > 227 && mouseX < 623) && (mouseY > 452 && mouseY < 525))
    {
      int temp = (selection+4)%buttons.length;
      buttons[temp].click();
    }
  }
}

void controlEvent(ControlEvent theEvent)
{
  if(userSearch == true && hashtagSearch == false)
  {
    if(theEvent.isAssignableFrom(Textfield.class))
    {
      user = theEvent.getStringValue();
      displayUser(user);
      
    }
  } 
  else if (userSearch == false && hashtagSearch == true)
  {
    if(theEvent.isAssignableFrom(Textfield.class))
    {
      hashtag = theEvent.getStringValue();
      displayHashtag(hashtag);
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
      
      println("Tweet " + i + ": " + status.getText() + "\t ID: " + status.getId());
      
      
      
      if (status.getGeoLocation() != null)
      {
        tweets[i].setCoordStatus(true);
        tweets[i].setCoords(status.getGeoLocation().getLatitude(), status.getGeoLocation().getLongitude());
        println("Enabled " + i + " " + status.getUser().getScreenName()); 
      }
      else
      {
        userParentLocation(i, tweets[i].getUserLoc());
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
      
      if (status.getGeoLocation() != null)
      {
        tweets[i].setCoordStatus(true);
        tweets[i].setCoords(status.getGeoLocation().getLatitude(), status.getGeoLocation().getLongitude());
        println("Enabled " + i + " " + status.getUser().getScreenName());
      }
      else
      {
        userParentLocation(i, tweets[i].getUserLoc());
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

