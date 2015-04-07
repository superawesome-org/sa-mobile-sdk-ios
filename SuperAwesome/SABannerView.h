//
//  SABanner.h
//  SAMobileSDK
//
//  Created by Balázs Kiss on 11/08/14.
//  Copyright (c) 2014 SuperAwesome Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAParentalGate.h"
#import "SAPlacementView.h"

@class SABannerView;

/**
 * Implement this protocol to be notified of different events in the lifecycle of the ad.
 */
@protocol SABannerViewDelegate <ATBannerViewDelegate>
@optional

/**
 * Called when the ad will take over the screen in order to give the application the chance to pause ongoing activities.
 * This is in response for user interaction with the ad.
 *
 * @param view The ad view that will take over the screen.
 */
- (void)shouldSuspendForAd:(SABannerView *)view;

/**
 * Called when the ad will relinquish control of the screen as a result of the user dismissing it.
 *
 * @param view The ad view that had control of the screen.
 */
- (void)shouldResumeForAd:(SABannerView *)view;

/**
 * Called when the user interaction with the ad triggers leaving the application.
 * This can be, for example, opening a URL in Safari or Maps or another application registered to handle the URL specified by the ad.
 * You should save the state of the application when you get this call.
 *
 * @param view The ad view that triggered leaving the application.
 */
- (void)willLeaveApplicationForAd:(SABannerView *)view;

/**
 * Called when the ad network did not serve any ads and custom mediation should be displayed.
 */
- (void)shouldDisplayCustomMediationForAd:(SABannerView *)view;
@end

/**
 *  Represents one ad banner that you place on one of your views.
 *
 *  For each ad banner you want to place in your app create one instance of this class.
 *  The view will call the delegate when different events occur in the ad's lifecycle.
 *
 *  @see SABannerViewDelegate
 */
//IB_DESIGNABLE
@interface SABannerView : SAPlacementView <ATBannerViewDelegate, SAParentalGateDelegate>

/**
 * The delegate gets notified of different events in the lifecycle of the ad. It is not required to be set.
 *
 * @see SABannerViewDelegate
 */
@property (nonatomic,weak) id<SABannerViewDelegate> delegate;

/**
 * Set the value to reflect the visibility of the ad on screen.
 *
 * For example, when the ad goes off screen set this to NO. When it comes back into view set it to YES.
 * While the ad's visibility is NO, new ads are not fetched.
 *
 * @warning *Important:* You should always set the visibility of the ad when it's state of being shown changes.
 * For example, you should set the visiblity to NO when a different screen is being shown,
 * the screen is turned off by the user or the ad exits the screen being placed on a scrollable view.
 * Similarly, you should set visibility to YES when the view preseting the ad comes back into view,
 * the screen is turned on or the ad is scrolled back into the screen.
 *
 * A suggestion for managing the ad visibility is setting the value inside the viewDidAppear and viewDidDisappear methods of you view controllers.
 */
@property (nonatomic,assign,getter = isVisible) BOOL visible;
/**
 * The view controller that is the owner of the ad view being shown.
 *
 * If you do not set this property, it will use the closest parent UIViewController instance.
 */
@property (nonatomic,strong) UIViewController *viewController;
/**
 * The internal ADTECH banner view that is being used
 *
 * @warning Ideally, you should not directly access this property.
 */
@property (nonatomic,strong,readonly) ATBannerView *bannerView;

@end
