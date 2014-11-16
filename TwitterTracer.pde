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
***************************************/

import controlP5.*;

import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.utils.*;

import twitter4j.util.*;
import twitter4j.management.*;
import twitter4j.api.*;
import twitter4j.conf.*;
import twitter4j.json.*;
import twitter4j.auth.*;
import twitter4j.*;

import java.util.*;

List<Status>statuses = null;
Paging page;
double lon1, lat1;
//double lat = 37.76525524, lon = -122.45573659;

de.fhpotsdam.unfolding.geo.Location loc;
UnfoldingMap map;

String user = "mindEnigma";

void setup()
{
  size(800, 600, OPENGL);
  
  
  ConfigurationBuilder cb = new ConfigurationBuilder();
  //cb.setOAuthConsumerKey("xxxx");
  //cb.setOAuthConsumerSecret("xxxx");
  //cb.setOAuthAccessToken("xxxx");
  //cb.setOAuthAccessTokenSecret("xxxx");

  
  Twitter twitter = new TwitterFactory(cb.build()).getInstance();
  
  page = new Paging (1,1);
  
  try
  {
    statuses = twitter.getUserTimeline(user, page);
    //println(statuses + "\n");
  }
  catch(TwitterException e)
  {
    println("User doesn't exist\n");
  }
  
  for (int i=0; i<statuses.size(); i++) 
  {
    Status status = (Status)statuses.get(i);
    
    GeoLocation loc = status.getGeoLocation();
    
 
    println(status.getUser().getName() + ": " + status.getText());
    
    if (status.getGeoLocation() != null)
    {
      println("Latitude: " + status.getGeoLocation().getLatitude() + 
      "\tLongitude: " + status.getGeoLocation().getLongitude());
      lat1 = status.getGeoLocation().getLatitude();
      lon1 = status.getGeoLocation().getLongitude();
    }
  }
  
  //println(lon1 + " " + lat1);
  map = new UnfoldingMap(this);
  
  map.zoomAndPanTo(new de.fhpotsdam.unfolding.geo.Location(lat1, lon1), 12);

  MapUtils.createDefaultEventDispatcher(this, map);
  
  loc = new de.fhpotsdam.unfolding.geo.Location(lat1, lon1);
}

void draw()
{
  map.draw();
  
  ScreenPosition marker = map.getScreenPosition(loc);
  fill(200, 0, 0, 100);
  ellipse(marker.x, marker.y, 20, 20);
}

