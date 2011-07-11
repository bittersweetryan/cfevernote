<cfcomponent displayname="Note">
	<cfscript>
		variables.instance = {};
	</cfscript>
	
	<cffunction name="init" returntype="Note" access="public" output="false" hint="I construct the Note object" >
		<cfargument name="libDirectory" type="string" required="false" default="#getDirectoryFromPath(getCurrentTemplatePath())#/lib">
		<cfargument name="note" type="any" required="false" default="" />
		<cfscript>
			instance.classLoader = createObject("component", "JavaLoader").init(["#libDirectory#/CFEvernote.jar","#libDirectory#/evernote-api-1.18.jar","#libDirectory#/libthrift.jar"]);  
	
			if(arguments.note neq "" AND arguments.note.getClass().getName() eq "com.evernote.edam.type.note")
				instance.note = arguments.note;
			else
				instance.note = instance.classLoader.create("com.evernote.edam.type.Note").init();	
				
			return this;		
		</cfscript>	
	</cffunction>
	
	<cffunction name="getDateCreated" returntype="Date" access="public" output="false" hint="I get the date created of this notebook" >
		<cfscript>
			if(isNumeric(instance.note.getCreated()) AND instance.note.getCreated() neq 0)
				return dateFormat(dateAdd("s",instance.note.getCreated(),DateConvert("utc2Local", "January 1 1970 00:00")),"m/d/yyyy");
			else
				return "1/1/1900";
		</cfscript>
	</cffunction>
	
	<cffunction name="setDateCreated" returntype="void" access="public" output="false" hint="I set the date created." >
		<cfargument name="dateCreated" type="Date" required="false" default="1/1/1900" />
		<cfscript>
			var epoch = dateDiff("s",DateConvert("utc2Local", "January 1 1970 00:00"), arguments.dateCreated);
			instance.note.setCreated(javaCast("Long",epoch));
		</cfscript>
	</cffunction>
	
	<cffunction name="getContent" returntype="String" access="public" output="false" hint="I get this notes content" >
		<cfscript>
			var content = instance.note.getContent();
			
			if(isDefined("content"))
				return content;
			else
				return getNoteHeader() & getNoteFooter();
		</cfscript>
	</cffunction>
	
	<cffunction name="getNoteHeader" returntype="String" access="private" output="false" hint="I return a default note header" >
		<cfscript>
			return '<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd"><en-note>';
		</cfscript>
	</cffunction>
	
	<cffunction name="getNoteFooter" returntype="String" access="private" output="false" hint="I return a default note header" >
		<cfscript>
			return "</en-note>";
		</cfscript>
	</cffunction>
</cfcomponent>