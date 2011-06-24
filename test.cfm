<cfscript>
	cfEvernote = new CFEvernote("bittersweetryan","c62b156785e8f7dc","sandbox.evernote.com","http://localhost/test.cfm");

	if(cfEvernote.authenticate())
		writedump(cfEvernote.getEvernoteOAuthVerifyURL());
	


</cfscript>
