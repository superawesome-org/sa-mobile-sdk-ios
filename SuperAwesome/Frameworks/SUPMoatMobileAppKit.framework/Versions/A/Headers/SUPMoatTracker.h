//
// Created by Moat on 2/24/15.
// Copyright (c) 2015 Moat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SUPMoatBootstrap.h"

@interface SUPMoatTracker : SUPMoatBootstrap
// Use this to track ads that can't run JavaScript. This method accepts any UIView. Web-based ads, including "opaque"
// web containers (Google's DFPBannerView, etc.) are best tracked using MoatBootstrap's injectDelegateWrapper instead.
+ (SUPMoatTracker *)trackerWithAdView:(UIView *)adView partnerCode:(NSString *)partnerCode;

-(void)trackAd:(NSDictionary*)adIds;
@end
