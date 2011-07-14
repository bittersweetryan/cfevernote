<cfcomponent output="false" displayname="Notebook">
	<cfscript>
		variables.instance = {};
		variables.instance.notebook = "";
	</cfscript>
	
	<cffunction name="init" returntype="Notebook" access="public" output="false" hint="I am the constructor for the notbook component" >
		<cfargument name="libDirectory" type="string" required="false" default="#getDirectoryFromPath(getCurrentTemplatePath())#/lib">
		<cfargument name="notebook" type="any" required="false" default="" displayname="" />
		<cfscript>
			instance.classLoader = createObject("component", "resources.JavaLoader").init(["#libDirectory#/CFEvernote.jar","#libDirectory#/evernote-api-1.18.jar","#libDirectory#/libthrift.jar"]);  
			
			if(arguments.notebook neq "" AND arguments.notebook.getClass().getName() eq "com.evernote.edam.type.notebook")
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
	
</cfcomponent>