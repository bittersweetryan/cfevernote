<cfcomponent name="testCFEvernote.cfc" extends="mxunit.framework.TestCase">
	<cfscript>
		variables.cfEvernote = "";	
		
		variables.classLoader = createObject("component", "JavaLoader").init(["#expandPath('../lib/mockito-all-1.8.5.jar')#","#expandPath('../lib/CFEvernote.jar')#","#expandPath('../lib/libthrift.jar')#","#expandPath('../lib/evernote-api-1.18.jar')#"]);  
		variables.mockito = variables.classLoader.create("org.mockito.Mockito").init();
		variables.libDir = ExpandPath('../lib');
		
		//java mock objects
		variables.mockCFEvernote = variables.mockito.mock(variables.classLoader.create("com.sudios714.cfevernote.CFEvernote").init("123","S1","232","sandbox.evernote.com","mock").getClass());		
		variables.mockNote = variables.mockito.mock(variables.classLoader.create("com.evernote.edam.type.Note").init().getClass());		
		variables.mockNotebook = variables.mockito.mock(variables.classLoader.create("com.evernote.edam.type.Notebook").init().getClass());
	</cfscript>
	
	<cffile action="read" file="#expandPath('/example')#/config.txt" variable="variables.filecontents" />
	
	<cfset variables.configArray = listToArray(variables.filecontents)/>

	<cffunction name="setUp" access="public" output="false" returntype="void">
		<cfscript>
			variables.cfEvernote = createObject("component","com.714studios.cfevernote.CFEvernote").Init(variables.configArray[1],variables.configArray[2],"sandbox.evernote.com","http://localhost/cfevernote/callback.cfm","#variables.libDir#");
			
			variables.cfEvernote.setCFEvernote(mockCFEvernote);
		</cfscript>		
	</cffunction>
	
	<cffunction name="testSettingAPIKeyReturnsCorrectAPIKey" returntype="void" access="public" output="false">
		<cfscript>
			var expected = "ABC123";
			var actual = "";
			
			variables.cfEvernote.setAPIKey("ABC123");
			actual = variables.cfEvernote.getAPIKey();
			
			assertEquals(expected,actual);
		</cfscript>
	</cffunction>
	
	<cffunction name="testSettingAPIAccountReturnsCorrectAPIAccount" returntype="void" access="public" output="false">
		<cfscript>
			var expected = "bittersweetryan";
			var actual = "";
			
			variables.cfEvernote.setAPIAccount("bittersweetryan");
			actual = variables.cfEvernote.getAPIAccount();
			
			assertEquals(expected,actual);
		</cfscript>
	</cffunction>
	
	<cffunction name="testGetOAuthURL" returntype="void" access="public" output="false" hint="test oauthurl" >
		<cfscript>
			var expected = "https://sandbox.evernote.com/oauth";
			var actual = variables.cfEvernote.getEvernoteOAuthURL();
			
			assertEquals(expected,actual);
		</cfscript>
	</cffunction>
	
	<cffunction name="testAuthenticateAPIUser" returntype="void" access="public" output="false" hint="test authentication" >
		<cfscript>
			var response = variables.cfEvernote.authenticateAPIUser(variables.configArray[1],variables.configArray[2]);
			
			if(!response)
				fail("Auth returned false!");
			else if(variables.cfEvernote.getTemporaryAuthToken() eq "")
				fail("Auth returned empty temporary Token");
			else
				writedump(var=response,output="console");
		</cfscript>
	</cffunction>
	
	<cffunction name="testParseTemporaryOAuthResponseReturnsToken" returntype="void" access="public" output="false" hint="test oauth response" >
		<cfscript>
			var expected="testuser.130B763E6C0.687474703A2F2F6C6F63616C686F73742F6366657665726E6F74652F63616C6C6261636B2E63666D.BD5F4D71952B75C68799427C59754E72";
			var actual = "";
			
			makePublic(variables.cfEvernote,"parseOauthTokenResponse");
			
			
			actual=variables.cfEvernote.parseOauthTokenResponse("oauth_token=testuser.130B763E6C0.687474703A2F2F6C6F63616C686F73742F6366657665726E6F74652F63616C6C6261636B2E63666D.BD5F4D71952B75C68799427C59754E72&oauth_token_secret=&oauth_callback_confirmed=true");
			
			assertEquals(expected,actual);
		</cfscript>		
	</cffunction>	
	
	<cffunction name="testParseCreentialOAuthResponseReturnsToken" returntype="void" access="public" output="false" hint="test oauth response" >
		<cfscript>
			var expected="S%3Ds1%3AU%3Dddec%3AE%3D130eaf46a27%3AC%3D130e5ce0e2b%3AP%3D7%3AA%3Dbittersweetryan%3AH%3D37086d55175a538e34cb194af4c7ee27";
			var actual = "";
			
			makePublic(variables.cfEvernote,"parseOauthTokenResponse");
			
			
			actual=variables.cfEvernote.parseOauthTokenResponse("oauth_token=S%3Ds1%3AU%3Dddec%3AE%3D130eaf46a27%3AC%3D130e5ce0e2b%3AP%3D7%3AA%3Dbittersweetryan%3AH%3D37086d55175a538e34cb194af4c7ee27&oauth_token_secret=&edam_shard=s1&edam_userId=56812");
			
			assertEquals(expected,actual);
		</cfscript>		
	</cffunction>	
	
	<cffunction name="testParseOAuthResponseReturnsEmptyStringWhenNotInResponse" returntype="void" access="public" output="false" hint="test oauth response" >
		<cfscript>
			var expected="";
			var actual = "";
			
			makePublic(variables.cfEvernote,"parseOauthTokenResponse");
			
			
			actual=variables.cfEvernote.parseOauthTokenResponse("oauth_token_secret=&oauth_callback_confirmed=true");
			
			assertEquals(expected,actual);
		</cfscript>		
	</cffunction>	
	
	<cffunction name="testParseOAuthResponseReturnsEmptyStringWhenNothingIsPassedIn" returntype="void" access="public" output="false" hint="test oauth response" >
		<cfscript>
			var expected="";
			var actual = "";
			
			makePublic(variables.cfEvernote,"parseOauthTokenResponse");
			
			
			actual=variables.cfEvernote.parseOauthTokenResponse("");
			
			assertEquals(expected,actual);
		</cfscript>		
	</cffunction>
		
	<cffunction name="testParseShardResponseReturnsToken" returntype="void" access="public" output="false" hint="test oauth response" >
		<cfscript>
			var response = "oauth_token=S%3Ds4%3AU%3Da1%3AE%3D12bfd68c6b6%3AC%3D12bf8426ab8%3AP%3D7%3AA%3Den_oauth_test%3AH%3D3df9cf6c0d7bc410824c80231e64dbe1&oauth_token_secret=&edam_shard=s4&edam_userId=161";
			var expected="s4";
			var actual = "";
			
			makePublic(variables.cfEvernote,"parseOauthShardResponse");

			actual=variables.cfEvernote.parseOauthShardResponse(response);
			
			assertEquals(expected,actual);
		</cfscript>		
	</cffunction>	
	
	<cffunction name="testParseShardResponseReturnsEmptyStringWhenResponseDoesntHaveShard" returntype="void" access="public" output="false" hint="test oauth response" >
		<cfscript>
			var response = "oauth_token=S%3Ds4%3AU%3Da1%3AE%3D12bfd68c6b6%3AC%3D12bf8426ab8%3AP%3D7%3AA%3Den_oauth_test%3AH%3D3df9cf6c0d7bc410824c80231e64dbe1&oauth_token_secret=&edam_userId=161";
			var expected="";
			var actual = "";
			
			makePublic(variables.cfEvernote,"parseOauthShardResponse");

			actual=variables.cfEvernote.parseOauthShardResponse(response);
			
			assertEquals(expected,actual);
		</cfscript>		
	</cffunction>	
	
	
	<cffunction name="testParseUserIDResponseReturnsCorrectID" returntype="void" access="public" output="false" hint="test oauth response" >
		<cfscript>
			var response = "oauth_token=S%3Ds4%3AU%3Da1%3AE%3D12bfd68c6b6%3AC%3D12bf8426ab8%3AP%3D7%3AA%3Den_oauth_test%3AH%3D3df9cf6c0d7bc410824c80231e64dbe1&oauth_token_secret=&edam_shard=s4&edam_userId=161";
			var expected="161";
			var actual = "";
			
			makePublic(variables.cfEvernote,"parseOauthUserIDResponse");

			actual=variables.cfEvernote.parseOauthUserIDResponse(response);
			
			assertEquals(expected,actual);
		</cfscript>		
	</cffunction>	
	
	<cffunction name="testParseUserIDResponseReturnsEmptyStringIfNotInResponse" returntype="void" access="public" output="false" hint="test oauth response" >
		<cfscript>
			var response = "oauth_token=S%3Ds4%3AU%3Da1%3AE%3D12bfd68c6b6%3AC%3D12bf8426ab8%3AP%3D7%3AA%3Den_oauth_test%3AH%3D3df9cf6c0d7bc410824c80231e64dbe1&oauth_token_secret=&edam_shard=s4&";
			var expected="";
			var actual = "";
			
			makePublic(variables.cfEvernote,"parseOauthUserIDResponse");

			actual=variables.cfEvernote.parseOauthUserIDResponse(response);
			
			assertEquals(expected,actual);
		</cfscript>		
	</cffunction>	
	<cffunction name="testSetGetAuthToken" returntype="void" access="public" output="false" hint="" >
		<cfscript>
			var expected = "abc123";
			
			variables.cfEvernote.setAuthToken("abc123");
			
			var actual = variables.cfEvernote.getAuthToken();
			
			assertEquals(expected,actual);
		</cfscript>
	</cffunction>
	
	<cffunction name="testGetNotebooksWithNoParamReturnsArrayOf100"  returntype="void" access="public" output="false" hint="I test that the get notebooks method returns an array of notebooks" >
		<cfscript>
			var notebooks = ""; 
			var expected = 100;
			var i = 0;
			var retArray = createObject("Java","java.util.ArrayList");
			var actual = "";
			var tempNote = "";
			
			for(i = 1; i lte 100; i = i + 1){
				tempNote = duplicate(variables.mockNote);
				retArray.Add(tempNote);
			}
			
			variables.mockito.when(mockCFEvernote.listNotebooks()).thenReturn(retArray);
			
			notebooks = variables.cfEvernote.getNotebooks(); 
			
			actual = arrayLen(notebooks);
			
			assertEquals(expected,actual);
		</cfscript>
	</cffunction>

	<cffunction name="testGetNotebooksWithMaxNotesReturnsArrayOfThatSize"  returntype="void" access="public" output="false" hint="I test that the get notebooks method returns an array of notebooks" >
		<cfscript>
			var notebooks = ""; 
			var expected = 12;
			var i = 0;
			var retArray = createObject("Java","java.util.ArrayList");
			var actual = "";
			var tempNote = "";
			
			for(i = 1; i lte 12; i = i + 1){
				tempNote = duplicate(variables.mockNote);
					
				retArray.add(tempNote);		
			}
		
			writedump(var=retArray,output="console");
			
			variables.mockito.when(mockCFEvernote.listNotebooks(12)).thenReturn(retArray);
			
			notebooks = variables.cfEvernote.getNotebooks(12); 
			
			actual = arrayLen(notebooks);
			
			assertEquals(expected,actual);
		</cfscript>
	</cffunction>
	
	<cffunction name="testGetNotebookReturnsProperNotebook"  returntype="void" access="public" output="false" hint="I make sure that getting a notebook via guid returns the proper notebook" >
		<cfscript>
			var expected = variables.mockNotebook;
			var notebook = "";	
			var actual = "";
			
			variables.mockito.when(variables.mockNotebook.getGUID()).thenReturn("aac89a28-c080-4bde-92f6-9eaa8c27ee49");
			variables.mockito.when(variables.mockCFEvernote.getNotebook("aac89a28-c080-4bde-92f6-9eaa8c27ee49")).thenReturn(variables.mockNotebook);
		
			actual = variables.cfEvernote.getNotebook("aac89a28-c080-4bde-92f6-9eaa8c27ee49").getNotebook();
	
			assertEquals(expected,actual);
		</cfscript>
	</cffunction>
	
	<cffunction name="testGetNotesForNotebookReturnsNotes"  returntype="void" access="public" output="false" hint="I test getting notes for a notebook returns a list of notes for that notebook" >
		<cfscript>
			fail("method not written");
		</cfscript>
	</cffunction>
	
	<cffunction name="testGetNotesWithNoParamReturnsArrayOf100"  returntype="void" access="public" output="false" hint="I test that the get notebooks method returns an array of notebooks" >
		<cfscript>
			var notes = ""; 
			var expected = 100;
			var i = 0;
			var retArray = createObject("Java","java.util.ArrayList");
			var actual = "";
			
			for(i = 1; i lte 100; i = i + 1){
				retArray.Add("#i#");
			}
			
			variables.mockito.when(variables.mockCFEvernote.listNotes()).thenReturn(retArray);
			
			variables.cfEvernote.setCFEvernote(mockCFEvernote);
			
			notes = variables.cfEvernote.getNotes(); 	
			
			actual = arrayLen(notes);
			
			assertEquals(expected,actual);
		</cfscript>
	</cffunction>
	
	<cffunction name="testGetNotesWithMaxNotesReturnsArrayOfThatSize"  returntype="void" access="public" output="false" hint="I test that the get notebooks method returns an array of notebooks" >
		<cfscript>
			var notes = ""; 
			var expected = 15;
			var i = 0;
			var retArray = createObject("Java","java.util.ArrayList");
			var actual = "";
			
			for(i = 1; i lte 15; i = i + 1){
				retArray.Add("");
			}
			
			variables.mockito.when(mockCFEvernote.listNotes(15)).thenReturn(retArray);
			
			notes = variables.cfEvernote.getNotes(15); 
			actual = arrayLen(notes);
			
			assertEquals(expected,actual);
		</cfscript>
	</cffunction>
	
	<cffunction name="testCreateNoteShouldReturnANoteObject"  returntype="void" access="public" output="false" hint="I test creating a note" >
		<cfscript>
			var expected = "";
			var actual = "";
			//mock java note object, gets returned by cfevernote java object when a new note is created
			var mockNote = variables.mockito.mock(variables.classLoader.create("com.evernote.edam.type.Note").getClass());
			var content = "Test Note";
			//mock coldfusion note, gets returned by cfevernote coldfusion object when a note is created
			var note = mock(createObject("component","com.714studios.cfevernote.Note"));
						
			mockito.when(mockCFEvernote.createNote(mockNote)).thenReturn(mockNote);
			
			note.getNote().returns(mockNote);
			
			expected = note;
			
			actual = variables.cfEvernote.addNote(note);
			
			assertSame(expected,actual);
		</cfscript>
	</cffunction>
	
	<cffunction name="testCreateNoteShouldReturnTheProperContent"  returntype="void" access="public" output="false" hint="I test creating a note returns the correct content" >
		<cfscript>
			fail("test not yet written");
		</cfscript>
	</cffunction>
</cfcomponent>