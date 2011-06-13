<cfscript>
	objShareaholic = createObject(
						"component",
						'com.coldfumonkeh.shareaholic.shareaholic'
					).init(
						apiKey='< your api key goes here >'
					);


	strURL = objShareaholic.buildLink(
					apitype		=	'1',
					service		=	'7',
					link		=	'http://www.mattgifford.co.uk/shareaholic-api-coldfusion-wrapper',
					notes		=	'Shareaholic ColdFusion API wrapper',
					title		=	'Shareaholic ColdFusion API wrapper from @coldfumonkeh',
					shortener	=	'bitly',
					source		=	'Matt Gifford aka coldfumonkeh',
					template	=	'Check out the ${title}: (${short_link}) %23ColdFusion %23API'
			);
			
</cfscript>
									
<cfoutput>
	<h2>Link generated</h2>
	<p>#strURL#</p>
	<p><a href="#strURL#" target="_blank">Share this message to see the API in action.</a></p>
</cfoutput>

<h2>Share your content through the following services</h2>

<cfdump var="#application.objShareaholic.getServiceListAsArray()#" />

