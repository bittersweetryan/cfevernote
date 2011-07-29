#CFEvernote Documentation

##Overview 

CFEvernote is a ColdFusion implementation of the Evernote API.  It allows developers to view, create, and edit notes and notebooks.  

##Components

CFEvernote consists of two main parts: the ColdFusion objects and the Java objects.  CFEvernote uses a custom java class that wraps the calls to the Evernote API in a manner that is friendly for ColdFusion to use.  The ColdFusion components wrap the Evernote API object and also encapsulate the Note and Notebook evernote objects.  When you do calls to Evernote methods the ColdFusion wrapped objects are returned.  For instance when you call a getNotebooks() method a list of Notebook ColdFusion components is returned. 

## Installation

###Requirements

*Evernote API account. Get one [Here](http://www.evernote.com/about/developer/api/)
*Adobe ColdFusion 6.1 or newer, Railo 3 or newer (needs verification), OpenBD (needs version and verification)
*The ability to instantiate Java objects on your ColdFusion server (some shared hosting environments do not allow this)

###Installing Files

Copy the com, lib, support, and tmp directories to your web root.   The com directory contains the CFC's for cfEvernote, the lib directory contains dependencies for all of the java objects (mockito-all-1.8.5.jar is not required for the app to function, however, it is required to run the unit tests), the support and tmp directories both contain important files for the JavaLoader class to function properly.

## Creating and CFEvernote object

There are two ways to create an instance of cfevernote.  One is to intitlaize it BEFORE oauth and one is to intitalize it AFTER oauth.

###Creating an CFEvernote object
One option for creating an instance of the cfevernote object is to use createObject like so:
	cfevernote = createObject("component","com.714studios.cfevernote.CFEvernote).Init(apiAccount,apiSecret,evernoteHost,oauthCallbackURL,[libDirectory=_libDirectory]);

####Arguments	
*apiAccount - this is your evernote API account name, called a KEY by evernote. 
*apiSecret - this is your evernote API secret.
*evernoteHost - this is the evernote host to use for the API commands.  At the time of this writing sandbox.evernote.com for testing and www.evernote.com for production. Its important to note that www.evernote.com will not work unless your application has been approved by Evernote.
*oauthCallbackURL - this is the url on your server that a user should get redirected back to after they've approved your application to use evernote on their behalf. 
*libDirectory - this is the full directory where the "lib" folder can be accessed.  CFEvernote will by default guess that it is one directory below where it is being called from.  _If the objects aren't being created properly this is a good place to look first._

##Using 	

###The oAuth Process
	
Once you have an instance of the component you must first authenticate your api account like so:
	authenticateAPIUser()
This method will retun a boolean value which will be true if your api credentials have generated a temoprary auth token or false if there was a problem.  Once you have your temproary token the user will need to authorize your api account to access their account. Call the getEvernoteOAuthVerifyURL method to give your users a link to click on to allow your API key to access their account as follows:
	getEvernoteOAuthVerifyURL()
Once the user clicks on this url and authenticates your account Evernote will redirect the user back to the url that was specified in the callbackURL parameter when the CFEvernote object was created.  You will have to parse this url to reteive the token verifier, authentication token values and save them to the CFEvernote object:
	cfEvernote.setAuthToken(url.oauth_Token);
	cfEvernote.setAuthVerifier(url.oauth_verifier);
Once those values are set calling the getTokenCredentials() method will return your authentication token if your account has been authorized.  This is mostly a conveience method and won't need to be used when working with the API.
	cfEvernote.getTokenCredentials();

###Listing Notes

####Get all notes:
	//returns an array of note objects
	cfEvernote.getNotes()

####Get notes in a notebook:
	//returns an array of note objects
	cfEvernote.getNotesForNotebook(String notebookGUID)
	
###Listing Notebooks
	//returns an array of notebook objects
	cfEvernote.getNotebooks()

###Creating Notes
	//create a note object
	note = createObject("component","com.714studios.cfevernote.note").init("#ExpandPath('../')#/lib");
	//then set its content
	note.setContent(form.content);
			
	//set the notebook id if there is one
	if(len(form.notebookID))
		note.setNotebookGUID(form.notebookID);
			
	//set the tags if they exist
	if(form.tags neq ""){
		tagNames = listToArray(form.tags,",");
		
		//here we can either loop through the tags and cal the addTag method like so:
		//for(i = 1, i lte arrayLen(tagNames), i = i + 1){
		//	note.addTag(tagNames[i]);
		//}
		//or use a shortcut
		note.setTagNames(tagNames);
	}
			
	//lastly add the note to evernote using the cfevernote returns a new Note object
	note = session.cfEvernote.addNote(note);
			
###Creating Notebooks
	//returns a notebooj object
	cfEvernote.createNotebook(String name)
	
###Updating Notes
_coming in version 0.1.1_

###Updating Notebooks
_coming in version 0.1.1_

##Contribution

###Source Code
The code for this project is on github at [https://github.com/bittersweetryan/cfevernote](https://github.com/bittersweetryan/cfevernote).  If you would like to submit a pull request please do, i'd be more than happy to pull in any bug fixes or enhancements.  

###Java Project
The code for the java portion of this project is in the java/CFEvernote foldder.  There is a Netbeans 7.0 configured project in there so you should be able to import the project directly into the IDE.

###Tests
If you change either the ColdFusion code or the Java code please make sure that the mxunit or mockito tests all run green before sending the pull request.  Any new functions should have unit tests to test them as well. 
