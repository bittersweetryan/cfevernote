<cfcomponent extends="mxunit.framework.TestCase">
	<cfscript>
		variables.notebook = "";
	</cfscript>
	
	<cffunction name="setUp" returntype="void" access="public" output="false" hint="I setup the notebook test and create a new instance for each test" >
		<cfscript>
			variables.notebook = createObject("Component","com.714studios.cfevernote.Notebook").Init("#ExpandPath('../lib')#");			
		</cfscript>	
	</cffunction>
	
	<cffunction name="testNotebookCreatesANewNotebook"  returntype="void" access="public" output="false" hint="I test that the setup method actually creates a new instance of a notebook" >
		<cfscript>
			var expected = "com.714studios.cfevernote.Notebook";
			var actual = getMetaData(variables.noteBook).name;
			
			assertEquals(expected,actual);
		</cfscript>
	</cffunction>
	
	<cffunction name="testGetNotebookReturnsNotebookJavaClass"  returntype="void" access="public" output="false" hint="I test that the getnotebook method returns a java notebook object" >
		<cfscript>
			var expected = "com.evernote.edam.type.notebook";
			var actual = "";
			var notebook = variables.notebook.getNotebook();
			
			actual = notebook.getClass().getName();
			
			assertEquals(expected,actual);
		</cfscript>
	</cffunction>

	<cffunction name="testGetBlankNotebookGUIDReturnsEmptyString"  returntype="void" access="public" output="false" hint="I test getting a notebooks GUID" >
		<cfscript>
			var expected = "";
			var actual = variables.notebook.getGUID();
			
			assertEquals(expected,actual);
		</cfscript>
	</cffunction>
	
	<cffunction name="testSetNotebookGUIDSetsTheProperGUID"  returntype="void" access="public" output="false" hint="I test setting a notebooks GUID" >
		<cfscript>
			var expected = "123456";
			var actual = "";
			
			variables.notebook.setGUID("123456");
			actual = variables.notebook.getGUID();
			
			assertEquals(expected,actual);
		</cfscript>
	</cffunction>
	
	<cffunction name="testGetBlankNotebooksNameReturnsEmptyString"  returntype="void" access="public" output="false" hint="I test getting a notebooks name" >
		<cfscript>
			var expected = "";
			var actual = variables.notebook.getName();
			
			assertEquals(expected,actual);
		</cfscript>
	</cffunction>
	
	<cffunction name="testSetNameReturnsProperName"  returntype="void" access="public" output="false" hint="I test setting a notebooks name" >
		<cfscript>
			var expected = "testName";
			var actual = "";
			
			variables.notebook.setName("testName");
			actual = variables.notebook.getName();
			
			assertEquals(expected,actual);
		</cfscript>
	</cffunction>
	
	<cffunction name="testGetIsDefault"  returntype="void" access="public" output="false" hint="I test getting weather a notebook is default or not" >
		<cfscript>
			var expected = false;
			var actual = variables.notebook.isDefaultNotebook();
			
			assertEquals(expected,actual);
		</cfscript>
	</cffunction>
	
	<cffunction name="testSetDefault"  returntype="void" access="public" output="false" hint="I test setting the default notebook" >
		<cfscript>
			var expected = true;
			var actual = "";
			
			variables.notebook.setDefaultNotebook(true);
			
			actual = variables.notebook.isDefaultNotebook();
			
			assertEquals(expected,actual);
		</cfscript>
	</cffunction>
</cfcomponent>