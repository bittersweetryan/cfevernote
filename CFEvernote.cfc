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
	</cfscript>

	<cffunction name="init" returntype="void" access="public" hint="Default constructor for the cfevernote plugin">
		<cfargument name="apiKey" type="string" required="false" default="" />
		<cfargument name="apiAccount" type="string" required="false" default="" />
		<cfscript>
			if(arguments.apiKey neq "")
				variables.apiKey = arguments.apiKey;
			
			if(arguments.apiAccount neq "")
				variables.apiAccount = arguments.apiAccount;
		</cfscript>
	</cffunction>
	
	
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
</cfcomponent>
