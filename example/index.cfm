	<cffile action="read" file="#expandPath('/')#example/config.txt" variable="variables.filecontents" />
	<cfset configArray = listToArray(variables.filecontents)/>
<cfscript>
	//its best to persist this object somewhere since the oauth process will require saving state
	
	if(NOT structKeyExists(session,"cfEvernote") OR isDefined("url.reset")){
		
		session.cfEvernote = new com.714studios.cfevernote.CFEvernote(configArray[1],configArray[2],"sandbox.evernote.com","http://localhost/cfevernote/example/index.cfm","#ExpandPath('../')#/lib");
		
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
	
	if(isDefined("url.method")){
		method = url.method;
		
		switch(method){
			case "createNote":
			{
				//to create a note first create a note object
				note = createObject("component","com.714.cfevernote.note");
				//then set its content
				note.setContent(form.content);
				//lastly add the note to evernote using the cfevernote
				session.cfEvernote.createNote(note);
				break;
			}
		}
	}
</cfscript>

<html>
<head>
	<title>CFEvernote Example</title>
	<link rel="stylesheet" type="text/css" href="jquery.cleditor.css" />
	<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.6.1/jquery.min.js" type="text/javascript"></script>
	<script src="jquery.cleditor.min.js" type="text/javascript"></script>
	<script language="javascript">
		 $(document).ready(function() {
       		 $("#content").cleditor();
    	 });
	</script>
</head>
<body>
<cfoutput>
	<div id="evernoteInfo">
		<cfif Len(session.cfEvernote.getAuthToken())>
			<h2>Evernote Information</h2>
			<ul id="evernoteInfo">
				<li>Token: #session.cfEvernote.getAuthToken()#</li>
				<li>User ID: #session.cfEvernote.getUserID()#</li>
			</ul>
		<cfelse>
			<h2>You have note yet authenticated with evernote.</h2>
			<a href="#session.cfEvernote.getEvernoteOAuthVerifyURL()#">Click here to authorize</a>
		</cfif>
	</div>
	
	<div id="actions">
		<h2>Evernote Actions</h2>
		<ul>
			<li>
				<a href="index.cfm?reset=true">Reset Evernote credentials</a>
			<li>
				<a href="index.cfm?method=getNotebooks">Get Notebooks</a>
			</li>
			<li>
				<a href="index.cfm?method=getNotes">Get Notes</a>
			</li>
		</ul>
	</div>
	
	<div id="createNote">
		<h2>Create Note</h2>
		<form action="index.cfm" method="post">
			<textarea name="content" id="content" rows="4" cols="30"></textarea>
			<input type="hidden" name="method" value="createNote" id="method">
			<input type="submit" value="create note" />
		</form>
	</div>
	
	<cfif isDefined("url.method") AND url.method eq "getNotebooks">
		<cfset notebooks = session.cfEvernote.getNotebooks() />
		<cfdump var="#getMetaData(notebooks[1])#" />
		<cfdump var="#session.cfEvernote.getNotebooks()#">
	<cfelseif isDefined("url.method") AND url.method eq "getNotes">
		<cfdump var="#session.cfEvernote.getNotes()#">
	</cfif>
</cfoutput>
</body>
</html>