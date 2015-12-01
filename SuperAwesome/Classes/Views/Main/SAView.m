//
//  SAView.m
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 12/10/2015.
//
//

#import "SAView.h"

// import model
#import "SAAd.h"
#import "SACreative.h"
#import "SADetails.h"

// import loade
#import "SALoader.h"
#import "SASender.h"

// import subview
#import "SAParentalGate.h"
#import "SAPadlockView.h"

// Anon category of SAView that does not do much
@interface SAView () <SAParentalGateProtocol>
@end

@implementation SAView

// overwriting init functions
- (id) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _isParentalGateEnabled = YES;
        _refreshPeriod = 30;
    }
    
    return self;
}

#pragma mark Playing and displaying

- (void) setAd:(SAAd *)_ad {
    ad = _ad;
    
    gate = [[SAParentalGate alloc] initWithAd:ad];
    gate.delegate = self;
}

- (void) play {
    // do nothing here
}


#pragma mark Normal click

- (void) tryToGoToURL:(NSURL*)url {
    
    // call delegate
    if (_delegate && [_delegate respondsToSelector:@selector(adWasClicked:)]) {
        [_delegate adWasClicked:ad.placementId];
    }
    
    NSURL *gotoUrl = NULL;
    
    // simplest case scenario - image
    if (ad.creative.format == image) {
        gotoUrl = [NSURL URLWithString:ad.creative.clickURL];
    }
    // edge case rich media
    else if (ad.creative.format == rich) {
        // do nothing here
    }
    // edge case tag ad
    else if (ad.creative.format == tag) {
        NSString *startURL = [url absoluteString];
        NSString *okURL = [startURL substringFromIndex:[startURL rangeOfString:@"http"].location];
        NSString *finalURL = [NSString stringWithFormat:@"%@&redir=%@", ad.creative.trackingURL, okURL];
        gotoUrl = [NSURL URLWithString:finalURL];
    }
    // edge case video
    else if (ad.creative.format == video) {
        gotoUrl = [NSURL URLWithString:ad.creative.clickURL];
    }
    
    if (_isParentalGateEnabled) {
        gate.gotoURL = gotoUrl;
        [gate show];
    } else {
        [[UIApplication sharedApplication] openURL:gotoUrl];
    }
}

#pragma mark Parental Gate

- (void) parentalGateWasCanceled {
    if (_delegate && [_delegate respondsToSelector:@selector(parentalGateWasCanceled:)]) {
        [_delegate parentalGateWasCanceled:ad.placementId];
    }
}

- (void) parentalGateWasFailed {
    if (_delegate && [_delegate respondsToSelector:@selector(parentalGateWasFailed:)]) {
        [_delegate parentalGateWasFailed:ad.placementId];
    }
}

- (void) parentalGateWasSuccededAndShouldGoTo:(NSURL *)url {
    if (_delegate && [_delegate respondsToSelector:@selector(parentalGateWasSucceded:)]){
        [_delegate parentalGateWasSucceded:ad.placementId];
    }
    
    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark Padlock

- (void) createPadlockButtonWithParent:(UIView *)parent{
    
    // don't go any further is ad is fallback
    if (ad.isFallback) {
        return;
    }
    
    // 2.
    // add the padlock button
    CGRect main_frame = parent.frame;
    CGSize padlock_size = CGSizeMake(15, 15);
    CGRect padlock_frame = CGRectMake(main_frame.size.width - padlock_size.width,
                                      main_frame.size.height - padlock_size.height,
                                      padlock_size.width,
                                      padlock_size.height);
    
    padlockBtn = [[UIButton alloc] initWithFrame:padlock_frame];
    [padlockBtn setImage:[UIImage imageNamed:@"sa_padlock"] forState:UIControlStateNormal];
    [padlockBtn addTarget:self action:@selector(onPadlockClick) forControlEvents:UIControlEventTouchUpInside];
    [parent addSubview:padlockBtn];
    [parent bringSubviewToFront:padlockBtn];
}

- (void) removePadlockButtonFromParent {
    [padlockBtn removeFromSuperview];
}

- (void) onPadlockClick {
    if (!pad) {
        pad = [[SAPadlockView alloc] initWithAd:ad];
    }
    
    // show this
    [[[[UIApplication sharedApplication] delegate] window] addSubview:pad];
}

#pragma mark Resize to Frame

- (void) resizeToFrame:(CGRect)frame {
    // do nothing
}

@end
