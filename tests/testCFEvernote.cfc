<cfcomponent name="testCFEvernote.cfc" extends="mxunit.framework.TestCase">
	<cfscript>
		variables.cfEvernote = "";	
	</cfscript>
	
	<cffile action="read" file="#expandPath('/')#config.txt" variable="filecontents" />
	<cfset configArray = listToArray(filecontents)/>

	<cffunction name="setup" access="public" output="false" returntype="void">
		<cfscript>
			variables.cfEvernote = new CFEvernote().Init("CDA321","bittersweetdev","sandbox.evernote.com");
		</cfscript>		
	</cffunction>
	
	<cffunction name="testInitSettingKeyandAccountReturnsExpectedResult" returntype="void" access="public" output="false" >
		<cfscript>
			expected = "CDA321";
			actual = variables.cfEvernote.getApiKey();
			
			assertEquals(expected, actual);
			
			expected = "bittersweetdev";
			actual = variables.cfEvernote.getApiAccount();
					
			assertEquals(expected,actual);
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
	
	<cffunction name="testAuthenticate" returntype="void" access="public" output="false" hint="test authentication" >
		<cfscript>
			//not sure about the composition of this function, creating the tsclient in the function doesn't make it
			//very testable
			
			variables.cfEvernote.Authenticate(variables.configArray[1],variables.configArray[2]);
		</cfscript>
	</cffunction>
		
</cfcomponent>