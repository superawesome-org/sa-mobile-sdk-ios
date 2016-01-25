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
@interface SuperAwesomeInterstitialCustomEvent () <SALoaderProtocol, SAAdProtocol, SAParentalGateProtocol>

@property (nonatomic, strong) SAInterstitialAd *interstitial;
@property (nonatomic, assign) NSInteger placementId;
@property (nonatomic, assign) BOOL isTestEnabled;
@property (nonatomic, assign) BOOL isParentalGateEnabled;
@property (nonatomic, strong) SALoader *loader;

@end

@implementation SuperAwesomeInterstitialCustomEvent

- (void) requestInterstitialWithCustomEventInfo:(NSDictionary *)info {
    
    // variables received from the MoPub server
    id _Nullable placementIdObj = [info objectForKey:@"placementId"];
    id _Nullable isTestEnabledObj = [info objectForKey:@"isTestEnabled"];
    id _Nullable isParentalGateEnabledObj = [info objectForKey:@"isParentalGateEnabled"];
    
    if (isTestEnabledObj == NULL || placementIdObj == NULL) {
        
        // then send this to bannerCustomEvent:didFailToLoadAdWithError:
        [self.delegate interstitialCustomEvent:self
                      didFailToLoadAdWithError:[self createErrorWith:@"Failed to get correct custom data from MoPub server."
                                                           andReason:@"Either \"testMode\" or \"placementId\" parameters are wrong."
                                                       andSuggestion:@"Make sure your custom data JSON has format: { \"placementId\":XXX, \"testMode\":true/false }"]];
        
        // return
        return;
    }
    
    // assign values, because they exist
    _isTestEnabled = [isTestEnabledObj boolValue];
    _placementId = [placementIdObj integerValue];
    _isParentalGateEnabled = (isParentalGateEnabledObj != NULL ? [isParentalGateEnabledObj boolValue] : true);
    
    // enable or disable test mode
    [[SuperAwesome getInstance] setTesting:_isTestEnabled];
    
    // start the loader
    _loader = [[SALoader alloc] init];
    [_loader setDelegate:self];
    [_loader loadAdForPlacementId:_placementId];
}

- (void) showInterstitialFromRootViewController:(UIViewController *)rootViewController {
    
    [rootViewController presentViewController:_interstitial animated:YES completion:^{
        
        // call events
        [self.delegate interstitialCustomEventWillAppear:self];
        
        // play preloaded ad
        [_interstitial play];
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

- (void) didLoadAd:(SAAd *)ad {
    // init interstitial
    _interstitial = [[SAInterstitialAd alloc] init];
    
    // set parameters
    [_interstitial setIsParentalGateEnabled:_isParentalGateEnabled];
    
    // set delegate
    [_interstitial setAdDelegate:self];
    [_interstitial setParentalGateDelegate: self];
    
    // set ad
    [_interstitial setAd:ad];
    
    // call events
    [self.delegate interstitialCustomEvent:self didLoadAd:_interstitial];
}

- (void) didFailToLoadAdForPlacementId:(NSInteger)placementId {
    // then send this to bannerCustomEvent:didFailToLoadAdWithError:
    [self.delegate interstitialCustomEvent:self
                  didFailToLoadAdWithError:[self createErrorWith:[NSString stringWithFormat:@"Failed to preload SuperAwesome Intestitial Ad for PlacementId: %ld", (long)placementId]
                                                       andReason:@"The operation timed out."
                                                   andSuggestion:@"Check your placement Id."]];
}

#pragma mark <SAAdProtocol>

- (void) adWasShown:(NSInteger)placementId {
    [self.delegate interstitialCustomEventDidAppear:self];
}

- (void) adFailedToShow:(NSInteger)placementId {
    
    // then send this to bannerCustomEvent:didFailToLoadAdWithError:
    [self.delegate interstitialCustomEvent:self
                  didFailToLoadAdWithError:[self createErrorWith:[NSString stringWithFormat:@"Failed to display SuperAwesome Intestitial Ad for PlacementId: %ld", (long)placementId]
                                                       andReason:@"JSON invalid."
                                                   andSuggestion:@"Contact SuperAwesome support: <devsupport@superawesome.tv>"]];
}

- (void) adWasClicked:(NSInteger)placementId {
    // call required event
    [self.delegate interstitialCustomEventDidReceiveTapEvent:self];
    
    // only show this directly if PG is not enabled
    // if it is, it will be called when PG is successfull
    if (!_isParentalGateEnabled) {
        [self.delegate interstitialCustomEventWillLeaveApplication:self];
    }
}

- (void) adWasClosed:(NSInteger)placementId {
    // call required events
    [self.delegate interstitialCustomEventWillDisappear:self];
    [self.delegate interstitialCustomEventDidDisappear:self];
}

#pragma mark <SAParentalGateProtocol>

- (void) parentalGateWasCanceled:(NSInteger)placementId {
    // do nothing here
}

- (void) parentalGateWasSucceded:(NSInteger)placementId {
    [self.delegate interstitialCustomEventWillLeaveApplication:self];
}

- (void) parentalGateWasFailed:(NSInteger)placementId {
    // do nothing here
}

@end
