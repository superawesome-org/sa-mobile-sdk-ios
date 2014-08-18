//
//  SABanner.h
//  SAMobileSDK
//
//  Created by Balázs Kiss on 11/08/14.
//  Copyright (c) 2014 SuperAwesome Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ADTECHMobileSDK/ADTECHMobileSDK.h>

@class SABannerView;

@protocol SABannerViewDelegate <ATBannerViewDelegate>
@optional
- (void)shouldSuspendForAd:(SABannerView *)view;
- (void)shouldResumeForAd:(SABannerView *)view;
- (void)willLeaveApplicationForAd:(SABannerView *)view;
@end


@interface SABannerView : UIView <ATBannerViewDelegate>

@property (nonatomic,weak) id<SABannerViewDelegate> delegate;
@property (nonatomic,assign,getter = isVisible) BOOL visible;
@property (nonatomic,strong) UIViewController *viewController;
@property (nonatomic,strong,readonly) ATBannerView *bannerView;

@end
