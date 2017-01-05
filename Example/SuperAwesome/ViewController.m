//
//  ViewController.m
//  SuperAwesome
//
//  Created by Gabriel Coman on 10/03/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

#import "ViewController.h"
#import "SuperAwesome.h"
#import "SAUtils.h"
#import "SASession.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet SABannerAd *bannerAd;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // load banner
    [_bannerAd setConfigurationStaging];
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
    [SAInterstitialAd disableParentalGate];
    [SAInterstitialAd setOrientationLandscape];
    [SAInterstitialAd setCallback:^(NSInteger placementId, SAEvent event) {
        if (event == adLoaded) {
            NSLog(@"adLoaded ==> %ld", (long) placementId);
        } else if (event == adFailedToLoad) {
            NSLog(@"adFailedToLoad ==> %ld", (long) placementId);
        }
    }];

    // load video
    [SAVideoAd setConfigurationStaging];
    [SAVideoAd disableParentalGate];
    [SAVideoAd setCallback:^(NSInteger placementId, SAEvent event) {
        if (event == adLoaded) {
            NSLog(@"adLoaded ==> %ld", (long) placementId);
        } else if (event == adFailedToLoad) {
            NSLog(@"adFailedToLoad ==> %ld", (long) placementId);
        }
    }];

    // load gamewall
//    [SAAppWall setConfigurationStaging];
//    [SAAppWall setCallback:^(NSInteger placementId, SAEvent event) {
//        if (event == adLoaded) {
//            NSLog(@"[AppWall] adLoaded ==> %ld", (long) placementId);
//        } else if (event == adFailedToLoad){
//            NSLog(@"[AppWall] adFailedToLoad ==> %ld", (long) placementId);
//        } else if (event == adShown) {
//            NSLog(@"[AppWall] adShown ==> %ld", (long) placementId);
//        } else if (event == adClosed) {
//            NSLog(@"[AppWall] adClosed ==> %ld", (long) placementId);
//        } else if (event == adClicked) {
//            NSLog(@"[AppWall] adClicked ==> %ld", (long) placementId);
//        }
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)loadAction:(id)sender {
//    [_bannerAd load:584];
//    [SAInterstitialAd load:585];
//    [SAVideoAd load:586];
    [SAInterstitialAd setConfigurationProduction];
    [SAInterstitialAd load:31380];
}

- (IBAction)playBanner:(id)sender {
    if ([_bannerAd hasAdAvailable]){
        [_bannerAd play];
    }
}

- (IBAction)playInterstitial1:(id)sender {
    if ([SAInterstitialAd hasAdAvailable:585]) {
        [SAInterstitialAd play: 585 fromVC:self];
    }
}

- (IBAction)playInterstitial2:(id)sender {
    if ([SAInterstitialAd hasAdAvailable:31380]) {
        [SAInterstitialAd play:31380 fromVC:self];
    }
}

- (IBAction)playVideo1:(id)sender {
    if ([SAVideoAd hasAdAvailable:586]) {
        [SAVideoAd play: 586 fromVC:self];
    }
}

- (IBAction)playVideo2:(id)sender {
    //
}


@end
