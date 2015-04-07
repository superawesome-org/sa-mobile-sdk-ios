//
//  ATInterstitialViewDelegate.h
//  ADTECHMobileSDK
//
//  Created by ADTECH AG on 11/24/11.
//  Copyright (c) 2011 ADTECH AG. All rights reserved.
//
//  www.adtech.com 
//

#import <Foundation/Foundation.h>

@class ATInterstitialView;
@class ATBrowserViewController;

/**
 * Defines the interface the delegate of an interstitial ads
 *
 * @since 1.0
 */
@protocol ATInterstitialViewDelegate <NSObject>

/**
 * The ad was hidden from view. It gets called either when the ad is dismissed by the user or the refresh timer fires for the ad.
 * You should take down the interstitial ad from the screen at this time.
 *
 * @since 1.0
 *
 * @param view The interstitial ad view that was shown.
 *
 * @note You must implement and take action when this method is called on the delegate.
 */
- (void)didHideInterstitialAd:(ATInterstitialView*)view;

@optional

/**
 * Called when the interstial ad is fetched from a campaign and available to be displayed.
 * You should put up the ad on the screen at this time.
 *
 * @since 1.0
 *
 * @param view The interstitial ad view that fetched the ad.
 *
 * @see didSuccessfullyFetchInterstitialAd:signals:
 */
- (void)didSuccessfullyFetchInterstitialAd:(ATInterstitialView*)view;

/**
 * Called when the interstial ad is fetched from a campaign and available to be displayed.
 * You should put up the ad on the screen at this time.
 *
 * It includes the signals that came within the ad. In case this method is implemented,
 * it takes precedence over didSuccessfullyFetchInterstitialAd: and will be the only one called.
 *
 * @since 3.5
 *
 * @param view The interstitial ad view that failed getting an ad.
 * @param signals The interstitial ad view that fetched the ad. In case there were no signals with the ad, the value will be nil.
 *
 * @see didSuccessfullyFetchInterstitialAd:
 */
- (void)didSuccessfullyFetchInterstitialAd:(ATInterstitialView*)view signals:(NSArray *)signals;

/**
 * Called when the server sends back a custom mediation event instead of an ad. This is an opportunity for your application
 * to perform an action instead of showing an ADTECH provided interstitial, like showing an ad using another SDK you use.
 * The campaign can be configured server-side to allow custom mediation with a certain fill-rate.
 * Once your app receives this callback, the SDK will not display an interstitial and hands over control to the application.
 * The app can perform any kind of action it wants, not necessarily mediation related.
 *
 * @param view The interstitial ad view that fetched the ad.
 *
 * @since 3.2
 *
 * @see [ATBannerViewDelegate didStopOnCustomMediation:]
 */
- (void)didFetchCustomMediation:(ATInterstitialView*)view;

/**
 * Called when an ad fails to be fetched. Usually this happens because of networking conditions and in rare cases if an exceptions occurs on the server.
 * You can call load to try again, if you think the conditions leading to the error have changed.
 *
 * @warning Use didFailFetchingInterstitialAd:signals:error: to see the error for fething the interstitial.
 *
 * @since 1.0
 *
 * @param view The interstitial ad view that failed getting an ad.
 *
 * @see didFailFetchingInterstitialAd:signals:
 * @see didFailFetchingInterstitialAd:signals:error:
 */
- (void)didFailFetchingInterstitialAd:(ATInterstitialView*)view;

/**
 * Called when an ad fails to be fetched. Usually this happens because of networking conditions and in rare cases if an exceptions occurs on the server.
 * You can call load to try again, if you think the conditions leading to the error have changed.
 *
 * It includes the signals that came within the ad. In case this method is implemented,
 * it takes precedence over didFailFetchingInterstitialAd: and will be the only one called.
 *
 * It is possible to get signal codes on failures to fetch an ad when the server responds
 * with a default ad that contains these signal codes. Default ads are considered failures to get
 * a valid ad, but they could contain signal codes that could be useful for the app.
 *
 * @warning Use didFailFetchingInterstitialAd:signals:error: to see the error for fething the interstitial.
 *
 * @since 3.5
 *
 * @param view The interstitial ad view that failed getting an ad.
 * @param signals The signals that were sent with the ad. In case there were no signals with the ad, the value will be nil.
 *
 * @see didFailFetchingInterstitialAd:
 * @see didFailFetchingInterstitialAd:signals:error:
 */
- (void)didFailFetchingInterstitialAd:(ATInterstitialView*)view signals:(NSArray *)signals;


/**
 * Called when an ad fails to be fetched. Usually this happens because of networking conditions and in rare cases if an exceptions occurs on the server.
 * You can call load to try again, if you think the conditions leading to the error have changed.
 *
 * It includes the signals that came within the ad. In case this method is implemented,
 * it takes precedence over didFailFetchingInterstitialAd: and will be the only one called.
 *
 * It is possible to get signal codes on failures to fetch an ad when the server responds
 * with a default ad that contains these signal codes. Default ads are considered failures to get
 * a valid ad, but they could contain signal codes that could be useful for the app.
 *
 * This callback also includes the error on what has caused the ad to fail loading.
 *
 * @since 3.6
 *
 * @param view The interstitial ad view that failed getting an ad.
 * @param signals The signals that were sent with the ad. In case there were no signals with the ad, the value will be nil.
 * @param error The error that caused the interstitial to fail fetching
 *
 * @see didFailFetchingInterstitialAd:
 * @see didFailFetchingInterstitialAd:signals:
 */
- (void)didFailFetchingInterstitialAd:(ATInterstitialView*)view signals:(NSArray *)signals error:(NSError *)error;

/**
 * Called when the user interaction with the ad triggers leaving the application.
 * This can be, for example, opening a URL in Safari or Maps or another application registered to handle the URL specified by the ad.
 * You should save the state of the application when you get this call.
 *
 * @since 1.0
 *
 * @param view The ad view that triggered leaving the application.
 *
 * @warning *Important:* If a request fails the SDK stops fetching ads until you call [ATInterstitialView load] again. See the logs in order to know the reason for the error.
 *
 * @see ATInterstitialView load
 *
 */
- (void)willLeaveApplicationForInterstitialAd:(ATInterstitialView*)view;

/**
 * Called when the ad will try to show a landing page after user tapped it.
 *
 *
 * @param view The interstitial ad view that had control of the screen.
 * @param URL The URL that needs to be loaded.
 * @param browserViewController Your custom browser view controller that needs to inherit ATBrowserViewController class.
 * @return Return YES if you want to show the landing page at this time.
 *         Return NO if you plan on showing the landing page yourself at a later time.
 *
 * @see ATBrowserViewController
 *
 * @warning If you return 'nil' on 'browserViewController' param, the SDK will use it's own mechanism to open the 'URL' param.
 *
 * @since 3.4
 */
- (BOOL)shouldOpenLandingPageForAd:(ATInterstitialView*)view withURL:(NSURL*)URL useBrowser:(ATBrowserViewController *__autoreleasing *)browserViewController;

@end
