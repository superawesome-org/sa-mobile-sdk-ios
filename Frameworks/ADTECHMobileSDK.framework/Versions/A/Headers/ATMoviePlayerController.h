//
//  ATMoviePlayerController.h
//  ADTECHMobileSDK
//
//  Created by ADTECH GmbH on 4/18/12.
//  Copyright (c) 2012 ADTECH GmbH. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>

@class ATVideoAdConfiguration;
@class ATVASTDocument;
@class ATBrowserViewController;
@protocol ATMoviePlayerDelegate;

/**
 * Movie player that allows for VAST compliant advertisement. Depending on the configuration provided
 * ads will be fetched and presented during the playback of the video content.
 * Currently, linear videos are supported (pre-roll, mid-roll and post-roll video ads).
 *
 * The ATMoviePlayerController can be used as a normal movie player controller that will introduce
 * ads during playback of the video content as configured.
 *
 * @since 2.2
 *
 * @warning: *You must call stop before releasing the movie player on iOS 4.3 or earlier*
 */
@interface ATMoviePlayerController : MPMoviePlayerController

/**
 * The delegate gets notified of different ad events in the lifecycle of the movie player.
 *
 * @since 3.4
 *
 * @see ATMoviePlayerDelegate
 */
@property (nonatomic, weak) id<ATMoviePlayerDelegate> delegate;

/**
 * The configuration specifies the placement details used for serving ads and the type of ads to be presented.
 *
 * @since 2.2
 */
@property (nonatomic, strong) ATVideoAdConfiguration *configuration;

/**
 * The view controller that is the presenter of the video being shown. It is used to present modally screens when the user
 * engages and interacts with the shown ads.
 *
 * @since 2.2
 *
 * @warning *You must set this property before calling play. Ads won't get loaded without this property being set.*
 */
@property (nonatomic, weak) UIViewController *presentingViewController;

/**
 * The view used to show the linear ads.
 * You can use this property to place overlays, like a custom countdown, on top of the linear ads.
 * The same view is used when both in fullscreen and windowed mode.
 *
 * @note This API replaces the previously available fullscreenView, removing the need to perform conditional logic
 * when moving between fullscreen and windowed mode.
 *
 * @since 3.5.4
 */
@property (nonatomic, readonly) UIView *linearAdView;

/**
 * Fetches the parsed VAST document for the provided configuration and ad type. If successful, you are provided
 * the root of the VAST document as specified by http://www.iab.net/media/file/VASTv3.0.pdf
 *
 * @param configuration The video configuration to use. If you want companion ads to be served with linear one, please
 *                      add the companion positions to the configuration and request a linear ad type.
 * @param adTypeFlags   The combination of ad types you want fetched: pre-roll, mid-roll, post-roll, overlay and companions.
 *                      The companions are only valid when paired with linear ads. They are ignored for overlays.
 *                      <br/>It is invalid to combine more than one linear or linears with overlays.
 *                      There should be only one linear, optionally with companions, or an overlay.
 * @param completion    The completion block to call when the request is successfully completed.
 *                      The block is provided the parsed document as parameter.
 * @param failure       The block to execute in case the request doesn't go well. The error reason is provided as parameter.
 *
 * @note    The configuration is used for campaign identification. The ad types enabled on the configuration are ignored.
 *          Use the adTypeFlags parameter to specify which ad types you want fetched.
 *
 * @since 3.4
 */
+ (void)fetchVASTModelWithConfiguration:(ATVideoAdConfiguration*)configuration
                        withAdTypeFlags:(ATVideoAdType)adTypeFlags
                    withCompletionBlock:(void(^)(ATVASTDocument *document))completion
                       withFailureBlock:(void(^)(NSError *error))failure;

/**
 * Call this method when you want the movie player to open a landing page URL. You would normally use this method
 * only when you want to delay presenting a landing page in order to perform some processing or getting permission first.
 *
 * You would return NO on the shouldOpenLandingPageWithURL:useBrowser: callback, store the URL and when the processing is done
 * or you get permission, you can feed back the URL into the SDK to show the landing page using this method.
 *
 * @since 3.4
 *
 * @param URL The URL that you got on the shouldOpenLandingPageWithURL:useBrowser: callback
 * @param browserViewController A custom in-app browser that will be used to present the landing page.
 *                              In case you want the SDK to use its own default in-app browser, pass in nil here.
 *
 * @warning *Your custom browser will be used to open only web page URLs.*
 */
- (void)openLandingPageWithURL:(NSURL*)URL useBrowser:(ATBrowserViewController*)browserViewController;

@end
