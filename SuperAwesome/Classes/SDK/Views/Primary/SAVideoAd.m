//
//  SAVideoAd.m
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 20/10/2015.
//
//

#import "SAVideoAd.h"

// import models
#import "SAAd.h"
#import "SACreative.h"
#import "SACreativeFormat.h"
#import "SADetails.h"
#import "SASender.h"

// import parental gate
#import "SAParentalGate.h"
#import "SAPadlock.h"

// import the SAVASTParser
#import "libSAiOSVAST.h"

// Anon Category of SAView to maintain some functions private
@interface SAView ()
- (void) tryToGoToURL:(NSURL*)url;
- (void) resizeToFrame:(CGRect)toframe;
@end

// Anon Category of SAvideoAd to declare private variables and delegate
// implementations, especially for google IMA ads
@interface SAVideoAd () <SAVASTManagerProtocol>

// the invisible action button
@property (nonatomic, strong) UIButton *actionButton;

// declare the player
@property (nonatomic, strong) SAVASTPlayer *player;

// and the associated parser
@property (nonatomic, strong) SAVASTManager *manager;

// internal proto
@property id<SAAdProtocol> internalAdProto;
@property id<SAVideoAdProtocol> internalVideoAdProto;

@end

// Implementation of SAVideo Ad
@implementation SAVideoAd

- (void) play {
    [super play];
    
    self.backgroundColor = [UIColor redColor];
    
    if (super.ad.creative.format != video) {
        if (super.adDelegate != NULL && [super.adDelegate respondsToSelector:@selector(adHasIncorrectPlacement:)]){
            [super.adDelegate adHasIncorrectPlacement:super.ad.placementId];
        }
        return;
    }
    
    // create the player
    _player = [[SAVASTPlayer alloc] initWithFrame:self.bounds];
    [self addSubview:_player];
    
    // create the vast manager
    _manager = [[SAVASTManager alloc] initWithPlayer:_player];
    _manager.delegate = self;
    [_manager parseVASTURL:super.ad.creative.details.vast];
    
    
    [pad addPadlockButtonToSubview:self];
}

#pragma mark <SAVASTManagerProtocol>

- (void) didParseVASTAndFindAds {
    
}

- (void) didParseVASTButDidNotFindAnyAds {
    if (super.adDelegate && [super.adDelegate respondsToSelector:@selector(adFailedToShow:)]) {
        [super.adDelegate adFailedToShow:super.ad.placementId];
    }
    
    // send a message to the internal ad proto as well
    if (_internalAdProto && [_internalAdProto respondsToSelector:@selector(adFailedToShow:)]) {
        [_internalAdProto adFailedToShow:super.ad.placementId];
    }
}

- (void) didNotParseVAST {
    if (super.adDelegate && [super.adDelegate respondsToSelector:@selector(adFailedToShow:)]) {
        [super.adDelegate adFailedToShow:super.ad.placementId];
    }
    
    // send a message to the internal ad proto as well
    if (_internalAdProto && [_internalAdProto respondsToSelector:@selector(adFailedToShow:)]) {
        [_internalAdProto adFailedToShow:super.ad.placementId];
    }
}

- (void) didStartAd {
    // send the viewable impression URL as well
    [SASender sendEventToURL:super.ad.creative.viewableImpressionURL];
    
    if (super.adDelegate && [super.adDelegate respondsToSelector:@selector(adWasShown:)]) {
        [super.adDelegate adWasShown:super.ad.placementId];
    }
}

- (void) didStartCreative {
    if (_videoDelegate && [_videoDelegate respondsToSelector:@selector(videoStarted:)]) {
        [_videoDelegate videoStarted:super.ad.placementId];
    }
}

- (void) didReachFirstQuartileOfCreative {
    if (_videoDelegate && [_videoDelegate respondsToSelector:@selector(videoReachedFirstQuartile:)]) {
        [_videoDelegate videoReachedFirstQuartile:super.ad.placementId];
    }
}

- (void) didReachMidpointOfCreative {
    if (_videoDelegate && [_videoDelegate respondsToSelector:@selector(videoReachedMidpoint:)]) {
        [_videoDelegate videoReachedMidpoint:super.ad.placementId];
    }
}

- (void) didReachThirdQuartileOfCreative {
    if (_videoDelegate && [_videoDelegate respondsToSelector:@selector(videoReachedThirdQuartile:)]) {
        [_videoDelegate videoReachedThirdQuartile:super.ad.placementId];
    }
}

- (void) didEndOfCreative {
    if (_videoDelegate && [_videoDelegate respondsToSelector:@selector(videoEnded:)]) {
        [_videoDelegate videoEnded:super.ad.placementId];
    }
}

- (void) didHaveErrorForCreative{
    
}

- (void) didEndAd {
    if (_videoDelegate && [_videoDelegate respondsToSelector:@selector(adEnded:)]) {
        [_videoDelegate adEnded:super.ad.placementId];
    }
}

- (void) didEndAllAds {
    if (_videoDelegate && [_videoDelegate respondsToSelector:@selector(allAdsEnded:)]) {
        [_videoDelegate allAdsEnded:super.ad.placementId];
    }
    if (_internalVideoAdProto && [_internalVideoAdProto respondsToSelector:@selector(allAdsEnded:)]) {
        [_internalVideoAdProto allAdsEnded:super.ad.placementId];
    }
}

- (void) didGoToURL:(NSURL *)url {    
    [self tryToGoToURL:url];
}

#pragma mark <Stop Ad>

- (void) stopVideoAd {
    // just reset the player and it will all stop
    [_player resetPlayer];
}

#pragma mark <Resize functions>

- (void) resizeToFrame:(CGRect)toframe {
    
    self.frame = toframe;
    CGRect playerFrame = CGRectMake(0, 0, toframe.size.width, toframe.size.height);
    [_player updateToFrame:playerFrame];
    
    _actionButton.frame = CGRectMake(0, 0, self.frame.size.width, 30.0f);
    
    [pad removePadlockButton];
    [pad addPadlockButtonToSubview:self];
}

@end
