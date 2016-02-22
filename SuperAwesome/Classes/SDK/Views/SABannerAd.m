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
#import "SASender.h"
#import "SAWebView.h"
#import "SAUtils.h"

// defines
#define BG_COLOR [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1]
#define BIG_PAD_FRAME CGRectMake(0, 0, 67, 25)

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

- (void) setAd:(SAAd*)_ad {
    ad = _ad;
}

- (SAAd*) getAd {
    return ad;
}

- (void) play {
    // check for incorrect placement
    if (ad.creative.format == video || ad == nil) {
        if (_adDelegate != NULL && [_adDelegate respondsToSelector:@selector(adHasIncorrectPlacement:)]){
            [_adDelegate adHasIncorrectPlacement:ad.placementId];
        }
        return;
    }
    
    // start creating the banner ad
    gate = [[SAParentalGate alloc] initWithWeakRefToView:self];
    gate.delegate = _parentalGateDelegate;
    
    // calc correctly scaled frame
    CGRect frame = [SAUtils arrangeAdInNewFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
                                      fromFrame:CGRectMake(0, 0, ad.creative.details.width, ad.creative.details.height)];
    
    // add the sawebview
    sawebview = [[SAWebView alloc] initWithHTML:ad.adHTML
                                      andAdSize:CGSizeMake(ad.creative.details.width, ad.creative.details.height)
                                       andFrame:frame
                                    andDelegate:self];
    
    // add the subview
    [self addSubview:sawebview];
    
    // add the padlick
    padlock = [[UIImageView alloc] initWithFrame:BIG_PAD_FRAME];
    padlock.image = [UIImage imageNamed:@"watermark_67x25"];
    if (!ad.isFallback && !ad.isHouse) {
        [sawebview addSubview:padlock];
    }
}

- (void) close {
    // do nothing
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
    
    CGRect frame = [SAUtils arrangeAdInNewFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
                                      fromFrame:CGRectMake(0, 0, ad.creative.details.width, ad.creative.details.height)];
    
    // rearrange the webview
    [sawebview rearrangeForFrame:frame];
    
    // rearrange the padlock
    padlock.frame = BIG_PAD_FRAME;
}

#pragma mark <SAWebViewProtocol> functions

- (void) saWebViewDidLoad {
    [SASender sendEventToURL:ad.creative.viewableImpressionURL];
    
    if ([_adDelegate respondsToSelector:@selector(adWasShown:)]) {
        [_adDelegate adWasShown:ad.placementId];
    }
}

- (void) saWebViewDidFail {
    if ([_adDelegate respondsToSelector:@selector(adFailedToShow:)]) {
        [_adDelegate adFailedToShow:ad.placementId];
    }
}

- (void) saWebViewWillNavigate:(NSURL *)url {
    [self tryToGoToURL:url];
}

@end
