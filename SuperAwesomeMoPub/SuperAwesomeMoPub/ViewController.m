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
- (IBAction)playInter:(id)sender {
    if (self.interstitial.ready) {
        [self.interstitial showFromViewController:self];
    } else {
        NSLog(@"No interstitial present");
    }
}

- (IBAction)openVideo:(id)sender {
    [[MoPub sharedInstance] initializeRewardedVideoWithGlobalMediationSettings:nil delegate:self];
    [MPRewardedVideo loadRewardedVideoAdWithAdUnitID:@"b21c7878bb1343fc8a9b267edf3c6618" withMediationSettings:nil];
}

- (IBAction)playVideo:(id)sender {
    if ([MPRewardedVideo hasAdAvailableForAdUnitID:@"b21c7878bb1343fc8a9b267edf3c6618"]) {
        [MPRewardedVideo presentRewardedVideoAdForAdUnitID:@"b21c7878bb1343fc8a9b267edf3c6618" fromViewController:self];
    } else {
        NSLog(@"No video present");
    }
}



#pragma mark - <MPAdViewDelegate>
- (UIViewController *)viewControllerForPresentingModalView {
    return self;
}

#pragma mark - <MPInterstitialAdControllerDelegate>
- (void) interstitialDidLoadAd:(MPInterstitialAdController *)interstitial {
    NSLog(@"interstitialDidLoadAd");
}

- (void) interstitialDidFailToLoadAd:(MPInterstitialAdController *)interstitial {
    NSLog(@"Did fail to load ad");
}

#pragma mark - <MPRewardedVideoDelegate>

- (void) rewardedVideoAdDidLoadForAdUnitID:(NSString *)adUnitID {
    
}

- (void) rewardedVideoAdShouldRewardForAdUnitID:(NSString *)adUnitID reward:(MPRewardedVideoReward *)reward {
    NSLog(@"User was rewarded");
}

@end
