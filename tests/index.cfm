<cfsetting showdebugoutput="false" />
<cfinvoke component="mxunit.runner.DirectoryTestSuite"
          method="run"
          directory="#expandPath('.')#"
          recurse="true"
          excludes=""
          returnvariable="results" />

<cfscript>
	testResults = results.getResultsOutput('html');
	
	testResults = replace(testResults, "mxunit","cfevernote\\mxunit","ALL");
</cfscript>

<cfoutput>  
	#testResults#
</cfoutput>