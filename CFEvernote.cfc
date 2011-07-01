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
		//instance scope
		variables.instance = structNew();
		
		//api information
		instance.apiKey = "";
		instance.apiAccount = "";
		instance.evernoteHost = "";
		instance.userStoreURL = "";
		instance.userStorURLBase = "";
		
		//oauth information
		variables.instance.oAuth = structNew();
		
		instance.oAuth.callbackURL = "";
		//url for obtaining temporary token and credentials form evernote
		instance.oAuth.evernoteOAuthURL = "";		
		//url to send a user to verify access to their account
		instance.oAuth.evernoteOAuthVerifyURL = "";				
		//append to oauthurl to form authenticaion link
		instance.oAuth.evernoteOAuthQueryLink = "/oauth";
		//append to oauthverifyurl to form user verification link
		instance.oAuth.evernoteOAuthVerifyQueryLink = "/OAuth.action?oauth_token=";
		//temp token obtained from first oauth call
		instance.oAuth.temporaryAuthToken = ""; 
		//token obtained once user verifies
		instance.oAuth.authToken = "";
		//unique verifier key
		instance.oAuth.authVerifier = "";
		
		instance.evernote = structNew();
		
		//evernote user information
		instance.evernote.shard = ""; //might not need to persist this
		instance.evernote.userID = ""; //might not need to persist this
		//used when creating the evernote java object, gets passed to evernote
		instance.evernote.userAgent = "CFEvernote (ColdFusion) ";
		
		instance.evernote.authCredentials = "";
		
		paths = ["lib/CFEvernote.jar"];
		
		instance.classLoader = createObject("component", "JavaLoader").init();  
		instance.cfEvernote = "";
	</cfscript>

	<cffunction name="init" returntype="CFEvernote" access="public" hint="Default constructor for the cfevernote plugin">
		<cfargument name="apiAccount" type="string" required="false" default="" />
		<cfargument name="apiKey" type="string" required="false" default="" />
		<cfargument name="evernoteHost" type="string" required="false" default="" />
		<cfargument name="callbackURL" type="string" required="false" default="" />
		
		<cfscript>
			if(arguments.apiKey neq "")
				instance.apiKey = arguments.apiKey;
			
			if(arguments.apiAccount neq "")
				instance.apiAccount = arguments.apiAccount;
			
			if(arguments.evernoteHost neq ""){
				instance.evernoteHost = arguments.evernoteHost;
				
				instance.oAuth.evernoteOAuthURL = "https://" & arguments.evernoteHost & instance.oAuth.evernoteOAuthQueryLink;
			}
			
			if(arguments.callbackURL neq "")
				instance.oAuth.callbackURL = arguments.callbackURL;
							
			return this;
		</cfscript>
	</cffunction>

	<!--------------------------------------------
	*   	     Action Methods                  *
	--------------------------------------------->
	<cffunction name="authenticateAPIUser" returntype="boolean" access="public" output="false" hint="I log user into evernote using oauth">
		<cfscript>
			var temporaryAuthToken = getTemporaryAuthTokenFromEvernote();
			
			if(temporaryAuthToken eq ""){
				return false;
			}
			else{
				instance.oAuth.temporaryAuthToken = temporaryAuthToken;
				instance.oAuth.evernoteOAuthVerifyURL = "https://" & instance.evernoteHost & instance.oAuth.evernoteOAuthVerifyQueryLink & temporaryAuthToken;
				return true;
			}
		</cfscript>
	</cffunction>	
	
	<cffunction name="getTemporaryAuthTokenFromEvernote" returntype="String" access="private" output="false" hint="I get a temporary access Token for o-auth" >
		<!-- maybe refactor building url out to new method -->
		<cfhttp url="#instance.oAuth.evernoteOAuthURL#?oauth_consumer_key=#instance.apiAccount#&oauth_signature=#instance.apiKey#&oauth_signature_method=PLAINTEXT&
					oauth_timestamp=#getTickCount()#&oauth_callback=#URLEncodedFormat(instance.oAuth.callbackURL)#&oauth_nonce=#hash(createUUID(),'md5')#" result="oauthResult" />
					
		<cfscript>
			if(oauthResult.Responseheader.Status_Code neq "200"){
				return "";
			}
			else
			{
				return parseOauthTokenResponse(oauthResult.fileContent);
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="getTokenCredentials" returntype="void" access="public" output="false" hint="I take a authorized token response form evernote and get user credentials from evernote" >
		<cfargument name="authToken" type="String" required="false" default="" displayname="" hint="" />
		<cfargument name="authVerifier" type="String" required="false" default="" displayname="" hint="oauth verification Token" />
		
		<cfscript>
			//TODO: clean this up, getting argument errors if a local var shares same name as a argument
			var _authToken = "";
			var _authVerifier = "";
			var response = false;
			
			if(arguments.authToken neq "")
				_authToken = arguments.authToken;
			else if(instance.oAuth.authToken neq "")
				_authToken = instance.oAuth.authToken;
			
				
			if(arguments.authVerifier neq "")
				_authVerifier = arguments.authVerifier;
			else if(instance.oAuth.authVerifier neq "")
				_authVerifier = instance.oAuth.authVerifier;
				
			if(_authToken neq "" && _authVerifier neq ""){
				response = getCredentialsRequest(_authToken,_authVerifier);
			}
			
			if(NOT response){
				//do something to handle errors
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="getCredentialsRequest" returntype="Boolean" access="private" output="true" hint="I call the evernote API to get credentials (oauth step 3) and return the result" >
		<cfargument name="authToken" type="String" required="false" default="" displayname="" hint="oauth authorization Token" />
		<cfargument name="authVerifier" type="String" required="false" default="" displayname="" hint="oauth verification Token" />
				
		<cfhttp url="#instance.oAuth.evernoteOAuthURL#?oauth_consumer_key=#instance.apiAccount#&oauth_signature=#instance.apiKey#&oauth_signature_method=PLAINTEXT&oauth_timestamp=#getTickCount()#&oauth_nonce=#hash(createUUID(),'md5')#&oauth_token=#arguments.authToken#&oauth_verifier=#arguments.authVerifier#" result="oauthResult" />

		<cfscript>
		if(oauthResult.Responseheader.Status_Code neq "200"){
				return false;
			}
			else
			{
				instance.oAuth.authToken = URLDecode(parseOauthTokenResponse(oauthResult.fileContent));
				instance.evernote.shard = parseOauthShardResponse(oauthResult.fileContent);
				instance.evernote.userID = parseOauthUserIDResponse(oauthResult.fileContent);
				return true;
			}	
		</cfscript>		
	</cffunction>
	
	<!---TODO: these regex functions have a code smell, should have one regex function and pass in what we are looking for --->
	<cffunction name="parseOauthTokenResponse" returntype="String" access="private" output="false" hint="I take the response from the oauth temp responsoe and parse out the Token" >
		<cfargument name="oauthResponse" type="String" required="true" default="" hint="resonse from oauth" />
		<cfscript>
			var regexval = refindnocase('\oauth_token=(.*?)\&',arguments.oauthResponse,0,true);
			
			if(arrayLen(regexval["pos"]) eq 2 AND regexval["pos"][2] AND arrayLen(regexval["len"]) eq 2 AND  regexval["len"][2])
				return mid(arguments.oauthResponse,regexval["pos"][2],regexval["len"][2]);
			else
				return "";
		</cfscript>
	</cffunction>
	
	<cffunction name="parseOauthShardResponse" returntype="String" access="private" output="false" hint="I take the response from the oauth temp responsoe and parse out the Token" >
		<cfargument name="oauthResponse" type="String" required="true" default="" hint="resonse from oauth" />
		<cfscript>
			var regexval = refindnocase('edam_shard=(.*?)\&',arguments.oauthResponse,0,true);
			
			if(arrayLen(regexval["pos"]) eq 2 AND regexval["pos"][2] AND arrayLen(regexval["len"]) eq 2 AND  regexval["len"][2])
				return mid(arguments.oauthResponse,regexval["pos"][2],regexval["len"][2]);
			else
				return "";
		</cfscript>
	</cffunction>

	<cffunction name="parseOauthUserIDResponse" returntype="String" access="private" output="false" hint="I take the response from the oauth temp responsoe and parse out the Token" >
		<cfargument name="oauthResponse" type="String" required="true" default="" hint="resonse from oauth" />
		<cfscript>
			var regexval = refindnocase('edam_userId=(\d*)',arguments.oauthResponse,0,true);
			
			if(arrayLen(regexval["pos"]) eq 2 AND regexval["pos"][2] AND arrayLen(regexval["len"]) eq 2 AND  regexval["len"][2])
				return mid(arguments.oauthResponse,regexval["pos"][2],regexval["len"][2]);
			else
				return "";
		</cfscript>
	</cffunction>
	<!--------------------------------------------
	*   	     Mutaters and Accessors          *
	--------------------------------------------->
	<cffunction name="getApiKey" returntype="string" roles="" access="public" output="false" displayname="" hint="" description="">
		<cfscript>
			return instance.apiKey;
		</cfscript>
	</cffunction>
	
	<cffunction name="setApiKey" returntype="void" roles="" access="public" output="false" displayname="" hint="" description="">
		<cfargument name="apiKey" type="String" required="false" default="" displayname="" hint="" />
		<cfscript>
			instance.apiKey = arguments.apiKey;
		</cfscript>
	</cffunction>
	
	<cffunction name="getApiAccount" returntype="string" roles="" access="public" output="false" displayname="" hint="" description="">
		<cfscript>
			return instance.apiAccount;
		</cfscript>
	</cffunction>
	
	<cffunction name="setApiAccount" returntype="void" roles="" access="public" output="false" displayname="" hint="" description="">
		<cfargument name="apiAccount" type="String" required="false" default="" displayname="" hint="" />
		<cfscript>
			instance.apiAccount = arguments.apiAccount;
		</cfscript>
	</cffunction>
	
	<cffunction name="getEvernoteOAuthURL" returntype="String" access="public" output="false" hint="returns the oauth url link" >
		<cfscript>
			return instance.oAuth.evernoteOAuthURL;
		</cfscript>
	</cffunction>
	
	<cffunction name="getTemporaryAuthToken" returntype="String" access="public" output="false" hint="return the temporary oauth Token used when getting the oauth Token" >
		<cfscript>
			return instance.oAuth.temporaryAuthToken;
		</cfscript>
	</cffunction>
	
	<cffunction name="getAuthToken" returntype="String" access="public" output="false" hint="I return the auth Token" >
		<cfscript>
			return instance.oAuth.authToken;		
		</cfscript>
	</cffunction>
	
	<cffunction name="setAuthToken" returntype="String" access="public" output="false" hint="I set the auth Token" >
		<cfargument name="authToken" type="String" required="false" default=""/>
		<cfscript>
			instance.oAuth.authToken = arguments.authToken;		
		</cfscript>
	</cffunction>

	<cffunction name="getShard" returntype="String" access="public" output="false" hint="I return the shard after oauth credentials" >
		<cfscript>
			return instance.evernote.shard;		
		</cfscript>
	</cffunction>
	
	<cffunction name="getUserID" returntype="String" access="public" output="false" hint="I return the users id after oauth credentials" >
		<cfscript>
			return instance.evernote.userID;
		</cfscript>
	</cffunction>
	
	<cffunction name="getAuthVerifier" returntype="String" access="public" output="false" hint="I return the auth Token" >
		<cfscript>
			return instance.oAuth.authVerifier;		
		</cfscript>
	</cffunction>
	
	<cffunction name="setAuthVerifier" returntype="String" access="public" output="false" hint="I set the auth Token" >
		<cfargument name="authVerifier" type="String" required="false" default=""/>
		<cfscript>
			instance.oAuth.authVerifier = arguments.authVerifier;		
		</cfscript>
	</cffunction>
	
	<cffunction name="getEvernoteOAuthVerifyURL" access="public" output="false" returntype="any">
		<cfscript>
			return instance.oAuth.evernoteOAuthVerifyURL;
		</cfscript>
	</cffunction>
</cfcomponent>
