//
//  ATCompanionViewDelegate.h
//  ADTECHMobileSDK
//
//  Created by ADTECH GmbH on 11/19/13.
//  Copyright (c) 2013 ADTECH GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Implement this protocol to be notified of different events in the lifecycle of the companion ad.
 *
 * @since 3.4.1
 */
@protocol ATCompanionViewDelegate <NSObject>
@optional

/**
 * Called when the companion ad will present its landing page. You have the chance to pause ongoing activities.
 * This is a good place to pause playback.
 *
 * @since 3.4.1
 *
 * @param view The companion ad view that presents the landing page.
 */
- (void)shouldSuspendForCompanionAd:(ATCompanionView*)view;

/**
 * Called when the companion ad is done presenting its landing page. You have the chance to resume ongoing activities.
 * This is a good place to resume playback.
 *
 * @since 3.4.1
 *
 * @param view The companion ad view that presented the landing page.
 */
- (void)shouldResumeForCompanionAd:(ATCompanionView*)view;

/**
 * Called when the companion ad wants to show a landing page, giving you the chance to allow or deny it.
 * You can also provide your own custom implementation for the In-App browser used.
 *
 * @since 3.4.1
 *
 * @param view The companion ad view that had control of the screen.
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
 *   - (BOOL)shouldOpenLandingPageForAd:(ATCompanionView*)view withURL:(NSURL*)URL useBrowser:(ATBrowserViewController *__autoreleasing *)browserViewController
 *   {
 *      &emsp;&emsp;MyCustomInAppBrowser *browser = [[ MyCustomInAppBrowser alloc] initWithURL:URL nibName:nil bundle:nil];
 *      &emsp;&emsp;*browserViewController = browser;
 *
 *      &emsp;&emsp;return YES;
 *   }
 * </code></pre>
 */
- (BOOL)shouldOpenLandingPageForAd:(ATCompanionView*)view withURL:(NSURL*)URL useBrowser:(ATBrowserViewController *__autoreleasing *)browserViewController;

@end
