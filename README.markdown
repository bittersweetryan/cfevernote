# CFEvernote

Cfevernote is a evernote api wrapper for coldfusion.  

## Installation
Copy lib/evernote-api-1.18 to you <cfinstall dir>/lib folder

## To use in ColdFusion 9 or newer:
	cfevernote = new CFEvernote(apiKey,apiAccountName);
	
## To use in ColdFusion 6, 7, & 8:	
	cfevernote = CreateObject("component","CFEvernote).Init(apiKey,apiAccountName);
