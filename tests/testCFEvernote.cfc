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
			expected = "ABC123";
			
			variables.cfEvernote.setAPIKey("ABC123");
			actual = variables.cfEvernote.getAPIKey();
			
			assertEquals(expected,actual);
		</cfscript>
	</cffunction>
	
	<cffunction name="testSettingAPIAccountReturnsCorrectAPIAccount" returntype="void" access="public" output="false">
		<cfscript>
			expected = "bittersweetryan";
			
			variables.cfEvernote.setAPIAccount("bittersweetryan");
			actual = variables.cfEvernote.getAPIAccount();
			
			assertEquals(expected,actual);
		</cfscript>
	</cffunction>
	
	<cffunction name="testGetUserStoreURL" returntype="void" access="public" output="false">
		<cfscript>
			expected = "https://sandbox.evernote.com/edam/user";
			
			actual = variables.cfEvernote.getUserStoreURL();
			
			assertEquals(expected,actual);
		</cfscript>
	</cffunction>
	
	<cffunction name="testGetUserStoreURLBase" returntype="void" access="public" output="false">
		<cfscript>
			expected = "https://sandbox.evernote.com/edam/note/";
			
			actual = variables.cfEvernote.getUserStoreURLBase();
			
			assertEquals(expected,actual);
		</cfscript>
	</cffunction>
	
	<cffunction name="testGetOAuthURL" returntype="void" access="public" output="false" hint="test oauthurl" >
		<cfscript>
			expected = "https://sandbox.evernote.com/oauth";
			
			actual = variables.cfEvernote.getEvernoteOAuthURL();
			
			assertEquals(expected,actual);
		</cfscript>
	</cffunction>
	
	<cffunction name="testAuthenticate" returntype="void" access="public" output="false" hint="test authentication" >
		<cfscript>
			variables.cfEvernote.Authenticate(variables.configArray[1],variables.configArray[2]);
		</cfscript>
	</cffunction>
		
</cfcomponent>