<cfcomponent hint="Wrapper for DaisyDiff" output="false">

	<cffunction name="Init" output="false" returntype="DaisyDiff">
		<cfargument name="daisydiffpath" hint="absolute path to daisydiff jar file" type="string" required="true">
		<cfargument name="javaloaderpath" hint="component path to JavaLoader.cfc" type="string" required="true">
		<cfset This.daisydiffpath = arguments.daisydiffpath>
		<cfset This.javaloaderpath = arguments.javaloaderpath>
		<cfreturn This>
	</cffunction>

	<cffunction name="Diff" output="false" returntype="string">
		<cfargument name="olderHtml" type="string" required="true">
		<cfargument name="newerHtml" type="string" required="true">

		<cfset var paths = [This.daisydiffpath]>
		<cfset var loader = createObject("component", This.javaloaderpath).init(paths)>
		<cfset var TransformerFactoryImpl = 	loader.create("com.sun.org.apache.xalan.internal.xsltc.trax.TransformerFactoryImpl")>
		<cfset var StringReader = 				loader.create("java.io.StringReader")>
		<cfset var StringWriter = 				loader.create("java.io.StringWriter")>
		<cfset var Locale = 					loader.create("java.util.Locale")>
		<cfset var StreamResult = 				loader.create("javax.xml.transform.stream.StreamResult")>
		<cfset var OutputKeys = 				loader.create("javax.xml.transform.OutputKeys")>
		<cfset var NekoHtmlParser = 			loader.create("org.outerj.daisy.diff.helper.NekoHtmlParser")>
		<cfset var DomTreeBuilder = 			loader.create("org.outerj.daisy.diff.html.dom.DomTreeBuilder")>
		<cfset var HTMLDiffer = 				loader.create("org.outerj.daisy.diff.html.HTMLDiffer")>
		<cfset var HtmlSaxDiffOutput = 			loader.create("org.outerj.daisy.diff.html.HtmlSaxDiffOutput")>
		<cfset var TextNodeComparator = 		loader.create("org.outerj.daisy.diff.html.TextNodeComparator")>
		<cfset var InputSource = 				loader.create("org.xml.sax.InputSource")>
				
        <cfset var finalResult = StringWriter.Init()>
		<cfset var result = TransformerFactoryImpl.Init().newTransformerHandler()>
		<cfset var sr = StreamResult.Init(finalResult)>
        <cfset var prefix = "diff">
        <cfset var cleaner = NekoHtmlParser.Init()>
		<cfset var oldSource = InputSource.Init(StringReader.Init(olderHtml))>
		<cfset var newSource = InputSource.Init(StringReader.Init(newerHtml))>
		<cfset var oldHandler = DomTreeBuilder.Init()>
		<cfset var newHandler = DomTreeBuilder.Init()>
		<cfset var leftComparator = "">
		<cfset var rightComparator = "">
		<cfset var output = "">
		<cfset var differ = "">
		<cfset var diff = "">

        <cfset result.setResult(sr)>
        <cfset result.getTransformer().setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes")>

        <cfset cleaner.parse(oldSource, oldHandler)>
        <cfset leftComparator = TextNodeComparator.Init(oldHandler, Locale.getDefault())>

        <cfset cleaner.parse(newSource, newHandler)>
        <cfset rightComparator = TextNodeComparator.Init(newHandler, Locale.getDefault())>

        <cfset output = HtmlSaxDiffOutput.Init(result,prefix)>
        <cfset differ = HTMLDiffer.Init(output)>
        <cfset differ.diff(leftComparator, rightComparator)>
        <cfset diff = finalResult.toString()>

		<cfreturn diff>
	</cffunction>

</cfcomponent>