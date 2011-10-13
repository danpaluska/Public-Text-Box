/* Public Text Box */

/*

contains portions of a simple Processing and Twitter thingy majiggy
RobotGrrl.com
Code licensed under:
CC-BY

update from dan, additional code, public domain.

*/

// First step is to register your Twitter application at dev.twitter.com
// Once registered, you will have the info for the OAuth tokens
// You can get the Access token info by clicking on the button on the
// right on your twitter app's page

// get library from http://www.sojamo.de/libraries/controlP5
// and http://www.superduper.org/processing/fullscreen_api/
import fullscreen.*; 
FullScreen fs; 

import controlP5.*;
ControlP5 controlP5;
String textValue = "";
Textfield myTextfield;

static String accessKeys[];
static String OAuthConsumerKey;
static String OAuthConsumerSecret;
// This is where you enter your Access Token info
static String AccessToken;
static String AccessTokenSecret;

//static means global
int x = 30;
PFont fontA;
static String[] pastTweets = new String[20];
static String thisTweet="";
int numTweets;

String myTimeline;
java.util.List statuses = null;
Twitter twitter = new TwitterFactory().getInstance();
RequestToken requestToken;
String[] theSearchTweets = new String[11];


Textlabel myTextlabelA;
Textlabel myTextlabelB;

void setup() {
  
// see keys-dummy.txt and rename and replace for yourself.
accessKeys = loadStrings("keys.txt");
OAuthConsumerKey = accessKeys[0];
OAuthConsumerSecret = accessKeys[1];
AccessToken = accessKeys[2];
AccessTokenSecret = accessKeys[3];
  
  
  controlP5 = new ControlP5(this);

  myTextfield = controlP5.addTextfield("type msg here",10,60,350,50);
  myTextfield.setFocus(true);
  //myTextfield.
//  controlP5.setControlFont(new ControlFont(createFont("Georgia",14), 14));

  myTextlabelA = controlP5.addTextlabel("label","remaining chars = 140",240,114);
    //myTextlabelB = controlP5.addTextlabel("label2","@publictextbox",10,10);
  //myTextlabelA.setColorValue(0xffcccccc);

  myTextlabelB = new Textlabel(this,"publictextbox",10,10,800,250);

  //controlP5.addTextfield("textValue",100,200,200,20);
  
  size(1200,700);
//  size(640,480);
    // Create the fullscreen object
  fs = new FullScreen(this); 
  
  // enter fullscreen mode
  fs.enter(); 

  background(100);
   //fontA = loadFont("Ziggurat-HTF-Black-32.vlw");

  // Set the font and its size (in units of pixels)
  //textFont(fontA, 32);

  
  connectTwitter();
  
  //sendTweet("Hey from processing test application");
  getTimeline();
 
}


void draw() {
  background(100);
  
  int remChars=140-myTextfield.getText().length();
fill(50);
//text("type and then hit enter to tweet", 10, 20);

fill(200);
//rect(10,40,900,100);
//myTextlabelB = new Textlabel(this,"characters remaining " + remChars,20,74,300,200);
myTextlabelB.draw(this);
//yTextlabelA = new Textlabel(this,"----changed text with remChars = "+remChars,20,74,800,40);
//myTextlabelA.draw(this);

myTextlabelA.setValue("remaining chars = "+remChars);


//text("characters remaining " +remChars, 10, 50);
fill(0);
//keyTyped();
//println(myTextlabelA.isAutoClear());

fill(150);
text("the past", 10, 180);
  for(int i=0; i<numTweets; i++)
  {    
    text(pastTweets[i],10, i*30+210);
  }
 
}


// Initial connection
void connectTwitter() {

  twitter.setOAuthConsumer(OAuthConsumerKey, OAuthConsumerSecret);
  AccessToken accessToken = loadAccessToken();
  twitter.setOAuthAccessToken(accessToken);

}

// Sending a tweet
void sendTweet(String t) {

  try {
    Status status = twitter.updateStatus(t);
    println("Successfully updated the status to [" + status.getText() + "].");
  } catch(TwitterException e) { 
    println("Send tweet: " + e + " Status code: " + e.getStatusCode());
  }

}


// Loading up the access token
private static AccessToken loadAccessToken(){
  return new AccessToken(AccessToken, AccessTokenSecret);
}


// Get your tweets
void getTimeline() {
String foo;
  try {
    statuses = twitter.getUserTimeline(); 
  } catch(TwitterException e) { 
    println("Get timeline: " + e + " Status code: " + e.getStatusCode());
  }
numTweets=statuses.size();
  for(int i=0; i<numTweets; i++) {
    
    Status status = (Status)statuses.get(i);
    pastTweets[i] = status.getCreatedAt() + ": " + status.getText();
    println(pastTweets[i]);
  
    //println(status.getUser().getName() + ": " + status.getText());
   // DATE 
    //date = status.getUser().getCreatedAt();
  }

}


// Search for tweets
void getSearchTweets() {

  String queryStr = "@publictextbox";

  try {
    Query query = new Query(queryStr);    
    query.setRpp(10); // Get 10 of the 100 search results  
    QueryResult result = twitter.search(query);    
    ArrayList tweets = (ArrayList) result.getTweets();    

    for (int i=0; i<tweets.size(); i++) {	
      Tweet t = (Tweet)tweets.get(i);	
      String user = t.getFromUser();
      String msg = t.getText();
      Date d = t.getCreatedAt();	
      theSearchTweets[i] = msg.substring(queryStr.length()+1);

      println(theSearchTweets[i]);
    }

  } catch (TwitterException e) {    
    println("Search tweets: " + e);  
  }

}

 
void controlEvent(ControlEvent theEvent) {
  println("controlEvent: accessing a string from controller '"+theEvent.controller().name()+"': "+theEvent.controller().stringValue());
  sendTweet(theEvent.controller().stringValue());
  getTimeline();
}


public void texting(String theText) {
  // receiving text from controller texting
  println("a textfield event for controller 'texting': "+theText);
}



