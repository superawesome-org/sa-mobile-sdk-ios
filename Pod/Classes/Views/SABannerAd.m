//
//  SABannerAd2.m
//  Pods
//
//  Created by Gabriel Coman on 13/02/2016.
//
//

#import "SABannerAd.h"

#import "SuperAwesome.h"
#import "SAParentalGate.h"
#import "SAAd.h"
#import "SACreative.h"
#import "SADetails.h"
#import "SAMedia.h"
#import "SALoader.h"

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

@property (nonatomic, strong) SALoader *loader;
@property (nonatomic, strong) SAEvents *events;

@property (nonatomic, strong) SAAd *ad;
@property (nonatomic, strong) SAWebPlayer *webplayer;
@property (nonatomic, strong) SAParentalGate *gate;
@property (nonatomic, strong) UIImageView *padlock;

@property (nonatomic, strong) NSString *fullHTMLToLoad;
@property (nonatomic, strong) NSString *destinationURL;
@property (nonatomic, assign) BOOL canPlay;

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
    _canPlay = true;
    _loader = [[SALoader alloc] init];
    _isParentalGateEnabled = false;
    self.backgroundColor = BG_COLOR;
}

#pragma mark <SAViewProtocol> functions

- (void) load:(NSInteger)placementId {
    
    // reset playability
    _canPlay = false;
    
    // get a weak self reference
    __weak typeof (self) weakSelf = self;
    
    // load ad
    [_loader loadAd:placementId withResult:^(SAAd *ad) {
        
        // assign new ad
        weakSelf.ad = ad;
        
        // set can play
        weakSelf.canPlay = true;
        
        // call delegate
        if (ad != NULL) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(SADidLoadAd:forPlacementId:)]) {
                [weakSelf.delegate SADidLoadAd:weakSelf forPlacementId:placementId];
            }
        } else {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(SADidNotLoadAd:forPlacementId:)]) {
                [weakSelf.delegate SADidNotLoadAd:weakSelf forPlacementId:placementId];
            }
        }
    }];
}

- (void) play {
    
    if (_ad && _ad.creative.creativeFormat != video && _canPlay) {
        
        // start events
        _events = [[SAEvents alloc] init];
        [_events setAd:_ad];
        
        // get a weak self reference
        __weak typeof (self) weakSelf = self;
        
        // reset play-ability
        _canPlay = false;
        
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
        _fullHTMLToLoad = [_ad.creative.details.media.html stringByReplacingOccurrencesOfString:@"_MOAT_" withString:moatString];
        
        // add callbacks for web player events
        [_webplayer setEventHandler:^(SAWebPlayerEvent event) {
            switch (event) {
                case Web_Start: {
                    // send viewable impression
                    [weakSelf.events sendViewableForInScreen:weakSelf];
                    
                    // if the banner has a separate impression URL, send that as well for 3rd party tracking
                    [weakSelf.events sendAllEventsForKey:@"impression"];
                    
                    if ([weakSelf.delegate respondsToSelector:@selector(SADidShowAd:)]) {
                        [weakSelf.delegate SADidShowAd:weakSelf];
                    }
                    break;
                }
                case Web_Error: {
                    if ([weakSelf.delegate respondsToSelector:@selector(SADidNotShowAd:)]) {
                        [weakSelf.delegate SADidNotShowAd:weakSelf];
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
                [weakSelf click];
            }
        }];
        
        // add the webplayer as a subview
        [self addSubview:_webplayer];
        
        // add the padlock
        _padlock = [[UIImageView alloc] initWithFrame:BIG_PAD_FRAME];
        _padlock.image = [SAUtils padlockImage];
        if ([self shouldShowPadlock]) {
            [_webplayer addSubview:_padlock];
        }
        
        // finally play!
        [_webplayer loadAdHTML:_fullHTMLToLoad];
        
    } else {
        if (_delegate && [_delegate respondsToSelector:@selector(SADidNotShowAd:)]) {
            [_delegate SADidNotShowAd:self];
        }
    }
}

- (void) setAd:(SAAd *)ad {
    _ad = ad;
}

- (SAAd*) getAd {
    return _ad;
}

- (BOOL) shouldShowPadlock {
    if (_ad.creative.creativeFormat == tag) return false;
    if (_ad.isFallback) return false;
    if (_ad.isHouse && !_ad.safeAdApproved) return false;
    return true;
}

- (void) close {
    // remove all stuffs
    [_webplayer removeFromSuperview];
    _webplayer = nil;
    [_padlock removeFromSuperview];
    _padlock = nil;
    _gate = nil;
    
    // call delegate
    if (_delegate && [_delegate respondsToSelector:@selector(SADidCloseAd:)]) {
        [_delegate SADidCloseAd:self];
    }
}

- (void) click {
    NSLog(@"[AA :: INFO] Going to %@", _destinationURL);
    
    // call delegate
    if (_delegate && [_delegate respondsToSelector:@selector(SADidClickAd:)]) {
        [_delegate SADidClickAd:self];
    }
    
    // call events
    if ([_destinationURL rangeOfString:[[SuperAwesome getInstance] getBaseURL]].location == NSNotFound) {
        [_events sendAllEventsForKey:@"sa_tracking"];
    }
    
    // open URL
    NSURL *url = [NSURL URLWithString:_destinationURL];
    [[UIApplication sharedApplication] openURL:url];
}

- (void) resize:(CGRect)toframe {
    self.frame = toframe;
    
    CGRect frame = [SAUtils mapOldFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
                             toNewFrame:CGRectMake(0, 0, _ad.creative.details.width, _ad.creative.details.height)];
    
    // rearrange the webview
    [_webplayer updateToFrame:frame];
    
    // rearrange the padlock
    _padlock.frame = BIG_PAD_FRAME;
}


@end
