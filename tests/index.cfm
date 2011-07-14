<cfsetting showdebugoutput="false" />
<cfinvoke component="mxunit.runner.DirectoryTestSuite"
          method="run"
          directory="#expandPath('.')#"
          recurse="true"
          excludes=""
          returnvariable="results" />

<cfscript>
	testResults = results.getResultsOutput('html');
</cfscript>

<cfoutput>  
	#testResults#
</cfoutput>
