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

// import SA.h
#import "SuperAwesome.h"

// import model
#import "SAAd.h"
#import "SACreative.h"
#import "SADetails.h"

// import subview
#import "SAParentalGate.h"
#import "SAPadlock.h"

#import "SAURLUtils.h"
#import "SASender.h"

@interface SAView ()
@property (nonatomic, strong) NSString *destinationURL;
@end

@implementation SAView

// overwriting init functions
- (id) init {
    if (self = [super init]) {
        _isParentalGateEnabled = NO;
        _refreshPeriod = 30;
    }
    
    return self;
}

- (id) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _isParentalGateEnabled = NO;
        _refreshPeriod = 30;
    }
    
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _isParentalGateEnabled = NO;
        _refreshPeriod = 30;
        
    }
    
    return self;
}

#pragma mark Playing and displaying

- (void) play {
    // init the pad
    gate = [[SAParentalGate alloc] initWithWeakRefToView:self];
    gate.delegate = _parentalGateDelegate;
    pad = [[SAPadlock alloc] initWithWeakRefToView:self];
}


#pragma mark Click Handling

- (void) tryToGoToURL:(NSURL*)url {
    
    // get the going to URL
    _destinationURL = [url absoluteString];
    
    if (_isParentalGateEnabled) {
        // send an event
        [SASender sendEventToURL:_ad.creative.parentalGateClickURL];
        
        // show the gate
        [gate show];
    } else {
        [self advanceToClick];
    }
}

- (void) advanceToClick {
    NSLog(@"[AA :: INFO] Going to %@", _destinationURL);
    
    if ([_destinationURL rangeOfString:[[SuperAwesome getInstance] getBaseURL]].location == NSNotFound) {
        NSLog(@"Sending click event to %@", _ad.creative.trackingURL);
        [SASender sendEventToURL:_ad.creative.trackingURL];
    }
    
    // call delegate
    if (_adDelegate && [_adDelegate respondsToSelector:@selector(adWasClicked:)]) {
        [_adDelegate adWasClicked:_ad.placementId];
    }
    
    NSURL *url = [NSURL URLWithString:_destinationURL];
    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark Resize to Frame

- (void) resizeToFrame:(CGRect)frame {
    // do nothing
}

@end
