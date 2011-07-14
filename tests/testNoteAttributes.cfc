<cfcomponent extends="mxunit.framework.TestCase">
	<cfscript>
		variables.noteAttributes = "";
	</cfscript>
	
	<cffunction name="setUp" returntype="void" access="public" output="false" hint="I setup this " >
		<cfscript>
			variables.noteAttributes = createObject("component","com.714studios.cfevernote.NoteAttributes").init("#ExpandPath('../lib')#");
		</cfscript>	
	</cffunction>	
	
	<cffunction name="testNoteAttributeIsCreatedProperly"  returntype="void" access="public" output="false" hint="" >
		<cfscript>
			var expected = "com.714studios.cfevernote.NoteAttributes";
			var actual = getMetaData(variables.noteAttributes).name;
			
			assertEquals(expected,actual);
		</cfscript>
	</cffunction>
</cfcomponent>