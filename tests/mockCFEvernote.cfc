<cfcomponent output="false" hint="I mock the java instance of the cfevernote class">

	<cffunction name="listNotebooks" returntype="Array" access="public" output="false" hint="" >
		<cfargument name="maxCount" type="numeric" default="9999">
		<!--- the default for maxcount matches the maxcount in the java class --->
		<cfscript>
			var myArray = ArrayNew(1);
			var i = 0;
			
			//create an array thats the size of the maxcount
			for(i = 1; i lte arguments.maxCount; i = i + 1){
				myArray[i] = "";
			}		

			return myArray;
		</cfscript>	
	</cffunction>

	<cffunction name="listNotes" returntype="Array" access="public" output="false" hint="" >
		<cfargument name="maxCount" type="numeric" default="9999">
		<!--- the default for maxcount matches the maxcount in the java class --->
		<cfscript>
			var myArray = ArrayNew(1);
			var i = 0;
			
			//create an array thats the size of the maxcount
			for(i = 1; i lte arguments.maxCount; i = i + 1){
				myArray[i] = "";
			}		

			return myArray;
		</cfscript>	
	</cffunction>
</cfcomponent>