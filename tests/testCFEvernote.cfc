<cfcomponent name="testCFEvernote.cfc" extends="mxunit.framework.TestCase">
	<cfscript>
		variables.cfEvernote = "";	
	</cfscript>
	
	<cffunction name="setup" access="public" output="false" returntype="void">
		<cfscript>
			variables.cfEvernote = new CFEvernote();
		</cfscript>		
	</cffunction>
	d
	<cffunction name="testInitSettingKeyandAccountReturnsExpectedResult" returntype="void" access="public" output="false" >
		<cfscript>
			variables.cfEvernote.Init("CDA321","bittersweetdev");
			
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
</cfcomponent>