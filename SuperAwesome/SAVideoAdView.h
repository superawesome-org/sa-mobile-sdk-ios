//
//  SAVideoView.h
//  SAMobileSDK
//
//  Created by Balázs Kiss on 03/09/14.
//  Copyright (c) 2014 SuperAwesome Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ADTECHMobileSDK/ADTECHMobileSDK.h>
#import "UIView+FindUIViewController.h"
#import "IMAAdsLoader.h"
#import "SAPlacementView.h"


@class SAVideoAdView;

@protocol SAVideoAdViewDelegate <NSObject>
@optional

- (void)didLoadVideoAd:(SAVideoAdView *)videoAd;
- (void)didFailToLoadVideoAd:(SAVideoAdView *)videoAd;

- (void)didStartPlayingVideoAd:(SAVideoAdView *)videoAd;
- (void)didFinishPlayingVideoAd:(SAVideoAdView *)videoAd;
- (void)didFailToPlayVideoAd:(SAVideoAdView *)videoAd;
- (void)didClickVideoAd:(SAVideoAdView *)videoAd;

@end


@interface SAVideoAdView : SAPlacementView <IMAAdsLoaderDelegate, IMAAdsManagerDelegate, SAParentalGateDelegate>

@property (nonatomic,weak) id<SAVideoAdViewDelegate> delegate;
@property (nonatomic,assign) IBInspectable BOOL autoplay;

- (void)play;
- (void)stop;
- (void)resume;

@end
