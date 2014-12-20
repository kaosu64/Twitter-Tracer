# Twitter-Tracer

Twitter has become one of the leading social networking websites within recent years. It allows information to spread quickly around the world in an instant. Twitter Tracer allows the user to visualize the flow of communication through Twitter. The program tracks how far a user’s status (tweets) travels from one location to another by connecting tweets with retweets over a map. The program also displays a time series of tweets as a number of tweets vs. time graph, which shows the activity and lifespan of retweets. The user can search for tweets using either twitter handles or hashtags, and can specify a time period for the search when searching with user handles.


## Website
http://mindbeef.github.io/Twitter-Tracer/


## How to Compile
This program was created in Processing 2.2.1. It also requires a GeoNames username and Twitter API keys to run properly.

### GeoNames
1. Go to: http://www.geonames.org/login

2. Sign up and log-in to GeoNames.

3. Once logged-in, click on your username or go here: http://www.geonames.org/manageaccount

4. Find the section "Free Web Services" and click enable.

5. Find the following line in TwitterTracer.pde and replace INSERT_USERNAME with your GeoNames username:

  ```
  //GeoNames account - Insert username here
  WebService.setUserName("INSERT_USERNAME");
  ```

### Twitter API
1. Go to: https://apps.twitter.com/

2. Sign up and log-in to Twitter.

3. Click "Create New App" and fill in the required fields.

4. Click the "Keys and Access Tokens" tab.

5. Find the section "Your Access Tokens" and under "Token Actions," click "Create my access token."

6. Under "API Settings," copy the Consumer Key (API Key) and Consumer Secret (API Secret). Under "Your Access Tokens," copy "Access Token" and "Access Token Secret."

7. Find the following lines in TwitterTracer.pde and replace each INSERT_KEY with the respective key:

  ```
  //Insert Twitter API keys here
  cb.setOAuthConsumerKey("INSERT_KEY");
  cb.setOAuthConsumerSecret("INSERT_KEY");
  cb.setOAuthAccessToken("INSERT_KEY");
  cb.setOAuthAccessTokenSecret("INSERT_KEY");
  ```

### Processing
1. Open the program in Processing (2.2.1) and select Run.
