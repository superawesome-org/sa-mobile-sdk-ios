#import "SAAdMobInterstitialAd.h"
#import "SAAdMobExtras.h"
#include <stdatomic.h>

#define kERROR_DOMAIN @"tv.superawesome.SAAdMobVideoMediationAdapter"

@interface SAAdMobInterstitialAd () <GADMediationInterstitialAd> {
    
}

/// Placement Id for requested ad
@property (nonatomic, assign) NSInteger placementId;

/// An ad event delegate to invoke when ad rendering events occur.
@property (nonatomic, weak, nullable) id<GADMediationInterstitialAdEventDelegate> delegate;

@end

@implementation SAAdMobInterstitialAd {
    /// The completion handler to call when the ad loading succeeds or fails.
    GADMediationInterstitialLoadCompletionHandler _completionHandler;
}

- (void)loadInterstitialForAdConfiguration: (GADMediationInterstitialAdConfiguration *) adConfiguration
                         completionHandler: (GADMediationInterstitialLoadCompletionHandler) completionHandler {
    // Ensure the original completion handler is only called once, and is deallocated once called.
    __block atomic_flag completionHandlerCalled = ATOMIC_FLAG_INIT;
    
    // Store the complition handler for later use
    __block GADMediationInterstitialLoadCompletionHandler originalCompletionHandler = [completionHandler copy];
    
    // Complition handler is called once the ad is loaded
    _completionHandler = ^id<GADMediationInterstitialAdEventDelegate>(
                                                                  id<GADMediationInterstitialAd> ad,
                                                                  NSError *error) {
        // Check wether the complition handler is called and return if it is
        if (atomic_flag_test_and_set(&completionHandlerCalled)) {
            return nil;
        }
        
        id<GADMediationInterstitialAdEventDelegate> delegate = nil;
        if (originalCompletionHandler) {
            delegate = originalCompletionHandler(ad, error);
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
        [SAInterstitialAd setTestMode:extras.testEnabled];
        [SAInterstitialAd setOrientation:extras.orientation];
        [SAInterstitialAd setParentalGate:extras.parentalGateEnabled];
        [SAInterstitialAd setBumperPage:extras.bumperPageEnabled];
    }
    
    [self requestVideoAd];
}

- (void) adLoaded {
    _delegate = _completionHandler(self, nil);
}

- (void) adFailed {
    NSError *error = [NSError errorWithDomain:kERROR_DOMAIN code:0 userInfo:nil];
    [_delegate didFailToPresentWithError:error];
}

- (void) requestVideoAd {
    __weak typeof (self) weakSelf = self;
    
    [SAInterstitialAd setCallback:^(NSInteger placementId, SAEvent event) {
        switch (event) {
            case SAEventAdLoaded: {
                [weakSelf adLoaded];
                break;
            }
            case SAEventAdEmpty: {
                [weakSelf adFailed];
                break;
            }
            case SAEventAdFailedToLoad: {
                [weakSelf adFailed];
                break;
            }
            case SAEventAdShown: {
                [weakSelf.delegate willPresentFullScreenView];
                break;
            }
            case SAEventAdClicked: {
                [weakSelf.delegate reportClick];
                [weakSelf.delegate willDismissFullScreenView];
                break;
            }
            case SAEventAdClosed: {
                [weakSelf.delegate willDismissFullScreenView];
                [weakSelf.delegate didDismissFullScreenView];
                break;
            //
            // non supported SA events
            default:
                break;
            }
        }
    }];
    
    [SAInterstitialAd load: _placementId];
}

- (void)presentFromViewController:(nonnull UIViewController *)viewController {
    if ([SAInterstitialAd hasAdAvailable: _placementId]) {
        [SAInterstitialAd play: _placementId fromVC:viewController];
    } else {
        NSError *error =
        [NSError errorWithDomain:@"SAAdMobInterstitialAd"
                            code:0
                        userInfo:@{NSLocalizedDescriptionKey : @"Unable to display ad."}];
        [self.delegate didFailToPresentWithError:error];
    }
}

@end
