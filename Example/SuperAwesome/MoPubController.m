#import "MoPubController.h"
#import <MoPub.h>

#define BANNER_ID @"f6fcf45c734d4d3ebd7b7351c9d9758d"
#define INTER_ID  @"5f2864bf19fb473fb0419e24c8671e24"
#define VIDEO_ID  @"fafa409d1b3c446e86c1c001667ca8dd"

@interface MoPubController () <MPAdViewDelegate, MPInterstitialAdControllerDelegate, MPRewardedVideoDelegate>
@property (nonatomic, retain) MPAdView *banner;
@property (nonatomic, strong) MPInterstitialAdController *interstitial;
@end

@implementation MoPubController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //
    // create & load banner
//    _banner = [[MPAdView alloc] initWithAdUnitId:BANNER_ID size:MOPUB_BANNER_SIZE];
//    _banner.frame = CGRectMake(0, 0, self.view.frame.size.width, 80);
//    _banner.delegate = self;
//    [self.view addSubview:_banner];
//    [_banner loadAd];
    
    //
    // create & load interstitial
    _interstitial = [MPInterstitialAdController interstitialAdControllerForAdUnitId:INTER_ID];
    _interstitial.delegate = self;
    [_interstitial loadAd];
    
//    //
//    // load video ads
//    [[MoPub sharedInstance] initializeRewardedVideoWithGlobalMediationSettings:nil delegate:self];
//    [MPRewardedVideo loadRewardedVideoAdWithAdUnitID:VIDEO_ID withMediationSettings:nil];
}

////////////////////////////////////////////////////////////////////////////////
// Actions
////////////////////////////////////////////////////////////////////////////////

- (IBAction)showInterstitial:(id)sender {
    if (_interstitial.ready) {
        [_interstitial showFromViewController:self];
    }
    else {
        NSLog(@"Interstitial was not ready!");
    }
}

- (IBAction)showVideo:(id)sender {
    if ([MPRewardedVideo hasAdAvailableForAdUnitID:VIDEO_ID]) {
        [MPRewardedVideo presentRewardedVideoAdForAdUnitID:VIDEO_ID fromViewController:self withReward:nil];
    } else {
        NSLog(@"Video was not ready!");
    }
}

////////////////////////////////////////////////////////////////////////////////
// MPAdViewDelegate delegates
////////////////////////////////////////////////////////////////////////////////

- (UIViewController *)viewControllerForPresentingModalView {
    return self;
}

- (void)adViewDidLoadAd:(MPAdView *)view {
    NSLog(@"[SuperAwesome | MoPub] Banner ad Loaded");
}

- (void)adViewDidFailToLoadAd:(MPAdView *)view {
    NSLog(@"[SuperAwesome | MoPub] Banner ad fail to load");
}

- (void)willPresentModalViewForAd:(MPAdView *)view {
    NSLog(@"[SuperAwesome | MoPub] Banner ad present");
}

- (void)didDismissModalViewForAd:(MPAdView *)view {
    NSLog(@"[SuperAwesome | MoPub] Banner ad dismiss");
}

- (void)willLeaveApplicationFromAd:(MPAdView *)view {
    NSLog(@"[SuperAwesome | MoPub] Banner ad will leave app");
}

////////////////////////////////////////////////////////////////////////////////
// MPInterstitialAdControllerDelegate
////////////////////////////////////////////////////////////////////////////////

- (void)interstitialDidLoadAd:(MPInterstitialAdController *)interstitial {
    NSLog(@"[SuperAwesome | MoPub] Interstitial load ad");
}

- (void)interstitialDidFailToLoadAd:(MPInterstitialAdController *)interstitial {
    NSLog(@"[SuperAwesome | MoPub] Interstitial fail to load ad");
}

- (void)interstitialWillAppear:(MPInterstitialAdController *)interstitial {
    NSLog(@"[SuperAwesome | MoPub] Interstitial will appear");
}

- (void)interstitialDidAppear:(MPInterstitialAdController *)interstitial {
    NSLog(@"[SuperAwesome | MoPub] Interstitial did appear");
}

- (void)interstitialWillDisappear:(MPInterstitialAdController *)interstitial {
    NSLog(@"[SuperAwesome | MoPub] Interstitial will disappear");
}

- (void)interstitialDidDisappear:(MPInterstitialAdController *)interstitial {
    NSLog(@"[SuperAwesome | MoPub] Interstitial did disappear");
}

- (void)interstitialDidExpire:(MPInterstitialAdController *)interstitial {
    NSLog(@"[SuperAwesome | MoPub] Interstitial did expire");
}

- (void)interstitialDidReceiveTapEvent:(MPInterstitialAdController *)interstitial {
    NSLog(@"[SuperAwesome | MoPub] Interstitial did tap");
}

////////////////////////////////////////////////////////////////////////////////
// MPRewardedVideoDelegate
////////////////////////////////////////////////////////////////////////////////

- (void)rewardedVideoAdDidLoadForAdUnitID:(NSString *)adUnitID {
    NSLog(@"[SuperAwesome | MoPub] Video did load");
}

- (void)rewardedVideoAdDidFailToLoadForAdUnitID:(NSString *)adUnitID error:(NSError *)error {
    NSLog(@"[SuperAwesome | MoPub] Video did fail to load");
}

- (void)rewardedVideoAdDidExpireForAdUnitID:(NSString *)adUnitID {
    NSLog(@"[SuperAwesome | MoPub] Video did expire");
}

- (void)rewardedVideoAdDidFailToPlayForAdUnitID:(NSString *)adUnitID error:(NSError *)error {
    NSLog(@"[SuperAwesome | MoPub] Video did fail to play");
}

- (void)rewardedVideoAdWillAppearForAdUnitID:(NSString *)adUnitID {
    NSLog(@"[SuperAwesome | MoPub] Video will appear");
}

- (void)rewardedVideoAdDidAppearForAdUnitID:(NSString *)adUnitID {
    NSLog(@"[SuperAwesome | MoPub] Video did appear");
}

- (void)rewardedVideoAdWillDisappearForAdUnitID:(NSString *)adUnitID {
    NSLog(@"[SuperAwesome | MoPub] Video will disappear");
}

- (void)rewardedVideoAdDidDisappearForAdUnitID:(NSString *)adUnitID {
    NSLog(@"[SuperAwesome | MoPub] Video did disappear");
}

- (void)rewardedVideoAdDidReceiveTapEventForAdUnitID:(NSString *)adUnitID {
    NSLog(@"[SuperAwesome | MoPub] Video did tap");
}

- (void)rewardedVideoAdWillLeaveApplicationForAdUnitID:(NSString *)adUnitID {
   NSLog(@"[SuperAwesome | MoPub] Video did leave app");
}

- (void)rewardedVideoAdShouldRewardForAdUnitID:(NSString *)adUnitID reward:(MPRewardedVideoReward *)reward {
    NSLog(@"[SuperAwesome | MoPub] Video should reward");
}


@end
