//
//  SAInterstitialView.h
//  SAMobileSDK
//
//  Created by Balázs Kiss on 12/08/14.
//  Copyright (c) 2014 SuperAwesome Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAPlacementView.h"
#import "SAParentalGate.h"

/**
 * Defines the interface the delegate of an interstitial ads
 *
 * @since 1.0
 */
@class SAInterstitialView;

@protocol SAInterstitialViewDelegate <NSObject>
@optional

/**
 * Called when the interstial ad is fetched from a campaign and available to be displayed.
 * You should put up the ad on the screen at this time.
 *
 * @param view The interstitial ad view that fetched the ad.
 */
- (void)didSuccessfullyFetchInterstitialAd:(SAInterstitialView *)interstitialView;

/**
 * The ad was hidden from view. It gets called either when the ad is dismissed by the user or the refresh timer fires for the ad.
 * You should take down the interstitial ad from the screen at this time.
 *
 * @param view The interstitial ad view that was shown.
 *
 * @note You must implement and take action when this method is called on the delegate.
 */
- (void)didHideInterstitialView:(SAInterstitialView *)interstitialView;
@end


@interface SAInterstitialView : SAPlacementView <ATInterstitialViewDelegate, SAParentalGateDelegate>

/**
 * The delegate gets notified of different events in the lifecycle of the ad.
 * Your presenting view controller should register itself as delegate of the ad view.
 *
 * @see SAInterstitialViewDelegate
 */
@property (nonatomic,weak) id<SAInterstitialViewDelegate> delegate;

/**
 *  Initialises the interstitial ad in the given view controller
 *
 *  @param viewController The view controller that is the owner of the ad view being shown.
 *
 *  @return New interstitial instance
 */
- (instancetype)initWithViewController:(UIViewController *)viewController;

/**
 * Presents the interstitial view modally on top of the view controller.
 * Call this method after receiving the [SAInterstitialViewDelegate didSuccessfullyFetchInterstitialAd:] callback in order
 * to present the interstitial. It will be automatically dismissed after the refresh interval or when the user chooses to close it.
 * Calling this method before receiving the above callbacks will have no effect.
 */
- (void)present;

/**
 * Sets the background color for the interstitial.
 * The default color is clear on iOS 8 and above and white on iOS 6 and 7.
 */
- (void)setBackgroundColor:(UIColor *)backgroundColor;

@end
