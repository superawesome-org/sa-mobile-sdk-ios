#import "SAAdMobVideoMediationAdapter.h"
#import "SAAdMobExtras.h"
#import <SuperAwesome/SAVersion.h>
#import "SAAdMobRewardedAd.h"
#include <stdatomic.h>

#define kERROR_DOMAIN @"tv.superawesome.SAAdMobVideoMediationAdapter"

@implementation SAAdMobVideoMediationAdapter {
    SAAdMobRewardedAd *_rewardedAd;
}

+ (GADVersionNumber)adSDKVersion {
    NSString *versionString = [SAVersion getSdkVersion];
    NSArray *versionComponents = [versionString componentsSeparatedByString:@"."];
    GADVersionNumber version = {0};
    if (versionComponents.count == 3) {
        version.majorVersion = [versionComponents[0] integerValue];
        version.minorVersion = [versionComponents[1] integerValue];
        version.patchVersion = [versionComponents[2] integerValue];
    }
    return version;
}

+ (GADVersionNumber)version {
    NSString *versionString = [NSString stringWithFormat:@"%@.0", [SAVersion getSdkVersion]];
    NSArray *versionComponents = [versionString componentsSeparatedByString:@"."];
    GADVersionNumber version = {0};
    if (versionComponents.count == 4) {
        version.majorVersion = [versionComponents[0] integerValue];
        version.minorVersion = [versionComponents[1] integerValue];
        
        // Adapter versions have 2 patch versions. Multiply the first patch by 100.
        version.patchVersion = [versionComponents[2] integerValue] * 100
        + [versionComponents[3] integerValue];
    }
    return version;
}

+ (NSString *)adapterVersion {
    return [SAVersion getSdkVersion];
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
