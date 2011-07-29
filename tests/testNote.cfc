<cfcomponent extends="mxunit.framework.TestCase">
	<cfscript>
		variables.note = "";
	</cfscript>
	
	<cffunction name="setUp" returntype="void" access="public" output="false" hint="" >
		<cfscript>
			variables.note = createObject("component","com.714studios.cfevernote.Note").init("#ExpandPath('../lib')#");
		</cfscript>
	</cffunction>
	
	<cffunction name="testCreatingNoteObject"  returntype="void" access="public" output="false" hint="" >
		<cfscript>
			var expected = "com.714studios.cfevernote.Note";
			var actual = getMetaData(variables.note).name;
			
			assertEquals(expected,actual);
		</cfscript>
	</cffunction>
	
	<cffunction name="testGetGUIDForBlankNote"  returntype="void" access="public" output="false" hint="I test getting the guid" >
		<cfscript>
			var expected = ""; 
			var actual = variables.note.getGUID();
			
			assertEquals(expected,actual);
		</cfscript>
	</cffunction>
	
	<cffunction name="testSetGUIDForNote"  returntype="void" access="public" output="false" hint="I test setting the GUID" >
		<cfscript>
			var expected = "1e345ser";
			var actual = "";
			
			variables.note.setGUID(expected);
			
			actual = variables.note.getGUID();
			
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
	
	<cffunction name="testGetUpdated"  returntype="void" access="public" output="false" hint="I test getting the Updated date" >
		<cfscript>
			var expected = "1/1/1900";
			var actual = variables.note.getDateUpdated();
			
			assertEquals(expected,actual);
		</cfscript>
	</cffunction>
	
	<cffunction name="testSetUpdated"  returntype="void" access="public" output="false" hint="Test set date Updated" >
		<cfscript>
			var expected = "12/26/1990";
			var actual = "";
			
			variables.note.setDateUpdated(expected);
			
			actual = variables.note.getDateUpdated();
			
			assertEquals(expected,actual);
		</cfscript>
	</cffunction>
	
	<cffunction name="testSetContentWithBlankReturnsDefault"  returntype="void" access="public" output="false" hint="" >
		<cfscript>
			var expected = '<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd"><en-note></en-note>';
			var actual = variables.note.getContent();
			
			assertEquals(expected,actual);
		</cfscript>
	</cffunction>
	
	<cffunction name="testCreatedGetTickCount"  returntype="void" access="public" output="false" hint="I test the getting the tickcount for a note" >
		<cfscript>
			var expected = "1311768000000";
			var actual = "";
			
			variables.note.setDateCreated(createDateTime(2011,7,27,7,0,0));
			
			actual = variables.note.getCreatedTickCount();
			
			assertEquals(expected,actual);
		</cfscript>
	</cffunction>
	
	<cffunction name="testUpdatedGetTickCount"  returntype="void" access="public" output="false" hint="I test the getting the tickcount for a note" >
		<cfscript>
			var expected = "1311768000000";
			var actual = "";
			
			variables.note.setDateUpdated(createDateTime(2011,7,27,7,0,0));
			
			actual = variables.note.getUpdatedTickCount();
			
			assertEquals(expected,actual);
		</cfscript>
	</cffunction>
	
	<cffunction name="testSetContentWithStructuredNoteReturnsContent"  returntype="void" access="public" output="false" hint="" >
		<cfscript>
			var expected = '<?xml version="1.0" encoding="UTF-8"?>
							<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">
							<en-note>
							<b><font size="5">Here is a sample document:</font></b>
							<br/>
							Encrypted credit card number:
							<en-crypt cipher="RC2"
							length="64">qo37rLw+x4eNnoaoII/OUN4fasfyauHhdsnq/2/QiA0=</en-crypt>
							<br/>
							<u>Things to work on:</u>
							<en-todo checked="true"/> Write up ENML API documentation
							<br/>
							<en-todo/> Set up ENML API wiki
							<br/>
							Important audio clip:
							<en-media type="audio/wav" hash="5d328e22b2a8593f265b61d05c37f0c6"/>
							<br/>
							Whiteboard picture:
							<en-media width="671" height="503" type="image/jpeg"
							hash="47aa2ac0e29962f3699abe50f1afa996"/>
							<br/>
							</en-note>';
							
			variables.note.setContent(expected);
			
			var actual = variables.note.getContent();
			
			assertEquals(expected,actual);
		</cfscript>
	</cffunction>
	
	<cffunction name="testSetContentWithHTMLReturnsProperStructure"  returntype="void" access="public" output="false" hint="" >
		<cfscript>
			var expected = '<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd"><en-note>Hello World</en-note>';
							
			var actual = "";
			
			variables.note.setContent('<html><head></head><body>Hello World</body></html>');
			
			actual = variables.note.getContent();
			
			assertEquals(expected,actual);
		</cfscript>
	</cffunction>
	
	<cffunction name="testSetContentWithHTMLWithNoBodyReturnsValidENML"  returntype="void" access="public" output="false" hint="" >
		<cfscript>
			var expected = '<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd"><en-note><h1>Header</h1><b>Hello World</b></en-note>';
			var content = '<h1>Header</h1><b>Hello World</b>';
			var actual = "";
			
			variables.note.setContent(content);
			actual = variables.note.getContent(0);
			
			assertEquals(expected,actual);
		</cfscript>
	</cffunction>
	
	<cffunction name="testValidateWithValidMarkupDoesntThrowError"  returntype="void" access="public" output="false" hint="Testing a private method to make sure it works as planned" >
		<cfscript>
			var validENML = '<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd"><en-note><b>Hello World</b></en-note>';
			
			makePublic(variables.note,"validate");
		</cfscript>
	</cffunction>
	
	<cffunction name="testGetNotebookGUIDForBlankNotebook"  returntype="void" access="public" output="false" hint="" >
		<cfscript>
			var expected = "";
			var actual = variables.note.getNotebookGUID();
			
			assertEquals(expected,actual);
		</cfscript>
	</cffunction>
	
	<cffunction name="testSetNotebookGUID"  returntype="void" access="public" output="false" hint="I test the notebok guid" >
		<cfscript>
			var expected = "12fd345e";
			var actual = "";
			
			variables.note.setNotebookGUID(expected);
			
			actual = variables.note.getNotebookGUID();
			
			assertEquals(expected,actual);
		</cfscript>
	</cffunction>
	
	<cffunction name="testGetTagNamesForBlankNote"  returntype="void" access="public" output="false" hint="I test getting tags" >
		<cfscript>
			var expected = arrayNew(1);
			var actual = variables.note.getTagNames();
			
			assertEquals(expected,actual);
		</cfscript>
	</cffunction>
	
	<cffunction name="testSetTagNamess"  returntype="void" access="public" output="false" hint="I test setting the tag names" >
		<cfscript>
			var expected = ["Apple","Banana","Pear","Pineapple"];
			var actual = "";
			
			variables.note.setTagNames(expected);
			actual = variables.note.getTagNames();
			
			assertEquals(expected,actual);
		</cfscript>
	</cffunction>
	
	<cffunction name="testAddSingleTagName"  returntype="void" access="public" output="false" hint="I test setting a single tag name" >
		<cfscript>
			var expected = ["Apple"];
			var actual = "";
			
			variables.note.addTag("Apple");
			
			actual = variables.note.getTagNames();
			
			assertEquals(expected,actual);
		</cfscript>
	</cffunction>
	
	<cffunction name="testGetNote"  returntype="void" access="public" output="false" hint="I test getting a note object from cfevernote" >
		<cfscript>
			var expected = "com.evernote.edam.type.Note";
			var actual = variables.note.getNote().getClass().getName();
			
			assertEquals(expected,actual);
		</cfscript>
	</cffunction>
	
	<cffunction name="testSetNote"  returntype="void" access="public" output="false" hint="I test setting a note ojbect form cfevenote" >
		<cfscript>
			var mock = mock(createObject("component","com.714studios.cfevernote.Note"));
			var expected = mock;
			var actual = "";
			
			variables.note.setNote(mock);
			
			actual = variables.note.getNote();

			assertSame(expected,actual);
		</cfscript>
	</cffunction>
	
	<cffunction name="testSetTitleSetsTitle"  returntype="void" access="public" output="false" hint="I test setting a notes title" >
		<cfscript>
			var expected = "Hello, Title.";
			var actual = "";
			
			variables.note.setTitle("Hello, Title.");
			actual = variables.note.getTitle();
			
			assertEquals(expected,actual);
		</cfscript>
	</cffunction>
</cfcomponent>