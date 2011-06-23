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
		//api information
		variables.apiKey = "";
		variables.apiAccount = "";
		variables.evernoteHost = "";
		variables.userStoreURL = "";
		variables.userStorURLBase = "";
		
		//oauth information
		variables.callbackURL = "";
		variables.evernoteOAuthURL = "";				
		variables.evernoteOAuthQueryLink = "/oauth";
		variables.temporaryAuthTolken = ""; 
		variables.authTolken = "";
		
		//api url information
		variables.userStoreQueryLink = "/edam/user";
		variables.userStoreBaseQueryLink = "/edam/note/";
		
		
		
		variables.userAgent = "CFEvernote (ColdFusion) ";
	</cfscript>

	<cffunction name="init" returntype="CFEvernote" access="public" hint="Default constructor for the cfevernote plugin">
		<cfargument name="apiAccount" type="string" required="false" default="" />
		<cfargument name="apiKey" type="string" required="false" default="" />
		<cfargument name="evernoteHost" type="string" required="false" default="" />
		<cfargument name="callbackURL" type="string" required="false" default="" />
		
		<cfscript>
			if(arguments.apiKey neq "")
				variables.apiKey = arguments.apiKey;
			
			if(arguments.apiAccount neq "")
				variables.apiAccount = arguments.apiAccount;
			
			if(arguments.evernoteHost neq ""){
				variables.evenoteHost = arguments.evernoteHost;
				
				variables.userStoreURL = "https://" & arguments.evernoteHost &  variables.userStoreQueryLink;
				variables.userStoreURLBase = "https://" & arguments.evernoteHost & variables.userStoreBaseQueryLink;
				
				variables.evernoteOAuthURL = "https://" & arguments.evernoteHost & variables.evernoteOAuthQueryLink;
			}
			
			if(arguments.callbackURL neq "")
				variables.callbackURL = arguments.callbackURL;
							
			return this;
		</cfscript>
	</cffunction>

	<!--------------------------------------------
	*   	     Action Methods                  *
	--------------------------------------------->
	<cffunction name="authenticate" returntype="boolean" access="public" output="false" hint="I log  user into evernote using oauth">
		<cfscript>
			var temporaryAuthTolken = getTemporaryAuthTolkenFromEvernote();
			
			if(temporaryAuthTolken eq ""){
				return false;
			}
			else{
				variables.temporaryAuthTolken = temporaryAuthTolken;
				return true;
			}
		</cfscript>
	</cffunction>	
	
	<cffunction name="getTemporaryAuthTolkenFromEvernote" returntype="String" access="private" output="false" hint="I get a temporary access tolken for o-auth" >
		<!-- maybe refactor building url out to new method -->
		<cfhttp url="#variables.evernoteOAuthURL#?oauth_consumer_key=#variables.apiAccount#&oauth_signature=#variables.apiKey#&oauth_signature_method=PLAINTEXT&
					oauth_timestamp=#getTickCount()#&oauth_callback=#URLEncodedFormat(variables.callbackURL)#&oauth_nonce=#hash(createUUID(),'md5')#" result="oauthResult" />
					
		<cfscript>
			if(oauthResult.Responseheader.Status_Code neq "200"){
				return "";
			}
			else
			{
				return parseOauthTempTokenResponse(oauthResult.fileContent);
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="parseOauthTempTokenResponse" returntype="String" access="private" output="false" hint="I take the response from the oauth temp responsoe and parse out the tolken" >
		<cfargument name="oauthResponse" type="String" required="true" default="" hint="resonse from oauth" />
		<cfscript>
			var regexval = refindnocase('\oauth_token=(.*?)\&',arguments.oauthResponse,0,true);
			
			return mid(arguments.oauthResponse,regexval["pos"][2],regexval["len"][2]);
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
	
	<cffunction name="getEvernoteOAuthURL" returntype="String" access="public" output="false" hint="returns the oauth url link" >
		<cfscript>
			return variables.evernoteOAuthURL;
		</cfscript>
	</cffunction>
	
	<cffunction name="getTemporaryAuthTolken" returntype="String" access="public" output="false" hint="return the temporary oauth tolken used when getting the oauth tolken" >
		<cfscript>
			return variables.temporaryAuthTolken;
		</cfscript>
	</cffunction>
	
	<cffunction name="getAuthTolken" returntype="String" access="public" output="false" hint="I return the auth tolken" >
		<cfscript>
			return variables.authTolken;		
		</cfscript>
	</cffunction>
	
	<cffunction name="setAuthTolken" returntype="String" access="public" output="false" hint="I set the auth tolken" >
		<cfargument name="authTolken" type="String" required="false" default=""/>
		<cfscript>
			variables.authTolken = arguments.authTolken;		
		</cfscript>
	</cffunction>
</cfcomponent>
