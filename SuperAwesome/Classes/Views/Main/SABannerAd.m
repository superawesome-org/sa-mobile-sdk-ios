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

// import utils
#import "SAUtils.h"
#import "SASender.h"
#import "SAParentalGate.h"

// Declaration of SAView anonymous category
// basically making sure that all these functions stay "private" for the
// SDK User
// This declaration has to be repeated in every child of SAView that wants
// to use these functions
@interface SAView ()
- (CGRect) arrangeAdInFrame:(CGRect)frame;
- (void) tryToGoToURL:(NSURL*)url;
- (void) createPadlockButtonWithParent:(UIView *)parent;
- (void) removePadlockButtonFromParent;
- (void) resizeToFrame:(CGRect)toframe;
@end

// Internal category declaration of SABannerAd
@interface SABannerAd () <SKMRAIDViewDelegate>
@end

// Actual implementation of SABannerAd
@implementation SABannerAd

- (id) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // do nothing here
    }
    return self;
}

- (void) play {
    [super play];
    
    CGRect frame = [SAUtils arrangeAdInNewFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
                                    fromFrame:CGRectMake(0, 0, ad.creative.details.width, ad.creative.details.height)];
    
    raidview = [[SKMRAIDView alloc] initWithFrame:frame
                                     withHtmlData:ad.adHTML
                                      withBaseURL:[NSURL URLWithString:@""]
                                supportedFeatures:@[]
                                         delegate:self
                                  serviceDelegate:nil
                               rootViewController:nil];
    
    [self addSubview:raidview];
    [self createPadlockButtonWithParent:raidview];
}

#pragma mark MKRAID View delegate

- (void) mraidViewAdReady:(SKMRAIDView *)mraidView {
    [SASender sendEventToURL:ad.creative.viewableImpressionURL];
    
    if ([super.delegate respondsToSelector:@selector(adWasShown:)]) {
        [super.delegate adWasShown:ad.placementId];
    }
}

- (void) mraidViewAdFailed:(SKMRAIDView *)mraidView {
    
    if ([super.delegate respondsToSelector:@selector(adFailedToShow:)]) {
        [super.delegate adFailedToShow:ad.placementId];
    }
}

- (void) mraidViewNavigate:(SKMRAIDView *)mraidView withURL:(NSURL *)url {
    [self tryToGoToURL:url];
}

#pragma mark Resize

- (void) resizeToFrame:(CGRect)toframe {
    
    self.frame = toframe;
    
    CGRect frame = [SAUtils arrangeAdInNewFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
                                    fromFrame:CGRectMake(0, 0, ad.creative.details.width, ad.creative.details.height)];
    
    raidview.frame = frame;
    [padlockBtn removeFromSuperview];
    padlockBtn = NULL;
    [self createPadlockButtonWithParent:raidview];
}

@end
