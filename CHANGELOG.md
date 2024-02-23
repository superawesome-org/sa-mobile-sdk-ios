## [9.0.1](https://github.com/superawesome-org/sa-mobile-sdk-ios-private/compare/v9.0.0...v9.0.1) (2023-05-31)


### Bug Fixes

* **IV:** Add option to show close button on adEnded if it is set to hidden ([#29](https://github.com/superawesome-org/sa-mobile-sdk-ios-private/issues/29)) ([ed2207a](https://github.com/superawesome-org/sa-mobile-sdk-ios-private/commit/ed2207af145475874a11943abe1958759177bde6))
* **UserAgent:** Corrected the User Agent string for iPads and fixed the missing user agent string in Moya. ([#30](https://github.com/superawesome-org/sa-mobile-sdk-ios-private/issues/30)) ([031533a](https://github.com/superawesome-org/sa-mobile-sdk-ios-private/commit/031533a1386e558b426509bc431a753577532f9d))
* **Video:** Added additional checks for downloaded videos before attempting to play. ([#31](https://github.com/superawesome-org/sa-mobile-sdk-ios-private/issues/31)) ([7bd47b5](https://github.com/superawesome-org/sa-mobile-sdk-ios-private/commit/7bd47b57fb13cd402195dce2b4dbb34eb4ace4a9))

# [9.0.0](https://github.com/superawesome-org/sa-mobile-sdk-ios-private/compare/v8.6.0...v9.0.0) (2023-05-18)


### Bug Fixes

* **ManagedAd:** Corrected the close behaviour for Ads when close video at end is disabled. ([#11](https://github.com/superawesome-org/sa-mobile-sdk-ios-private/issues/11)) ([2843a8b](https://github.com/superawesome-org/sa-mobile-sdk-ios-private/commit/2843a8b02946fa9045274db69b02f673702996b7))
* **Video:** Added the ability to load direct "vast" videos as they do not load and play ([#9](https://github.com/superawesome-org/sa-mobile-sdk-ios-private/issues/9)) ([4606621](https://github.com/superawesome-org/sa-mobile-sdk-ios-private/commit/46066213a34964ed14be7ae6efa7a74a59ea3ef5))
* **Video:** Fixed Extraneous Celtra call when loading a VPAID Ad ([#13](https://github.com/superawesome-org/sa-mobile-sdk-ios-private/issues/13)) ([708b00b](https://github.com/superawesome-org/sa-mobile-sdk-ios-private/commit/708b00b9e571e0e6769fbd9e3e00b21c596b9b28))
* **Video:** Moved play code for videos so that the video starts to play on appear instead of view did load ([#20](https://github.com/superawesome-org/sa-mobile-sdk-ios-private/issues/20)) ([ebd1ee8](https://github.com/superawesome-org/sa-mobile-sdk-ios-private/commit/ebd1ee8d3bfd8294218124ec216eff78c6d8f1af))
* **Video:** Removed margins around videos and webviews so that Ads fill the screen better. ([#17](https://github.com/superawesome-org/sa-mobile-sdk-ios-private/issues/17)) ([ed3c20e](https://github.com/superawesome-org/sa-mobile-sdk-ios-private/commit/ed3c20e3792ae7dfd12ab7fe895f1e5a81b55198))
* **Video:** Removed the gradient from videos and made the ad counter darker. ([ac8ee7f](https://github.com/superawesome-org/sa-mobile-sdk-ios-private/commit/ac8ee7f910ae22d7e5840a623983e4e96ecc748d))
* **Video:** Vast tag nil handlers ([#14](https://github.com/superawesome-org/sa-mobile-sdk-ios-private/issues/14)) ([2fdb1a5](https://github.com/superawesome-org/sa-mobile-sdk-ios-private/commit/2fdb1a5b68974e21f608bca4cf08f8fb8a3dbea1))


### Features

* **UITesting:** Added tests around parental gate and banner edge cases ([#5](https://github.com/superawesome-org/sa-mobile-sdk-ios-private/issues/5)) ([adce2d8](https://github.com/superawesome-org/sa-mobile-sdk-ios-private/commit/adce2d8fc306a5160ea0a12ab32c613e9e4778d2))


### Performance Improvements

* **CI:** Fixed CI issues ([#19](https://github.com/superawesome-org/sa-mobile-sdk-ios-private/issues/19)) ([2e70088](https://github.com/superawesome-org/sa-mobile-sdk-ios-private/commit/2e70088d3eff077ad6ac528a09b938468e1f1ced))
* **Release:** Updated Major version to bring code into line with other SDKs ([#18](https://github.com/superawesome-org/sa-mobile-sdk-ios-private/issues/18)) ([aa7e639](https://github.com/superawesome-org/sa-mobile-sdk-ios-private/commit/aa7e6398ebc7470ba88b10b12837b68e002613ad))


### BREAKING CHANGES

* **CI:** Updating version number to be inline with Android SDK, there are no breaking changes in this version.

# [8.6.0](https://github.com/superawesome-org/sa-mobile-sdk-ios/compare/v8.5.7...v8.6.0) (2023-04-19)


### Bug Fixes

* **Bumper:** calling dismiss on the presenting viewcontroller if one exists and cleaning up the timer ([#292](https://github.com/superawesome-org/sa-mobile-sdk-ios/issues/292)) ([a88f15c](https://github.com/superawesome-org/sa-mobile-sdk-ios/commit/a88f15c61c83d088162f2993682655cc36e999ac))
* **CI:** Locked in Circle CI macos.x86.medium.gen2 resource class ([#279](https://github.com/superawesome-org/sa-mobile-sdk-ios/issues/279)) ([8e18233](https://github.com/superawesome-org/sa-mobile-sdk-ios/commit/8e182334d7260ac4b40ff22df0ffeabb8f310d59))
* **Interactive Video:** Added Video Leave Warning dialog and close at end option to IV. ([#280](https://github.com/superawesome-org/sa-mobile-sdk-ios/issues/280)) ([a7d38a8](https://github.com/superawesome-org/sa-mobile-sdk-ios/commit/a7d38a8674753ead80de61873a149d4d8d6168d0))
* **InteractiveVideo:** Added Player end and pause events and play and resume methods to the Managed Ad View ([#290](https://github.com/superawesome-org/sa-mobile-sdk-ios/issues/290)) ([9f53899](https://github.com/superawesome-org/sa-mobile-sdk-ios/commit/9f53899cb736d60b6a44b8bc3bf653d02e694608))
* **Settings:** Added a settings screen to the test app for testing. ([#284](https://github.com/superawesome-org/sa-mobile-sdk-ios/issues/284)) ([5dcd9ce](https://github.com/superawesome-org/sa-mobile-sdk-ios/commit/5dcd9ceb9c8662186961a3d0b1eb283bcc5c120b))
* **Test Ads:** Made the duration parameter optional in the Decodable object ([#283](https://github.com/superawesome-org/sa-mobile-sdk-ios/issues/283)) ([2fbf955](https://github.com/superawesome-org/sa-mobile-sdk-ios/commit/2fbf955b82d4bb8d0918563ddf632c0bbcaa8ba4))


### Features

* **Network:** Adds retry mechanism for the failed networking requests ([#278](https://github.com/superawesome-org/sa-mobile-sdk-ios/issues/278)) ([a7a43d6](https://github.com/superawesome-org/sa-mobile-sdk-ios/commit/a7a43d6df11f1307d277341bf677cfb796d74f7b))

## [8.5.7](https://github.com/superawesome-org/sa-mobile-sdk-ios/compare/v8.5.6...v8.5.7) (2023-03-15)


### Bug Fixes

* **Unity:** Removed Unity files as these are now moved to the Unity Repo ([#274](https://github.com/superawesome-org/sa-mobile-sdk-ios/issues/274)) ([732bdf8](https://github.com/superawesome-org/sa-mobile-sdk-ios/commit/732bdf8aa5f2a80108dabe846cfbe118ddf48bdf))

## [8.5.6](https://github.com/superawesome-org/sa-mobile-sdk-ios/compare/v8.5.5...v8.5.6) (2023-02-28)


### Bug Fixes

* **IV Close Button:** Added configuration methods to control the display of the close button ([#270](https://github.com/superawesome-org/sa-mobile-sdk-ios/issues/270)) ([c81a6bc](https://github.com/superawesome-org/sa-mobile-sdk-ios/commit/c81a6bcd170a552ca4b0a4a82413df3e0c44d86e))

## [8.5.5](https://github.com/superawesome-org/sa-mobile-sdk-ios/compare/v8.5.4...v8.5.5) (2023-02-23)


### Bug Fixes

* AdMob custom adapters so that the correct events are passed through the admob plugin from the awesome ads sdk ([#264](https://github.com/superawesome-org/sa-mobile-sdk-ios/issues/264)) ([384aa72](https://github.com/superawesome-org/sa-mobile-sdk-ios/commit/384aa724540a9708732024bcd46d7b3cd8c546c6))
* **Networking:** AAG-2861: Changed the caching policy on all network requests made by the SA SDK to ignore cache on both local and remote. ([#266](https://github.com/superawesome-org/sa-mobile-sdk-ios/issues/266)) ([91e6a56](https://github.com/superawesome-org/sa-mobile-sdk-ios/commit/91e6a563b03208d5a04d52fd83a681b607f07824))

## [8.5.4](https://github.com/superawesome-org/sa-mobile-sdk-ios/compare/v8.5.3...v8.5.4) (2023-02-17)


### Bug Fixes

* **VideoAd:** updated the loading / play and hasAdAvailable methods for consistency ([#262](https://github.com/superawesome-org/sa-mobile-sdk-ios/issues/262)) ([7325d5b](https://github.com/superawesome-org/sa-mobile-sdk-ios/commit/7325d5b3ebc9ded6eee5594c2693a63443dfe068))

## [8.5.3](https://github.com/superawesome-org/sa-mobile-sdk-ios/compare/v8.5.2...v8.5.3) (2023-02-16)


### Bug Fixes

* Added wrapper methods for obj-c / Unity compatibility ([#259](https://github.com/superawesome-org/sa-mobile-sdk-ios/issues/259)) ([16bc985](https://github.com/superawesome-org/sa-mobile-sdk-ios/commit/16bc985c663a97739634157f78f9d2570894d850))
* **CI:** Added Tag format to semantic release ([#251](https://github.com/superawesome-org/sa-mobile-sdk-ios/issues/251)) ([6106dd7](https://github.com/superawesome-org/sa-mobile-sdk-ios/commit/6106dd706a7551b50a17231b00ce10d7251610c2))
* **CI:** Fixed missing git pull step for semantic release ([#258](https://github.com/superawesome-org/sa-mobile-sdk-ios/issues/258)) ([0a327b8](https://github.com/superawesome-org/sa-mobile-sdk-ios/commit/0a327b85ed9f7b5ad810153375fafdd081b6f662))
* **version:** Fixed version number in podspec ([#256](https://github.com/superawesome-org/sa-mobile-sdk-ios/issues/256)) ([41cdb50](https://github.com/superawesome-org/sa-mobile-sdk-ios/commit/41cdb500b97270ac32e2eab9f7b158dd01f30c4c))

CHANGELOG
=========

8.5.2
 - Update AdMob plguin to use latest AdMob MediationAdapter
 - Update BannerView layout positioning
 - Update API decoding for Ad models
 - Update Unity plugin and convert ObjC++ to ObjC

8.5.1
 - Update AdMob plugin

8.5.0
 - Added a functionality to video ads to mute audio on the start

8.4.1
 - Fix SDK version information on non framework builds
 - Added an optional confirmation dialog when closing the ad

8.4.0
 - Added new functionality to display close button immediately for the interstitial ads

8.3.10
 - Fix compile issue on iOS 16 where it restricts adding available annotation to stored properties

8.3.9
 - Fix multiple click event is being sent to listener
 - Update objc annotation for AwesomeAds class

8.3.8
 - Fix for missing events in the AdController callback

8.3.7
 - Added constraint fixes for the video player

8.3.6
 - Updated iOS Unity plugin to account for iOS refactor
 - Added support for multiple ID placement loading
 - Added support for setting custom parameters in SDK initialisation for event tracking
 - Added support for immediate close button showing
 
8.3.5
 - Refactor: video player flow to only Swift
 - Refactor: expose SDK version information
 - Refactor: update access modifiers for Creative object
 - Fix: sending dwell time events correctly on iOS
 
8.3.4
 - Exposed the payload property on the Creative object

8.3.3
 - Fix occasional sizing issues with AwesomeVideoFullscreenPlayer.swift

8.3.2
 - Fix Unity plugin for banner ads

8.3.1
 - Add JavaScript bridge to receive events from WebView sources

8.3.0
 - Fix showing KSF safe ad logos properly
 - Fix Interstitial via KSF ads not loading
 - Complete VPAID support
 - Fix double encoding for event names
 - Update internal dependencies

8.1.6
 - Add VPAID support
 - Fix unit tests
 - Add tracking logs
 - Add safe ad approved placements to Demo App
 - Fix safe ad logo appearances

8.1.5
- Add tracking logs
- Update SwiftyXml
- Fix double encoding and incorrect event names
- Fix SuperAwesomeUnityBumperOverrideName

8.1.4
- SwiftyXml changes

8.1.3
- Add support for additional video overlay views

8.1.2
- Remove aspect ratio

8.1.1
- Added initial implementation of SKADNetwork
- Fixed SDK version being passed through in the request 
- Updated Dwell Time metric from custom metric to standard metric

8.0.8
 - Added Dwell Time
 - Cleaned up and updated dependencies across the board, including Admob and Mopub
 - Fixed viewable impression calculation
 - Added support for new formats: 3rd party display and interstitials
 - Removed ASIdentifier wholely from the project. The code was not in use. 
 - Initial functionality added for selection of a specific creative based on request parameters

7.2.10
 - Removed IDFA and AdSupport framework from the codebase
 
7.2.9
 - Moved Moat library to it's own module

7.2.8
 - Release MoPub Adapter 
 - Add SDK metric info
 
7.2.7
 - Added support for AdMob
 - Separated AdMob into its own podspec
 
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
 - Also, once an ad has been played, it has to be loaded again
