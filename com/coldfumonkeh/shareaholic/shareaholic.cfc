<!---
Name: shareaholic.cfc
Author: Matt Gifford aka coldfumonkeh (http://www.mattgifford.co.uk)
Date: 13.06.2011

Copyright 2011 Matt Gifford aka coldfumonkeh. All rights reserved.
Product and company names mentioned herein may be
trademarks or trade names of their respective owners.

Subject to the conditions below, you may, without charge:

Use, copy, modify and/or merge copies of this software and
associated documentation files (the 'Software')

Any person dealing with the Software shall not misrepresent the source of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Revision history
================

13/06/2011 - Version 1.0

	- initial release

--->
<cfcomponent displayname="shareaholic" output="false" hint="I am the shareaholic component that interacts with the shareaholic API">
	
	<cfset variables.instance = structNew() />
	
	<cffunction name="init" access="public" output="false" hint="I am the init constructor method for the shareaholic component">
		<cfargument name="apiKey" 	required="true" 				type="string" hint="I am the API Key required to access the services." />
		<cfargument name="version" 	required="false" default="1" 	type="string" hint="I am the version number of the current API implementation." />
			<cfscript>
				variables.instance.apiKey 	= 	arguments.apiKey;
				variables.instance.version	=	arguments.version;
				variables.instance.endPoint	= 	'http://www.shareaholic.com/api/';      	            
            </cfscript>
		<cfreturn this  />
	</cffunction>
	
	<!--- Getters / Accessors --->
	<cffunction name="getAPIKey" output="false" access="private" hint="I return the apiKey value from the variables.instance scope.">
		<cfreturn variables.instance.apiKey />
	</cffunction>
	
	<cffunction name="getVersion" output="false" access="private" hint="I return the version value from the variables.instance scope.">
		<cfreturn variables.instance.version />
	</cffunction>
	
	<cffunction name="getEndpoint" output="false" access="private" hint="I return the endpoint value from the variables.instance scope.">
		<cfreturn variables.instance.endPoint />
	</cffunction>
	
	<!--- Public methods --->
		
	<!--- Data-specific methods --->
	<cffunction name="shareCount" access="public" output="false" hint="Answers how many times webpages from your website have been shared in a given timeframe.">
		<cfargument name="domain" 		required="true" 	type="string" 					hint="I am the domain or sub-domain you want data returned for." />
		<cfargument name="timeframe" 	required="false" 	type="string"	default="1" 	hint="I am the timeframe you wish to search within. 1=share count for last 24 hours. 30=last 30 days." />
		<cfargument name="callback" 	required="false" 	type="string"	default=""		hint="I am the optional name for the callback function. I pass the JSON response to the JavaScript callback function you specify." />
				<cfset var strURL 		= '' />
				<cfset strURL 		= getEndpoint() & 'data/' & arguments.domain & '/sharecount/' & arguments.timeframe & '/' />
				<cfif len(arguments.callback)>
					<cfset strURL = strURL & '?' & arguments.callback />
				</cfif>
		<cfreturn makeGetCall(strURL) />
	</cffunction>
	
	<cffunction name="topUsers" access="public" output="false" hint="Answers who are the top users / sharers for a given website.">
		<cfargument name="domain" 		required="true" 	type="string" 					hint="I am the domain or sub-domain you want data returned for." />
		<cfargument name="count" 		required="false" 	type="string"	default="5" 	hint="I am the number of users you wish to obtain. 5=return top 5 users (default), 20=maximum." />
		<cfargument name="callback" 	required="false" 	type="string"	default=""		hint="I am the optional name for the callback function. I pass the JSON response to the JavaScript callback function you specify." />
				<cfset var strURL 		= '' />
				<cfset strURL 		= getEndpoint() & 'data/' & arguments.domain & '/topusers/' & arguments.count & '/' />
				<cfif len(arguments.callback)>
					<cfset strURL = strURL & '?' & arguments.callback />
				</cfif>
		<cfreturn makeGetCall(strURL) />
	</cffunction>
	<!--- End of data-specific methods --->
		
	<!--- Share-specific methods --->
	<cffunction name="buildLink" access="public" output="false" hint="I am the method that generates the link for the shareaholic services based upon your selections.">
		<cfargument name="apitype" 			required="true" 	type="string" 	default="1" 				hint="1=Redirect, 2=Pingback, 3=1x1 pixel" />
		<cfargument name="service" 			required="true" 	type="string" 								hint="I am the code for the service you wish to use." />
		<cfargument name="link" 			required="true" 	type="string" 								hint="I am the link you wish to share." />
		<cfargument name="title" 			required="false" 	type="string" 	default=""					hint="I am an optional title for the link you wish to share." />
		<cfargument name="notes" 			required="false" 	type="string" 	default=""					hint="I am an optional note for the link you wish to share." />
		<cfargument name="short_link" 		required="false"	type="string" 	default=""					hint="I am an optional shortened link for the link you wish to share." />
		<cfargument name="shortener"		required="false" 	type="string"	default="google"			hint="I am the url shortening service you wish to use for this link. google (default), tinyurl, supr, bitly, jmp, mcafee, none." />
		<cfargument name="shortener_key"	required="false" 	type="string"	default=""					hint="I am the authentication / account details for your own specific shortening account (if using bitly or supr). Bit.ly format: username|apikey (i.e. delimited by '|'). Su.pr format: just pass the apikey." />
		<cfargument name="template"			required="false"	type="string"	default="" 					hint="I am the template parameter and allows you to customize the default post format fpr services that support templates. The Share API supports a few different tokens in a template — you can use all, some, or none of them: ${title} - title of the page. ${link} - link to the page. ${short_link} - short link that you pass to the Share API. ${notes} - any text; usually a very short summary of the link or user selected text" />
		<cfargument name="tags"				required="false"	type="string"	default="" 					hint="I am an optional comma-delimited list of tags to provide with the link you wish to share." />
		<cfargument name="source"			required="false"	type="string"	default="" 					hint="I am the source of the referral, eg. Shareaholic" />
		<cfargument name="apikey"			required="true"		type="string"	default="#getAPIKey()#" 	hint="I am the api key for the application." />
		<cfargument name="v"				required="true"		type="string"	default="#getVersion()#" 	hint="I am the version number of the API." />
			<cfset var strURL 		= '' />
			<cfset var stuParams 	= '' />
				<cfif len(arguments.apikey)>
					<cfset stuParams	= clearEmptyParams(arguments) />
					<cfset strURL 		= getEndpoint() & 'share/?' & buildParamString(stuParams) />
				<cfelse>
					<cfset strURL		=	'Please supply your Shareaholic API key to continue.' />
				</cfif>
		<cfreturn strURL />
	</cffunction>
	
	<!--- 
		Provide a list of all available services.
		Shareaholic provided no simple way to pull the list of services (which kind of sucks a little).
		This isn't pretty or dynamic, but it contains the services and their relevant service ID,
		and will create an array for you to loop over and work with.
	--->
	<cffunction name="getServiceListAsArray" output="false" access="public" hint="I return an array of structs containing the available services and service IDs to use through the API.">
		<cfset var networkList = '
					AIM							|50,
					Allvoices					|63,
					Amazon (CA) Wish List       |271,
					Amazon (DE) Wish List       |272,
				    Amazon (FR) Wish List       |273,
				    Amazon (JP) Wish List       |274,
				    Amazon (UK) Wish List       |270,
				    Amazon (US) Wish List       |200,
				    AOL Mail                    |55,
				    Arto                        |194,
				    Ask.com MyStuff             |91,
				    AttentionMeter              |221,
				    Backflip                    |97,
				    Balatarin                   |241,
				    Bebo                        |196,
				    BibSonomy                   |25,
				    Bit.ly                      |208,
				    Bitty Browser               |108,
				    Blinklist                   |48,
				    Blogger Post                |219,
				    BlogMarks                   |27,
				    BobrDobr                    |266,
				    Bookmarks.fr                |35,
				    Box.net                     |240,
				    BuddyMarks                  |90,
				    Buzzster                    |1,
				    Care2 News                  |104,
				    CiteULike                   |13,
				    Clicky.me                   |248,
				    Connotea                    |96,
				    Current                     |80,
				    DailyMe                     |237,
				    Delicious                   |2,
				    Design Float                |106,
				    Digg                        |3,
				    Digg Bar                    |224,
				    Diglog                      |72,
				    diHITT                      |244,
				    Diigo                       |24,
				    Dwellicious                 |251,
				    DZone                       |102,
				    Evernote                    |191,
				    Expression                  |186,
				    Facebook                    |5,
				    Fark                        |62,
				    Faves                       |49,
				    Favoriten                   |242,
				    Feedmarker Bookmarks        |69,
				    Folkd                       |197,
				    Followup.cc                 |235,
				    FriendFeed                  |43,
				    FunP                        |17,
				    Furl                        |11,
				    Gabbr                       |183,
				    Global Grind                |89,
				    Google Apps Mail            |260,
				    Google Bookmarks            |74,
				    Google Buzz                 |257,
				    Google Mail                 |52,
				    Google Reader               |207,
				    Google Sidewiki             |275,
				    Google Translate            |252,
				    Google Wave                 |262,
				    Gravee                      |95,
				    Hatena                      |246,
				    HelloTxt                    |81,
				    Hemidemi                    |16,
				    HootSuite                   |261,
				    Hotmail                     |53,
				    Hub.tm                      |234,
				    Hugg                        |71,
				    Hyves                       |105,
				    Identi.ca                   |205,
				    Imera Brazil                |65,
				    Instapaper                  |18,
				    Is.gd                       |228,
				    iZeby                       |263,
				    j.mp                        |249,
				    Jamespot                    |64,
				    Jumptags                    |14,
				    Khabbr                      |31,
				    Kledy                       |30,
				    LinkaGoGo                   |67,
				    Linkatopia                  |85,
				    LinkedIn                    |88,
				    LiveJournal                 |79,
				    Ma.gnolia                   |23,
				    Mail                        |201,
				    Maple                       |93,
				    Memori.ru                   |269,
				    Menéame                     |33,
				    MindBodyGreen               |68,
				    Mister-Wong                 |6,
				    Mixx                        |4,
				    Moemesto                    |268,
				    Mozillaca                   |231,
				    MSDN                        |184,
				    Multiply                    |42,
				    MyLinkVault                 |98,
				    MySpace                     |39,
				    Netlog                      |8,
				    Netvibes Share              |195,
				    Netvouz                     |21,
				    NewsTrust                   |199,
				    NewsVine                    |41,
				    Ning                        |264,
				    NowPublic                   |75,
				    NUjij                       |238,
				    Oknotizie                   |243,
				    Oneview                     |84,
				    Orkut                       |247,
				    PhoneFavs                   |19,
				    Pinboard.in                 |256,
				    Ping                        |45,
				    Plaxo Pulse                 |44,
				    Plurk                       |218,
				    Posterous                   |210,
				    PrintFriendly               |236,
				    Propeller                   |77,
				    Protopage Bookmarks         |47,
				    Pusha                       |59,
				    Read It Later               |239,
				    ReadWriteWeb                |250,
				    Reddit                      |40,
				    Segnalo                     |58,
				    Shoutwire                   |12,
				    Simpy                       |86,
				    SiteJot                     |99,
				    Slashdot                    |61,
				    SmakNews                    |206,
				    Soup.io                     |217,
				    Sphere                      |107,
				    Sphinn                      |100,
				    SpringPad                   |265,
				    Spurl                       |82,
				    Squidoo                     |46,
				    StartAid                    |29,
				    Strands                     |190,
				    Streakr                     |215,
				    StumbleUpon                 |38,
				    Stumpedia                   |192,
				    Su.pr                       |232,
				    Svejo                       |245,
				    Symbaloo Feeds              |103,
				    Taggly                      |26,
				    Tagza                       |187,
				    Tailrank                    |28,
				    Techmeme                    |204,
				    TechNet                     |185,
				    Technorati Favorites        |10,
				    Technotizie                 |36,
				    TinyURL                     |223,
				    Tipd                        |188,
				    Tr.im                       |214,
				    Truemors                    |203,
				    Tumblr                      |78,
				    Tweetie                     |226,
				    Twiddla                     |66,
				    Twine                       |216,
				    Twitter                     |7,
				    TypePad Post                |220,
				    unalog                      |70,
				    Viadeo                      |92,
				    VodPod                      |198,
				    Webnews                     |57,
				    Windows Live Favorites      |37,
				    Windows Live Spaces         |15,
				    Wink                        |22,
				    Wists                       |94,
				    WordPress                   |230,
				    Xerpi                       |20,
				    Yahoo Bookmarks             |76,
				    Yahoo Buzz                  |73,
				    Yahoo Buzz India            |254,
				    Yahoo Messenger             |87,
				    Yahoo! Mail                 |54,
				    Yammer                      |253,
				    Yample                      |83,
				    Yandex                      |267,
				    YC Hacker News              |202,
				    YiGG                        |56,
				    Yoolink                     |34,
				    YouMob                      |60' />
	

		<cfset var arrList 		= listToArray(networkList) />
		<cfset var arrNetworks 	= arrayNew(1) />

			<cfloop array="#arrList#" index="item">
				<cfset arrayAppend(arrNetworks,{
											service 	= 	trim(listGetAt(item,1,'|')),
											serviceID	=	trim(listGetAt(item,2,'|'))	
										}
									) />
			</cfloop> 
	
		<cfreturn arrNetworks />
	</cffunction>
	<!--- End of share-specific methods --->
	
	<!--- Private methods --->
	<cffunction name="clearEmptyParams" access="private" output="false" hint="I accept the structure of arguments and remove any empty / nulls values before they are sent to the OAuth processing.">
		<cfargument name="paramStructure" required="true" type="Struct" hint="I am a structure containing the arguments / parameters you wish to filter." />
			<cfset var stuRevised = {} />
				<cfloop collection="#arguments.paramStructure#" item="key">
					<cfif len(arguments.paramStructure[key])>
						<cfset structInsert(stuRevised, lcase(key), arguments.paramStructure[key], true) />
					</cfif>
				</cfloop>
		<cfreturn stuRevised />
	</cffunction>
	
	<cffunction name="buildParamString" access="private" output="false" returntype="String" hint="I loop through a struct to convert to query params for the URL">
		<cfargument name="argScope" required="true" type="struct" hint="I am the struct containing the method params" />
			<cfset var strURLParam 	= '' />
			<cfloop collection="#arguments.argScope#" item="key">
				<cfif len(arguments.argScope[key])>
					<cfif listLen(strURLParam)>
						<cfset strURLParam = strURLParam & '&' />
					</cfif>
					<cfset strURLParam = strURLParam & lcase(key) & '=' & urlEncodedFormat(arguments.argScope[key]) />
				</cfif>
			</cfloop>
		<cfreturn strURLParam />
	</cffunction>
	
	<cffunction name="makeGetCall" access="private" output="false" returntype="Any" hint="I am the function that makes the cfhttp GET requests">
		<cfargument name="URLEndpoint" 	required="true" type="string" hint="The URL to call for the GET request." />
			<cfset var cfhttp	 = '' />
			<cfhttp url="#arguments.URLEndpoint#" method="get" useragent="monkehLove_Shareaholic" />
		<cfreturn cfhttp.FileContent />
	</cffunction>
	
</cfcomponent>