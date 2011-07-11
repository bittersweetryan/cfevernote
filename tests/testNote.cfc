<cfcomponent extends="mxunit.framework.TestCase">
	<cfscript>
		variables.note = "";
	</cfscript>
	
	<cffunction name="setUp" returntype="void" access="public" output="false" hint="" >
		<cfscript>
			variables.note = createObject("component","com.714studios.cfevernote.Note").init("#ExpandPath('../lib')#");
		</cfscript>
	</cffunction>
	
	<cffunction name="testCreatingNote"  returntype="void" access="public" output="false" hint="" >
		<cfscript>
			var expected = "com.714studios.cfevernote.Note";
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
	
	<cffunction name="testSetContentWithBlankReturnsDefault"  returntype="void" access="public" output="false" hint="" >
		<cfscript>
			var expected = '<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd"><en-note></en-note>';
			var actual = variables.note.getContent();
			
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
	
	<cffunction name="testValidateWithValidMarkupReturnsTrue"  returntype="void" access="public" output="false" hint="Testing a private method to make sure it works as planned" >
		<cfscript>
			var validENML = '<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd"><en-note><b>Hello World</b></en-note>';
			
			makePublic(variables.note,"validate");
			
			assertTrue(variables.note.validate(validENML));
		</cfscript>
	</cffunction>
	
	<cffunction name="testSetContentWithENMLReturnsValidENML"  returntype="void" access="public" output="false" hint="" >
		<cfscript>
			fail("Method not written yet");
		</cfscript>
	</cffunction>
	
	<cffunction name="testSetContentWithHTMLWithNoBodyReturnsValidENML"  returntype="void" access="public" output="false" hint="" >
		<cfscript>
			fail("Method not written yet");
		</cfscript>
	</cffunction>
</cfcomponent>