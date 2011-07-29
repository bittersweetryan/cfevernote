<cfset str = "Hello World! This string is a bit longer." & DateFormat(NOW(),"mm/dd/yyyy") />
<cfset str1 = "" />
<cfset output = "" />

<cfloop from=1 to=100000 index="i">
	<cfif i mod 2>
		<cfif len(str)>
			<cfset output = str />
		</cfif>
	<cfelse>
		<cfif len(str1)>
			<cfset output = str1 />
		</cfif>
	</cfif>
</cfloop>

