//
//  ATMoviePlayerDelegate.h
//  ADTECHMobileSDK
//
//  Created by ADTECH GmbH on 10/24/13.
//  Copyright (c) 2013 ADTECH GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ATBrowserViewController;

extern NSString *const kATCompanionTop;                         /// the companion top ad key
extern NSString *const kATCompanionLeft;                        /// the companion left ad key
extern NSString *const kATCompanionBottom;                      /// the companion bottom ad key
extern NSString *const kATCompanionRight;                       /// the companion right ad key

/**
 * The key for the display requirements of the companions
 * The possible values stored for this key are enumerated in ATVASTCompanionDisplayRequirement
 *
 * @since 3.6
 */
extern NSString *const kCompanionDisplayRequirement;


/**
 * Implement this protocol to be notified of different events in the lifecycle of the movie player.
 *
 * @since 3.4
 */
@protocol ATMoviePlayerDelegate <NSObject>
@optional

/**
 * Called when a video ad tries to show a landing page, giving you the chance to allow or deny it.
 * You can also provide your own custom implementation for the In-App browser used.
 *
 * @since 3.4
 *
 * @param URL The URL that needs to be loaded
 * @param browserViewController Your custom browser view controller that needs to inherit ATBrowserViewController class
 * @return Return YES if you want to show the landing page at this time.
 *         Return NO if you plan on showing the landing page yourself at a later time, using [ATMoviePlayerController openLandingPageWithURL:useBrowser:]
 *
 * @see ATBrowserViewController
 *
 * @discussion If you don't set the 'browserViewController' parameter, the SDK will use its own in-app browser for WEB URLs.
 *             If the URL type is Native or InApp (like an AppStore URL that will show SKStoreProductViewController on iOS 6.0 or greater), 
 *             the SDK will use its own mechanism to open it.
 *             You can provide your own in-app browser like this:
 *
 * <pre><code>
 *   - (BOOL)shouldOpenLandingPageWithURL:(NSURL*)URL useBrowser:(ATBrowserViewController *__autoreleasing *)browserViewController
 *   {
 *      &emsp;&emsp;MyCustomInAppBrowser *browser = [[ MyCustomInAppBrowser alloc] initWithURL:URL nibName:nil bundle:nil];
 *      &emsp;&emsp;*browserViewController = browser;
 *
 *      &emsp;&emsp;return YES;
 *   }
 * </code></pre>
 */
- (BOOL)shouldOpenLandingPageWithURL:(NSURL*)URL useBrowser:(ATBrowserViewController *__autoreleasing *)browserViewController;

/**
 * Called when the player is about to start playback of a linear ad.
 *
 * @param type The linear ad type
 *
 * @since 3.4
 */
- (void)playerWillStartPlayingLinearAdOfType:(ATVideoAdType)type;

/**
 * Called when the player is about to start playback of a linear ad. It also has the companion ads that come with a linear ad.
 *
 * @param type The linear ad type
 * @param companionAds The companion ads that come with a linear ad. You can get the right companion
 *                     from the companionAds dictionary using the following constant keys:
 *                     kATCompanionTop, kATCompanionLeft, kATCompanionBottom, kATCompanionRight.
 *                     Starting 3.6, you can get the display requirements for the companions using the key: kCompanionDisplayRequirement.
 *                     See http://www.iab.net/media/file/VASTv3.0.pdf chapter 2.3.3.4 for understanding what the display requirement means.
 *
 * @discussion This callback has priority over playerWillStartPlayingLinearAdOfType:. If both of them are implemented,
 *             only this callback will be called.
 *
 *             You are responsible for holding on to the companion ad views, by either adding them to your view hierarchy
 *             or creating a strong reference to them for later use. If you don't hold on to these references, the SDK
 *             will release them after returning from this callback.
 *
 *             If you don't handle companion ads in your application, it is strongly recommended that you don't request them
 *             and implement only the playerWillStartPlayingLinearAdOfType: callback. This will allow the SDK to use resources
 *             to load and render companion ads that are not going to be used.
 *
 * @since 3.4.1
 */
- (void)playerWillStartPlayingLinearAdOfType:(ATVideoAdType)type withCompanions:(NSDictionary*)companionAds;

/**
 * Called during playback of a linear ad informing about progress. The current playback time and the total time are provided
 * so you can update your progress indicators, if any.
 *
 * The method gets called 10 times a second. It can happen that the same position is reported more than once.
 *
 * @param type          The linear ad type
 * @param currentTime   The current playhead position in seconds from the beginning of the linear ad
 * @param totalTime     The total duration of the linear ad in seconds
 *
 * @since 3.5.1
 */
- (void)playerDidProgressPlayingLinearAdOfType:(ATVideoAdType)type
                                 toCurrentTime:(NSTimeInterval)currentTime
                                   ofTotalTime:(NSTimeInterval)totalTime;

/**
 * Called when the player ends the playback of a linear ad. This can happen when the linear naturally reaches the end of its content,
 * when it is skipped, when the landing page is shown and dismissed (the remaining part of the linear is skipped) or when the player is stopped.
 *
 * @param type The linear ad type
 *
 * @since 3.4
 */
- (void)playerDidStopPlayingLinearAdOfType:(ATVideoAdType)type;

/**
 * Called when the users skips the playback of a linear ad by interacting with the skip button.
 *
 * @param type The linear ad type
 *
 * @since 3.6
 */
- (void)playerDidSkipLinearAdOfType:(ATVideoAdType)type;

/**
 * Called when the player is about to start playback of an ad break.
 *
 * @param type The linear ad type
 * @param totalAds The total number of ads the player will play
 *
 * @since 3.6
 */
- (void)playerWillStartPlayingAdBreakOfType:(ATVideoAdType)type
                                   totalAds:(NSInteger)totalAds;

/**
 * Called when the player progresses to the next ad inside an ad break.
 *
 * @param type The linear ad type
 * @param adNumber The number of the ad the player has progressed to
 * @param totalAds The total number of ads the player will play
 *
 * @since 3.6
 */
- (void)playerDidProgressPlayingAdBreakOfType:(ATVideoAdType)type
                               toAdNumber:(NSInteger)adNumber
                                   ofTotalAds:(NSInteger)totalAds;

/**
 * Called when the player ends the playback of an ad break. This can happen when the last linear ad inside the ad break
 * naturally reaches the end of its content, when the last linear in an ad break is skipped, when the landing page is 
 * shown and dismissed (the remaining part of the linear is skipped) and it is the last linear in the ad break or when the player is stopped.
 *
 * @param type The linear ad type
 *
 * @since 3.6
 */
- (void)playerDidStopPlayingAdBreakOfType:(ATVideoAdType)type;



@end
