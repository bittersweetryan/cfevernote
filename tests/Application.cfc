<cfcomponent>
	<cfscript>
		this.seperator = "";
		this.name = "cfevernote test suite"; 
		
		this.seperator = createObject("java","java.lang.System").getProperty("file.separator");
		this.mappings["/mxunit"] = expandpath("..") & this.seperator &  "mxunit" & this.seperator;
		this.mappings["/"] = expandpath("..") & this.seperator;
	</cfscript>
	
	<cffunction name="OnApplicationStart" access="public" returntype="boolean" output="false">
		<cfscript>
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
