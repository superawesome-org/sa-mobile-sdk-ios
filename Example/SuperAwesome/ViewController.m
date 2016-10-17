//
//  ViewController.m
//  SuperAwesome
//
//  Created by Gabriel Coman on 10/03/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

#import "ViewController.h"
#import "SuperAwesome.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet SABannerAd *bannerAd;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // load banner
    [_bannerAd setConfigurationStaging];
    [_bannerAd disableTestMode];
    [_bannerAd disableParentalGate];
    [_bannerAd setCallback:^(NSInteger placementId, SAEvent event) {
        if (event == adLoaded) {
            NSLog(@"adLoaded ==> %ld", (long) placementId);
        } else if (event == adFailedToLoad) {
            NSLog(@"adFailedToLoad ==> %ld", (long) placementId);
        }
    }];
    
    // load interstitials
    [SAInterstitialAd setConfigurationStaging];
    [SAInterstitialAd disableTestMode];
    [SAInterstitialAd enableParentalGate];
    [SAInterstitialAd setOrientationPortrait];
    [SAInterstitialAd setCallback:^(NSInteger placementId, SAEvent event) {
        if (event == adLoaded) {
            NSLog(@"adLoaded ==> %ld", (long) placementId);
        } else if (event == adFailedToLoad) {
            NSLog(@"adFailedToLoad ==> %ld", (long) placementId);
        }
    }];

    // load video
    [SAVideoAd setConfigurationProduction];
    [SAVideoAd disableParentalGate];
    [SAVideoAd setCallback:^(NSInteger placementId, SAEvent event) {
        if (event == adLoaded) {
            NSLog(@"adLoaded ==> %ld", (long) placementId);
        } else if (event == adFailedToLoad) {
            NSLog(@"adFailedToLoad ==> %ld", (long) placementId);
        }
    }];

    // load gamewall
    [SAGameWall setConfigurationStaging];
    [SAGameWall setCallback:^(NSInteger placementId, SAEvent event) {
        if (event == adLoaded) {
            NSLog(@"[GameWall] adLoaded ==> %ld", (long) placementId);
        } else if (event == adFailedToLoad){
            NSLog(@"[GameWall] adFailedToLoad ==> %ld", (long) placementId);
        } else if (event == adShown) {
            NSLog(@"[GameWall] adShown ==> %ld", (long) placementId);
        } else if (event == adClosed) {
            NSLog(@"[GameWall] adClosed ==> %ld", (long) placementId);
        } else if (event == adClicked) {
            NSLog(@"[GameWall] adClicked ==> %ld", (long) placementId);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)loadAction:(id)sender {
    [_bannerAd load:446];
//    [SAVideoAd load:447];
//    [SAGameWall load:470];
    [SAInterstitialAd setConfigurationProduction];
    [SAInterstitialAd load:32569];
    [SAInterstitialAd setConfigurationStaging];
    [SAInterstitialAd load:418];
//    [SAVideoAd setConfigurationProduction];
//    [SAVideoAd load:31718];
//    [SAVideoAd load:31721];
//    [SAVideoAd setConfigurationStaging];
//    [SAVideoAd setOrientationLandscape];
//    [SAVideoAd load:480];
    [SAVideoAd load:481];
}

- (IBAction)playBanner:(id)sender {
    if ([_bannerAd hasAdAvailable]){
        [_bannerAd play];
    }
}

- (IBAction)playInterstitial1:(id)sender {
    if ([SAInterstitialAd hasAdAvailable:32569]) {
        [SAInterstitialAd play: 32569 fromVC:self];
    }
}

- (IBAction)playInterstitial2:(id)sender {
    if ([SAInterstitialAd hasAdAvailable:418]) {
        [SAInterstitialAd play: 418 fromVC:self];
    }
}

- (IBAction)playVideo1:(id)sender {
//    if ([SAVideoAd hasAdAvailable:31718]) {
//        [SAVideoAd play: 31718 fromVC:self];
//    }
    
//    if ([SAVideoAd hasAdAvailable:480]) {
//        [SAVideoAd play:480 fromVC:self];
//    }
}

- (IBAction)playVideo2:(id)sender {
//    if ([SAGameWall hasAdAvailable:470]) {
//        [SAGameWall play:470  fromVC:self];
//    }
//    if ([SAVideoAd hasAdAvailable:31721]) {
//        [SAVideoAd play:31721 fromVC:self];
//    }
    
//    if ([SAVideoAd hasAdAvailable:481]) {
//        [SAVideoAd play:481 fromVC:self];
//    }
}

@end
