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

// import models
#import "SAAd.h"
#import "SACreative.h"
#import "SADetails.h"

// import aux utils
#import "libSAiOSUtils.h"
#import "libSAiOSNetwork.h"

// import aux classes parental gate & padlock & sawebview
#import "libSAiOSWebView.h"
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
@interface SABannerAd () <SAWebViewProtocol>

// internal raidview
@property (nonatomic, retain) SAWebView *sawebview;

@end

// Actual implementation of SABannerAd
@implementation SABannerAd

- (void) play {
    [super play];
    
    if (super.ad.creative.format == video) {
        if (super.adDelegate != NULL && [super.adDelegate respondsToSelector:@selector(adHasIncorrectPlacement:)]){
            [super.adDelegate adHasIncorrectPlacement:super.ad.placementId];
        }
        return;
    }
    
    CGRect frame = [SAUtils arrangeAdInNewFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
                                      fromFrame:CGRectMake(0, 0, super.ad.creative.details.width, super.ad.creative.details.height)];
    
    _sawebview = [[SAWebView alloc] initWithFrame:frame
                                          andHTML:super.ad.adHTML
                                      andDelegate:self];
    
    [self addSubview:_sawebview];
    
    [pad addPadlockButtonToSubview:_sawebview];
}

#pragma mark MKRAID View delegate

- (void) saWebViewDidLoad {
    [SASender sendEventToURL:super.ad.creative.viewableImpressionURL];
    
    if ([super.adDelegate respondsToSelector:@selector(adWasShown:)]) {
        [super.adDelegate adWasShown:super.ad.placementId];
    }
}

- (void) saWebViewDidFail {
    if ([super.adDelegate respondsToSelector:@selector(adFailedToShow:)]) {
        [super.adDelegate adFailedToShow:super.ad.placementId];
    }
}

- (void) saWebViewWillNavigate:(NSURL *)url {
    [self tryToGoToURL:url];
}

#pragma mark Resize

- (void) resizeToFrame:(CGRect)toframe {
    
    self.frame = toframe;
    
    CGRect frame = [SAUtils arrangeAdInNewFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
                                      fromFrame:CGRectMake(0, 0, super.ad.creative.details.width, super.ad.creative.details.height)];
    
    _sawebview.frame = frame;
    
    [pad removePadlockButton];
    [pad addPadlockButtonToSubview:_sawebview];
}

@end
