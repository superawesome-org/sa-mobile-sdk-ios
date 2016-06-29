//
//  SABannerAd2.m
//  Pods
//
//  Created by Gabriel Coman on 13/02/2016.
//
//

#import "SABannerAd.h"

// import Parental Gate
#import "SuperAwesome.h"
#import "SAParentalGate.h"
#import "SAAd.h"
#import "SACreative.h"
#import "SADetails.h"
#import "SAData.h"

#import "SAEvents.h"
#if defined(__has_include)
#if __has_include("SAEvents+Moat.h")
#import "SAEvents+Moat.h"
#endif
#endif
#import "SAUtils.h"

// defines
#define BG_COLOR [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1]
#define BIG_PAD_FRAME CGRectMake(0, 0, 67, 25)
#define DISPLAY_VIEWABILITY_COUNT 1

@interface SABannerAd () <SAWebPlayerProtocol>

@property (nonatomic, weak) id<SAAdProtocol> internalAdProto;

@property (nonatomic, strong) SAAd *ad;
@property (nonatomic, strong) NSString *destinationURL;
@property (nonatomic, strong) SAWebPlayer *webplayer;
@property (nonatomic, strong) SAParentalGate *gate;
@property (nonatomic, strong) UIImageView *padlock;

@property (nonatomic, strong) NSTimer *viewabilityTimer;
@property (nonatomic, assign) NSInteger ticks;
@property (nonatomic, assign) NSInteger viewabilityCount;

@end

@implementation SABannerAd

#pragma mark <INIT> functions

- (id) init {
    if (self = [super init]){
        _isParentalGateEnabled = false;
        self.backgroundColor = BG_COLOR;
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _isParentalGateEnabled = false;
        self.backgroundColor = BG_COLOR;
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]){
        _isParentalGateEnabled = false;
        self.backgroundColor = BG_COLOR;
    }
    return self;
}

#pragma mark <SAViewProtocol> functions

- (void) setAd:(SAAd*)__ad {
    _ad = __ad;
}

- (SAAd*) getAd {
    return _ad;
}

- (void) play {
    
    // reset
    _viewabilityCount = _ticks = 0;
    
    // check for incorrect placement
    if (_ad.creative.creativeFormat == video || _ad == nil) {
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
    
    // calc correctly scaled frame
    CGRect frame = [SAUtils mapOldFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
                             toNewFrame:CGRectMake(0, 0, _ad.creative.details.width, _ad.creative.details.height)];
    
    // add the sawebview
    _webplayer = [[SAWebPlayer alloc] initWithFrame:frame];
    _webplayer.sadelegate = self;
    [_webplayer setAdSize:CGSizeMake(_ad.creative.details.width, _ad.creative.details.height)];
    [_webplayer loadAdHTML:_ad.creative.details.data.adHTML];
    
    // add the subview
    [self addSubview:_webplayer];
    
    // add the padlick
    _padlock = [[UIImageView alloc] initWithFrame:BIG_PAD_FRAME];
    _padlock.image = [SAUtils padlockImage];
    if (!_ad.isFallback && !_ad.isHouse) {
        [_webplayer addSubview:_padlock];
    }
}

- (void) close {
    [_webplayer removeFromSuperview];
    _webplayer = nil;
    [_padlock removeFromSuperview];
    _padlock = nil;
    _gate = nil;
    if (_viewabilityTimer != nil) {
        [_viewabilityTimer invalidate];
        _viewabilityTimer = nil;
    }
}

- (void) advanceToClick {
    NSLog(@"[AA :: INFO] Going to %@", _destinationURL);
    
    if ([_destinationURL rangeOfString:[[SuperAwesome getInstance] getBaseURL]].location == NSNotFound) {
        NSLog(@"Sending click event to %@", _ad.creative.trackingUrl);
        [SAEvents sendEventToURL:_ad.creative.trackingUrl];
    }
    
    // call delegate
    if (_adDelegate && [_adDelegate respondsToSelector:@selector(adWasClicked:)]) {
        [_adDelegate adWasClicked:_ad.placementId];
    }
    
    NSURL *url = [NSURL URLWithString:_destinationURL];
    [[UIApplication sharedApplication] openURL:url];
}

- (void) resizeToFrame:(CGRect)toframe {
    self.frame = toframe;
    
    CGRect frame = [SAUtils mapOldFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
                             toNewFrame:CGRectMake(0, 0, _ad.creative.details.width, _ad.creative.details.height)];
    
    // rearrange the webview
    [_webplayer updateToFrame:frame];
    
    // rearrange the padlock
    _padlock.frame = BIG_PAD_FRAME;
}

#pragma mark <SAWebViewProtocol> functions

- (void) webPlayerDidLoad {
    // send viewable impression
    _viewabilityTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(viewableImpressionFunc) userInfo:nil repeats:YES];
    [_viewabilityTimer fire];
    
    // moat tracking
    if ([[SAEvents class] respondsToSelector:@selector(sendDisplayMoatEvent:andAdDictionary:)]) {
        
        NSDictionary *moatDict = @{
                                   @"campaign":@(_ad.campaignId),
                                   @"line_item":@(_ad.lineItemId),
                                   @"creative":@(_ad.creative._id),
                                   @"app":@(_ad.app),
                                   @"placement":@(_ad.placementId)
                                   };
        [SAEvents sendDisplayMoatEvent:_webplayer andAdDictionary:moatDict];
    }
    
    // if the banner has a separate impression URL, send that as well for 3rd party tracking
    if (_ad.creative.impressionUrl && [_ad.creative.impressionUrl rangeOfString:[[SuperAwesome getInstance] getBaseURL]].location == NSNotFound) {
        [SAEvents sendEventToURL:_ad.creative.impressionUrl];
    }
    
    if ([_adDelegate respondsToSelector:@selector(adWasShown:)]) {
        [_adDelegate adWasShown:_ad.placementId];
    }
}

- (void) viewableImpressionFunc {
    
    if (_ticks >= DISPLAY_VIEWABILITY_COUNT) {
        [_viewabilityTimer invalidate];
        _viewabilityTimer = nil;
        
        if (_viewabilityCount == DISPLAY_VIEWABILITY_COUNT) {
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
        
        NSLog(@"[AA :: Info] Tick %ld/%d - Viewability Count %ld/%d", _ticks, DISPLAY_VIEWABILITY_COUNT, _viewabilityCount, DISPLAY_VIEWABILITY_COUNT);
    }
}

- (void) webPlayerDidFail {
    if ([_adDelegate respondsToSelector:@selector(adFailedToShow:)]) {
        [_adDelegate adFailedToShow:_ad.placementId];
    }
}

- (void) webPlayerWillNavigate:(NSURL *)url {
    // get the going to URL
    _destinationURL = [url absoluteString];
    
    if (_isParentalGateEnabled) {
        [_gate show];
    } else {
        [self advanceToClick];
    }
}

@end
