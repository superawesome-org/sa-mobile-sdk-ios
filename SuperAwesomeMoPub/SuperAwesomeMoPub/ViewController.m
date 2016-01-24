//
//  ViewController.m
//  SAMoPubIntegrationDemo
//
//  Created by Gabriel Coman on 26/10/2015.
//  Copyright © 2015 Gabriel Coman. All rights reserved.
//

#import "ViewController.h"


#import "MoPub.h"
#import "MPAdView.h"
#import "MPInterstitialAdController.h"
#import "MPRewardedVideo.h"


@interface ViewController ()
<MPAdViewDelegate, MPInterstitialAdControllerDelegate, MPRewardedVideoDelegate>

@property (nonatomic, strong) MPAdView *adView;
@property (nonatomic, strong) MPInterstitialAdController *interstitial;

@end

@implementation ViewController

- (void)viewDidLoad {
    // ... your other -viewDidLoad code ...
    
    self.adView = [[MPAdView alloc] initWithAdUnitId:@"6acb36d7c1c94461844419ef03cc10cf" size:MOPUB_BANNER_SIZE];
    self.adView.delegate = self;
    self.adView.frame = CGRectMake((self.view.bounds.size.width - MOPUB_BANNER_SIZE.width) / 2,
                                   self.view.bounds.size.height - MOPUB_BANNER_SIZE.height,
                                   MOPUB_BANNER_SIZE.width, MOPUB_BANNER_SIZE.height);
    [self.view addSubview:self.adView];
    [self.adView loadAd];
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openInterstitial:(id)sender {
    
    // Instantiate the interstitial using the class convenience method.
    self.interstitial = [MPInterstitialAdController interstitialAdControllerForAdUnitId:@"74ccdcb1059b4c038e0bfadf1c61a84b"];
    self.interstitial.delegate = self;
    
    // Fetch the interstitial ad.
    [self.interstitial loadAd];
    
}

- (IBAction)openVideo:(id)sender {
    [[MoPub sharedInstance] initializeRewardedVideoWithGlobalMediationSettings:nil delegate:self];
    [MPRewardedVideo loadRewardedVideoAdWithAdUnitID:@"39d8771203114e7b9a3d77a45e238a1a" withMediationSettings:nil];
}


#pragma mark - <MPAdViewDelegate>
- (UIViewController *)viewControllerForPresentingModalView {
    return self;
}

#pragma mark - <MPInterstitialAdControllerDelegate>
- (void) interstitialDidLoadAd:(MPInterstitialAdController *)interstitial {
    if (self.interstitial.ready) {
        [self.interstitial showFromViewController:self];
    }
}

- (void) interstitialDidFailToLoadAd:(MPInterstitialAdController *)interstitial {
    NSLog(@"Did fail to load ad");
}

#pragma mark - <MPRewardedVideoDelegate>

- (void) rewardedVideoAdDidLoadForAdUnitID:(NSString *)adUnitID {
    if ([MPRewardedVideo hasAdAvailableForAdUnitID:adUnitID]) {
        [MPRewardedVideo presentRewardedVideoAdForAdUnitID:adUnitID fromViewController:self];
    }
}

- (void) rewardedVideoAdShouldRewardForAdUnitID:(NSString *)adUnitID reward:(MPRewardedVideoReward *)reward {
    NSLog(@"User was rewarded");
}

@end
