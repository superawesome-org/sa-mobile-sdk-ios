//
//  SAFullscreenVideoAd.m
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 21/10/2015.
//
//

#import "SAFullscreenVideoAd.h"
#import "SAVideoAd.h"

@implementation SAFullscreenVideoAd

- (void) viewDidLoad {
    [super viewDidLoad];
    
    // setup a special background color
    self.view.backgroundColor = [UIColor blackColor];
    
    adview = [[SAVideoAd alloc] initWithFrame:adviewFrame];
    adview.adDelegate = super.adDelegate;
    adview.parentalGateDelegate = super.parentalGateDelegate;
    [(SAVideoAd*)adview setVideoDelegate:_videoDelegate];
    
    [self.view addSubview:adview];

    // only <<IF>> ad is already here
    if (super.ad != NULL) {
        [adview setAd:super.ad];
    }
    
    // also allow these to be copied
    adview.isParentalGateEnabled = super.isParentalGateEnabled;
    adview.refreshPeriod = super.refreshPeriod;
}

- (void) close {
    [(SAVideoAd*)adview stopVideoAd];
    [super close];
}

@end
