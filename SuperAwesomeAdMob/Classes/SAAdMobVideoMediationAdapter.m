#import "SAAdMobVideoMediationAdapter.h"
#import "SAAdMobExtras.h"
#import "SAAdMobRewardedAd.h"
#include <stdatomic.h>

#define kERROR_DOMAIN @"tv.superawesome.SAAdMobVideoMediationAdapter"

@implementation SAAdMobVideoMediationAdapter {
    SAAdMobRewardedAd *_rewardedAd;
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

@end
