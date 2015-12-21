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

@interface SAVideoAd ()

@property id<SAAdProtocol> internalAdProto;
@property id<SAVideoAdProtocol> internalVideoAdProto;

@end

@interface SAViewController ()

- (void) setupCoordinates;

@end

@interface SAFullscreenVideoAd () <SAVideoAdProtocol, SAAdProtocol>

@end

@implementation SAFullscreenVideoAd

- (id) init {
    if (self = [super init]) {
        _shouldAutomaticallyCloseAtEnd = YES;
        closeBtn.hidden = YES;
    }
    
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _shouldAutomaticallyCloseAtEnd = YES;
        closeBtn.hidden = YES;
    }
    return self;
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _shouldAutomaticallyCloseAtEnd = YES;
        closeBtn.hidden = YES;
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    // setup a special background color
    self.view.backgroundColor = [UIColor blackColor];
    
    adview = [[SAVideoAd alloc] initWithFrame:adviewFrame];
    adview.adDelegate = super.adDelegate;
    adview.parentalGateDelegate = super.parentalGateDelegate;
    [(SAVideoAd*)adview setVideoDelegate:_videoDelegate];
    [(SAVideoAd*)adview setInternalAdProto:self];
    [(SAVideoAd*)adview setInternalVideoAdProto:self];
    
    [self.view addSubview:adview];

    // only <<IF>> ad is already here
    if (super.ad != NULL) {
        [adview setAd:super.ad];
    }
    
    // also allow these to be copied
    adview.isParentalGateEnabled = super.isParentalGateEnabled;
    adview.refreshPeriod = super.refreshPeriod;
}

- (void) setupCoordinates {
    // then if the ads says it's supposed to close at the end - redo the
    // adviewFrame and closeBtn frames
    if (_shouldAutomaticallyCloseAtEnd) {
        CGRect frame = [UIScreen mainScreen].bounds;
        adviewFrame = frame;
        closeBtn.frame = CGRectZero;
    } else {
        [super setupCoordinates];
        closeBtn.hidden = NO;
    }
}

- (void) close {
    [(SAVideoAd*)adview stopVideoAd];
    [super close];
}

#pragma mark <SAVideoAdProtocol> - internal

- (void) allAdsEnded:(NSInteger)placementId {
    if (_shouldAutomaticallyCloseAtEnd) {
        [self close];
    }
}

#pragma mark <SAAdProtocol> - internal

- (void) adFailedToShow:(NSInteger)placementId {
    [self close];
}

@end
