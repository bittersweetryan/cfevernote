	<cffile action="read" file="#expandPath('/')#config.txt" variable="variables.filecontents" />
	<cfset configArray = listToArray(variables.filecontents)/>
	
<cfscript>
	//its best to persist this object somewhere since the oauth process will require saving state
	
	if(NOT structKeyExists(session,"cfEvernote") OR isDefined("url.reset")){
		
		session.cfEvernote = new com.714studios.cfevernote.CFEvernote(configArray[1],configArray[2],"sandbox.evernote.com","http://localhost/cfevernote/callback.cfm","#getDirectoryFromPath(getCurrentTemplatePath())#/lib");
		
		if(NOT session.cfEvernote.authenticateAPIUser()){
			//this is one way to call get Token credentials, the other would be:session.cfEvernote.getTokenCredentials(url.oauth_Token,url.oauth_verifier);
			writeDump(var="API Key and Username were not authenticated by evernote",abort=true);
		}
	}

	//once a suer authentictaes with everhote, it will pass them back to the callback when you intialized evernote and pass a token and verifier
	//we can set get credentials in two ways, by first seetting the token and verifier then calling it with no properties, or calling it using
	//them as arguments		
	if(isDefined("url.oauth_Token") AND isDefined("url.oauth_verifier")){
		session.cfEvernote.setAuthToken(url.oauth_Token);
		session.cfEvernote.setAuthVerifier(url.oauth_verifier);
		session.cfEvernote.getTokenCredentials();
	}

</cfscript>

<cfoutput>
	<ul>
		<li>
			<a href="#session.cfEvernote.getEvernoteOAuthVerifyURL()#">Auth</a>
		</li>
		<li>
			<a href="callback.cfm?reset=true">Reset</a>
		<li>
			<a href="callback.cfm?method=getNotebooks">Get Notebooks</a>
		</li>
		<li>
			<a href="callback.cfm?method=getNotes">Get Notes</a>
		</li>
	</ul>
	
	<cfif isDefined("url.method") AND url.method eq "getNotebooks">
		<cfset notebooks = session.cfEvernote.getNotebooks() />
		<cfdump var="#getMetaData(notebooks[1])#" />
		<cfdump var="#session.cfEvernote.getNotebooks()#">
	<cfelseif isDefined("url.method") AND url.method eq "getNotes">
		<cfdump var="#session.cfEvernote.getNotes()#">
	</cfif>
</cfoutput>

<cfscript >
	writedump(session.cfEvernote.getAuthToken());
	writedump(session.cfEvernote.getShard());
	writedump(session.cfEvernote.getUserID());
</cfscript>