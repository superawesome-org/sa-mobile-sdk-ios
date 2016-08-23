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
#import "SAMedia.h"

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

@interface SABannerAd ()

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
        [self initialize];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]){
        [self initialize];
    }
    return self;
}

- (void) initialize {
    _isParentalGateEnabled = false;
    self.backgroundColor = BG_COLOR;
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
        if (_adDelegate != NULL && [_adDelegate respondsToSelector:@selector(adFailedToShow:)]){
            [_adDelegate adFailedToShow:_ad.placementId];
        }
        if (_internalAdProto != NULL && [_internalAdProto respondsToSelector:@selector(adFailedToShow:)]){
            [_internalAdProto adFailedToShow:_ad.placementId];
        }
        
        return;
    }
    
    // start creating the banner ad
    _gate = [[SAParentalGate alloc] initWithWeakRefToView:self];
    
    // calc correctly scaled frame
    CGRect frame = [SAUtils mapOldFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
                             toNewFrame:CGRectMake(0, 0, _ad.creative.details.width, _ad.creative.details.height)];
    
    // add the sawebview
    _webplayer = [[SAWebPlayer alloc] initWithFrame:frame];
    
    // setup the ad size
    [_webplayer setAdSize:CGSizeMake(_ad.creative.details.width, _ad.creative.details.height)];
    
    // moat tracking
    NSString *moatString = @"";
    Class class = NSClassFromString(@"SAEvents");
    SEL selector = NSSelectorFromString(@"sendDisplayMoatEvent:andAdDictionary:");
    if ([class instancesRespondToSelector:selector]) {
        NSDictionary *moatDict = @{
                                   @"advertiser": @(_ad.advertiserId),
                                   @"campaign": @(_ad.campaignId),
                                   @"line_item": @(_ad.lineItemId),
                                   @"creative": @(_ad.creative._id),
                                   @"app": @(_ad.app),
                                   @"placement": @(_ad.placementId),
                                   @"publisher": @(_ad.publisherId)
                                   };
        
        NSMethodSignature *signature = [class methodSignatureForSelector:selector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:class];
        [invocation setSelector:selector];
        [invocation setArgument:&_webplayer atIndex:2];
        [invocation setArgument:&moatDict atIndex:3];
        [invocation retainArguments];
        [invocation invoke];
        void *tmpResult;
        [invocation getReturnValue:&tmpResult];
        moatString = (__bridge NSString*)tmpResult;
    }
    
    // form the full HTML string and play it!
    NSString *fullHTML = [_ad.creative.details.media.html stringByReplacingOccurrencesOfString:@"_MOAT_" withString:moatString];
    
    // get a weak self reference
    __weak typeof (self) weakSelf = self;
    
    // add callbacks for web player events
    [_webplayer setEventHandler:^(SAWebPlayerEvent event) {
        switch (event) {
            case Web_Start: {
                // send viewable impression
                weakSelf.viewabilityTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                                     target:weakSelf
                                                                   selector:@selector(viewableImpressionFunc)
                                                                   userInfo:nil
                                                                    repeats:YES];
                [weakSelf.viewabilityTimer fire];
                
                // if the banner has a separate impression URL, send that as well for 3rd party tracking
                [SAEvents sendAllEventsFor:weakSelf.ad.creative.events withKey:@"impression"];
                
                if ([weakSelf.adDelegate respondsToSelector:@selector(adWasShown:)]) {
                    [weakSelf.adDelegate adWasShown:weakSelf.ad.placementId];
                }
                break;
            }
            case Web_Error: {
                if ([weakSelf.adDelegate respondsToSelector:@selector(adFailedToShow:)]) {
                    [weakSelf.adDelegate adFailedToShow:weakSelf.ad.placementId];
                }
                break;
            }
        }
    }];
    
    // add callbacks for clicks
    [_webplayer setClickHandler:^(NSURL *url) {
        // get the going to URL
        weakSelf.destinationURL = [url absoluteString];
        
        if (weakSelf.isParentalGateEnabled) {
            [weakSelf.gate show];
        } else {
            [weakSelf advanceToClick];
        }
    }];
    
    
    // add it as a subview
    [self addSubview:_webplayer];
    
    // finally load the ad HTML data
    [_webplayer loadAdHTML:fullHTML];
    
    // add the padlock
    _padlock = [[UIImageView alloc] initWithFrame:BIG_PAD_FRAME];
    _padlock.image = [SAUtils padlockImage];
    if ([self shouldShowPadlock]) {
        [_webplayer addSubview:_padlock];
    }
}

- (BOOL) shouldShowPadlock {
    if (_ad.creative.creativeFormat == tag) return false;
    if (_ad.isFallback) return false;
    if (_ad.isHouse && !_ad.safeAdApproved) return false;
    return true;
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
        [SAEvents sendAllEventsFor:_ad.creative.events withKey:@"sa_tracking"];
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

- (void) viewableImpressionFunc {
    
    if (_ticks >= DISPLAY_VIEWABILITY_COUNT) {
        [_viewabilityTimer invalidate];
        _viewabilityTimer = nil;
        
        if (_viewabilityCount == DISPLAY_VIEWABILITY_COUNT) {
            [SAEvents sendAllEventsFor:_ad.creative.events withKey:@"viewable_impr"];
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
        
        NSLog(@"[AA :: Info] Tick %ld/%d - Viewability Count %ld/%d", (long)_ticks, DISPLAY_VIEWABILITY_COUNT, (long)_viewabilityCount, DISPLAY_VIEWABILITY_COUNT);
    }
}


@end
