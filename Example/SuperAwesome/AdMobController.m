#import "AdMobController.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "SuperAwesome.h"
#import "SAAdMobExtras.h"

@interface AdMobController () <GADBannerViewDelegate, GADInterstitialDelegate, GADRewardBasedVideoAdDelegate>

@property (weak, nonatomic) IBOutlet GADBannerView *banner;
@property (nonatomic, strong) GADInterstitial *interstitial;

@end

@implementation AdMobController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //
    // banner
    GADRequest *bannerReq = [GADRequest request];
    
    SAAdMobCustomEventExtra *extra1 = [[SAAdMobCustomEventExtra alloc] init];
    extra1.testEnabled = false;
    extra1.parentalGateEnabled = true;
    extra1.trasparentEnabled = true;
    extra1.configuration = STAGING;
    
    GADCustomEventExtras *extras = [GADCustomEventExtras new];
    [extras setExtras:extra1 forLabel:@"iOSBannerCustomEvent"];
    
    [bannerReq registerAdNetworkExtras:extras];
    
    self.banner.adSize = kGADAdSizeBanner;
    self.banner.rootViewController = self;
    self.banner.delegate = self;
    [self.banner loadRequest:bannerReq];
    
    //
    // interstitial
    self.interstitial = [[GADInterstitial alloc]
                         initWithAdUnitID:@"ca-app-pub-7706302691807937/7756520001"];
    self.interstitial.delegate = self;
    GADRequest *request = [GADRequest request];
    [self.interstitial loadRequest:request];
 
    //
    // video ad
    GADRequest *vidRequest = [GADRequest request];
    SAAdMobVideoExtra *extra = [[SAAdMobVideoExtra alloc] init];
    extra.testEnabled = false;
    extra.closeAtEndEnabled = true;
    extra.closeButtonEnabled = false;
    extra.parentalGateEnabled = false;
    extra.smallCLickEnabled = true;
    extra.configuration = STAGING;
    extra.orientation = LANDSCAPE;
    [vidRequest registerAdNetworkExtras:extra];
    [[GADRewardBasedVideoAd sharedInstance] loadRequest:vidRequest
                                           withAdUnitID:@"ca-app-pub-7706302691807937/9233253206"];
    [[GADRewardBasedVideoAd sharedInstance] setDelegate:self];
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
    
    if ([[GADRewardBasedVideoAd sharedInstance] isReady]) {
        [[GADRewardBasedVideoAd sharedInstance] presentFromRootViewController:self];
    }else {
        NSLog(@"[SuperAwesome | AdMob] Video ad wasn't ready");
    }
}

////////////////////////////////////////////////////////////////////////////////
// GADBannerViewDelegate
////////////////////////////////////////////////////////////////////////////////

- (void) adViewDidReceiveAd:(GADBannerView *)bannerView {
    NSLog(@"[SuperAwesome | AdMob] Banner did receive ad");
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
}

- (void) interstitialDidFailToPresentScreen:(GADInterstitial *)ad {
    NSLog(@"[SuperAwesome | AdMob] Interstitial did fail to present screen");
}

- (void) interstitialWillLeaveApplication:(GADInterstitial *)ad {
    NSLog(@"[SuperAwesome | AdMob] Interatitial will leave application");
}

////////////////////////////////////////////////////////////////////////////////
// GADMRewardBasedVideoAdNetworkConnector
////////////////////////////////////////////////////////////////////////////////

- (void)rewardBasedVideoAdDidReceiveAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"[SuperAwesome | AdMob] Video ad did receive ad");
}

- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
    didFailToLoadWithError:(NSError *)error {
    NSLog(@"[SuperAwesome | AdMob] Video ad did fail to receive ad with %ld | %@", error.code, error.description);
}

- (void)rewardBasedVideoAdDidOpen:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"[SuperAwesome | AdMob] Video ad did open");
}

- (void)rewardBasedVideoAdDidStartPlaying:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"[SuperAwesome | AdMob] Video ad did start playing");
}

- (void)rewardBasedVideoAdDidClose:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"[SuperAwesome | AdMob] Video ad did close");
}

- (void)rewardBasedVideoAdWillLeaveApplication:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    NSLog(@"[SuperAwesome | AdMob] Video ad will leave application");
}

- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
   didRewardUserWithReward:(GADAdReward *)reward {
    NSLog(@"[SuperAwesome | AdMob] Video ad will be rewarded with %@ | %@", reward.amount, reward.type);
}

@end
