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

<cfcomponent displayname="Note">
	<cfscript>
		variables.instance = {};
		
		instance.libDirectory = "";
		instance.jarArray = "";
		
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
			instance.libDirectory = arguments.libDirectory;
			
			instance.jarArray = ["#libDirectory#/CFEvernote.jar","#libDirectory#/evernote-api-1.18.jar","#libDirectory#/libthrift.jar"];
			
			setClassLoader(instance.jarArray);  
	
			//TODO: try to find a better way to test that the arguments.notebook is of the right type.  Right now its like this because mockito appends junk to the getname()
			if(arguments.note neq "" AND arguments.note.getClass().getName().indexOf("com.evernote.edam.type.Note") neq -1)
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
	
	<cffunction name="setTitle" returntype="void" access="public" output="false" hint="I set this notes title." >
		<cfargument name="title" type="String" required="false" default="" displayname="" />
		<cfscript>
			instance.note.setTitle(arguments.title);
		</cfscript>
	</cffunction>
	
	<cffunction name="getTitle" returntype="String" access="public" output="false" hint="I get this notes title." >
		<cfscript>
			var title = instance.note.getTitle();
			
			if(isDefined("title"))
				return title;
			else
				return "";
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
		<cfargument name="content" type="String" required="false" default="#getNoteHeader() & getNoteFooter()#" hint="Can be valid html or enml" />	
		<cfscript>
			var convertedContent = "";

			convertedContent = convertHTML(arguments.content);
			
			//need to validate the content beofre setting it
			validate(convertedContent);
			
			instance.note.setContent(convertedContent);
		</cfscript>
	</cffunction>
	
	<cffunction name="getGUID" returntype="String" access="public" output="false" hint="I get this notes GUID" >
		<cfscript>
			var guid = instance.note.getGUID();
			
			if(isDefined("guid"))
				return guid;
			else
				return "";		
		</cfscript>
	</cffunction>
	
	<cffunction name="setGUID" returntype="void" access="public" output="false" hint="I set this notes GUID" >
		<cfargument name="guid" type="String" required="false" default="" />
		<cfscript>
			instance.note.setGUID(arguments.guid);
		</cfscript>
	</cffunction>
	
	<cffunction name="getNotebookGUID" returntype="String" access="public" output="false" hint="I get this notes notebook guid" >
		<cfscript>
			var notebookGUID = instance.note.getNotebookGUID();
			
			if(isDefined("notebookGUID"))
				return notebookGUID;
			else
				return "";
		</cfscript>
	</cffunction>
	
	<cffunction name="setNotebookGUID" returntype="void" access="public" output="false" hint="I set this notebooks guid" >
		<cfargument name="notebookGUID" type="String" required="false" default="" />
		<cfscript>
			instance.note.setNotebookGUID(arguments.notebookGUID);
		</cfscript>
	</cffunction>
	
	<cffunction name="getTagNames" returntype="Array" access="public" output="false" hint="I return a list of this notes tags" >
		<cfscript>
			var retArray = "";
			
			retArray = instance.note.getTagNames();
			
			if(isDefined("retArray"))
				return retArray;
			else
				return arrayNew(1);
		</cfscript>
	</cffunction>
	
	<cffunction name="setTagNames" returntype="void" access="public" output="false" hint="I set this notes tags" >
		<cfargument name="tagNames" type="Array" required="false" default="#[]#" />
		<cfscript>
			var i = "";
			
			for(i = 1; i lte arrayLen(arguments.tagNames); i = i + 1){
				addTag(arguments.tagNames[i]);
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="addTag" returntype="void" access="public" output="false" hint="I add a single tag to the tag array" >
		<cfargument name="tagName" type="String" required="false" default="" />
		<cfscript>
			instance.note.addToTagNames(arguments.tagName);	
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

	<cffunction name="convertHTML" returntype="xml" access="private" output="false" hint="I search for html and body tags and replace them with enml en-note tags" >
		<cfargument name="content" type="String" required="true" />
		<cfscript>
			
			var returnXML = arguments.content;
			//if we found a body tag only get the stuff between it
			//TODO: this seems a bit restrictive, i'll prob need a better algorythm here
			returnXML = checkForHTMLWithBody(arguments.content);
			
			if(NOT len(returnXML)){
				returnXML = checkForENML(arguments.content);	
			}
			
			if(NOT len(returnXML)){
				returnXML = arguments.content;	
			}

			return returnXML;
		</cfscript>
	</cffunction>
	
	<cffunction name="checkForHTMLWithBody" returntype="String" access="private" output="false" hint="I check if content is html with a body tag" >
		<cfargument name="content" type="String" required="false" default="" />
		<cfscript>
			var match = reFindNoCase("<body\b[^>]*>(.*?)</body>",arguments.content,0,true);
			
			if((arrayLen(match["len"]) eq 2 AND match["len"][2] neq 0) AND (arrayLen(match["pos"]) eq 2 AND match["pos"][2] neq 0))
				return getNoteHeader() & mid(arguments.content,match["pos"][2],match["len"][2])	& getNoteFooter();
			else
				return "";
		</cfscript>
	</cffunction>
	
	<cffunction name="checkForENML" returntype="String" access="private" output="false" hint="I check for a string wrapped en enml, if it is not found I wrap the string in enml" >
		<cfargument name="content" type="String" required="false" default="" />
		<cfscript>
			var match = reFindNoCase("<en-note\b[^>]*>(.*?)</en-note>",arguments.content,0,true);
			
			if((arrayLen(match["len"]) eq 1 AND match["len"][1] eq 0) AND (arrayLen(match["pos"]) eq 1 AND match["pos"][1] eq 0))
				return getNoteHeader() & arguments.content & getNoteFooter();
			else
				return "";
		</cfscript>
	</cffunction>
	
	<cffunction name="validate" returntype="void" access="private" output="false" hint="I determin weather this notes content is valid or not" >
		<cfargument name="content" type="String" required="true" />
		<cfscript>
			for(key in variables.disallowedTags){
				
				if(reFindNoCase("<#variables.disallowedTags[key]#\b[^>]*>(.*?)</#variables.disallowedTags[key]#>",arguments.content)){
					throw("ENML content exception [#variables.disallowedTags[key]#]","The content passed in contains an illegal tag");
				}
			}
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
	
	<cffunction name="getNote" returntype="any" access="public" output="false" hint="I set this components evernote java note object" >
		<cfscript>
			return instance.note;
		</cfscript>
	</cffunction>
	
	<cffunction name="setNote" returntype="void" access="public" output="false" hint="I return this components evernote java note object" >
		<cfargument name="note" type="any" required="true" />
		<cfscript>
			instance.note = arguments.note;
		</cfscript>
	</cffunction>
	
	<!-- Move this up to a base class -->
	<cffunction name="throw" returntype="void" access="private" output="false" hint="Used as a proxy for throw for cf versions less than 9" >
		<cfargument name="type" type="String" required="false" default="" />
		<cfargument name="message" type="String" required="false" default="" />
		<cfargument name="detail" type="String" required="false" default="" />
		
		<cfthrow type="#arguments.type#" message="#arguments.message#" detail="#arguments.detail#" />
	</cffunction>
</cfcomponent>