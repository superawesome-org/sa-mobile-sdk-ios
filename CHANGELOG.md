CHANGELOG
=========

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

