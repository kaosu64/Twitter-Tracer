void userParentLocation(int num, String searchName)
{
  searchCriteria.setQ(searchName);
  
  try
  {
    ToponymSearchResult searchResult = WebService.search(searchCriteria);
    
    List<Toponym> toponym = searchResult.getToponyms();
    
    tweets[num].setCoords(toponym.get(0).getLatitude(), toponym.get(0).getLongitude());
    tweets[num].setCoordStatus(true);
    
    //println(toponym.get(0).getName());
    //println(num + " from method : " + toponym.get(0).getLatitude() + " " + toponym.get(0).getLongitude());
  }
  catch (Exception e) 
  {
    //println(num + " unable");
    tweets[num].setCoords(0.0, 0.0);
    tweets[num].setCoordStatus(false);
  }
}

