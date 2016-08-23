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

@interface SuperAwesomeRewardedVideoCustomEvent () <SALoaderProtocol, SAAdProtocol>

// SA objects
@property (nonatomic, assign) NSInteger placementId;
@property (nonatomic, assign) BOOL isTestEnabled;
@property (nonatomic, assign) BOOL isParentalGateEnabled;
@property (nonatomic, assign) BOOL shouldShowCloseButton;
@property (nonatomic, assign) BOOL shouldAutomaticallyCloseAtEnd;
@property (nonatomic, assign) BOOL shouldLockOrientation;
@property (nonatomic, assign) BOOL shouldShowSmallClickButton;
@property (nonatomic, assign) NSUInteger lockOrientation;
@property (nonatomic, strong) SAAd *cAd;
@property (nonatomic, strong) SALoader *loader;
@property (nonatomic, strong) SAVideoAd *fvad;
@property (nonatomic, strong) MPRewardedVideoReward *reward;

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
    _isTestEnabled = [isTestEnabledObj boolValue];
    _placementId = [placementIdObj integerValue];
    _isParentalGateEnabled = (isParentalGateEnabledObj != NULL ? [isParentalGateEnabledObj boolValue] : true);
    _shouldShowCloseButton = (shouldShowCloseButtonObj != NULL ? [shouldShowCloseButtonObj boolValue] : false);
    _shouldAutomaticallyCloseAtEnd = (shouldAutomaticallyCloseAtEndObj != NULL ? [shouldAutomaticallyCloseAtEndObj boolValue] : true);
    _shouldLockOrientation = (shouldLockOrientationObj != NULL ? [shouldLockOrientationObj boolValue] : false);
    _shouldShowSmallClickButton = (shouldShowSmallClickButtonObj != NULL ? [shouldShowSmallClickButtonObj boolValue] : false);
    
    if (lockOrientationObj != NULL) {
        NSString *orient = (NSString*)lockOrientationObj;
        if ([orient isEqualToString:@"LANDSCAPE"]){
            _lockOrientation = UIInterfaceOrientationMaskLandscape;
        } else if ([orient isEqualToString:@"PORTRAIT"]){
            _lockOrientation = UIInterfaceOrientationMaskPortrait;
        } else {
            _shouldLockOrientation = NO;
            _lockOrientation = UIInterfaceOrientationMaskAll;
        }
    }
    
    // enable or disable test mode
    [[SuperAwesome getInstance] setTesting:_isTestEnabled];
    
    // start the loader
    _loader = [[SALoader alloc] init];
    [_loader setDelegate:self];
    [_loader loadAdForPlacementId:_placementId];
}

- (void) presentRewardedVideoFromViewController:(UIViewController *)viewController {
    
    __weak typeof (self) weakSelf = self;
    
    [viewController presentViewController:_fvad animated:YES completion:^{
        // play
        [weakSelf.fvad play];
        
        // call delegate
        [weakSelf.delegate rewardedVideoWillAppearForCustomEvent:weakSelf];
    }];
}

- (BOOL) hasAdAvailable {
    return (_cAd ? true : false);
}

- (void) handleCustomEventInvalidated {
    // do nothing
}

- (void) handleAdPlayedForCustomEventNetwork {
    // do nothing
}

#pragma mark Custom Functions

- (NSError*) createErrorWith:(NSString*)description andReason:(NSString*)reaason andSuggestion:(NSString*)suggestion {
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: NSLocalizedString(description, nil),
                               NSLocalizedFailureReasonErrorKey: NSLocalizedString(reaason, nil),
                               NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(suggestion, nil)
                               };
    
    return [NSError errorWithDomain:ERROR_DOMAIN code:ERROR_CODE userInfo:userInfo];
}

#pragma mark <SALoaderDelegate>

- (void) didLoadAd:(SAAd *)ad {
    // assign current ad
    _cAd = ad;
    _reward = [[MPRewardedVideoReward alloc] initWithCurrencyType:kMPRewardedVideoRewardCurrencyTypeUnspecified amount:@(0)];
    
    // init video
    _fvad = [[SAVideoAd alloc] init];
    
    // set delegates
    [_fvad setAdDelegate:self];
    
    // set parameters
    [_fvad setIsParentalGateEnabled:_isParentalGateEnabled];
    [_fvad setShouldAutomaticallyCloseAtEnd:_shouldAutomaticallyCloseAtEnd];
    [_fvad setShouldShowCloseButton:_shouldShowCloseButton];
    [_fvad setShouldLockOrientation:_shouldLockOrientation];
    [_fvad setShouldShowSmallClickButton:_shouldShowSmallClickButton];
    [_fvad setLockOrientation:_lockOrientation];
    
    // set ad
    [_fvad setAd:_cAd];
    
    // call events
    [self.delegate rewardedVideoDidLoadAdForCustomEvent:self];
}

- (void) didFailToLoadAdForPlacementId:(NSInteger)placementId {
    [self.delegate rewardedVideoDidFailToLoadAdForCustomEvent:self
                                                        error:[self createErrorWith:ERROR_LOAD_TITLE(@"Video Ad", placementId)
                                                                          andReason:ERROR_LOAD_MESSAGE
                                                                      andSuggestion:ERROR_LOAD_SUGGESTION]];
}

#pragma mark <SAAdProtocol>

- (void) adWasShown:(NSInteger)placementId {
    // do nothing
    [self.delegate rewardedVideoDidAppearForCustomEvent:self];
}

- (void) adFailedToShow:(NSInteger)placementId {
    
    [_fvad close];
    
    // then send this to bannerCustomEvent:didFailToLoadAdWithError:
    [self.delegate rewardedVideoDidFailToPlayForCustomEvent:self
                                                      error:[self createErrorWith:ERROR_SHOW_TITLE(@"Video Ad", placementId)
                                                                        andReason:ERROR_SHOW_MESSAGE
                                                                    andSuggestion:ERROR_SHOW_SUGGESTION]];
    
}

- (void) adWasClicked:(NSInteger)placementId {
    // call required event
    [self.delegate rewardedVideoDidReceiveTapEventForCustomEvent:self];
    
    // only show this directly if PG is not enabled
    // if it is, it will be called when PG is successfull
    if (!_isParentalGateEnabled) {
        [self.delegate rewardedVideoWillLeaveApplicationForCustomEvent:self];
    }
}

- (void) adWasClosed:(NSInteger)placementId {
    // call required events
    [self.delegate rewardedVideoWillDisappearForCustomEvent:self];
    [self.delegate rewardedVideoDidDisappearForCustomEvent:self];
    
    // also null this so no references remain and memory is freed correctly
    _fvad = NULL;
    _cAd = NULL;
    _loader = NULL;
    _reward = NULL;
}

- (void) adHasIncorrectPlacement:(NSInteger)placementId {
    [_fvad close];
}

#pragma mark <SAParentalGateProtocol>

- (void) parentalGateWasCanceled:(NSInteger)placementId {
    // do nothing here
}

- (void) parentalGateWasSucceded:(NSInteger)placementId {
    [self.delegate rewardedVideoWillLeaveApplicationForCustomEvent:self];
}

- (void) parentalGateWasFailed:(NSInteger)placementId {
    // do nothing here
}

#pragma mark <SAVideoProtocol>

- (void) videoEnded:(NSInteger)placementId {
    [self.delegate rewardedVideoShouldRewardUserForCustomEvent:self reward:_reward];
}

@end