<cfcomponent extends="mxunit.framework.TestCase">
	<cfscript>
		variables.note = "";
	</cfscript>
	
	<cffunction name="setUp" returntype="void" access="public" output="false" hint="" >
		<cfscript>
			variables.note = createObject("component","Note").init();
		</cfscript>
	</cffunction>
	
	<cffunction name="testTestCreatingNote"  returntype="void" access="public" output="false" hint="" >
		<cfscript>
			var expected = "Note";
			var actual = getMetaData(variables.note).name;
			
			assertEquals(expected,actual);
		</cfscript>
	</cffunction>
	
</cfcomponent>