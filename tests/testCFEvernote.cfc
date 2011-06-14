<cfcomponent name="testCFEvernote.cfc" extends="mxunit.framework.TestCase">
	<cfscript>
		variables.cfEvernote = "";	
	</cfscript>
	
	<cffunction name="setup" access="public" output="false" returntype="void">
		<cfscript>
			variables.cfEvernote = new CFEvernote();
		</cfscript>		
	</cffunction>
</cfcomponent>