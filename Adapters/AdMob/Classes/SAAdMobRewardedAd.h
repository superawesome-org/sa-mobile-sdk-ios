#import <Foundation/Foundation.h>
@import GoogleMobileAds;

@interface SAAdMobRewardedAd : NSObject <GADMediationRewardedAd>

- (void)loadRewardedAdForAdConfiguration: (GADMediationRewardedAdConfiguration *) adConfiguration
                       completionHandler: (GADMediationRewardedLoadCompletionHandler) completionHandler;

@end
