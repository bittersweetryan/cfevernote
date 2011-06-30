<cfcomponent name="testCFEvernote.cfc" extends="mxunit.framework.TestCase">
	<cfscript>
		variables.cfEvernote = "";	
	</cfscript>
	
	<cffile action="read" file="#expandPath('/')#config.txt" variable="variables.filecontents" />
	<cfset variables.configArray = listToArray(variables.filecontents)/>

	<cffunction name="setUp" access="public" output="false" returntype="void">
		<cfscript>
			variables.cfEvernote = createObject("component","CFEvernote").Init(variables.configArray[1],variables.configArray[2],"sandbox.evernote.com","http://localhost/cfevernote/callback.cfm");
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
	
	<cffunction name="testGetUserStoreURL" returntype="void" access="public" output="false">
		<cfscript>
			var expected = "https://sandbox.evernote.com/edam/user";
			var actual = variables.cfEvernote.getUserStoreURL();
			
			assertEquals(expected,actual);
		</cfscript>
	</cffunction>
	<cffunction name="testGetUserStoreURLBase" returntype="void" access="public" output="false">
		<cfscript>
			var expected = "https://sandbox.evernote.com/edam/note/";
			var actual = variables.cfEvernote.getUserStoreURLBase();
			
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
	
	<cffunction name="testAuthenticate" returntype="void" access="public" output="false" hint="test authentication" >
		<cfscript>
			var response = variables.cfEvernote.Authenticate(variables.configArray[1],variables.configArray[2]);
			
			if(!response)
				fail("Auth returned false!");
			else if(variables.cfEvernote.getTemporaryAuthToken() eq "")
				fail("Auth returned empty temporary Token");
			else
				writedump(var=response,output="console");
		</cfscript>
	</cffunction>
	
	<cffunction name="testParseOAuthResponseReturnsToken" returntype="void" access="public" output="false" hint="test oauth response" >
		<cfscript>
			var expected="testuser.130B763E6C0.687474703A2F2F6C6F63616C686F73742F6366657665726E6F74652F63616C6C6261636B2E63666D.BD5F4D71952B75C68799427C59754E72";
			var actual = "";
			
			makePublic(variables.cfEvernote,"parseOauthTempTokenResponse");
			
			
			actual=variables.cfEvernote.parseOauthTempTokenResponse("oauth_token=testuser.130B763E6C0.687474703A2F2F6C6F63616C686F73742F6366657665726E6F74652F63616C6C6261636B2E63666D.BD5F4D71952B75C68799427C59754E72&oauth_token_secret=&oauth_callback_confirmed=true");
			
			assertEquals(expected,actual);
		</cfscript>		
	</cffunction>	
	
	<cffunction name="testParseOAuthResponseReturnsEmptyStringWhenNotInResponse" returntype="void" access="public" output="false" hint="test oauth response" >
		<cfscript>
			var expected="";
			var actual = "";
			
			makePublic(variables.cfEvernote,"parseOauthTempTokenResponse");
			
			
			actual=variables.cfEvernote.parseOauthTempTokenResponse("oauth_token_secret=&oauth_callback_confirmed=true");
			
			assertEquals(expected,actual);
		</cfscript>		
	</cffunction>	
	
	<cffunction name="testParseOAuthResponseReturnsEmptyStringWhenNothingIsPassedIn" returntype="void" access="public" output="false" hint="test oauth response" >
		<cfscript>
			var expected="";
			var actual = "";
			
			makePublic(variables.cfEvernote,"parseOauthTempTokenResponse");
			
			
			actual=variables.cfEvernote.parseOauthTempTokenResponse("");
			
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
	
	<cffunction name="testGetOAuthCredentials"  returntype="void" access="public" output="false" hint="" >
		<cfscript>
			fail("no test written yet");
			/*
			var expected = "";
			var actual = "";
			
			assertEquals(expected,actual);
			*/
		</cfscript>
	</cffunction>
</cfcomponent>