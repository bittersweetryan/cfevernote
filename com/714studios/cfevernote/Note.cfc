<cfcomponent displayname="Note">
	<cfscript>
		variables.instance = {};
		
		variables.allowedTags = {A="a", ABBR="abbr", ACRONYM="acronym", ADDRESS="address", AREA="area", B="b", BDO="bdo", BIG="big", BLOCKQUOTE="blockquote", 
								 BR="br",CAPTION="caption", CENTER="center", CITE="cite", CODE="code", COL="col", COLGROUP="colgroup", DD="dd", DEL="del", DFN="dfn", 
								 DIV="div", DL="dl",DT="dt", EM="em", FONT="font", H1="h1", H2="h2", H3="h3", H4="h4", H5="h5", H6="h6", HR="hr", I="i", IMG="img",
								 INS="ins", KBD="kbd", LI="li", MAP="map", OL="ol", P="p", PRE="pre", Q="q", S="s", SAMP="samp", SMALL="small", SPAN="span", 
								 STRIKE="strike", STRONG="strong", SUB="sub", SUP="sup", TABLE="table", TBODY="tbody", TD="td", TFOOT="tfood", TH="th", THEAD="thead", 
								 TITLE="title", TR="tr", TT="tt", U="u", UL="ul", VAR="var", XMP="xmp"};
								 
		variables.disallowedTags = {APPLET="applet", BASE="base", BASEFONT="basefont", BGSOUND="bgsound", BLINK="blink", BODY="body", BUTTON="button", DIR="dir", EMBED="embed",
									FIELDSET="fieldset", FORM="form", FRAME="frame", FRAMESET="frameset", HEAD="head", HTML="html", IFRAME="iframe", ILAYER="ilayer", 
									INPUT="input", ISINDEX="isindex", LABEL="label", LAYER="layer", LEGEND="legend", LINK="link", MARQUEE="marquee", MENU="menu", 
									META="meta", NOFRAMES="noframes", NOSCRIPT="noscript", OBJECT="object", OPTGROUP="optgroup", OPTION="option", PARAM="param", 
									PLAINTEXT="plaintext", SCRIPT="script", SELECT="select", STYLE="style", TEXTAREA="textarea", XML="xml"};
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
	
	<cffunction name="getContent" returntype="xml" access="public" output="false" hint="I get this notes content, if a note contains no content I return the xml for a blank note" >
		<cfscript>
			var content = instance.note.getContent();
			
			if(isDefined("content"))
				return content;
			else
				return getNoteHeader() & getNoteFooter();

		</cfscript>
	</cffunction>
	
	<cffunction name="setContent" returntype="void" access="public" output="false" hint="I set this notes content" >
		<cfargument name="content" type="xml" required="false" default="#getNoteHeader() & getNoteFooter()#" hint="Can be valid html or enml" />	
		<cfscript>
			//need to validate the content
			convertHTML(arguments.content);
			//validate(arguments.content);  //validate should throw error
			
			instance.note.setContent(arguments.content);
		</cfscript>
	</cffunction>
	
	<!--- Private methods --->
	<cffunction name="convertHTML" returntype="any" access="private" output="false" hint="I search for html and body tags and replace them with enml en-note tags" >
		<cfargument name="content" type="xml" required="true" />
		<cfscript>
			var match = reFindNoCase("<body\b[^>]*>(.*?)</body>",arguments.content,0,true);
			writedump(var=match,abort=true);
			return ("<xml></xml>");
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