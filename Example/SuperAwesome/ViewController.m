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
            [_bannerAd play];
        } else {
            NSLog(@"Banner %ld event %ld", placementId, event);
        }
    }];
    
    // load interstitials
    [SAInterstitialAd setConfigurationStaging];
    [SAInterstitialAd disableParentalGate];
    [SAInterstitialAd setCallback:^(NSInteger placementId, SAEvent event) {
        NSLog(@"Interstitial %ld event %ld", placementId, event);
    }];

    // load video
    [SAVideoAd setConfigurationStaging];
    [SAVideoAd disableParentalGate];
    [SAVideoAd setCloseAtEnd:false];
    [SAVideoAd enableCloseButton];
    [SAVideoAd setCallback:^(NSInteger placementId, SAEvent event) {
        NSLog(@"Video %ld event %ld", placementId, event);
        if (event == adEnded) {
            NSLog(@"VIDEO ENDED!");
        }
    }];

    // load gamewall
    [SAAppWall setConfigurationStaging];
    [SAAppWall setCallback:^(NSInteger placementId, SAEvent event) {
        NSLog(@"App Wall %ld event %ld", placementId, event);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)loadAction:(id)sender {
//    [_bannerAd load:584];
//    [SAInterstitialAd load:585];
//    [SAVideoAd load:586];
    
//    [_bannerAd load:2];
//    [SAInterstitialAd load:2];
//    [SAVideoAd load:3];
    
//    [SAInterstitialAd load:600];
//    [SAInterstitialAd load:32];
//    [SAInterstitialAd load:601];
//    [SAInterstitialAd load:605];
//    [SAInterstitialAd load:606];
    [SAVideoAd setConfigurationProduction];
    [SAVideoAd load:33501];
//    [SAVideoAd load:604];
//    [SAAppWall load:437];

}

- (IBAction)playBanner1:(id)sender {
    [_bannerAd load:599];
}

- (IBAction)playBanner2:(id)sender {
    [_bannerAd load:602];
//    [_bannerAd load:32];
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
    [SAInterstitialAd play:606 fromVC:self];
}

- (IBAction)playVideo1:(id)sender {
    [SAVideoAd play:33501 fromVC:self];
}

- (IBAction)playVideo2:(id)sender {
    [SAVideoAd play:604 fromVC:self];
}

- (IBAction)playAppWall:(id)sender {
    [SAAppWall play:437 fromVC:self];
}




@end
