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
#import "SAEvents.h"
#import "SAUtils.h"

// defines
#define BG_COLOR [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1]
#define BIG_PAD_FRAME CGRectMake(0, 0, 67, 25)

@interface SABannerAd () <SAWebPlayerProtocol>
@property (nonatomic, strong) SAAd *ad;
@property (nonatomic, strong) NSString *destinationURL;
@property (nonatomic, strong) SAWebPlayer *webplayer;
@property (nonatomic, strong) SAParentalGate *gate;
@property (nonatomic, strong) UIImageView *padlock;
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
    // check for incorrect placement
    if (_ad.creative.format == video || _ad == nil) {
        if (_adDelegate != NULL && [_adDelegate respondsToSelector:@selector(adHasIncorrectPlacement:)]){
            [_adDelegate adHasIncorrectPlacement:_ad.placementId];
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
    [_webplayer loadAdHTML:_ad.adHTML];
    
    // add the subview
    [self addSubview:_webplayer];
    
    // add the padlick
    _padlock = [[UIImageView alloc] initWithFrame:BIG_PAD_FRAME];
    
    NSBundle *podBundle = [NSBundle bundleForClass:self.classForCoder];
    NSURL *bundleUrl = [podBundle URLForResource:@"SuperAwesome" withExtension:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithURL:bundleUrl];
    NSString *file = [bundle pathForResource:@"watermark_49x25" ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:file];
    
    _padlock.image = image;
    if (!_ad.isFallback && !_ad.isHouse) {
        [_webplayer addSubview:_padlock];
    }
}

- (void) close {
    // do nothing
}

- (void) advanceToClick {
    NSLog(@"[AA :: INFO] Going to %@", _destinationURL);
    
    if ([_destinationURL rangeOfString:[[SuperAwesome getInstance] getBaseURL]].location == NSNotFound) {
        NSLog(@"Sending click event to %@", _ad.creative.trackingURL);
        [SAEvents sendEventToURL:_ad.creative.trackingURL];
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
    [SAEvents sendEventToURL:_ad.creative.viewableImpressionURL];
    [SAEvents sendDisplayMoatEvent:self andAdDictionary:@{
        @"campaign": [NSString stringWithFormat:@"%ld", (long)_ad.campaignId],
        @"line_item": [NSString stringWithFormat:@"%ld", (long)_ad.lineItemId],
        @"creative": [NSString stringWithFormat:@"%ld", (long)_ad.creative.creativeId],
        @"app": [NSString stringWithFormat:@"%ld", (long)_ad.appId],
        @"placement": [NSString stringWithFormat:@"%ld", (long)_ad.placementId],
    }];
    
    if ([_adDelegate respondsToSelector:@selector(adWasShown:)]) {
        [_adDelegate adWasShown:_ad.placementId];
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
        // send an event
        [SAEvents sendEventToURL:_ad.creative.parentalGateClickURL];
        
        // show the gate
        [_gate show];
    } else {
        [self advanceToClick];
    }
}

@end
