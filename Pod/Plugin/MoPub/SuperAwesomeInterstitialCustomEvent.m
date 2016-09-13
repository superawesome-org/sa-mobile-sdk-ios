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

@interface SuperAwesomeInterstitialCustomEvent ()
@property (nonatomic, assign) NSInteger placementId;
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
    
    // get a weak self reference
    __weak typeof (self) weakSelf = self;
    
    // assign values, because they exist
    BOOL isTestEnabled = [isTestEnabledObj boolValue];
    _placementId = [placementIdObj integerValue];
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
    
    // start the loader
    [SAInterstitialAd setTest:isTestEnabled];
    [SAInterstitialAd setConfigurationProduction];
    [SAInterstitialAd setIsParentalGateEnabled:isParentalGateEnabled];
    [SAInterstitialAd setShouldLockOrientation:shouldLockOrientation];
    [SAInterstitialAd setLockOrientation:lockOrientation];
    [SAInterstitialAd setCallback:^(NSInteger placementId, SAEvent event) {
        switch (event) {
            case adLoaded: {
                [weakSelf.delegate interstitialCustomEvent:weakSelf didLoadAd:[SAInterstitialAd self]];
                break;
            }
            case adFailedToLoad: {
                [weakSelf.delegate interstitialCustomEvent:weakSelf
                                  didFailToLoadAdWithError:[weakSelf createErrorWith:ERROR_LOAD_TITLE(@"Interstitial Ad", placementId)
                                                                           andReason:ERROR_LOAD_MESSAGE
                                                                       andSuggestion:ERROR_LOAD_SUGGESTION]];
                break;
            }
            case adShown: {
                [weakSelf.delegate interstitialCustomEventDidAppear:weakSelf];
                break;
            }
            case adFailedToShow: {
                [weakSelf.delegate interstitialCustomEvent:weakSelf
                                  didFailToLoadAdWithError:[weakSelf createErrorWith:ERROR_SHOW_TITLE(@"Interstitial Ad", 0)
                                                                           andReason:ERROR_SHOW_MESSAGE
                                                                       andSuggestion:ERROR_SHOW_SUGGESTION]];
                break;
            }
            case adClicked: {
                [weakSelf.delegate interstitialCustomEventDidReceiveTapEvent:weakSelf];
                [weakSelf.delegate interstitialCustomEventWillLeaveApplication:weakSelf];
                break;
            }
            case adClosed: {
                [weakSelf.delegate interstitialCustomEventWillDisappear:weakSelf];
                [weakSelf.delegate interstitialCustomEventDidDisappear:weakSelf];
                break;
            }
        }
    }];
    
    // load
    [SAInterstitialAd load:_placementId];
}

- (void) showInterstitialFromRootViewController:(UIViewController *)rootViewController {
    // play
    [SAInterstitialAd play:_placementId fromVC:rootViewController];
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

@end
