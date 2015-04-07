//
//  ATInterstitialView.h
//  ADTECHMobileSDK
//
//  Created by ADTECH AG on 11/24/11.
//  Copyright (c) 2011 ADTECH AG. All rights reserved.
//
//  www.adtech.com 
//

#import <UIKit/UIKit.h>

@class ATAdConfiguration;
@protocol ATInterstitialViewDelegate;

/**
 * Represents one interstitial ad that you place in your application at various times and places.
 * For each interstitial ad you want to display, create one instance of this class.
 * 
 * The interstitial will call the delegate when different events occur in the ad's lifecycle.
 *
 * @since 1.0
 *
 * @see ATInterstitialViewDelegate
 */
@interface ATInterstitialView : NSObject

/** 
 * The delegate gets notified of different events in the lifecycle of the ad.
 * Your presenting view controller should register itself as delegate of the ad view.
 *
 * @since 1.0
 *
 * @see ATInterstitialViewDelegate
 */
@property (nonatomic, weak) id<ATInterstitialViewDelegate> delegate;

/**
 * The view controller that is the owner of the ad view being shown.
 *
 * @since 1.0
 *
 * @warning *You must set this property before calling load. Ads won't get loaded without this property being set.*
 */
@property (nonatomic, weak) UIViewController *viewController;

/** Allows configuring the ad and specifying different parameters for better targeting.
 *
 * @since 1.0
 *
 * @see ATAdConfiguration
 */
@property (nonatomic, strong) ATAdConfiguration *configuration;

/**
 * Allows changing the background color for the interstitial.
 * The default color is clear on iOS 8 and above and white on iOS 6 and 7.
 *
 * @since 3.6
 * @see modalPresentationStyle
 */
@property (strong, nonatomic) UIColor *backgroundColor;

/**
 * Allows changing the presentation style for the interstitial.
 *
 * @note If the backgroundColor set is partially transparent, i.e. alpha is below 1, the SDK changes the presentation style
 *       to UIModalPresentationOverFullScreen on iOS 8 and above. Transparent interstitials don't work with all
 *       presentation styles. You can still change the modalPresentationStyle to something else after that.
 *
 * @since 3.6
 * @see backgroundColor
 */
@property (assign, nonatomic) UIModalPresentationStyle modalPresentationStyle;

/** 
 * Returns YES when an interstitial ad is ready to be presented.
 * The delegate's [ATInterstitialViewDelegate didSuccessfullyFetchInterstitialAd:] is called when the value switches from NO to YES.
 * Once an interstitial is presented, the value changes to NO. You need to load again in order
 * to be able to present another interstitial view.
 *
 * @since 2.0
 */
@property (nonatomic, readonly) BOOL isReady;

/**
 * Begins loading the ad. The ad should be configured before calling this method.
 * The delegate will be called on events only after this call.
 *
 * @since 1.0
 *
 * @warning *Important:* If a request fails the SDK stops fetching ads until you call ATInterstitialView::load again.
 *
 * @warning *Important:* Before calling *load* you should always check the validity of the ad configuration by checking the ads configuration isValid property.
 * Failing to ensure a valid configuration will result in the ad not being correctly loaded and displayed.
 */
- (void)load;

/**
 * Presents the interstitial view modally on top of the view controller.
 * Call this method after receiving the [ATInterstitialViewDelegate didSuccessfullyFetchInterstitialAd:] callback in order
 * to present the interstitial. It will be automatically dismissed after the refresh interval or when the user chooses to close it.
 * Calling this method before receiving the above callbacks will have no effect.
 *
 * @since 2.0
 */
- (void)present;

/**
 * Call this to programmatically dismiss the interstitial view that is being presented modally on top of the view controller.
 * Calling this method before actually presenting the interstitial will have no effect.
 * If you don't call it, the interstitial will still be automatically dismissed after the refresh interval or when the user chooses to close it.
 *
 * @since 3.3
 */
- (void)dismiss;

@end
