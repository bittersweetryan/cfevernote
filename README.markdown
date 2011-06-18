# CFEvernote

Cfevernote is a evernote api wrapper for coldfusion that uses the cfevernote jar and the apache thrift library.  Also included is Mark Mandel's java loader class.

## Installation
Copy lib directory to your web application's root

## To use in ColdFusion 9 or newer:
	cfevernote = new CFEvernote(apiKey,apiAccountName);

	cfevernote.authenticate(username,password);
		
## To use in ColdFusion 6, 7, & 8:	
	cfevernote = CreateObject("component","CFEvernote).Init(apiKey,apiAccountName);
	
	cfevernote.authenticate(username,password);