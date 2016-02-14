//
//  SAVideoAd2.m
//  Pods
//
//  Created by Gabriel Coman on 13/02/2016.
//
//

#import "SAVideoAd.h"

// import Parental Gate
#import "SuperAwesome.h"
#import "SAParentalGate.h"
#import "SAAd.h"
#import "SACreative.h"
#import "SADetails.h"
#import "SASender.h"
#import "SAWebView.h"
#import "SAUtils.h"
#import "SAVASTPlayer.h"
#import "SAVASTManager.h"

@interface SAVideoAd () <SAVASTManagerProtocol>
@property id<SAAdProtocol> internalAdProto;
@property id<SAVideoAdProtocol> internalVideoAdProto;
@end

@implementation SAVideoAd

#pragma mark <INIT> functions

- (id) init {
    if (self = [super init]){
        _isParentalGateEnabled = false;
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _isParentalGateEnabled = false;
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]){
        _isParentalGateEnabled = false;
    }
    return self;
}

#pragma mark <SAViewProtocol>

- (void) setAd:(SAAd*)_ad {
    ad = _ad;
}

- (SAAd*) getAd {
    return ad;
}

- (void) play {
    // check for incorrect placement
    if (ad.creative.format != video || ad == nil) {
        if (_adDelegate != NULL && [_adDelegate respondsToSelector:@selector(adHasIncorrectPlacement:)]){
            [_adDelegate adHasIncorrectPlacement:ad.placementId];
        }
        return;
    }
    
    // start creating the banner ad
    gate = [[SAParentalGate alloc] initWithWeakRefToView:self];
    gate.delegate = _parentalGateDelegate;
    
    // create the player
    player = [[SAVASTPlayer alloc] initWithFrame:self.bounds];
    [self addSubview:player];
    
    // create the vast manager
    manager = [[SAVASTManager alloc] initWithPlayer:player];
    manager.delegate = self;
    [manager parseVASTURL:ad.creative.details.vast];
    
    // add the padlick
    CGRect padFrame = CGRectMake(self.frame.origin.x + self.frame.size.width - 15, self.frame.origin.y + self.frame.size.height - 15, 15, 15);
    padlock = [[UIImageView alloc] initWithFrame:padFrame];
    padlock.image = [UIImage imageNamed:@"sa_padlock"];
    if (!ad.isFallback) {
        [self addSubview:padlock];
    }
}

- (void) close {
    [player resetPlayer];
}

- (void) tryToGoToURL:(NSURL*)url {
    // get the going to URL
    destinationURL = [url absoluteString];
    
    if (_isParentalGateEnabled) {
        // send an event
        [SASender sendEventToURL:ad.creative.parentalGateClickURL];
        
        // show the gate
        [gate show];
    } else {
        [self advanceToClick];
    }
}

- (void) advanceToClick {
    NSLog(@"[AA :: INFO] Going to %@", destinationURL);
    
    if ([destinationURL rangeOfString:[[SuperAwesome getInstance] getBaseURL]].location == NSNotFound) {
        NSLog(@"Sending click event to %@", ad.creative.trackingURL);
        [SASender sendEventToURL:ad.creative.trackingURL];
    }
    
    // call delegate
    if (_adDelegate && [_adDelegate respondsToSelector:@selector(adWasClicked:)]) {
        [_adDelegate adWasClicked:ad.placementId];
    }
    
    NSURL *url = [NSURL URLWithString:destinationURL];
    [[UIApplication sharedApplication] openURL:url];
}

- (void) resizeToFrame:(CGRect)toframe {
    
    self.frame = toframe;
    CGRect playerFrame = CGRectMake(0, 0, toframe.size.width, toframe.size.height);
    [player updateToFrame:playerFrame];
    
    // rearrange the padlock
    CGRect padFrame = CGRectMake(self.frame.origin.x + self.frame.size.width - 15, self.frame.origin.y + self.frame.size.height - 15, 15, 15);
    padlock.frame = padFrame;
}

#pragma mark <SAVASTProtocol>

- (void) didParseVASTAndFindAds {
    
}

- (void) didParseVASTButDidNotFindAnyAds {
    if (_adDelegate && [_adDelegate respondsToSelector:@selector(adFailedToShow:)]) {
        [_adDelegate adFailedToShow:ad.placementId];
    }
    
    // send a message to the internal ad proto as well
    if (_internalAdProto && [_internalAdProto respondsToSelector:@selector(adFailedToShow:)]) {
        [_internalAdProto adFailedToShow:ad.placementId];
    }
}

- (void) didNotParseVAST {
    if (_adDelegate && [_adDelegate respondsToSelector:@selector(adFailedToShow:)]) {
        [_adDelegate adFailedToShow:ad.placementId];
    }
    
    // send a message to the internal ad proto as well
    if (_internalAdProto && [_internalAdProto respondsToSelector:@selector(adFailedToShow:)]) {
        [_internalAdProto adFailedToShow:ad.placementId];
    }
}

- (void) didStartAd {
    // send the viewable impression URL as well
    [SASender sendEventToURL:ad.creative.viewableImpressionURL];
    
    if (_adDelegate && [_adDelegate respondsToSelector:@selector(adWasShown:)]) {
        [_adDelegate adWasShown:ad.placementId];
    }
    
    if (_internalVideoAdProto && [_internalVideoAdProto respondsToSelector:@selector(adStarted:)]) {
        [_internalVideoAdProto adStarted:ad.placementId];
    }
}

- (void) didStartCreative {
    if (_videoDelegate && [_videoDelegate respondsToSelector:@selector(videoStarted:)]) {
        [_videoDelegate videoStarted:ad.placementId];
    }
}

- (void) didReachFirstQuartileOfCreative {
    if (_videoDelegate && [_videoDelegate respondsToSelector:@selector(videoReachedFirstQuartile:)]) {
        [_videoDelegate videoReachedFirstQuartile:ad.placementId];
    }
}

- (void) didReachMidpointOfCreative {
    if (_videoDelegate && [_videoDelegate respondsToSelector:@selector(videoReachedMidpoint:)]) {
        [_videoDelegate videoReachedMidpoint:ad.placementId];
    }
}

- (void) didReachThirdQuartileOfCreative {
    if (_videoDelegate && [_videoDelegate respondsToSelector:@selector(videoReachedThirdQuartile:)]) {
        [_videoDelegate videoReachedThirdQuartile:ad.placementId];
    }
}

- (void) didEndOfCreative {
    if (_videoDelegate && [_videoDelegate respondsToSelector:@selector(videoEnded:)]) {
        [_videoDelegate videoEnded:ad.placementId];
    }
}

- (void) didHaveErrorForCreative{
    
}

- (void) didEndAd {
    if (_videoDelegate && [_videoDelegate respondsToSelector:@selector(adEnded:)]) {
        [_videoDelegate adEnded:ad.placementId];
    }
}

- (void) didEndAllAds {
    if (_videoDelegate && [_videoDelegate respondsToSelector:@selector(allAdsEnded:)]) {
        [_videoDelegate allAdsEnded:ad.placementId];
    }
    
    if (_internalVideoAdProto && [_internalVideoAdProto respondsToSelector:@selector(allAdsEnded:)]) {
        [_internalVideoAdProto allAdsEnded:ad.placementId];
    }
}

- (void) didGoToURL:(NSURL *)url {
    [self tryToGoToURL:url];
}

@end
