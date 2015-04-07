//
//  ATBannerViewDelegate.h
//  ADTECHMobileSDK
//
//  Created by ADTECH AG on 11/9/11.
//  Copyright (c) 2011 ADTECH AG. All rights reserved.
//
//  www.adtech.com 
//

#import <Foundation/Foundation.h>
#import "ATConfigurationConstants.h"
#import "ATBannerResizeAnimation.h"

@class ATBrowserViewController;

/**
 * Implement this protocol to be notified of different events in the lifecycle of the ad.
 *
 * @since 1.0.
 */
@protocol ATBannerViewDelegate<NSObject>
@optional

/**
 * Called when the ad will take over the screen in order to give the application the chance to pause ongoing activities.
 * This is in response for user interaction with the ad.
 *
 * @since 1.0.
 *
 * @param view The ad view that will take over the screen.
 */
- (void)shouldSuspendForAd:(ATBannerView*)view;

/**
 * Called when the ad will relinquish control of the screen as a result of the user dismissing it.
 *
 * @since 1.0.
 *
 * @param view The ad view that had control of the screen.
 */
- (void)shouldResumeForAd:(ATBannerView*)view;

/**
 * Called when the ad tries to show a landing page, giving you the chance to allow or deny it.
 * You can also provide your own custom implementation for the In-App browser used.
 *
 * @since 3.4.
 *
 * @param view The ad view that had control of the screen.
 * @param URL The URL that needs to be loaded.
 * @param browserViewController An instance of your custom browser view controller. It needs to inherit the ATBrowserViewController class.
 * @return Return YES if you want to show the landing page at this time.
 *         Return NO if you plan on showing the landing page yourself at a later time.
 *
 * @see ATBrowserViewController
 *
 * @discussion If you don't set the 'browserViewController' parameter, the SDK will use its own in-app browser.
 *             You can provide your own in-app browser like this:
 *
 * <pre><code>
 *   - (BOOL)shouldOpenLandingPageForAd:(ATBannerView*)view withURL:(NSURL*)URL useBrowser:(ATBrowserViewController *__autoreleasing *)browserViewController
 *   {
 *      &emsp;&emsp;MyCustomInAppBrowser *browser = [[ MyCustomInAppBrowser alloc] initWithURL:URL nibName:nil bundle:nil];
 *      &emsp;&emsp;*browserViewController = browser;
 *
 *      &emsp;&emsp;return YES;
 *   }
 * </code></pre>
 */
- (BOOL)shouldOpenLandingPageForAd:(ATBannerView*)view withURL:(NSURL*)URL useBrowser:(ATBrowserViewController *__autoreleasing *)browserViewController;

/**
 * Called when the ad is about to resize. You could at this time rearrange your application content to make space for the resized ad.
 * If you want to animate your content being resized this a good place to do it. An ad can both grow or shrink as a result of a resize.
 * Not all ads will exercise the option of resizing. Resizing ads should be placed on screens where the application content allows rearranging or can accommodate a resized ad.
 * Even if the content is not resizing, the ad will still try to resize over the application content (until closed).
 *
 * For more control over the ad being resized, see the willResizeAd:toFrame:withBehavior: and willResizeAd:toFrame:withAnimation: callbacks.
 *
 * @since 2.0.
 *
 * @param view The ad view that is going to be resized
 * @param size The size the ad is going to be resized to
 *
 * @return The behavior to use when resizing the ad.
 *
 * @see willResizeAd:toFrame:withBehavior:
 * @see willResizeAd:toFrame:withAnimation:
 * @see didResizeAd:toSize:
 * @see didResizeAd:toBannerFrame:andAdFrame:
 *
 * @warning The ad frame will be changed automatically according to the resize parameters received from the ad.
 *          The SDK will try to place the ad at the highest possible Z order within only its direct parent view in order to cover the application content.
 *          After the ad closes, its initial frame will be restored.
 */
- (void)willResizeAd:(ATBannerView*)view toSize:(CGSize)size;

/**
 * Called when the ad is about to resize. You could at this time rearrange your application content to make space for the resized ad.
 * If you want to animate your content being resized this a good place to do it. An ad can both grow or shrink as a result of a resize.
 * Not all ads will exercise the option of resizing. Resizing ads should be placed on screens where the application content allows rearranging or can accommodate a resized ad.
 * Even if the content is not resizing, the ad will still try to resize over the application content (until closed).
 *
 * @since 3.4.
 *
 * @param view The ad view that is going to be resized
 * @param frame The frame the ad is going to be resized to, *relative to the banner's superview*
 * @param behavior The suggested behavior to use for resizing the ad. You can override this value by returning a different one.
 *
 * @return The behavior to use when resizing the ad.
 *
 * @discussion Inline behavior means the banner's frame will be adjusted to hug the ad view. The banner and the ad will have the same frame.
 *             Overlay behavior means the ad will have a different size than the banner. The ad view might extend beyond the bounds of the banner and overlap the adjacent content. The banner's frame doesn't change with the ad resizing.
 *
 * @see willResizeAd:toSize:
 * @see willResizeAd:toFrame:withAnimation:
 * @see didResizeAd:toSize:
 * @see didResizeAd:toBannerFrame:andAdFrame:
 *
 * @warning The ad frame will be changed automatically according to the resize parameters received from the ad.
 *          The SDK will try to place the ad at the highest possible Z order within only its direct parent view in order to cover the application content.
 *          After the ad closes, its initial frame will be restored.
 *
 * @note *The frame passed in, relative to the banner's superview, is correct at the time of the call. If you move the banner, the frame needs readjusting, as the ad is a subview of the banner.*
 */
- (ResizeBehavior)willResizeAd:(ATBannerView*)view toFrame:(CGRect)frame withBehavior:(ResizeBehavior)behavior;

/**
 * Called when the ad is about to resize. You could at this time rearrange your application content to make space for the resized ad.
 * If you want to animate the ad being resized this a good place to do it. An ad can both grow or shrink as a result of a resize.
 * Not all ads will exercise the option of resizing. Resizing ads should be placed on screens where the application content allows rearranging or can accommodate a resized ad.
 * Even if the content is not resizing, the ad will still try to resize over the application content (until closed).
 *
 * @since 3.4.
 *
 * @param view The ad view that is going to be resized
 * @param frame The frame the ad is going to be resized to, *relative to the banner's superview*
 * @param animation The animation parameters the resize operation will follow.
 *                  You have the opportunity to change the parameters to fit your needs.
 *                  You can set animation duration, options, other parameters and you can provide
 *                  a block with your content's animation to be performed together with the ad's resize animation.
 *                  You can also provide a completion handler.
 *                  For the available options, please see the ATBannerResizeAnimation class.
 *
 * @discussion Inline behavior means the banner's frame will be adjusted to hug the ad view. The banner and the ad will have the same frame.
 *             Overlay behavior means the ad will have a different size than the banner. The ad view might extend beyond the bounds of the banner and overlap the adjecent content. The banner's frame doesn't change with the ad resizing.
 *
 * @see willResizeAd:toSize:
 * @see willResizeAd:toFrame:withBehavior:
 * @see didResizeAd:toSize:
 * @see didResizeAd:toBannerFrame:andAdFrame:
 *
 * @warning The ad frame will be changed automatically according to the resize parameters received from the ad.
 *          The SDK will try to place the ad at the highest possible Z order within only its direct parent view in order to cover the application content.
 *          After the ad closes, its initial frame will be restored.
 *
 * @note *The frame passed in, relative to the banner's superview, is correct at the time of the call. If you move the banner, the frame needs readjusting, as the ad is a subview of the banner.*
 */
- (void)willResizeAd:(ATBannerView*)view toFrame:(CGRect)frame withAnimation:(ATBannerResizeAnimation*)animation;

/**
 * Called when the ad finished resizing to the specified size. The size is that of the ad inside the banner and
 * it might be different than the size of the banner in case the ResizeBehaviorOverlay was chosen as resize behavior.
 *
 * For backwards compatibility, the size reported here is the size of the ad, not necessarily the size of the banner.
 * If you need the banner frame, the ad's origin or both, consider using the didResizeAd:toBannerFrame:andAdFrame: callback instead.
 *
 * Of course, you could just get the frame of the view parameter.
 *
 * @since 2.0.
 *
 * @param view The ad view that is going to be resized
 * @param size The size the ad was resized to.
 *
 * @see didResizeAd:toBannerFrame:andAdFrame:
 * @see willResizeAd:toSize:
 */
- (void)didResizeAd:(ATBannerView*)view toSize:(CGSize)size;

/**
 * Called when the ad finished resizing to the specified size, providing the final banner frame and the frame of the ad.
 * If implemented, this callback takes precedence over didResizeAd:toSize:, which will not be called.
 *
 * The frame of the banner might not be the same as the frame of the ad having been resized, depending on the chosen resize behavior.
 * If the behavior is inline, the banner will be the same size as the ad.
 * If the behavior is overlay, then it is likely that the resized ad takes up space beyond the bounds of its banner.
 * This is especially likely for MRAID compliant ads, which can request being resized with an offset from their container.
 * If you want to allow such ads to temporarily cover you application content, you shouldn't be concerned with the ad frame.
 * If you want to adapt your contents' layout however, then please take into account the actual ad frame provided for correct measurements.
 *
 * @since 3.4.
 *
 * @param view The banner instance that finished resizing an ad.
 * @param bannerFrame The frame of the banner after the resize finished.
 *                    This might but be the same frame as for the ad shown inside the banner,
 *                    depending on the behavior chosen for the resize.
 * @param adFrame The frame of the ad relative to the *banner's superview*, the same reference as for bannerFrame.
 *
 * @see didResizeAd:toSize:
 * @see willResizeAd:toSize:
 * @see willResizeAd:toFrame:withBehavior:
 * @see willResizeAd:toFrame:withAnimation:
 */
- (void)didResizeAd:(ATBannerView*)view toBannerFrame:(CGRect)bannerFrame andAdFrame:(CGRect)adFrame;

/**
 * Called when the user interaction with the ad triggers leaving the application.
 * This can be, for example, opening a URL in Safari or Maps or another application registered to handle the URL specified by the ad.
 * You should save the state of the application when you get this call.
 *
 * @since 1.0.
 *
 * @param view The ad view that triggered leaving the application.
 */
- (void)willLeaveApplicationForAd:(ATBannerView*)view;

/**
 * Called when an ad is successfully fetched for the configured placement.
 * You will get one call each time a new ad is fetched successfully.
 *
 * @since 1.0.
 *
 * @param view The ad view that displays ad.
 */
- (void)didFetchNextAd:(ATBannerView*)view;

/**
 * Called when an ad is successfully fetched for the configured placement.
 * You will get one call each time a new ad is fetched successfully.
 *
 * It includes the signal codes that came within the ad. In case this method is implemented,
 * it takes precedence over didFetchNextAd: and will be the only one called.
 *
 * @since 3.5
 *
 * @see didFetchNextAd:
 *
 * @param view The ad view that displays ad.
 * @param signals The signals that were sent with the ad. In case there were no signals with the ad, the value will be nil.
 */
- (void)didFetchNextAd:(ATBannerView*)view signals:(NSArray *)signals;

/**
 * Called when the server sends back a custom mediation marker instead of an ad. This is an opportunity for your application
 * to perform an action during the lifecycle of the banner, like showing an ad through some other SDK you use.
 * The campaign can be configured server-side to allow custom mediation with a certain fill-rate.
 * Once your app receives this callback, the SDK stops getting new ads and hands over control to the application. The app can
 * perform any kind of action it needs. It is up to the application to call load again on the banner to start receiving new ads
 * (and maybe new custom mediation opportunities). During the time the banner is stopped following
 * delivery of a custom mediation event, the last ad is kept displayed. The application can choose to hide the banner until it is time
 * to resume its delivery of ads.
 *
 * @param view The ad view that displays the ads.
 *
 * @since 3.2.
 *
 * @see [ATBannerView load]
 */
- (void)didStopOnCustomMediation:(ATBannerView*)view;

/**
 * Called when an ad could not be fetched. You will get one call each time an ad failed being fetched.
 * The most common reason for failing to get an ad is connectivity issues.
 * If the configuration allows auto-refresh, a new ad is requested automatically, after a default waiting period.
 * The last shown ad (if any) remains shown until the next ad is successfully fetched.
 *
 * @since 1.0.
 *
 * @param view The ad view that displays the ads.
 *
 * @warning  Use didFailFetchingAd:signals:error: to see the error for fething the ad.
 *
 * @see [ATBannerView load]
 * @see didFailFetchingAd:signals:
 * @see didFailFetchingAd:signals:error:
 *
 */
- (void)didFailFetchingAd:(ATBannerView*)view;

/**
 * Called when an ad could not be fetched. You will get one call each time an ad failed being fetched.
 * The most common reason for failing to get an ad is connectivity issues.
 * If the configuration allows auto-refresh, a new ad is requested automatically, after a default waiting period.
 * The last shown ad (if any) remains shown until the next ad is successfully fetched.
 *
 * It includes the signal codes that came within the ad. In case this method is implemented,
 * it takes precedence over didFailFetchingAd: and will be the only one called.
 *
 * It is possible to get signal codes on failures to fetch an ad when the server responds
 * with a default ad that contains these signal codes. Default ads are considered failures to get
 * a valid ad, but they could contain signal codes that could be useful for the app.
 *
 * @since 3.5
 *
 * @param view The ad view that displays the ads.
 * @param signals The signals that were sent with the ad. In case there were no signals with the ad, the value will be nil.
 *
 * @warning Use didFailFetchingAd:signals:error: to see the error for fething the ad.
 *
 * @see [ATBannerView load]
 * @see didFailFetchingAd:
 * @see didFailFetchingAd:signals:error:
 *
 */
- (void)didFailFetchingAd:(ATBannerView*)view signals:(NSArray *)signals;

/**
 * Called when an ad could not be fetched. You will get one call each time an ad failed being fetched.
 * The most common reason for failing to get an ad is connectivity issues.
 * If the configuration allows auto-refresh, a new ad is requested automatically, after a default waiting period.
 * The last shown ad (if any) remains shown until the next ad is successfully fetched.
 *
 * It includes the signal codes that came within the ad. In case this method is implemented,
 * it takes precedence over didFailFetchingAd: and will be the only one called.
 *
 * It is possible to get signal codes on failures to fetch an ad when the server responds
 * with a default ad that contains these signal codes. Default ads are considered failures to get
 * a valid ad, but they could contain signal codes that could be useful for the app.
 *
 * This callback also includes the error on what has caused the ad to fail loading.
 *
 * @since 3.6
 *
 * @param view The ad view that displays the ads.
 * @param signals The signals that were sent with the ad. In case there were no signals with the ad, the value will be nil.
 * @param error The error that has caused the ad to fail fetching
 *
 * @see [ATBannerView load]
 * @see didFailFetchingAd:
 * @see didFailFetchingAd:signals:
 *
 */
- (void)didFailFetchingAd:(ATBannerView*)view signals:(NSArray *)signals error:(NSError *)error;

@end
