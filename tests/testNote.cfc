<cfcomponent extends="mxunit.framework.TestCase">
	<cfscript>
		variables.note = "";
	</cfscript>
	
	<cffunction name="setUp" returntype="void" access="public" output="false" hint="" >
		<cfscript>
			variables.note = createObject("component","Note").init();
		</cfscript>
	</cffunction>
	
	<cffunction name="testCreatingNote"  returntype="void" access="public" output="false" hint="" >
		<cfscript>
			var expected = "Note";
			var actual = getMetaData(variables.note).name;
			
			assertEquals(expected,actual);
		</cfscript>
	</cffunction>
	
	<cffunction name="testGetCreated"  returntype="void" access="public" output="false" hint="I test getting the created date" >
		<cfscript>
			var expected = "1/1/1900";
			var actual = variables.note.getDateCreated();
			
			assertEquals(expected,actual);
		</cfscript>
	</cffunction>
	
	<cffunction name="testSetCreated"  returntype="void" access="public" output="false" hint="Test set date created" >
		<cfscript>
			var expected = "12/26/1990";
			var actual = "";
			
			variables.note.setDateCreated(expected);
			
			actual = variables.note.getDateCreated();
			
			assertEquals(expected,actual);
		</cfscript>
	</cffunction>
</cfcomponent>