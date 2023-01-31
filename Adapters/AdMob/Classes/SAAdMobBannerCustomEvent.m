#import "SAAdMobBannerCustomEvent.h"
#import "SAAdMobExtras.h"
#import "SAAdMobBannerAd.h"
#include <stdatomic.h>

#define kERROR_DOMAIN @"tv.superawesome.SAAdMobBannerCustomEvent"

@implementation SAAdMobBannerCustomEvent {
    SAAdMobBannerAd *_bannerAd;
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
    return [SAAdMobExtras class];
}

- (void)loadBannerForAdConfiguration:(GADMediationBannerAdConfiguration *)adConfiguration completionHandler:(GADMediationBannerLoadCompletionHandler)completionHandler {
    _bannerAd = [[SAAdMobBannerAd alloc] init];
    [_bannerAd loadBannerForAdConfiguration:adConfiguration completionHandler:completionHandler];
}

@end
