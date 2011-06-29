	<cffile action="read" file="#expandPath('/')#config.txt" variable="variables.filecontents" />
	<cfset configArray = listToArray(variables.filecontents)/>
	
<cfscript>
	//if(NOT structKeyExists(session,"cfEvernote"))
	session.cfEvernote = new CFEvernote(configArray[1],configArray[2],"sandbox.evernote.com","http://localhost/cfevernote/callback.cfm");
	
	session.cfEvernote.authenticate();
	
	//this is one way to call get Token credentials, the other would be:session.cfEvernote.getTokenCredentials(url.oauth_Token,url.oauth_verifier);
	if(isDefined("url.oauth_Token") AND isDefined("url.oauth_verifier")){
		session.cfEvernote.setAuthToken(url.oauth_Token);
		session.cfEvernote.setAuthVerifier(url.oauth_verifier);
		session.cfEvernote.getTokenCredentials();
	}
	
	writedump(session.cfEvernote.getAuthToken());
	writedump(session.cfEvernote.getShard());
	writedump(session.cfEvernote.getUserID());
</cfscript>

<cfoutput>
		<a href="#session.cfEvernote.getEvernoteOAuthVerifyURL()#">Auth</a>
</cfoutput>