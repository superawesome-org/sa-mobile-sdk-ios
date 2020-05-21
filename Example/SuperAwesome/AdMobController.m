#if __has_include(<GoogleMobileAds/GoogleMobileAds.h>)

#import "AdMobController.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "AwesomeAds.h"
#import "SAAdMobExtras.h"

@interface AdMobController () <GADBannerViewDelegate, GADInterstitialDelegate, GADRewardedAdDelegate>

@property(nonatomic, strong) GADBannerView *bannerView;
@property(nonatomic, strong) GADInterstitial *interstitial;
@property(nonatomic, strong) GADRewardedAd *rewardedAd;

@end

@implementation AdMobController

NSString *bannerAdUnitId = @"__YOUR_ADMOB_UNIT_ID__";
NSString *interstitialAdUnitId = @"__YOUR_ADMOB_UNIT_ID__";
NSString *rewardAdUnitId = @"__YOUR_ADMOB_UNIT_ID__";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Banner Ad
    [self createAndLoadBannerAd];
    
    // Interstitial Ad
    self.interstitial = [self createAndLoadInterstitial];
    
    // Rewarded Ad
    self.rewardedAd = [self createAndLoadRewardedAd];
}

- (void)createAndLoadBannerAd {
    
    SAAdMobCustomEventExtra *extra = [[SAAdMobCustomEventExtra alloc] init];
    extra.testEnabled = false;
    extra.parentalGateEnabled = false;
    extra.trasparentEnabled = true;
    //extra.configuration = STAGING;
    
    GADCustomEventExtras *extras = [GADCustomEventExtras new];
    [extras setExtras:extra forLabel:@"iOSBannerCustomEvent"];
    
    GADRequest *request = [GADRequest request];
    [request registerAdNetworkExtras:extras];
    
    self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    [self addBannerViewToView: self.bannerView];
    self.bannerView.adUnitID = bannerAdUnitId;
    self.bannerView.rootViewController = self;
    self.bannerView.delegate = self;
    [self.bannerView loadRequest:request];
    
}

- (GADRewardedAd *)createAndLoadRewardedAd {
    SAAdMobVideoExtra *extra = [[SAAdMobVideoExtra alloc] init];
    extra.testEnabled = false;
    extra.closeAtEndEnabled = true;
    extra.closeButtonEnabled = false;
    extra.parentalGateEnabled = false;
    extra.smallCLickEnabled = true;
    //extra.configuration = STAGING;
    //extra.orientation = LANDSCAPE;
    
    GADRequest *request = [GADRequest request];
    [request registerAdNetworkExtras:extra];
    
    GADRewardedAd *rewardedAd = [[GADRewardedAd alloc] initWithAdUnitID:rewardAdUnitId];
    [rewardedAd loadRequest:request completionHandler:^(GADRequestError * _Nullable error) {
        if (error) {
            NSLog(@"[SuperAwesome | AdMob] RewardedAd failed to load case");
        } else {
            NSLog(@"[SuperAwesome | AdMob] RewardedAd successfully loaded");
            NSLog(@"[SuperAwesome | AdMob] RewardedAd adapter class name: %@", rewardedAd.responseInfo.adNetworkClassName);
        }
    }];
    return rewardedAd;
}

- (void)addBannerViewToView:(UIView *)bannerView {
    bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:bannerView];
    [self.view addConstraints:@[
        [NSLayoutConstraint constraintWithItem:bannerView
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.topLayoutGuide
                                     attribute:NSLayoutAttributeBottom
                                    multiplier:1
                                      constant:0],
        [NSLayoutConstraint constraintWithItem:bannerView
                                     attribute:NSLayoutAttributeCenterX
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.view
                                     attribute:NSLayoutAttributeCenterX
                                    multiplier:1
                                      constant:0]
    ]];
}

- (GADInterstitial *)createAndLoadInterstitial {
    GADInterstitial *interstitial = [[GADInterstitial alloc] initWithAdUnitID: interstitialAdUnitId];
    interstitial.delegate = self;
    [interstitial loadRequest:[GADRequest request]];
    return interstitial;
}

////////////////////////////////////////////////////////////////////////////////
// Actions
////////////////////////////////////////////////////////////////////////////////

- (IBAction)showInterstitial:(id)sender {
    
    if (self.interstitial.isReady) {
        [self.interstitial presentFromRootViewController:self];
    } else {
        NSLog(@"[SuperAwesome | AdMob] Interstitial Ad wasn't ready");
    }
    
}

- (IBAction)showVideo:(id)sender {
    if (self.rewardedAd.isReady) {
        [self.rewardedAd presentFromRootViewController:self delegate:self];
    } else {
        NSLog(@"[SuperAwesome | AdMob] Video ad wasn't ready");
    }
}

////////////////////////////////////////////////////////////////////////////////
// GADBannerViewDelegate
////////////////////////////////////////////////////////////////////////////////

- (void) adViewDidReceiveAd:(GADBannerView *)bannerView {
    NSLog(@"[SuperAwesome | AdMob] Banner did receive ad");
    NSLog(@"[SuperAwesome | AdMob] Banner adapter class name: %@", bannerView.responseInfo.adNetworkClassName);
}

- (void) adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"[SuperAwesome | AdMob] Banner did fail to receive ad with %ld | %@", error.code, error.description);
}

- (void) adViewWillPresentScreen:(GADBannerView *)bannerView {
    NSLog(@"[SuperAwesome | AdMob] Banner will present screen");
}

- (void) adViewWillDismissScreen:(GADBannerView *)bannerView {
    NSLog(@"[SuperAwesome | AdMob] Banner will dismiss screen");
}

- (void) adViewDidDismissScreen:(GADBannerView *)bannerView {
    NSLog(@"[SuperAwesome | AdMob] Banner did dismiss screen");
}

- (void) adViewWillLeaveApplication:(GADBannerView *)bannerView {
    NSLog(@"[SuperAwesome | AdMob] Banner will leave application");
}

////////////////////////////////////////////////////////////////////////////////
// GADInterstitialDelegate
////////////////////////////////////////////////////////////////////////////////

- (void) interstitialDidReceiveAd:(GADInterstitial *)ad {
    NSLog(@"[SuperAwesome | AdMob] Interstitial did receive ad");
    NSLog(@"[SuperAwesome | AdMob] Interstitial adapter class name: %@", ad.responseInfo.adNetworkClassName);
}

- (void) interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"[SuperAwesome | AdMob] Interstitial did fail to recived ad with %ld | %@", error.code, error.description);
}

- (void) interstitialWillPresentScreen:(GADInterstitial *)ad {
    NSLog(@"[SuperAwesome | AdMob] Interstitial will present screen");
}

- (void) interstitialWillDismissScreen:(GADInterstitial *)ad {
    NSLog(@"[SuperAwesome | AdMob] Interstitial will dismiss screen");
}

- (void) interstitialDidDismissScreen:(GADInterstitial *)ad {
    NSLog(@"[SuperAwesome | AdMob] Interstitial did dismiss screen");
    self.interstitial = [self createAndLoadInterstitial];
}

- (void) interstitialDidFailToPresentScreen:(GADInterstitial *)ad {
    NSLog(@"[SuperAwesome | AdMob] Interstitial did fail to present screen");
}

- (void) interstitialWillLeaveApplication:(GADInterstitial *)ad {
    NSLog(@"[SuperAwesome | AdMob] Interatitial will leave application");
}

////////////////////////////////////////////////////////////////////////////////
// GADRewardedAdDelegate
////////////////////////////////////////////////////////////////////////////////

/// Tells the delegate that the user earned a reward.
- (void)rewardedAd:(GADRewardedAd *)rewardedAd userDidEarnReward:(GADAdReward *)reward {
    // TODO: Reward the user.
    NSLog(@"[SuperAwesome | AdMob] rewardedAd:userDidEarnReward:");
}

/// Tells the delegate that the rewarded ad was presented.
- (void)rewardedAdDidPresent:(GADRewardedAd *)rewardedAd {
    NSLog(@"[SuperAwesome | AdMob] rewardedAdDidPresent:");
}

/// Tells the delegate that the rewarded ad failed to present.
- (void)rewardedAd:(GADRewardedAd *)rewardedAd didFailToPresentWithError:(NSError *)error {
    NSLog(@"[SuperAwesome | AdMob] rewardedAd:didFailToPresentWithError");
}

/// Tells the delegate that the rewarded ad was dismissed.
- (void)rewardedAdDidDismiss:(GADRewardedAd *)rewardedAd {
    NSLog(@"[SuperAwesome | AdMob] rewardedAdDidDismiss:");
    self.rewardedAd = [self createAndLoadRewardedAd];
}

@end
#endif
