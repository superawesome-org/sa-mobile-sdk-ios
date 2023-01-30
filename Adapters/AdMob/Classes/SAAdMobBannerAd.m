#import "SAAdMobBannerAd.h"
#import "SAAdMobExtras.h"
#include <stdatomic.h>

#define kERROR_DOMAIN @"tv.superawesome.SAAdMobBannerAd"

@interface SAAdMobBannerAd () <GADMediationBannerAd> {
}

@property (nonatomic, strong) SABannerAd *bannerAd;

/// Placement Id for requested ad
@property (nonatomic, assign) NSInteger placementId;

/// An ad event delegate to invoke when ad rendering events occur.
@property (nonatomic, weak, nullable) id<GADMediationBannerAdEventDelegate> delegate;

@end

@implementation SAAdMobBannerAd {
    /// The completion handler to call when the ad loading succeeds or fails.
    GADMediationBannerLoadCompletionHandler _completionHandler;
}

- (void)loadBannerForAdConfiguration: (GADMediationBannerAdConfiguration *) adConfiguration
                   completionHandler: (GADMediationBannerLoadCompletionHandler) completionHandler {
    // Ensure the original completion handler is only called once, and is deallocated once called.
    __block atomic_flag completionHandlerCalled = ATOMIC_FLAG_INIT;
    
    // Store the complition handler for later use
    __block GADMediationBannerLoadCompletionHandler originalCompletionHandler = [completionHandler copy];
    
    // Complition handler is called once the ad is loaded
    _completionHandler = ^id<GADMediationBannerAdEventDelegate>(
                                                                  id<GADMediationBannerAd> ad,
                                                                  NSError *error) {
        // Check wether the complition handler is called and return if it is
        if (atomic_flag_test_and_set(&completionHandlerCalled)) {
            return nil;
        }
        
        id<GADMediationBannerAdEventDelegate> delegate = nil;
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
    
    _bannerAd = [[SABannerAd alloc] initWithFrame:CGRectMake(0,
                                                             0,
                                                             adConfiguration.adSize.size.width,
                                                             adConfiguration.adSize.size.height)];
    
    SAAdMobExtras *extras = adConfiguration.extras;
    if (extras != nil) {
        [_bannerAd setTestMode:extras.testEnabled];
        [_bannerAd setParentalGate:extras.parentalGateEnabled];
        [_bannerAd setBumperPage:extras.bumperPageEnabled];
        [_bannerAd setColor:extras.transparentEnabled];
    }
   
    [self requestAd];
}

- (void) adLoaded {
    _delegate = _completionHandler(self, nil);
    [_bannerAd play];
}

- (void) adFailed {
    NSError *error = [NSError errorWithDomain:kERROR_DOMAIN code:0 userInfo:nil];
    [_delegate didFailToPresentWithError:error];
}

- (void) requestAd {
    __weak typeof (self) weakSelf = self;
    
    [_bannerAd setCallback:^(NSInteger placementId, SAEvent event) {
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
    
    [_bannerAd load:_placementId];
}

- (nonnull UIView *)view {
  return _bannerAd;
}

@end
