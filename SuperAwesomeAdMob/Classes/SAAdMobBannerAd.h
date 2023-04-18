#import <Foundation/Foundation.h>
@import GoogleMobileAds;
@import SuperAwesome;

@interface SAAdMobBannerAd : NSObject <GADMediationBannerAd>

- (void)loadBannerForAdConfiguration: (GADMediationBannerAdConfiguration *) adConfiguration
                   completionHandler: (GADMediationBannerLoadCompletionHandler) completionHandler;

@end
