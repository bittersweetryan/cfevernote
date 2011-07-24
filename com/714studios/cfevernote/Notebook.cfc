<!---
Copyright (c) 2011 Ryan S. Anklam (714 Studios, LLC)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
--->

<cfcomponent output="false" displayname="Notebook">
	<cfscript>
		variables.instance = {};
		
		instance.notebook = "";
		instance.libDirectory = "";
		instance.jarArray = "";
	</cfscript>
	
	<cffunction name="init" returntype="Notebook" access="public" output="false" hint="I am the constructor for the notbook component" >
		<cfargument name="libDirectory" type="string" required="false" default="#getDirectoryFromPath(getCurrentTemplatePath())#/lib">
		<cfargument name="notebook" type="any" required="false" default="" displayname="" />
		<cfscript>
			instance.libDirectory = arguments.libDirectory;
			
			instance.jarArray = ["#libDirectory#/CFEvernote.jar","#libDirectory#/evernote-api-1.18.jar","#libDirectory#/libthrift.jar"];
			//should these go into a metadata constant??
			setClassLoader(instance.jarArray);  

			//TODO: try to find a better way to test that the arguments.notebook is of the right type.  Right now its like this because mockito appends junk to the getname()
			if(arguments.notebook neq "" AND arguments.notebook.getClass().getName().indexOf("com.evernote.edam.type.Notebook") neq -1)
				variables.instance.notebook = notebook;
			else
				variables.instance.notebook = instance.classLoader.create("com.evernote.edam.type.Notebook").init();
			
			return this;
		</cfscript>
	</cffunction>
	
	<cffunction name="getNotebook" returntype="any" access="public" output="false" hint="I get this objects evernote notebook java object" >
		<cfscript>
			return instance.notebook;
		</cfscript>
	</cffunction>
	
	<cffunction name="setNotebook" returntype="void" access="public" output="false" hint="I set this objects evernote notebook java object" >
		<cfargument name="notebook" type="any" required="true" hint="notebook object" />
		<cfscript>
			instance.notebook = arguments.notebook;
		</cfscript>
	</cffunction>
	
	<cffunction name="getGUID" returntype="String" access="public" output="false" hint="I get this notebooks GUID" >
		<cfscript>
			var guid = instance.notebook.getGUID();
			
			if(isDefined("guid"))
				return guid;
			else
				return "";
		</cfscript>
	</cffunction>
	
	<cffunction name="setGUID" returntype="void" access="public" output="false" hint="I set this notebooks GUID" >
		<cfargument name="guid" type="String" required="false" default="" />
		<cfscript>
			instance.notebook.setGUID(arguments.guid);
		</cfscript>
	</cffunction>
	
	<cffunction name="getName" returntype="String" access="public" output="false" hint="I get this notebooks name" >
		<cfscript>
			var name = instance.notebook.getName();
			
			if(isDefined("name"))
				return name;
			else
				return "";
		</cfscript>
	</cffunction>
	
	<cffunction name="setName" returntype="void" access="public" output="false" hint="I set this notebooks name" >
		<cfargument name="notebookName" type="String" required="false" default="" />
		<cfscript>
			instance.notebook.setName(arguments.notebookName);
		</cfscript>
	</cffunction>
	
	<cffunction name="isDefaultNotebook" returntype="boolean" access="public" output="false" hint="I tell weather this notebook is default or not" >
		<cfscript>
			return instance.notebook.isDefaultNotebook();
		</cfscript>
	</cffunction>
	
	<cffunction name="setDefaultNotebook" returntype="void" access="public" output="false" hint="I set weather this is the default notebook or not" >
		<cfargument name="isDefaultNotebook" type="boolean" required="false" default="false" />
		<cfscript>
			instance.notebook.setDefaultNotebook(JavaCast("boolean",arguments.isDefaultNotebook));
		</cfscript>
	</cffunction>
	
	<cffunction name="reInitClassLoader" returntype="void" access="public" output="false" hint="I clear the classloader in the metadata" >
		<cfscript>
			var meta = getMetaData(this);
			
			if(structKeyExists(meta,"classLoader"))
				structDelete(meta,"classLoader");
				
			setClassLoader(instance.jarArray);
		</cfscript>
	</cffunction>
	
	<!----------------------------------- 
	*	       Private methods          *
	------------------------------------>
	<cffunction name="setClassLoader" returntype="void" access="private" output="false" hint="I put this objects classloader into the metadata its only created once" >
		<cfargument name="libs" type="array" required="true">
		<cfscript>
			var meta = getMetaData(this);
			
			//class loader doesn't exist yet
			if(!structKeyExists(meta,"classLoader"))
				meta.classLoader = createObject("component", "JavaLoader").init(arguments.libs);
				
			instance.classLoader =meta.classLoader;
		</cfscript>
	</cffunction>
</cfcomponent>