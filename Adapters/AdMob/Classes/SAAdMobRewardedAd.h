#import <Foundation/Foundation.h>
@import GoogleMobileAds;
@import SuperAwesome;

@interface SAAdMobRewardedAd : NSObject <GADMediationRewardedAd>

- (void)loadRewardedAdForAdConfiguration: (GADMediationRewardedAdConfiguration *) adConfiguration
                       completionHandler: (GADMediationRewardedLoadCompletionHandler) completionHandler;

@end
