CHANGELOG
=========
7.2.6
 - Moat framework updated to v4.0.0
 
7.2.5
 - Removal of UIWebview
 - Click & completed view discrepancy fixes
 - Moat made optional
 
7.0.1
 - Transitioned to a non-scaling WebView to display banner & interstitial type ads

7.0.0
 - Prepare and improve SDK for GDPR Release
 - Improved tests for a lot of sub-components (networking, parsing, etc)
 - Added a module that dynamically checks a user's "isMinor" status based on country, etc
 - Simplified a lot of the code in different sub-components (networking, parsing, etc)
 - Fixed an internal iFrame issue 

6.1.9
 - Added correct SDK version

6.1.8
6.1.7 
 - Fixed all warnings realted to SuperAwesome
 - Descreased size of uncompiled files by about 1MB
 - Removed unused code in SAUtils, AgeGate, etc
 - Fixed a bug that meant that images bigger than 320x480 were not scaled properly
 - Moved all dependency min. requirements to iOS 8.0 and removed deprecated code

6.1.6
 - Improved Bumper Page experience

6.1.5
 - Removed video auto-reload after an hour code

6.1.4
 - Update BumperPage copy

6.1.3
 - Fixed MoPub failLoad error that was prevening the MoPub Adapter to correctly signal either an empty ad or a mopub://failLoad tag

6.1.2
6.1.1
 - General small bug fixes
 - Added null checks for callbacks

6.1.0
 - Added the Bumper Page as another option to overlap to each ad (video, interstitial, banner, app wall)
 - Separated the parental gate into a separate library (and done some refactoring)

6.0.0
 - Removed CPI library dependancy
 - Made this SDK focus in Publishers (as opposed to the new Advertisers SDK)
 - Refactoring & renaming

5.7.2
 - Fixed a bug that caused video & interstitial ads that failed to load once, sending the adFailedToLoad callback event, start always sending adAlreadyLoaded on subsequent failed loads

5.7.1
 - Added a new ad callback event called adEmpty. This will be forwarded when the ad server returns successfully (status code 200) but has no actual ad to serve.
 - Added this event to the AIR and Unity plugins
 - It is also handled by the AdMob/MoPub adapters in their own internal logic
 - Fixed warnings from dependency libraries

5.7.0
 - Added AdMob support 
 - Refactored MoPub classes to use the same naming convention as the AdMob, Unity and AIR plugins
 - Made the padlock be positioned correctly over the main ad content
 - Refactored MoPub classes to better read values form the MoPub configuration JSON

5.6.0
 - Added MRAID capabilities to banner & interstitial ads
 - Updated the MOAT implementation to the latest one available
 - Updated the Padlock to have the new SA logo
 - Fixed a bug in SAAppWall class that crashed the app if the icons resources could not be loaded

5.5.8
 - Added camel & snake case options when parsing the SACreative object - for click, impression and install
 - Added the osTarget parameter to the SACreative
 - Fixed tests in SACPI

5.5.7
 - Made the aux "setAd:" method create the static dict holding ads, just as "load:"

5.5.6
 - Updated SAAdLoader dependency; it now contains load + local processing methods

5.5.5
 - Set "isOKToClose" parameter to true in case of a video error (such as the creative not being able to play) so that when the happens video can actually be auto-closed

5.5.4
 - Updated the Model space SADetails class to have a "base" string member to hold the base Url of the creative
 - Updated the Web Player to work with a base url and eliminate a series of minor bugs where 3rd party tags weren't rendered correctly

5.5.3
 - Added scrollable interstitial support

5.5.2
 - Refactored the SAModelSpace library to:
    - remove all Ad Events from the SACreative object
    - add a SAVASTAdType object to SAMedia; for video ads this is where additional details will be stored from now on 
    - renamed the SATracking model to SAVASTEvent
    - added a new constructor for SAAd that takes placementId and JSON Dictionary
 - Updated the VAST Parser library to take into account the new modelspace; added more tests
 - Updated the SAAdLoader library:
    - to take into account the new modelspace
    - to not try to add events to the SAAd class; 
    - added more tests
 - Refactored the SAEvents library:
    - each type of event (VAST events, click through, impression, etc) is now a separate class; that makes it easier to test 
    - there are now for modules: VASTModule, ServerModule, ViewableModule and MoatModule that deal with these different things that need to be triggered
    - added a lot more tests
 - Updated the CPI library to work with the new modelspace
 - Updated the Main SDK to work with the new modelspace & eventing system

5.5.1
 - Small update to add bitcode support
 - Renamed internal SAAd object members to be shorter

5.5.0
 - Refactored click handlging to now ignore null click urls
	- ads that now have a null click url won't fire either the parental gate or any associated click urls (for video, for example). 
	- refactored the web processror (SAProcessHTML) to ignore null click urls
	- improved the web view (SAWebView) to ignore urls like "about:blank"
	- refactored the "click" method of banner, interstitial & video ads to now contain the ad index (from the ad resoonse) and the destination. Now all methods more or less do the same thing and have the same structure. It's up to either the web view or the vast part to provide a valid click url, if it's available.
 - Refactored the CPI part in a separate library called SACPI (sa-mobile-lib-ios-cpi). 
	- Created a SAOnce class to make sure the CPI events are fired just once in the application's lifetime.
	- Created a SAInstall class that deals with sending the /install event to the ad server
	- SACPI is now a singleton
	- The library can be imported separately by advertisers if they just want to measure their installs, but don't want the full SDK
	- The library has now become a dependency of the main SDK. All previous CPI classes in the SDK have been removed
 - Improved the tag handling code to try to replace less characters in the tag so that more tags will work
 - Reverted back the 15s close button change done in 5.4.2. Video ads have a hidden close button by default, that shows up at the end of the ad playing routine. It can be set to be visible from the start.
 - Changes to event handling:
    - Removed firing of all "impression" events for banner, interstitial & app wall ads (these are fired by the server). For video the "impression" event is still fired, but that's taken from the VAST tag, so it's OK.
    - Removed firing of all "install" events for ads
    - Removed firing of all "clickCounter" events for ads
    - Removed the VAST "custom_clicks" events alltogether
    - Renamed the "sourceBundle" query parameter to "bundle"
    - Renamed events with either "superawesome_viewable_impression" or "vast_creativeView", etc. 
 - Removed the method that determines whether to show a padlock or not. It's not controlled by an ad's "showPadlock" member 
 - Fixed a bug in the Unity & AIR plugins that meant that loading and then quickly closing a banner would have unintended consequences.


5.4.2
5.4.1
 - Fixed a bug that made interstitial, video & app wall ads cause problems when ordered to display strictly in landscape or portait mode but the app didn't actually support those orientation modes. Now the ads will just try to match the possible orientation modes offered by the app when they can't display in the desired way.
 - Banner ads don't fire up an "adClosed" event on first load
 - The video ad close button will appear by default after 15 seconds of content playing, meaning that disabling the close button will have effect only for the first 15 seconds of play, or for ads shorter than 15 seconds. The close button will appear once the ad has ended nonetheless in that scenario. 
 - Updated the MoPub plugin to handle "adAlreadyLoaded" and "adEnded" events

5.4.0
 - Refactored the SAWebPlayer class to load & display HTML content at a 1:1 ratio. Then that gets scaled using Matrix transforms to the desired width & height to fit a container properly. This means that ad scaling will not happen in HTML anymore, but in native code.
 - Refactored the SABannerAd & SAInterstitialAd classes to use the new web player and to not reload data on screen rotations, etc.
 - Refactored the SABannerAd class to close an existing ad if a subsequent "load" method is called so as to reset the ad and keep a consistent visiual & internal state.
 - Refactored the SAWebPlayer click mechanism to be more simple and avoid a series of potential JavaScript issues. Now there are simply no briges between the underlining web view and native code.
 - Refactored the ad loader SAProcessHTML class to output simple encapsulating HTML for image, rich media and tag ads.
 - Added support for the adEnded event, fired when a video ad ends (but not necessarily closes)
 - Added support for the adAlreadyLoaded event, fired when an Insterstial, Video or AppWall tries to load ad data for an already existing placement
 - Added support for the clickCounterUrl; that's been added as part of the native Ad Creative model class and is now fired when a user clicks an ad.  

5.3.17
 - Refactored the SuperAwesome CPI code to add a callback that informs the SDK user if an install was recognized as successful by the Ad Server.
 - Made the Video ad close button appear at the end of the ad, if it's set to be invisible and the ad is set not to automatically close at the end. This removes an issue where if you disable both the close button and auto-close at end, the video would never be closed. This also improves the experience
with regards to rewarded videos since now you can trigger your reward UI while still having the video
 in the background.
 - Refactored some of the SuperAwesome libraries that go in supporting the main SDK
 	- SANetworking added a new class that downloads files from a list, sequentially
	- SAVASTParser was updated and now recursively parses VAST tags
 	- SAAdLoader had the VAST & AppWall loading classes removed. Now it depends on SAVASTParser to figure out a VAST tag and the sequential file list downloader to get AppWall data
 	- SAModelSpace added two classes needed for VAST parsing: SAVASTAd and SAVASTMedia
    	- Removed VAST elements from the SAAd model class, since now they're contained in SAVASTAd and SAVASTMedia. SAAd models are not associated with VAST and the VAST parser will not try to produce a SAAd model, but a SAVASTAd model.
	- Added static inline functions to parse integer or string values into enum values or vice-verse. This has taken the burden of getting correct enum values from JSON / Models to the enum (functions), not the parsers.
 	- SAEvents was simplified in relation to handling MOAT
 	- SAUtils now has SAAlert and SALoadingScreen as classes (same for Android)
 	- Small refactoring for the AIR, Unity & MoPub plugins
	- Renamed a lot of callbacks used by the SDK to include the "sa" particle at the start (so as not to have conflicts with other block definitions) and follow the "saDidDoThisOrThat" pattern.
	- Renamed a lot of enums to contain the "SA_" particle so as not to have conflicts with other C enum definitions.
 - Added, updated or improved tests for:
	- SANetworking
	- SAModelSpace
	- SAAdLoader 
	- SAEvents
	- SAUtils
 - Added comments to each library and SDK file

5.3.16
 - Updated the AIR & Unity plugins to be more modular. That means that in both of them the code is not bundled any more into one big class or file, but split into multiple classes / files, such as SAAIRBannerAd, SAUnityVideoAd, etc. This not only spearates concerns but also makes it more manageable and easier to spot errors.
 - The AIR & Unity plugins can now override the main SDK version & sdk type. Meaning that when bundled as part of any of those SDKs, the Android SDK will report as "air_x.y.z." or "unity_x.y.z" instead of "ios_x.y.z". This makes reporting so much more accurate.

5.3.15
 - Made the Video ad close button invisible by default. Developers will now actively have to enable it in our SDK. In historical cases where this has been a problem it will mean an increased VCR rate.
 - Refactored the way the SDK works with default values. A default "SDK state" is now stored by the main SuperAwesome singleton. This dictates banner background color, default orientation, whether the close button is visible or not on video and all types of default values for everything that is customizable.
 - Refactored the AIR & Unity plugins to be more robust and do more error checking and to use default values in case any of the plugins don't somehow send values.
 - Refactored the MoPub plugin to be more robust and do more error checking. 
 - Updated dependencies

5.3.11
5.3.10
5.3.9
 - Updated dependencies
 - Now all depdnencies should have "safe" imports, meaning that it will work with static libs or frameworks and it won't break
 - Also all the main SDK files have the same "safe" import type

5.3.8
 - Improved the way fullscreen ads (videos, interstitials and appwalls) return to the controller they were created in by making them remember if the status bar vas visible / invisible and return to that. By default our ads don't show a status bar and there was also a bug that allowed the parent VC, even if it did not have a status bar, to be returned to and display a status bar.

5.3.7
 - Updated the SALoader dependency to 0.8.5
 - This moves SAUtils.h header imports from SALoader.h to SALoader.m; 
 - Moved more external .h imports from SuperAwesome header files to .m files;
 - These moves will make the SDK be able to be correctly imported in projects that have both Swift and Objective-C and are integrated via CocoaPods (with use_frmeworks!)

5.3.6
 - Updted the SALoader dependency to 0.8.4
 - This fixes a bug that casued all invalid ads (empty, null, etc) to have gamewall type by default, instead of invalid

5.3.5
 - Added generic setters for each of the properties needed to configure loading & playing for banners, interstitials, videos and app wall
 - Banners: 
   - load parameters: test mode, configuration (production or staging)
   - play parameters: parental gate, background color
 - Interstitials:
   - load parameters: test mode, configuration (production or staging)
   - play parameters: parental gate, orientation (any, portrait, landscape)
 - Videos: 
   - load parameters: test mode, configuration (production or staging)
   - play parameters: parental gate, orientation (any, portrait, landscape), close button, auto close, small click button
 - App Wall:
   - load parameters: test mode, configuration (production or staging)
   - play parameters: parental gate

5.3.4
 - Added the new Adobe AIR plugin. This will connect with the SuperAwesome Adobe AIR SDK to provide native support for iOS apps built with Adobe AIR
 - It supports all the ad formats, including SAAppWall 

5.1.0
 - Added SAAppWall as a new ad format that's supported by the SDK

5.0.0
 - Base version 5
 - Added new publisher interface for SABannerAd, SAInterstitialAd, SAVideoAd
 - In this new version each type of ad is responsbile for loading & playing the ad unit
 - Also, onse an ad has been played, it has to be loaded again

