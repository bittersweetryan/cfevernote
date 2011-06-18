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
<cfcomponent hint="Im a ColdFusion wrapper for the evernote API">
	
	<cfscript>
		variables.apiKey = "";
		variables.apiAccount = "";
		variables.evernoteHost = "";
		variables.userStoreURL = "";
		variables.userStorURLBase = "";				
		
		variables.userStoreQueryLink = "/edam/user";
		variables.userStoreBaseQueryLink = "/edam/note/";
		
		variables.major = 0;
		variables.minor = 1;
		
		variables.userAgent = "CFEvernote (ColdFusion) " & variables.major & "." & variables.minor;
		
		variables.jarPath = [expandPath("\") & "lib" & application.seperator & "evernote-api-1.18.jar",
							 expandPath("\") & "lib" & application.seperator & "libthrift.jar"];
		variables.javaLoader = createObject("component","JavaLoader").init(jarPath);
		
		variables.userStore = variables.javaLoader.create("com.evernote.edam.userstore.UserStore");
		variables.noteStore = variables.javaLoader.create("com.evernote.edam.notestore.NoteStore");
	</cfscript>

	<cffunction name="init" returntype="CFEvernote" access="public" hint="Default constructor for the cfevernote plugin">
		<cfargument name="apiKey" type="string" required="false" default="" />
		<cfargument name="apiAccount" type="string" required="false" default="" />
		<cfargument name="evernoteHost" type="string" required="false" default="" />
		<cfscript>
			if(arguments.apiKey neq "")
				variables.apiKey = arguments.apiKey;
			
			if(arguments.apiAccount neq "")
				variables.apiAccount = arguments.apiAccount;
			
			if(arguments.evernoteHost neq ""){
				variables.evenoteHost = arguments.evernoteHost;
				
				variables.userStoreURL = "https://" & arguments.evernoteHost &  variables.userStoreQueryLink;
				variables.userStoreURLBase = "https://" & arguments.evernoteHost & variables.userStoreBaseQueryLink;
			}
							
			return this;
		</cfscript>
	</cffunction>

	<!--------------------------------------------
	*   	     Action Methods                  *
	--------------------------------------------->
	<cffunction name="authenticate" returntype="boolean" access="public" output="false" hint="I log  user into evernote using oauth">
		<cfargument name="username" type="String" required="false" default="" hint="evernote username" />		
		<cfargument name="password" type="String" required="false" default="" hint="evernote password" />
		<cfscript>
			client = javaLoader.create("org.apache.thrift.transport.THttpClient").init(variables.userStoreURL);
			client.setCustomHeader("User-Agent",variables.userAgent);
			
			protocol = javaLoader.create("org.apache.thrift.transport.TBinaryProtocol").init(client);
		</cfscript>
	</cffunction>	
	
	<!--------------------------------------------
	*   	     Mutaters and Accessors          *
	--------------------------------------------->
	<cffunction name="getApiKey" returntype="string" roles="" access="public" output="false" displayname="" hint="" description="">
		<cfscript>
			return variables.apiKey;
		</cfscript>
	</cffunction>
	
	<cffunction name="setApiKey" returntype="void" roles="" access="public" output="false" displayname="" hint="" description="">
		<cfargument name="apiKey" type="String" required="false" default="" displayname="" hint="" />
		<cfscript>
			variables.apiKey = arguments.apiKey;
		</cfscript>
	</cffunction>
	
	<cffunction name="getApiAccount" returntype="string" roles="" access="public" output="false" displayname="" hint="" description="">
		<cfscript>
			return variables.apiAccount;
		</cfscript>
	</cffunction>
	
	<cffunction name="setApiAccount" returntype="void" roles="" access="public" output="false" displayname="" hint="" description="">
		<cfargument name="apiAccount" type="String" required="false" default="" displayname="" hint="" />
		<cfscript>
			variables.apiAccount = arguments.apiAccount;
		</cfscript>
	</cffunction>
	
	<cffunction name="getUserStoreURL" returntype="String" access="public" output="false">
		<cfscript>
			return variables.userStoreURL;
		</cfscript>
	</cffunction>
	
	<cffunction name="getUserStoreURLBase" returntype="String" access="public" output="false">
		<cfscript>
			return variables.userStoreURLBase;
		</cfscript>
	</cffunction>
</cfcomponent>
