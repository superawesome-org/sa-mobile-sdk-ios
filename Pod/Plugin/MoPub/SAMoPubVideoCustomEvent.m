/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import "SAMoPubVideoCustomEvent.h"
#import "AwesomeAds.h"
#import "SASession.h"
#import "SASessionDefines.h"
#import "MPRewardedVideoReward.h"
#import "SAMoPub.h"
#import "NSDictionary+SafeHandling.h"

@interface SAMoPubVideoCustomEvent ()
@property (nonatomic, strong) MPRewardedVideoReward *reward;
@property (nonatomic, assign) BOOL hasAdAvailable;
@property (nonatomic, assign) NSInteger placementId;
@end

@implementation SAMoPubVideoCustomEvent

/**
 * Overridden MoPub method that requests a new video.
 *
 * @param info a dictionary of extra information passed down from MoPub to the
 *             SDK that help with loading the ad
 */

- (void) requestRewardedVideoWithCustomEventInfo:(NSDictionary *)info {
    
    _placementId = [[info safeObjectForKey:PLACEMENT_ID orDefault:@(SA_DEFAULT_PLACEMENTID)] integerValue];
    BOOL isTestEnabled = [[info safeObjectForKey:TEST_ENABLED orDefault:@(SA_DEFAULT_TESTMODE)] boolValue];
    BOOL isParentalGateEnabled = [[info safeObjectForKey:PARENTAL_GATE orDefault:@(SA_DEFAULT_PARENTALGATE)] boolValue];
    BOOL isBumperPageEnabled = [[info safeObjectForKey:BUMPER_PAGE orDefault:@(SA_DEFAULT_BUMPERPAGE)] boolValue];
    BOOL shouldShowCloseButton = [[info safeObjectForKey:SHOULD_SHOW_CLOSE orDefault:@(SA_DEFAULT_BACKBUTTON)] boolValue];
    BOOL shouldShowSmallClickButton = [[info safeObjectForKey:VIDEO_BUTTON_STYLE orDefault:@(SA_DEFAULT_SMALLCLICK)] boolValue];
    BOOL shouldAutomaticallyCloseAtEnd = [[info safeObjectForKey:SHOULD_AUTO_CLOSE orDefault:@(SA_DEFAULT_CLOSEATEND)] boolValue];
    
    SAOrientation orientation = SA_DEFAULT_ORIENTATION;
    
    NSString *ori = [info safeStringForKey:ORIENTATION];
    if (ori != nil && [ori isEqualToString:@"PORTRAIT"]) {
        orientation = PORTRAIT;
    }
    if (ori != nil && [ori isEqualToString:@"LANDSCAPE"]) {
        orientation = LANDSCAPE;
    }
    
    SAConfiguration configuration = SA_DEFAULT_CONFIGURATION;
    
    NSString *conf = [info safeStringForKey:CONFIGURATION];
    if (conf != nil && [conf isEqualToString:@"STAGING"]) {
        configuration = STAGING;
    }
    
    SARTBStartDelay playback = SA_DEFAULT_PLAYBACK_MODE;
    NSString *play = [info safeStringForKey:PLAYBACK_MODE];
    if (play != nil) {
        if ([play isEqualToString:@"POST_ROLL"]) {
            playback = DL_POST_ROLL;
        } else if ([play isEqualToString:@"MID_ROLL"]) {
            playback = DL_MID_ROLL;
        } else if ([play isEqualToString:@"PRE_ROLL"]) {
            playback = DL_PRE_ROLL;
        } else if ([play isEqualToString:@"GENERIC_MID_ROLL"]) {
            playback = DL_GENERIC_MID_ROLL;
        }
    }
    
    _hasAdAvailable = false;
    
    // get a weak self reference
    __weak typeof (self) weakSelf = self;
    
    // enable or disable test mode
    [SAVideoAd setConfiguration:configuration];
    [SAVideoAd setTestMode:isTestEnabled];
    [SAVideoAd setParentalGate:isParentalGateEnabled];
    [SAVideoAd setBumperPage:isBumperPageEnabled];
    [SAVideoAd setCloseButton:shouldShowCloseButton];
    [SAVideoAd setCloseAtEnd:shouldAutomaticallyCloseAtEnd];
    [SAVideoAd setSmallClick:shouldShowSmallClickButton];
    [SAVideoAd setOrientation:orientation];
    [SAVideoAd setPlaybackMode:playback];
    
    [SAVideoAd setCallback:^(NSInteger placementId, SAEvent event) {
        switch (event) {
            case adLoaded: {
                weakSelf.hasAdAvailable = true;
                weakSelf.reward = [[MPRewardedVideoReward alloc] initWithCurrencyType:kMPRewardedVideoRewardCurrencyTypeUnspecified amount:@(0)];
                [weakSelf.delegate rewardedVideoDidLoadAdForCustomEvent:weakSelf];
                break;
            }
            case adAlreadyLoaded: {
                // do nothing
                break;
            }
            case adEmpty: {
                [weakSelf.delegate rewardedVideoDidFailToLoadAdForCustomEvent:weakSelf
                                                                        error:[weakSelf createErrorWith:ERROR_LOAD_TITLE(@"Video Ad", placementId)
                                                                                              andReason:ERROR_LOAD_MESSAGE
                                                                                          andSuggestion:ERROR_LOAD_SUGGESTION]];
                break;
            }
            case adFailedToLoad: {
                [weakSelf.delegate rewardedVideoDidFailToLoadAdForCustomEvent:weakSelf
                                                                        error:[weakSelf createErrorWith:ERROR_LOAD_TITLE(@"Video Ad", placementId)
                                                                                              andReason:ERROR_NETWORK_MESSAGE
                                                                                          andSuggestion:ERROR_NETWORK_SUGGESTION]];
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
            case adEnded: {
                // reward
                [weakSelf.delegate rewardedVideoShouldRewardUserForCustomEvent:weakSelf reward:weakSelf.reward];
                // also null this so no references remain and memory is freed correctly
                weakSelf.reward = NULL;
                break;
            }
            case adClosed: {
                // call required events
                [weakSelf.delegate rewardedVideoWillDisappearForCustomEvent:weakSelf];
                [weakSelf.delegate rewardedVideoDidDisappearForCustomEvent:weakSelf];
                break;
            }
        }
    }];
    [SAVideoAd load:_placementId];
}

/**
 * Overridden MoPub method that actually displays an video ad.
 *
 * @param viewController the view controller from which the ad will spring
 */
- (void) presentRewardedVideoFromViewController:(UIViewController *)viewController {
    [SAVideoAd play:_placementId fromVC:viewController];
    [self.delegate rewardedVideoWillAppearForCustomEvent:self];
}

/**
 * Overridden MoPub method that returns whether there is any video ad present
 * 
 * @return true or false
 */
- (BOOL) hasAdAvailable {
    return _hasAdAvailable;
}

/**
 * Unimplemented overridden MoPub method
 */
- (void) handleCustomEventInvalidated {
    // do nothing
}

/**
 * Unimplemented overridden MoPub method
 */
- (void) handleAdPlayedForCustomEventNetwork {
    // do nothing
}

/**
 * MoPub method that creates a new error obkect
 *
 * @param description   the description text of the error
 * @param reason        a reason for why it might have happened
 * @param suggestion    a suggestion of how to fix it
 */
- (NSError*) createErrorWith:(NSString*) description
                   andReason:(NSString*) reason
               andSuggestion:(NSString*) suggestion {
    
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: NSLocalizedString(description, nil),
                               NSLocalizedFailureReasonErrorKey: NSLocalizedString(reason, nil),
                               NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(suggestion, nil)
                               };
    
    return [NSError errorWithDomain:ERROR_DOMAIN code:ERROR_CODE userInfo:userInfo];
}

@end
