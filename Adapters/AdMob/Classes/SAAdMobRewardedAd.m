#import "SAAdMobRewardedAd.h"
#import "SAAdMobExtras.h"
#include <stdatomic.h>

#define kERROR_DOMAIN @"tv.superawesome.SAAdMobRewardedAd"

@interface SAAdMobRewardedAd () <GADMediationRewardedAd> {
    
}

/// Placement Id for requested ad
@property (nonatomic, assign) NSInteger placementId;

/// An ad event delegate to invoke when ad rendering events occur.
@property (nonatomic, weak, nullable) id<GADMediationRewardedAdEventDelegate> delegate;

@end

@implementation SAAdMobRewardedAd {
    /// The completion handler to call when the ad loading succeeds or fails.
    GADMediationRewardedLoadCompletionHandler _completionHandler;
}

- (void)loadRewardedAdForAdConfiguration: (nonnull GADMediationRewardedAdConfiguration *)adConfiguration
                       completionHandler: (nonnull GADMediationRewardedLoadCompletionHandler)completionHandler {
    
    // Ensure the original completion handler is only called once, and is deallocated once called.
    __block atomic_flag completionHandlerCalled = ATOMIC_FLAG_INIT;
    
    // Store the complition handler for later use
    __block GADMediationRewardedLoadCompletionHandler originalCompletionHandler = [completionHandler copy];
    
    // Complition handler is called once the ad is loaded
    _completionHandler = ^id<GADMediationRewardedAdEventDelegate>(
                                                                  id<GADMediationRewardedAd> rewardedAd,
                                                                  NSError *error) {
        // Check wether the complition handler is called and return if it is
        if (atomic_flag_test_and_set(&completionHandlerCalled)) {
            return nil;
        }
        
        id<GADMediationRewardedAdEventDelegate> delegate = nil;
        if (originalCompletionHandler) {
            delegate = originalCompletionHandler(rewardedAd, error);
        }
        originalCompletionHandler = nil;
        
        return delegate;
    };
    
    NSString *parameter = [adConfiguration.credentials.settings objectForKey:GADCustomEventParametersServer];
    _placementId = [parameter integerValue];
    
    if (_placementId == 0) {
        NSError *error = [NSError errorWithDomain:kERROR_DOMAIN code:0 userInfo:nil];
        completionHandler(nil, error);
        return;
    }

    SAAdMobVideoExtra *extras = adConfiguration.extras;
    if (extras != nil) {
        [SAVideoAd setTestMode:extras.testEnabled];
        [SAVideoAd setOrientation:extras.orientation];
        [SAVideoAd setParentalGate:extras.parentalGateEnabled];
        [SAVideoAd setBumperPage:extras.bumperPageEnabled];
        [SAVideoAd setCloseButton:extras.closeButtonEnabled];
        [SAVideoAd setCloseAtEnd:extras.closeAtEndEnabled];
        [SAVideoAd setSmallClick:extras.smallCLickEnabled];
        [SAVideoAd setPlaybackMode:extras.playback];
    }
    
    [self requestAd];
}

- (void) adLoaded {
    _delegate = _completionHandler(self, nil);
}

- (void) adFailed {
    NSError *error = [NSError errorWithDomain:kERROR_DOMAIN code:0 userInfo:nil];
    [_delegate didFailToPresentWithError:error];
}

- (void) requestAd {
    __weak typeof (self) weakSelf = self;
    
    [SAVideoAd setCallback:^(NSInteger placementId, SAEvent event) {
        switch (event) {
            case SAEventAdAlreadyLoaded:
            case SAEventAdLoaded: {
                [weakSelf adLoaded];
                break;
            }
            case SAEventAdEmpty:
            case SAEventAdFailedToShow:
            case SAEventAdFailedToLoad: {
                [weakSelf adFailed];
                break;
            }
            case SAEventAdShown: {
                [weakSelf.delegate willPresentFullScreenView];
                [weakSelf.delegate didStartVideo];
                [weakSelf.delegate reportImpression];
                break;
            }
            case SAEventAdClicked: {
                [weakSelf.delegate reportClick];
                [weakSelf.delegate willDismissFullScreenView];
                break;
            }
            case SAEventAdClosed: {
                [weakSelf.delegate willDismissFullScreenView];
                [weakSelf.delegate didEndVideo];
                [weakSelf.delegate didDismissFullScreenView];
                break;
            }
            case SAEventAdEnded: {
                GADAdReward *reward = [[GADAdReward alloc] initWithRewardType:@"Reward"
                                                                 rewardAmount:[[NSDecimalNumber alloc] initWithInt:1]];
                [weakSelf.delegate didRewardUserWithReward: reward];
                break;
            }
        }
    }];
    
    [SAVideoAd load: _placementId];
}

- (void)presentFromViewController:(nonnull UIViewController *)viewController {
    if ([SAVideoAd hasAdAvailable: _placementId]) {
        [SAVideoAd play: _placementId fromVC:viewController];
    } else {
        NSError *error =
        [NSError errorWithDomain:@"SAAdMobRewardedAd"
                            code:0
                        userInfo:@{NSLocalizedDescriptionKey : @"Unable to display ad."}];
        [self.delegate didFailToPresentWithError:error];
    }
}

@end
