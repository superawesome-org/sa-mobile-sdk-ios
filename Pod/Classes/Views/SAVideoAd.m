//
//  SAVideoAd2.m
//  Pods
//
//  Created by Gabriel Coman on 13/02/2016.
//
//

#import "SAVideoAd.h"

#import "SuperAwesome.h"

// import Parental Gate
#import "SAParentalGate.h"

// import modelspace
#import "SAAd.h"
#import "SACreative.h"
#import "SADetails.h"
#import "SAData.h"

// import other headers
#import "SAEvents.h"
#if defined(__has_include)
#if __has_include("SAEvents+Moat.h")
#import "SAEvents+Moat.h"
#endif
#endif
#import "SAUtils.h"
#import "SAVideoPlayer.h"
#import "SAVASTManager.h"

#define SMALL_PAD_FRAME CGRectMake(0, 0, 67, 25)
#define VIDEO_VIEWABILITY_COUNT 2

@interface SAVideoAd () <SAVASTManagerProtocol>

@property (nonatomic, weak) id<SAAdProtocol> internalAdProto;
@property (nonatomic, weak) id<SAVideoAdProtocol> internalVideoAdProto;

@property (nonatomic, strong) SAAd *ad;
@property (nonatomic, strong) NSString *destinationURL;
@property (nonatomic, strong) NSArray *trackingArray;

@property (nonatomic, strong) SAParentalGate *gate;
@property (nonatomic, strong) UIImageView *padlock;
@property (nonatomic, strong) SAVideoPlayer *player;
@property (nonatomic, strong) SAVASTManager *manager;

@property (nonatomic, strong) NSTimer *viewabilityTimer;
@property (nonatomic, assign) NSInteger ticks;
@property (nonatomic, assign) NSInteger viewabilityCount;

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

- (void) setAd:(SAAd*)__ad {
    _ad = __ad;
}

- (SAAd*) getAd {
    return _ad;
}

- (void) play {
    
    // setup
    _viewabilityCount = _ticks = 0;
    
    // check for incorrect placement
    if (_ad.creative.creativeFormat != video || _ad == nil) {
        if (_adDelegate != NULL && [_adDelegate respondsToSelector:@selector(adHasIncorrectPlacement:)]){
            [_adDelegate adHasIncorrectPlacement:_ad.placementId];
        }
        if (_internalAdProto != NULL && [_internalAdProto respondsToSelector:@selector(adHasIncorrectPlacement:)]){
            [_internalAdProto adHasIncorrectPlacement:_ad.placementId];
        }
        return;
    }
    
    // start creating the banner ad
    _gate = [[SAParentalGate alloc] initWithWeakRefToView:self];
    _gate.delegate = _parentalGateDelegate;
    
    // create the player
    _player = [[SAVideoPlayer alloc] initWithFrame:self.bounds];
    _player.shouldShowSmallClickButton = _shouldShowSmallClickButton;
    [self addSubview:_player];

    // create the vast manager
    _manager = [[SAVASTManager alloc] initWithPlayer:_player];
    _manager.delegate = self;
    [_manager manageWithAd:_ad.creative.details.data.vastAd];

    // add the padlick
    _padlock = [[UIImageView alloc] initWithFrame:SMALL_PAD_FRAME];
    _padlock.image = [SAUtils padlockImage];
    if (!_ad.isFallback && !_ad.isHouse) {
        [self addSubview:_padlock];
    }
}

- (void) close {
    [_player destroy];
    _player = NULL;
    _ad = NULL;
    [_padlock removeFromSuperview];
    _padlock = nil;
    _gate = nil;
    if (_viewabilityTimer != nil) {
        [_viewabilityTimer invalidate];
        _viewabilityTimer = nil;
    }
}

- (void) pause {
    [_player pause];
}

- (void) resume {
    [_player resume];
}

- (void) advanceToClick {
    // call delegate
    if (_adDelegate && [_adDelegate respondsToSelector:@selector(adWasClicked:)]) {
        [_adDelegate adWasClicked:_ad.placementId];
    }
    
    // call trackers
    for (NSString *ctracking in _trackingArray) {
        [SAEvents sendEventToURL:ctracking];
    }
    
    // goto url
    NSURL *url = [NSURL URLWithString:_destinationURL];
    [[UIApplication sharedApplication] openURL:url];
    
    NSLog(@"[AA :: INFO] Going to %@", _destinationURL);
}

- (void) resizeToFrame:(CGRect)toframe {
    
    self.frame = toframe;
    CGRect playerFrame = CGRectMake(0, 0, toframe.size.width, toframe.size.height);
    [_player updateToFrame:playerFrame];
    
    // rearrange the padlock
    _padlock.frame = SMALL_PAD_FRAME;
}

#pragma mark <SAVASTProtocol>

- (void) didNotFindAds {
    if (_adDelegate && [_adDelegate respondsToSelector:@selector(adFailedToShow:)]) {
        [_adDelegate adFailedToShow:_ad.placementId];
    }
    
    if (_internalAdProto && [_internalAdProto respondsToSelector:@selector(adFailedToShow:)]) {
        [_internalAdProto adFailedToShow:_ad.placementId];
    }
}

- (void) didStartAd {
    // send viewable impression
    _viewabilityTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(viewableImpressionFunc) userInfo:nil repeats:YES];
    [_viewabilityTimer fire];
    
    // if the banner has a separate impression URL, send that as well for 3rd party tracking
    // although that's usually handled in the VAST tag for videos
    if (_ad.creative.impressionUrl && [_ad.creative.impressionUrl rangeOfString:[[SuperAwesome getInstance] getBaseURL]].location == NSNotFound) {
        [SAEvents sendEventToURL:_ad.creative.impressionUrl];
    }
    
    if (_adDelegate && [_adDelegate respondsToSelector:@selector(adWasShown:)]) {
        [_adDelegate adWasShown:_ad.placementId];
    }
    
    if (_internalVideoAdProto && [_internalVideoAdProto respondsToSelector:@selector(adStarted:)]) {
        [_internalVideoAdProto adStarted:_ad.placementId];
    }
}

- (void) viewableImpressionFunc {
    
    if (_ticks >= VIDEO_VIEWABILITY_COUNT) {
        [_viewabilityTimer invalidate];
        _viewabilityTimer = nil;
        
        if (_viewabilityCount == VIDEO_VIEWABILITY_COUNT) {
            [SAEvents sendEventToURL:_ad.creative.viewableImpressionUrl];
        } else {
            NSLog(@"[AA :: Error] Did not send viewable impression");
        }
    } else {
        _ticks++;
        
        CGRect childR = self.frame;
        CGRect superR = CGRectMake(0, 0, self.superview.frame.size.width, self.superview.frame.size.height);
        CGRect screenR = [UIScreen mainScreen].bounds;
        
        if ([SAUtils isRect:childR inRect:screenR] && [SAUtils isRect:childR inRect:superR]) {
            _viewabilityCount++;
        }
        
        NSLog(@"[AA :: Info] Tick %ld/%d - Viewability Count %ld/%d", _ticks, VIDEO_VIEWABILITY_COUNT, _viewabilityCount, VIDEO_VIEWABILITY_COUNT);
    }
}

- (void) didStartCreative {
    
    // moat
    if ([[SAEvents class] respondsToSelector:@selector(sendVideoMoatEvent:andLayer:andView:andAdDictionary:)]) {
        
        NSDictionary *moatDict = @{
                                   @"advertiser":@(_ad.advertiserId),
                                   @"campaign":@(_ad.campaignId),
                                   @"line_item":@(_ad.lineItemId),
                                   @"creative":@(_ad.creative._id),
                                   @"app":@(_ad.app),
                                   @"placement":@(_ad.placementId)
                                   };
        
        [SAEvents sendVideoMoatEvent:[_player getPlayer] andLayer:[_player getPlayerLayer] andView:self andAdDictionary:moatDict];
    }
    
    if (_videoDelegate && [_videoDelegate respondsToSelector:@selector(videoStarted:)]) {
        [_videoDelegate videoStarted:_ad.placementId];
    }
}

- (void) didReachFirstQuartileOfCreative {
    if (_videoDelegate && [_videoDelegate respondsToSelector:@selector(videoReachedFirstQuartile:)]) {
        [_videoDelegate videoReachedFirstQuartile:_ad.placementId];
    }
}

- (void) didReachMidpointOfCreative {
    if (_videoDelegate && [_videoDelegate respondsToSelector:@selector(videoReachedMidpoint:)]) {
        [_videoDelegate videoReachedMidpoint:_ad.placementId];
    }
}

- (void) didReachThirdQuartileOfCreative {
    if (_videoDelegate && [_videoDelegate respondsToSelector:@selector(videoReachedThirdQuartile:)]) {
        [_videoDelegate videoReachedThirdQuartile:_ad.placementId];
    }
}

- (void) didEndOfCreative {
    if (_videoDelegate && [_videoDelegate respondsToSelector:@selector(videoEnded:)]) {
        [_videoDelegate videoEnded:_ad.placementId];
    }
}

- (void) didHaveErrorForCreative{
    
}

- (void) didEndAd {
    if (_videoDelegate && [_videoDelegate respondsToSelector:@selector(adEnded:)]) {
        [_videoDelegate adEnded:_ad.placementId];
    }
}

- (void) didEndAllAds {
    
    // close the Pg
    [_gate close];
    
    if (_videoDelegate && [_videoDelegate respondsToSelector:@selector(allAdsEnded:)]) {
        [_videoDelegate allAdsEnded:_ad.placementId];
    }
    
    if (_internalVideoAdProto && [_internalVideoAdProto respondsToSelector:@selector(allAdsEnded:)]) {
        [_internalVideoAdProto allAdsEnded:_ad.placementId];
    }
}

- (void) didGoToURL:(NSURL *)url withTrackingArray:(NSArray *)clickTarcking{
    _trackingArray = clickTarcking;
    _destinationURL = [url absoluteString];
    
    if (_isParentalGateEnabled) {
        // show the gate
        [_gate show];
    } else {
        [self advanceToClick];
    }
}

@end
