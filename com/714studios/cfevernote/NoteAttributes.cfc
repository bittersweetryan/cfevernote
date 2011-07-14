<cfcomponent output="false" displayname="NoteAttributes">
	<cfscript>
		variables.instance = {};
	</cfscript>
	
	<cffunction name="init" returntype="NoteAttributes" access="public" output="false" hint="I construct the Note object" >
		<cfargument name="libDirectory" type="string" required="false" default="#getDirectoryFromPath(getCurrentTemplatePath())#/lib">
		<cfargument name="noteAttribute" type="any" required="false" default="" />
		<cfscript>
			instance.classLoader = createObject("component", "resources.JavaLoader").init(["#libDirectory#/CFEvernote.jar","#libDirectory#/evernote-api-1.18.jar","#libDirectory#/libthrift.jar"]);  
	
			if(arguments.noteAttribute neq "" AND arguments.noteAttribute.getClass().getName() eq "com.evernote.edam.type.NoteAttributes")
				instance.noteAttribute = arguments.noteAttribute;
			else
				instance.noteAttribute = instance.classLoader.create("com.evernote.edam.type.NoteAttributes").init();	
				
			return this;		
		</cfscript>	
	</cffunction>
</cfcomponent>