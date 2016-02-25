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

@interface SuperAwesomeRewardedVideoCustomEvent ()
<SALoaderProtocol,
 SAAdProtocol,
 SAVideoAdProtocol,
 SAParentalGateProtocol>

// SA objects
@property (nonatomic, assign) NSInteger placementId;
@property (nonatomic, assign) BOOL isTestEnabled;
@property (nonatomic, assign) BOOL isParentalGateEnabled;
@property (nonatomic, assign) BOOL shouldShowCloseButton;
@property (nonatomic, assign) BOOL shouldAutomaticallyCloseAtEnd;
@property (nonatomic, strong) SAAd *cAd;
@property (nonatomic, strong) SALoader *loader;
@property (nonatomic, strong) SAFullscreenVideoAd *fvad;
@property (nonatomic, strong) MPRewardedVideoReward *reward;

@end

@implementation SuperAwesomeRewardedVideoCustomEvent

- (void) requestRewardedVideoWithCustomEventInfo:(NSDictionary *)info {
    
    // get values from the info dictionary
    id _Nullable isTestEnabledObj = [info objectForKey:@"isTestEnabled"];
    id _Nullable placementIdObj = [info objectForKey:@"placementId"];
    id _Nullable isParentalGateEnabledObj = [info objectForKey:@"isParentalGateEnabled"];
    id _Nullable shouldShowCloseButtonObj = [info objectForKey:@"shouldShowCloseButton"];
    id _Nullable shouldAutomaticallyCloseAtEndObj = [info objectForKey:@"shouldAutomaticallyCloseAtEnd"];
    
    if (isTestEnabledObj == NULL || placementIdObj == NULL) {
        
        // then send this to bannerCustomEvent:didFailToLoadAdWithError:
        [self.delegate rewardedVideoDidFailToLoadAdForCustomEvent:self
                                                            error:[self createErrorWith:@"Failed to get correct custom data from MoPub server."
                                                                              andReason:@"Either \"testMode\" or \"placementId\" parameters are wrong."
                                                                          andSuggestion:@"Make sure your custom data JSON has format: { \"placementId\":XXX, \"testMode\":true/false }"]];
        
        
        // return
        return;
    }
    
    // assign values, because they exist
    _isTestEnabled = [isTestEnabledObj boolValue];
    _placementId = [placementIdObj integerValue];
    _isParentalGateEnabled = (isParentalGateEnabledObj != NULL ? [isParentalGateEnabledObj boolValue] : true);
    _shouldShowCloseButton = (shouldShowCloseButtonObj != NULL ? [shouldShowCloseButtonObj boolValue] : false);
    _shouldAutomaticallyCloseAtEnd = (shouldAutomaticallyCloseAtEndObj != NULL ? [shouldAutomaticallyCloseAtEndObj boolValue] : true);
    
    // enable or disable test mode
    [[SuperAwesome getInstance] setTesting:_isTestEnabled];
    
    // start the loader
    _loader = [[SALoader alloc] init];
    [_loader setDelegate:self];
    [_loader loadAdForPlacementId:_placementId];
}

- (void) presentRewardedVideoFromViewController:(UIViewController *)viewController {
    [viewController presentViewController:_fvad animated:YES completion:^{
        [_fvad play];
        
        // call delegate
        [self.delegate rewardedVideoWillAppearForCustomEvent:self];
    }];
}

- (BOOL) hasAdAvailable {
    return (_cAd ? true : false);
}

- (void) handleCustomEventInvalidated {
    // do nothing
}

- (void) handleAdPlayedForCustomEventNetwork {
    NSLog(@"Ad played");
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

#pragma mark <SALoaderDelegate>

- (void) didLoadAd:(SAAd *)ad {
    // assign current ad
    _cAd = ad;
    _reward = [[MPRewardedVideoReward alloc] initWithCurrencyType:kMPRewardedVideoRewardCurrencyTypeUnspecified amount:@(0)];
    
    // init video
    _fvad = [[SAFullscreenVideoAd alloc] init];
    
    // set delegates
    [_fvad setVideoDelegate:self];
    [_fvad setParentalGateDelegate:self];
    [_fvad setAdDelegate:self];
    
    // set parameters
    [_fvad setIsParentalGateEnabled:_isParentalGateEnabled];
    [_fvad setShouldAutomaticallyCloseAtEnd:_shouldAutomaticallyCloseAtEnd];
    [_fvad setShouldShowCloseButton:_shouldShowCloseButton];
    
    // set ad
    [_fvad setAd:_cAd];
    
    // call events
    [self.delegate rewardedVideoDidLoadAdForCustomEvent:self];
}

- (void) didFailToLoadAdForPlacementId:(NSInteger)placementId {
    [self.delegate rewardedVideoDidFailToLoadAdForCustomEvent:self
                                                        error:[self createErrorWith:[NSString stringWithFormat:@"Failed to load SuperAwesome Rewarded Video Ad for PlacementId: %ld", (long)placementId]
                                                                          andReason:@"The operation timed out."
                                                                      andSuggestion:@"Check your placement Id."]];
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
                                                      error:[self createErrorWith:[NSString stringWithFormat:@"Failed to display SuperAwesome Rewarded Video Ad for PlacementId: %ld", (long)placementId]
                                                                        andReason:@"JSON invalid."
                                                                    andSuggestion:@"Contact SuperAwesome support: <devsupport@superawesome.tv>"]];
    
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
