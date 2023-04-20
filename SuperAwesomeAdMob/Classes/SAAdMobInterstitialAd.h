#import <Foundation/Foundation.h>
@import GoogleMobileAds;
@import SuperAwesome;

@interface SAAdMobInterstitialAd : NSObject <GADMediationInterstitialAd>

- (void)loadInterstitialForAdConfiguration: (GADMediationInterstitialAdConfiguration *) adConfiguration
                         completionHandler: (GADMediationInterstitialLoadCompletionHandler) completionHandler;

@end
