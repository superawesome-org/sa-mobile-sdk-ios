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
@property (nonatomic, strong) SAFullscreenVideoAd *fvad;
@property (nonatomic, assign) BOOL parentalGate;

@end

@implementation SuperAwesomeRewardedVideoCustomEvent

- (void) requestRewardedVideoWithCustomEventInfo:(NSDictionary *)info {
    
    // variables received from the MoPub server
    BOOL testMode = false;
    BOOL isParentalGateEnabled = true;
    NSInteger placementId = -1;
    
    id _Nullable testModeObj = [info objectForKey:@"testMode"];
    id _Nullable placementIdObj = [info objectForKey:@"placementId"];
    id _Nullable parentalGateEnabledObj = [info objectForKey:@"parentalGateEnabled"];
    
    if (testModeObj == NULL || placementIdObj == NULL || parentalGateEnabledObj == NULL) {
        
        // then send this to bannerCustomEvent:didFailToLoadAdWithError:
        [self.delegate rewardedVideoDidFailToLoadAdForCustomEvent:self
                                                            error:[self createErrorWith:@"Failed to get correct custom data from MoPub server."
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
    
    // enable or disable test mode
    if (testMode) {
        [[SuperAwesome getInstance] enableTestMode];
    }
    else {
        [[SuperAwesome getInstance] disableTestMode];
    }
    
    [SALoader setDelegate:self];
    [SALoader loadAdForPlacementId:placementId];
}

- (void) presentRewardedVideoFromViewController:(UIViewController *)viewController {
    [viewController presentViewController:_fvad animated:YES completion:^{
        [_fvad play];
        
        // call delegate
        [self.delegate rewardedVideoWillAppearForCustomEvent:self];
    }];
}

- (BOOL) hasAdAvailable {
    return true;
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
    // init video
    _fvad = [[SAFullscreenVideoAd alloc] init];
    [_fvad setIsParentalGateEnabled:YES];
    [_fvad setVideoDelegate:self];
    [_fvad setParentalGateDelegate:self];
    [_fvad setAdDelegate:self];
    [_fvad setAd:ad];
    
    // call events
    [self.delegate rewardedVideoDidLoadAdForCustomEvent:self];
}

- (void) didFailToLoadAdForPlacementId:(NSInteger)placementId {
    [self.delegate rewardedVideoDidFailToLoadAdForCustomEvent:self
                                                        error:[self createErrorWith:[NSString stringWithFormat:@"Failed to load SuperAwesome Rewarded Video Ad for PlacementId: %ld", placementId]
                                                                          andReason:@"The operation timed out."
                                                                      andSuggestion:@"Check your placement Id."]];
}

#pragma mark <SAAdProtocol>

- (void) adWasShown:(NSInteger)placementId {
    // do nothing
    [self.delegate rewardedVideoDidAppearForCustomEvent:self];
}

- (void) adFailedToShow:(NSInteger)placementId {
    
    // then send this to bannerCustomEvent:didFailToLoadAdWithError:
    [self.delegate rewardedVideoDidFailToPlayForCustomEvent:self
                                                      error:[self createErrorWith:[NSString stringWithFormat:@"Failed to display SuperAwesome Rewarded Video Ad for PlacementId: %ld", placementId]
                                                                        andReason:@"JSON invalid."
                                                                    andSuggestion:@"Contact SuperAwesome support: <devsupport@superawesome.tv>"]];
    
}

- (void) adWasClicked:(NSInteger)placementId {
    // call required event
    [self.delegate rewardedVideoDidReceiveTapEventForCustomEvent:self];
    
    // only show this directly if PG is not enabled
    // if it is, it will be called when PG is successfull
    if (!_parentalGate) {
        [self.delegate rewardedVideoWillLeaveApplicationForCustomEvent:self];
    }
}

- (void) adWasClosed:(NSInteger)placementId {
    // call required events
    [self.delegate rewardedVideoWillDisappearForCustomEvent:self];
    [self.delegate rewardedVideoDidDisappearForCustomEvent:self];
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
    MPRewardedVideoReward *reward = [[MPRewardedVideoReward alloc] initWithCurrencyType:kMPRewardedVideoRewardCurrencyTypeUnspecified amount:0];
    [self.delegate rewardedVideoShouldRewardUserForCustomEvent:self reward:reward];
}

@end
