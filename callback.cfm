	<cffile action="read" file="#expandPath('/')#config.txt" variable="variables.filecontents" />
	<cfset configArray = listToArray(variables.filecontents)/>
	
<cfscript>
	cfEvernote = new CFEvernote(configArray[1],configArray[2],"sandbox.evernote.com","http://localhost/cfevernote/callback.cfm");
	
	cfEvernote.authenticate();
</cfscript>

<cfoutput>
		<a href="#cfEvernote.getEvernoteOAuthVerifyURL()">Auth</a>
</cfoutput>