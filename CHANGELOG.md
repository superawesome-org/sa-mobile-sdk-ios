CHANGELOG
=========

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

