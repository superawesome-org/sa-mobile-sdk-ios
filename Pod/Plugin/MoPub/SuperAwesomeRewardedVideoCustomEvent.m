//
//  SuperAwesomeRewardedVideoCustomEvent.m
//  SAMoPubIntegrationDemo
//
//  Created by Gabriel Coman on 17/12/2015.
//  Copyright © 2015 Gabriel Coman. All rights reserved.
//

// import header
#import "SuperAwesomeRewardedVideoCustomEvent.h"

// import SuperAwesome
#import "SuperAwesome.h"
#import "MPRewardedVideoReward.h"
#import "SuperAwesomeMoPub.h"

@interface SuperAwesomeRewardedVideoCustomEvent ()
@property (nonatomic, strong) MPRewardedVideoReward *reward;
@property (nonatomic, assign) BOOL hasAdAvailable;
@property (nonatomic, assign) NSInteger placementId;
@end

@implementation SuperAwesomeRewardedVideoCustomEvent

- (void) requestRewardedVideoWithCustomEventInfo:(NSDictionary *)info {
    
    // get values from the info dictionary
    id _Nullable placementIdObj = [info objectForKey:PLACEMENT_ID];
    id _Nullable isTestEnabledObj = [info objectForKey:TEST_ENABLED];
    id _Nullable isParentalGateEnabledObj = [info objectForKey:PARENTAL_GATE];
    id _Nullable shouldShowCloseButtonObj = [info objectForKey:SHOULD_SHOW_CLOSE];
    id _Nullable shouldAutomaticallyCloseAtEndObj = [info objectForKey:SHOULD_AUTO_CLOSE];
    id _Nullable shouldLockOrientationObj = [info objectForKey:SHOULD_LOCK];
    id _Nullable lockOrientationObj = [info objectForKey:LOCK_ORIENTATION];
    id _Nullable shouldShowSmallClickButtonObj = [info objectForKey:VIDEO_BUTTON_STYLE];
    
    if (isTestEnabledObj == NULL || placementIdObj == NULL) {
        
        // then send this to bannerCustomEvent:didFailToLoadAdWithError:
        [self.delegate rewardedVideoDidFailToLoadAdForCustomEvent:self
                                                            error:[self createErrorWith:ERROR_JSON_TITLE
                                                                              andReason:ERROR_JSON_MESSAGE
                                                                          andSuggestion:ERROR_JSON_SUGGESTION]];
        
        
        // return
        return;
    }
    
    // assign values, because they exist
    _placementId = [placementIdObj integerValue];
    BOOL isTestEnabled = [isTestEnabledObj boolValue];
    BOOL isParentalGateEnabled = (isParentalGateEnabledObj != NULL ? [isParentalGateEnabledObj boolValue] : true);
    BOOL shouldShowCloseButton = (shouldShowCloseButtonObj != NULL ? [shouldShowCloseButtonObj boolValue] : false);
    BOOL shouldAutomaticallyCloseAtEnd = (shouldAutomaticallyCloseAtEndObj != NULL ? [shouldAutomaticallyCloseAtEndObj boolValue] : true);
    BOOL shouldShowSmallClickButton = (shouldShowSmallClickButtonObj != NULL ? [shouldShowSmallClickButtonObj boolValue] : false);
    BOOL shouldLockOrientation = (shouldLockOrientationObj != NULL ? [shouldLockOrientationObj boolValue] : false);
    NSString *lockOrientationStr = (lockOrientationObj != NULL ? (NSString*)lockOrientationObj : NULL);
    NSInteger lockOrientation = 0;
    if (lockOrientationStr != NULL) {
        if ([lockOrientationStr isEqualToString:@"PORTRAIT"]) {
            lockOrientation = 1;
        } else {
            lockOrientation = 2;
        }
    }
    
    _hasAdAvailable = false;
    
    // get a weak self reference
    __weak typeof (self) weakSelf = self;
    
    // enable or disable test mode
    [SAVideoAd setConfigurationProduction];
    
    if (isTestEnabled) {
        [SAVideoAd enableTestMode];
    } else {
        [SAVideoAd disableTestMode];
    }
    
    if (isParentalGateEnabled) {
        [SAVideoAd enableParentalGate];
    } else {
        [SAVideoAd disableParentalGate];
    }
    
    if (shouldShowCloseButton) {
        [SAVideoAd enableCloseButton];
    } else {
        [SAVideoAd disableCloseButton];
    }
    
    if (shouldAutomaticallyCloseAtEnd) {
        [SAVideoAd enableCloseAtEnd];
    } else {
        [SAVideoAd disableCloseAtEnd];
    }
    
    if (shouldShowSmallClickButton) {
        [SAVideoAd enableSmallClickButton];
    } else {
        [SAVideoAd disableSmallClickButton];
    }
    
    if (shouldLockOrientation) {
        if (lockOrientation == 1) {
            [SAVideoAd setOrientationPortrait];
        } else {
            [SAVideoAd setOrientationLandscape];
        }
    } else {
        [SAVideoAd setOrientationAny];
    }
    
    [SAVideoAd setCallback:^(NSInteger placementId, SAEvent event) {
        switch (event) {
            case adLoaded: {
                weakSelf.hasAdAvailable = true;
                weakSelf.reward = [[MPRewardedVideoReward alloc] initWithCurrencyType:kMPRewardedVideoRewardCurrencyTypeUnspecified amount:@(0)];
                [weakSelf.delegate rewardedVideoDidLoadAdForCustomEvent:weakSelf];
                break;
            }
            case adFailedToLoad: {
                [weakSelf.delegate rewardedVideoDidFailToLoadAdForCustomEvent:weakSelf
                                                                        error:[weakSelf createErrorWith:ERROR_LOAD_TITLE(@"Video Ad", placementId)
                                                                                              andReason:ERROR_LOAD_MESSAGE
                                                                                          andSuggestion:ERROR_LOAD_SUGGESTION]];
                break;
            }
            case adShown: {
                [weakSelf.delegate rewardedVideoDidAppearForCustomEvent:weakSelf];
                break;
            }
            case adFailedToShow: {
                [weakSelf.delegate rewardedVideoDidFailToPlayForCustomEvent:weakSelf
                                                                      error:[weakSelf createErrorWith:ERROR_SHOW_TITLE(@"Video Ad", 0)
                                                                                            andReason:ERROR_SHOW_MESSAGE
                                                                                        andSuggestion:ERROR_SHOW_SUGGESTION]];
                break;
            }
            case adClicked: {
                [weakSelf.delegate rewardedVideoDidReceiveTapEventForCustomEvent:weakSelf];
                [weakSelf.delegate rewardedVideoWillLeaveApplicationForCustomEvent:weakSelf];
                break;
            }
            case adClosed: {
                // reward
                [weakSelf.delegate rewardedVideoShouldRewardUserForCustomEvent:weakSelf reward:_reward];
                
                // call required events
                [weakSelf.delegate rewardedVideoWillDisappearForCustomEvent:weakSelf];
                [weakSelf.delegate rewardedVideoDidDisappearForCustomEvent:weakSelf];
                
                // also null this so no references remain and memory is freed correctly
                weakSelf.reward = NULL;
                break;
            }
        }
    }];
    [SAVideoAd load:_placementId];
}

- (void) presentRewardedVideoFromViewController:(UIViewController *)viewController {
    // play
    [SAVideoAd play:_placementId fromVC:viewController];
    [self.delegate rewardedVideoWillAppearForCustomEvent:self];
}

- (BOOL) hasAdAvailable {
    return _hasAdAvailable;
}

- (void) handleCustomEventInvalidated {
    // do nothing
}

- (void) handleAdPlayedForCustomEventNetwork {
    // do nothing
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