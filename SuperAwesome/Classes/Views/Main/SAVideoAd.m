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

#import <AdSupport/ASIdentifierManager.h>

// import video stuff
#import <AVFoundation/AVFoundation.h>
#import "IMAAdsLoader.h"
#import "IMAAdsManager.h"
#import "IMAAVPlayerContentPlayhead.h"
#import "IMAAdDisplayContainer.h"
#import "IMAUiElements.h"

// import models
#import "SAAd.h"
#import "SACreative.h"
#import "SADetails.h"
#import "SASender.h"

// import parental gate
#import "SAParentalGate.h"

// import utils
#import "UIViewController+Utils.h"

// Anon Category of SAView to maintain some functions private
@interface SAView ()
- (void) tryToGoToURL:(NSURL*)url;
- (void) createPadlockButtonWithParent:(UIView *)parent;
- (void) removePadlockButtonFromParent;
- (void) resizeToFrame:(CGRect)toframe;
@end

// Anon Category of SAvideoAd to declare private variables and delegate
// implementations, especially for google IMA ads
@interface SAVideoAd ()
<IMAAdsLoaderDelegate,
 IMAAdsManagerDelegate,
 IMAWebOpenerDelegate>

// views
@property (nonatomic, strong) AVPlayer *contentPlayer;

// google specific stuff
@property (nonatomic, strong) IMAAdsLoader *adsLoader;
@property (nonatomic, strong) IMAAVPlayerContentPlayhead *contentPlayhead;
@property (nonatomic, strong) IMAAdsManager *adsManager;

// notif center
@property (nonatomic, strong) NSNotificationCenter *notifCenter;

@end

// Implementation of SAVideo Ad
@implementation SAVideoAd

- (id) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]){
        // do nothing
        _notifCenter = [NSNotificationCenter defaultCenter];
    }
    return self;
}

- (void) play {
    [super play];
    
    // setup ads loader
    _adsLoader = [[IMAAdsLoader alloc] initWithSettings:nil];
    _adsLoader.delegate = self;
    
    IMAAdDisplayContainer *adDisplayContainer = [[IMAAdDisplayContainer alloc] initWithAdContainer:self companionSlots:nil];
    IMAAdsRequest *request = [[IMAAdsRequest alloc] initWithAdTagUrl:ad.creative.details.vast adDisplayContainer:adDisplayContainer userContext:nil];
    [_adsLoader requestAdsWithRequest:request];
    
    // setup action button
    actionButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30.0f)];
    [actionButton setTitle:@"" forState:UIControlStateNormal];
    [actionButton addTarget:self action:@selector(gotoURL:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:actionButton];
}

#pragma mark SAVideoAd functions

- (void) createContentPlayhead {
    
}

- (void)contentDidFinishPlaying:(NSNotification *)notification {
    // end of content
    if (notification.object == _contentPlayer.currentItem) {
        [_adsLoader contentComplete];
    }
}

#pragma mark AdsLoader Delegate

- (void) adsLoader:(IMAAdsLoader *)loader adsLoadedWithData:(IMAAdsLoadedData *)adsLoadedData {
    // get an ad manager and set it's delegate
    _adsManager = adsLoadedData.adsManager;
    _adsManager.delegate = self;
    
    // create settings for the ad manager
    IMAAdsRenderingSettings *adsRenderingSettings = [[IMAAdsRenderingSettings alloc] init];
    adsRenderingSettings.webOpenerPresentingController = nil;
    
    // create content playhead
    _contentPlayhead = [[IMAAVPlayerContentPlayhead alloc] initWithAVPlayer:_contentPlayer];
    [_notifCenter addObserver:self selector:@selector(contentDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:[_contentPlayer currentItem]];
    
    // initialize manager with playhead and settings
    [_adsManager initializeWithContentPlayhead:_contentPlayhead adsRenderingSettings:adsRenderingSettings];
}

- (void) adsLoader:(IMAAdsLoader *)loader failedWithErrorData:(IMAAdLoadingErrorData *)adErrorData {
    [_contentPlayer play];
    
    if ([super.delegate respondsToSelector:@selector(adFailedToShow:)]) {
        [super.delegate adFailedToShow:ad.placementId];
    }
}

#pragma mark AdsManager Delegate

- (void)adsManager:(IMAAdsManager *)adsManager didReceiveAdEvent:(IMAAdEvent *)event {
    // When the SDK notified us that ads have been loaded, play them.
    switch (event.type) {
        case kIMAAdEvent_LOADED: {
            
            [adsManager start];
            [self createPadlockButtonWithParent:self];
            
            break;
        }
        case kIMAAdEvent_STARTED:{
            
            if ([super.delegate respondsToSelector:@selector(adWasShown:)]) {
                [super.delegate adWasShown:ad.placementId];
            }
            
            if ([_videoDelegate respondsToSelector:@selector(videoStarted:)]) {
                [_videoDelegate videoStarted:ad.placementId];
            }
            
            break;
        }
        case kIMAAdEvent_FIRST_QUARTILE:{
            
            if ([_videoDelegate respondsToSelector:@selector(videoReachedFirstQuartile:)]){
                [_videoDelegate videoReachedFirstQuartile:ad.placementId];
            }
            
            break;
        }
        case kIMAAdEvent_MIDPOINT: {
            
            if ([_videoDelegate respondsToSelector:@selector(videoReachedMidpoint:)]) {
                [_videoDelegate videoReachedMidpoint:ad.placementId];
            }
            
            break;
        }
        case kIMAAdEvent_THIRD_QUARTILE:{
            
            if ([_videoDelegate respondsToSelector:@selector(videoReachedThirdQuartile:)]) {
                [_videoDelegate videoReachedThirdQuartile:ad.placementId];
            }
            
            break;
        }
        case kIMAAdEvent_COMPLETE:{
            
            if ([_videoDelegate respondsToSelector:@selector(videoEnded:)]) {
                [_videoDelegate videoEnded:ad.placementId];
            }
            
            break;
        }
        case kIMAAdEvent_SKIPPED:{
            
            if ([_videoDelegate respondsToSelector:@selector(videoSkipped:)]){
                [_videoDelegate videoSkipped:ad.placementId];
            }
            
            break;
        }
            
        default:
            break;
    }
}

- (void)adsManager:(IMAAdsManager *)adsManager didReceiveAdError:(IMAAdError *)error {
    [_contentPlayer play];
    
    if ([super.delegate respondsToSelector:@selector(adFailedToShow:)]) {
        [super.delegate adFailedToShow:ad.placementId];
    }
}

- (void)adsManagerDidRequestContentPause:(IMAAdsManager *)adsManager {
    [_contentPlayer pause];
}

- (void)adsManagerDidRequestContentResume:(IMAAdsManager *)adsManager {
    [_contentPlayer play];
}

- (void) gotoURL: (id)sender {
    
    [self tryToGoToURL:NULL];

}

#pragma mark Resize

- (void) resizeToFrame:(CGRect)toframe {
    
    self.frame = toframe;
    actionButton.frame = CGRectMake(0, 0, self.frame.size.width, 30.0f);
    [padlockBtn removeFromSuperview];
    padlockBtn = NULL;
    [self createPadlockButtonWithParent:self];
}

@end
