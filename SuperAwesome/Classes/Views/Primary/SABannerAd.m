//
//  SAHalfscreenView.m
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 12/10/2015.
//
//

// impor theader
#import "SABannerAd.h"

// import actual SKMRAIDView class
#import "SKMRAIDView.h"

// import models
#import "SAAd.h"
#import "SACreative.h"
#import "SADetails.h"

// import aux utils
#import "SAAux.h"

// import sender
#import "SASender.h"

// import aux classes parental gate & padlock
#import "SAParentalGate.h"
#import "SAPadlock.h"

// Declaration of SAView anonymous category
// basically making sure that all these functions stay "private" for the
// SDK User
// This declaration has to be repeated in every child of SAView that wants
// to use these functions
@interface SAView ()
- (void) tryToGoToURL:(NSURL*)url;
- (void) resizeToFrame:(CGRect)toframe;
@end

// Internal category declaration of SABannerAd
@interface SABannerAd () <SKMRAIDViewDelegate>

// internal raidview
@property (nonatomic, retain) SKMRAIDView *raidview;

@end

// Actual implementation of SABannerAd
@implementation SABannerAd

- (void) play {
    [super play];
    
    CGRect frame = [SAAux arrangeAdInNewFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
                                    fromFrame:CGRectMake(0, 0, super.ad.creative.details.width, super.ad.creative.details.height)];
    
    _raidview = [[SKMRAIDView alloc] initWithFrame:frame
                                     withHtmlData:super.ad.adHTML
                                      withBaseURL:[NSURL URLWithString:@""]
                                supportedFeatures:@[]
                                         delegate:self
                                  serviceDelegate:nil
                               rootViewController:nil];
    
    [self addSubview:_raidview];
    
    [pad addPadlockButtonToSubview:_raidview];
}

#pragma mark MKRAID View delegate

- (void) mraidViewAdReady:(SKMRAIDView *)mraidView {
    [SASender sendEventToURL:super.ad.creative.viewableImpressionURL];
    
    if ([super.delegate respondsToSelector:@selector(adWasShown:)]) {
        [super.delegate adWasShown:super.ad.placementId];
    }
}

- (void) mraidViewAdFailed:(SKMRAIDView *)mraidView {
    
    if ([super.delegate respondsToSelector:@selector(adFailedToShow:)]) {
        [super.delegate adFailedToShow:super.ad.placementId];
    }
}

- (void) mraidViewNavigate:(SKMRAIDView *)mraidView withURL:(NSURL *)url {
    [self tryToGoToURL:url];
}

#pragma mark Resize

- (void) resizeToFrame:(CGRect)toframe {
    
    self.frame = toframe;
    
    CGRect frame = [SAAux arrangeAdInNewFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
                                    fromFrame:CGRectMake(0, 0, super.ad.creative.details.width, super.ad.creative.details.height)];
    
    _raidview.frame = frame;
    
    [pad removePadlockButton];
    [pad addPadlockButtonToSubview:_raidview];
}

@end
