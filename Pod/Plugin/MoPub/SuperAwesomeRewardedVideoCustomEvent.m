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

@interface SuperAwesomeRewardedVideoCustomEvent () <SAProtocol>
@property (nonatomic, strong) MPRewardedVideoReward *reward;
@property (nonatomic, assign) BOOL hasAdAvailable;
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
    NSInteger placementId = [placementIdObj integerValue];
    BOOL isTestEnabled = [isTestEnabledObj boolValue];
    BOOL isParentalGateEnabled = (isParentalGateEnabledObj != NULL ? [isParentalGateEnabledObj boolValue] : true);
    BOOL shouldShowCloseButton = (shouldShowCloseButtonObj != NULL ? [shouldShowCloseButtonObj boolValue] : false);
    BOOL shouldAutomaticallyCloseAtEnd = (shouldAutomaticallyCloseAtEndObj != NULL ? [shouldAutomaticallyCloseAtEndObj boolValue] : true);
    BOOL shouldLockOrientation = (shouldLockOrientationObj != NULL ? [shouldLockOrientationObj boolValue] : false);
    BOOL shouldShowSmallClickButton = (shouldShowSmallClickButtonObj != NULL ? [shouldShowSmallClickButtonObj boolValue] : false);
    BOOL lockOrientation = UIInterfaceOrientationMaskAll;
    if (lockOrientationObj != NULL) {
        NSString *orient = (NSString*)lockOrientationObj;
        if ([orient isEqualToString:@"LANDSCAPE"]){
            lockOrientation = UIInterfaceOrientationMaskLandscape;
        } else if ([orient isEqualToString:@"PORTRAIT"]){
            lockOrientation = UIInterfaceOrientationMaskPortrait;
        } else {
            shouldLockOrientation = NO;
            lockOrientation = UIInterfaceOrientationMaskAll;
        }
    }
    
    _hasAdAvailable = false;
    
    // enable or disable test mode
    [[SuperAwesome getInstance] setTesting:isTestEnabled];
    
    [SAVideoAd setIsParentalGateEnabled:isParentalGateEnabled];
    [SAVideoAd setDelegate:self];
    [SAVideoAd setShouldShowCloseButton:shouldShowCloseButton];
    [SAVideoAd setShouldAutomaticallyCloseAtEnd:shouldAutomaticallyCloseAtEnd];
    [SAVideoAd setShouldLockOrientation:shouldLockOrientation];
    [SAVideoAd setLockOrientation:lockOrientation];
    [SAVideoAd setShouldShowSmallClickButton:shouldShowSmallClickButton];
    [SAVideoAd load:placementId];
}

- (void) presentRewardedVideoFromViewController:(UIViewController *)viewController {
    [SAVideoAd play];
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

// MARK: SAProtocol implementation

- (void) SADidLoadAd:(id) sender forPlacementId: (NSInteger) placementId {
    _hasAdAvailable = true;
    _reward = [[MPRewardedVideoReward alloc] initWithCurrencyType:kMPRewardedVideoRewardCurrencyTypeUnspecified amount:@(0)];
    [self.delegate rewardedVideoDidLoadAdForCustomEvent:self];
}

- (void) SADidNotLoadAd:(id) sender forPlacementId: (NSInteger) placementId {
    [self.delegate rewardedVideoDidFailToLoadAdForCustomEvent:self
                                                        error:[self createErrorWith:ERROR_LOAD_TITLE(@"Video Ad", placementId)
                                                                          andReason:ERROR_LOAD_MESSAGE
                                                                      andSuggestion:ERROR_LOAD_SUGGESTION]];
}

- (void) SADidShowAd:(id) sender {
    [self.delegate rewardedVideoDidAppearForCustomEvent:self];
}

- (void) SADidNotShowAd:(id) sender {
    [self.delegate rewardedVideoDidFailToPlayForCustomEvent:self
                                                      error:[self createErrorWith:ERROR_SHOW_TITLE(@"Video Ad", 0)
                                                                        andReason:ERROR_SHOW_MESSAGE
                                                                    andSuggestion:ERROR_SHOW_SUGGESTION]];
}

- (void) SADidClickAd:(id) sender {
    [self.delegate rewardedVideoDidReceiveTapEventForCustomEvent:self];
    [self.delegate rewardedVideoWillLeaveApplicationForCustomEvent:self];
}

- (void) SADidCloseAd:(id) sender {
    // reward
    [self.delegate rewardedVideoShouldRewardUserForCustomEvent:self reward:_reward];
    
    // call required events
    [self.delegate rewardedVideoWillDisappearForCustomEvent:self];
    [self.delegate rewardedVideoDidDisappearForCustomEvent:self];
    
    // also null this so no references remain and memory is freed correctly
    _reward = NULL;
}



@end