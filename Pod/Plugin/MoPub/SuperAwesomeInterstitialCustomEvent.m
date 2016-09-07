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
#import "SuperAwesomeMoPub.h"

@interface SuperAwesomeInterstitialCustomEvent () <SAProtocol>
@end

@implementation SuperAwesomeInterstitialCustomEvent

- (void) requestInterstitialWithCustomEventInfo:(NSDictionary *)info {
    
    // variables received from the MoPub server
    id _Nullable placementIdObj = [info objectForKey:PLACEMENT_ID];
    id _Nullable isTestEnabledObj = [info objectForKey:TEST_ENABLED];
    id _Nullable isParentalGateEnabledObj = [info objectForKey:PARENTAL_GATE];
    id _Nullable shouldLockOrientationObj = [info objectForKey:SHOULD_LOCK];
    id _Nullable lockOrientationObj = [info objectForKey:LOCK_ORIENTATION];
    
    if (isTestEnabledObj == NULL || placementIdObj == NULL) {
        
        // then send this to bannerCustomEvent:didFailToLoadAdWithError:
        [self.delegate interstitialCustomEvent:self
                      didFailToLoadAdWithError:[self createErrorWith:ERROR_JSON_TITLE
                                                           andReason:ERROR_JSON_MESSAGE
                                                       andSuggestion:ERROR_JSON_SUGGESTION]];
        
        // return
        return;
    }
    
    // assign values, because they exist
    BOOL isTestEnabled = [isTestEnabledObj boolValue];
    NSInteger placementId = [placementIdObj integerValue];
    BOOL isParentalGateEnabled = (isParentalGateEnabledObj != NULL ? [isParentalGateEnabledObj boolValue] : true);
    BOOL shouldLockOrientation = (shouldLockOrientationObj != NULL ? [shouldLockOrientationObj boolValue] : false);
    NSInteger lockOrientation = UIInterfaceOrientationMaskAll;
    if (lockOrientationObj != NULL) {
        NSString *orient = (NSString*)lockOrientationObj;
        if ([orient isEqualToString:@"LANDSCAPE"]){
            lockOrientation = UIInterfaceOrientationMaskLandscape;
        } else if ([orient isEqualToString:@"PORTRAIT"]){
            lockOrientation = UIInterfaceOrientationMaskPortrait;
        } else {
            shouldLockOrientation = NO;
        }
    }
    
    // enable or disable test mode
    [[SuperAwesome getInstance] setTesting:isTestEnabled];
    
    // start the loader
    [SAInterstitialAd setDelegate:self];
    [SAInterstitialAd setIsParentalGateEnabled:isParentalGateEnabled];
    [SAInterstitialAd setShouldLockOrientation:shouldLockOrientation];
    [SAInterstitialAd setLockOrientation:lockOrientation];
    [SAInterstitialAd load:placementId];
}

- (void) showInterstitialFromRootViewController:(UIViewController *)rootViewController {
    [SAInterstitialAd play];
    [self.delegate interstitialCustomEventWillAppear:self];
}

- (NSError*) createErrorWith:(NSString*)description andReason:(NSString*)reaason andSuggestion:(NSString*)suggestion {
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: NSLocalizedString(description, nil),
                               NSLocalizedFailureReasonErrorKey: NSLocalizedString(reaason, nil),
                               NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(suggestion, nil)
                               };
    
    return [NSError errorWithDomain:ERROR_DOMAIN code:ERROR_CODE userInfo:userInfo];
}



// MARK: SAProtocol functions

- (void) SADidLoadAd:(id) sender forPlacementId: (NSInteger) placementId {
    [self.delegate interstitialCustomEvent:self didLoadAd:[SAInterstitialAd self]];
}

- (void) SADidNotLoadAd:(id) sender forPlacementId: (NSInteger) placementId {
    [self.delegate interstitialCustomEvent:self
                  didFailToLoadAdWithError:[self createErrorWith:ERROR_LOAD_TITLE(@"Interstitial Ad", placementId)
                                                       andReason:ERROR_LOAD_MESSAGE
                                                   andSuggestion:ERROR_LOAD_SUGGESTION]];
}

- (void) SADidShowAd:(id) sender {
    [self.delegate interstitialCustomEventDidAppear:self];
}

- (void) SADidNotShowAd:(id) sender {
    [self.delegate interstitialCustomEvent:self
                  didFailToLoadAdWithError:[self createErrorWith:ERROR_SHOW_TITLE(@"Interstitial Ad", 0)
                                                       andReason:ERROR_SHOW_MESSAGE
                                                   andSuggestion:ERROR_SHOW_SUGGESTION]];
}

- (void) SADidClickAd:(id) sender {
    [self.delegate interstitialCustomEventDidReceiveTapEvent:self];
    [self.delegate interstitialCustomEventWillLeaveApplication:self];
}

- (void) SADidCloseAd:(id) sender {
    // call required events
    [self.delegate interstitialCustomEventWillDisappear:self];
    [self.delegate interstitialCustomEventDidDisappear:self];
}

@end
