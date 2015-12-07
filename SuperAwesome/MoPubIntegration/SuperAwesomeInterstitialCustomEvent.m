//
//  SuperAwesome.h
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 28/09/2015.
//
//

// import useful headers
#import "SuperAwesomeInterstitialCustomEvent.h"
#import "SuperAwesome.h"

// private anonymous category of SuperAwesomeBannerCustomEvent, that
// implements two important ad protocols
// - SALoaderProtocol (of SALoader class)
// - SAAdProtocol (common to all SAViews)
@interface SuperAwesomeInterstitialCustomEvent () <SALoaderProtocol, SAAdProtocol>

@property (nonatomic, strong) SAInterstitialAd *interstitial;
@property (nonatomic, assign) BOOL parentalGate;

@end

@implementation SuperAwesomeInterstitialCustomEvent

- (void) requestInterstitialWithCustomEventInfo:(NSDictionary *)info {
    
    // variables received from the MoPub server
    BOOL testMode = false;
    BOOL isParentalGateEnabled = true;
    NSInteger placementId = -1;
    
    id _Nullable testModeObj = [info objectForKey:@"testMode"];
    id _Nullable placementIdObj = [info objectForKey:@"placementId"];
    id _Nullable parentalGateEnabledObj = [info objectForKey:@"parentalGateEnabled"];
    
    if (testModeObj == NULL || placementIdObj == NULL || parentalGateEnabledObj == NULL) {
        
        // then send this to bannerCustomEvent:didFailToLoadAdWithError:
        [self.delegate interstitialCustomEvent:self
                      didFailToLoadAdWithError:[self createErrorWith:@"Failed to get correct custom data from MoPub server."
                                                           andReason:@"Either \"testMode\" or \"placementId\" parameters are wrong."
                                                       andSuggestion:@"Make sure your custom data JSON has format: { \"placementId\":XXX, \"testMode\":true/false }"]];
        
        // return
        return;
    }
    
    // assign values, because they exist
    testMode = [testModeObj boolValue];
    placementId = [placementIdObj integerValue];
    isParentalGateEnabled = [parentalGateEnabledObj boolValue];
    _parentalGate = isParentalGateEnabled;
//    NSLog(@"Placement: %ld - %d", placementId]);
    
    // enable or disable test mode
    if (testMode) {
        [[SuperAwesome sharedManager] enableTestMode];
    }
    else {
        [[SuperAwesome sharedManager] disableTestMode];
    }
    
    [[SALoader sharedManager] setDelegate:self];
    [[SALoader sharedManager] preloadAdForPlacementId:placementId];
}

- (void) showInterstitialFromRootViewController:(UIViewController *)rootViewController {
    
    [rootViewController presentViewController:_interstitial animated:YES completion:^{
        
        // play preloaded ad
        [_interstitial playPreloaded];
        
        // call events
        [self.delegate interstitialCustomEventWillAppear:self];
        [self.delegate interstitialCustomEventDidAppear:self];
    }];
}

#pragma mark Custom Functions

- (NSError*) createErrorWith:(NSString*)description andReason:(NSString*)reaason andSuggestion:(NSString*)suggestion {
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: NSLocalizedString(description, nil),
                               NSLocalizedFailureReasonErrorKey: NSLocalizedString(reaason, nil),
                               NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(suggestion, nil)
                               };
    
    return [NSError errorWithDomain:@"SuperAwesomeErrorDomain" code:0 userInfo:userInfo];
}

#pragma mark <SALoaderProtocol>

- (void) didPreloadAd:(SAAd *)ad forPlacementId:(NSInteger)placementId {
    // init interstitial
    _interstitial = [[SAInterstitialAd alloc] init];
    [_interstitial setIsParentalGateEnabled:_parentalGate];
    [_interstitial setAd:ad];
    
    // call events
    [self.delegate interstitialCustomEvent:self didLoadAd:_interstitial];
}

- (void) didFailToPreloadAdForPlacementId:(NSInteger)placementId {
    
    // then send this to bannerCustomEvent:didFailToLoadAdWithError:
    [self.delegate interstitialCustomEvent:self
                  didFailToLoadAdWithError:[self createErrorWith:[NSString stringWithFormat:@"Failed to preload SuperAwesome Intestitial Ad for PlacementId: %ld", placementId]
                                                       andReason:@"The operation timed out."
                                                   andSuggestion:@"Check your placement Id."]];
}

#pragma mark <SAAdProtocol>

- (void) adFailedToShow:(NSInteger)placementId {
    
    // then send this to bannerCustomEvent:didFailToLoadAdWithError:
    [self.delegate interstitialCustomEvent:self
                  didFailToLoadAdWithError:[self createErrorWith:[NSString stringWithFormat:@"Failed to display SuperAwesome Intestitial Ad for PlacementId: %ld", placementId]
                                                       andReason:@"JSON invalid."
                                                   andSuggestion:@"Contact SuperAwesome support: <devsuppoer@superawesome.tv>"]];
}

- (void) adFollowedURL:(NSInteger)placementId {
    
    // call required event
    [self.delegate interstitialCustomEventDidReceiveTapEvent:self];
}

- (void) adWasClosed:(NSInteger)placementId {
    
    // call required events
    [self.delegate interstitialCustomEventWillDisappear:self];
    [self.delegate interstitialCustomEventDidDisappear:self];
}

@end
