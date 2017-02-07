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
    [_bannerAd enableParentalGate];
    [_bannerAd setCallback:^(NSInteger placementId, SAEvent event) {
        if (event == adLoaded) {
            [_bannerAd play];
        } else {
            NSLog(@"Banner %ld event %ld", (long)placementId, (long)event);
        }
    }];
    
    // load interstitials
    [SAInterstitialAd setConfigurationStaging];
    [SAInterstitialAd enableParentalGate];
//    [SAInterstitialAd setOrientationLandscape];
    [SAInterstitialAd setCallback:^(NSInteger placementId, SAEvent event) {
        NSLog(@"Interstitial %ld event %ld", (long)placementId, (long)event);
    }];

    // load video
    [SAVideoAd setConfigurationStaging];
    [SAVideoAd disableParentalGate];
    [SAVideoAd setCloseAtEnd:false];
    [SAVideoAd enableParentalGate];
//    [SAVideoAd enableCloseButton];
//    [SAVideoAd setOrientationLandscape];
    [SAVideoAd setCallback:^(NSInteger placementId, SAEvent event) {
        NSLog(@"Video %ld event %ld", (long)placementId, (long)event);
        if (event == adEnded) {
            NSLog(@"VIDEO ENDED!");
        }
    }];

    // load gamewall
    [SAAppWall setConfigurationStaging];
    [SAAppWall setCallback:^(NSInteger placementId, SAEvent event) {
        NSLog(@"App Wall %ld event %ld", (long)placementId, (long)event);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)loadAction:(id)sender {
    
//    [SAInterstitialAd load:600];
//    [SAInterstitialAd load:601];
//    [SAInterstitialAd load:605];
//    [SAInterstitialAd load:606];
//    [SAInterstitialAd load:613];
    [SAInterstitialAd load:614];
//    [SAVideoAd load:604];
//    [SAVideoAd load:603];
//    [SAVideoAd load:612];
//    [SAAppWall load:437];

}

- (IBAction)playBanner1:(id)sender {
    [_bannerAd load:599];
}

- (IBAction)playBanner2:(id)sender {
    [_bannerAd load:602];
//    [_bannerAd load:611];
}

- (IBAction)playInter1:(id)sender {
    [SAInterstitialAd play:600 fromVC:self];
}

- (IBAction)playInter2:(id)sender {
    [SAInterstitialAd play:601 fromVC:self];
}

- (IBAction)playInter3:(id)sender {
    [SAInterstitialAd play:605 fromVC:self];
}

- (IBAction)playInter4:(id)sender {
//    [SAInterstitialAd play:606 fromVC:self];
//    [SAInterstitialAd play:613 fromVC:self];
    [SAInterstitialAd play:614 fromVC:self];
}

- (IBAction)playVideo1:(id)sender {
    [SAVideoAd play:603 fromVC:self];
}

- (IBAction)playVideo2:(id)sender {
//    [SAVideoAd play:604 fromVC:self];
    [SAVideoAd play:612 fromVC:self];
}

- (IBAction)playAppWall:(id)sender {
    [SAAppWall play:437 fromVC:self];
}




@end
