<cfcomponent>
	<cfscript>
		this.seperator = "";
		this.name = "cfevernote example"; 
		
		this.seperator = createObject("java","java.lang.System").getProperty("file.separator");
		this.mappings["/"] = expandpath("..") & this.seperator;
		this.mappings["/com"] = expandpath("../com") & this.seperator;
		this.mappings["/resources"] = expandpath("../resources") & this.seperator;
		this.mappings["/lib"] = expandpath("../lib") & this.seperator;
		
		this.sessionManagement = true;
		this.sessionTimeout = createTimeSpan(1,0,0,0);
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
