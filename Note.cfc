<cfcomponent displayname="Note">
	<cfscript>
		variables.instance = {};
	</cfscript>
	
	<cffunction name="init" returntype="Note" access="public" output="false" hint="I construct the Note object" >
		<cfargument name="libDirectory" type="string" required="false" default="lib">
		<cfscript>
			instance.classLoader = createObject("component", "JavaLoader").init(["#getDirectoryFromPath(getCurrentTemplatePath())##libDirectory#/CFEvernote.jar","#getDirectoryFromPath(getCurrentTemplatePath())##libDirectory#/evernote-api-1.18.jar","#getDirectoryFromPath(getCurrentTemplatePath())##libDirectory#/libthrift.jar"]);  
	
			instance.note = instance.classLoader.create("com.evernote.edam.type.Note").init();
			
			return this;		
		</cfscript>	
	</cffunction>
	
	<cffunction name="getDateCreated" returntype="Date" access="public" output="false" hint="I get the date created of this notebook" >
		<cfscript>
			if(IsDate(instance.note.getCreated()))
				return DateFormat(instance.note.getCreated());
			else
				return "1/1/1900";
		</cfscript>
	</cffunction>
</cfcomponent>