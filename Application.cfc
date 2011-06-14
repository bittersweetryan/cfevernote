<cfcomponent>
	<cfscript>
		this.seperator = "";
		this.name = "cfevernote"; 
	</cfscript>
	
	<cffunction name="OnApplicationStart" access="public" returntype="boolean" output="false">
		<cfscript>
			
			this.seperator = createObject("java","java.lang.System").getProperty("file.separator");
			this.mappings["/"] = expandpath(".") & this.seperator;
			
			return true;
		</cfscript>
	</cffunction>
	
	<cffunction name="OnRequestStart" access="public" returntype="boolean" output="false">
 		<cfargument name="TargetPage" type="string" required="true"/>
 		<cfscript>
 			return true; 	 	

		</cfscript>
	</cffunction>
</cfcomponent>
