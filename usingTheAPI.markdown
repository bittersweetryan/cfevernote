## Installation
Copy all contents of "lib" a directory in your application. By default this is "lib", if you choose another directory you can pass in an argument to the constructor called "libDirectory" with its relative location to where this component lives.

## Creating an instance of the Evernote object

There are two ways to create an instance of cfevernote.  One is to intitlaize it BEFORE oauth and one is to intitalize it AFTER oauth.

###Before oAuth
	cfevernote = CreateObject("component","CFEvernote).Init(apiAccount,apiSecret,evernoteHost,oauthCallbackURL,[libDirectory=_libDirectory]);

###
	cfevernote = CreateObject("component","CFEvernote).Init(apiAccount,apiSecret,evernoteHost,oauthCallbackURL,authToken,shard,userID,[libDirectory]);

	
	
Once you have the component you must first authenticate your api account by calling the 
	authenticateAPIUser()
method.  This method retuns a boolean value, true if your api credentials generated a temoprary auth token or false if there was a problem.  Once you have your temproary token the user will need to authorize your api account to access their account.  Do do this create a link that calls the
	getEvernoteOAuthVerifyURL()
method which will send evernote your temporary auth token and will generate your evernote credentials for use.   
