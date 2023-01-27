#import "SAAdMobInterstitialCustomEvent.h"
#import "SAAdMobExtras.h"
#import "SAAdMobInterstitialAd.h"
#include <stdatomic.h>

#define kERROR_DOMAIN @"tv.superawesome.SAAdMobInterstitialCustomEvent"

@implementation SAAdMobInterstitialCustomEvent {
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

- (void)loadInterstitialForAdConfiguration:(GADMediationInterstitialAdConfiguration *)adConfiguration completionHandler:(GADMediationInterstitialLoadCompletionHandler)completionHandler {
    _interstitialAd = [[SAAdMobInterstitialAd alloc] init];
    [_interstitialAd loadInterstitialForAdConfiguration:adConfiguration completionHandler:completionHandler];
}

@end
