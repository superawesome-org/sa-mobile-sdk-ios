#import "SAAdMobAdapter.h"
#import "SAAdMobExtras.h"
#import "SAAdMobRewardedAd.h"
#import "SAAdMobBannerAd.h"
#import "SAAdMobInterstitialAd.h"
#include <stdatomic.h>

#define kERROR_DOMAIN @"tv.superawesome.SAAdMobAdapter"

@implementation SAAdMobAdapter {
    SAAdMobRewardedAd *_rewardedAd;
    SAAdMobBannerAd *_bannerAd;
    SAAdMobInterstitialAd *_interstitialAd;
}

+ (GADVersionNumber) adSDKVersion {
    NSString *versionString = [[AwesomeAds info] versionNumber];
    NSArray *versionComponents = [versionString componentsSeparatedByString:@"."];
    GADVersionNumber version = {0};
    if (versionComponents.count == 3) {
        version.majorVersion = [versionComponents[0] integerValue];
        version.minorVersion = [versionComponents[1] integerValue];
        version.patchVersion = [versionComponents[2] integerValue];
    }
    return version;
}

+ (GADVersionNumber) adapterVersion {
    NSString *versionString = [[AwesomeAds info] versionNumber];
    NSArray *versionComponents = [versionString componentsSeparatedByString:@"."];
    GADVersionNumber version = {0};
    if (versionComponents.count == 3) {
        version.majorVersion = [versionComponents[0] integerValue];
        version.minorVersion = [versionComponents[1] integerValue];
        version.patchVersion = [versionComponents[2] integerValue];
    }
    return version;
}

+ (Class<GADAdNetworkExtras>)networkExtrasClass {
    return [SAAdMobVideoExtra class];
}

- (void)loadRewardedAdForAdConfiguration: (GADMediationRewardedAdConfiguration *)adConfiguration
                       completionHandler: (GADMediationRewardedLoadCompletionHandler)completionHandler {
    _rewardedAd = [[SAAdMobRewardedAd alloc] init];
    [_rewardedAd loadRewardedAdForAdConfiguration:adConfiguration
                                completionHandler:completionHandler];
}

- (void)loadBannerForAdConfiguration:(GADMediationBannerAdConfiguration *)adConfiguration completionHandler:(GADMediationBannerLoadCompletionHandler)completionHandler {
    _bannerAd = [[SAAdMobBannerAd alloc] init];
    [_bannerAd loadBannerForAdConfiguration:adConfiguration completionHandler:completionHandler];
}

- (void)loadInterstitialForAdConfiguration:(GADMediationInterstitialAdConfiguration *)adConfiguration completionHandler:(GADMediationInterstitialLoadCompletionHandler)completionHandler {
    _interstitialAd = [[SAAdMobInterstitialAd alloc] init];
    [_interstitialAd loadInterstitialForAdConfiguration:adConfiguration completionHandler:completionHandler];
}

@end
