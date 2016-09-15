//
//  ViewController.m
//  SuperAwesome
//
//  Created by Gabriel Coman on 10/03/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

#import "ViewController.h"
#import "SuperAwesome.h"
#import "SAVideoAd.h"
#import "SAInterstitialAd.h"

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
    [_bannerAd load:414];
    
    // load interstitials
    [SAInterstitialAd setConfigurationStaging];
    [SAInterstitialAd disableTestMode];
    [SAInterstitialAd enableParentalGate];
    [SAInterstitialAd setOrientationPortrait];
    [SAInterstitialAd load:415];
    [SAInterstitialAd load:418];
    
    // load video
    [SAVideoAd setConfigurationStaging];
    [SAVideoAd disableParentalGate];
    [SAVideoAd setOrientationLandscape];
    [SAVideoAd disableCloseButton];
    [SAVideoAd enableSmallClickButton];
    [SAVideoAd load:416];
    [SAVideoAd load:417];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)playBanner:(id)sender {
    if ([_bannerAd hasAdAvailable]){
        [_bannerAd play];
    }
}

- (IBAction)playInterstitial1:(id)sender {
    if ([SAInterstitialAd hasAdAvailable:415]) {
        [SAInterstitialAd play: 415 fromVC:self];
    }
}

- (IBAction)playInterstitial2:(id)sender {
    if ([SAInterstitialAd hasAdAvailable:418]) {
        [SAInterstitialAd play: 418 fromVC:self];
    }
}

- (IBAction)playVideo1:(id)sender {
    if ([SAVideoAd hasAdAvailable:416]) {
        [SAVideoAd play: 416 fromVC:self];
    }
}

- (IBAction)playVideo2:(id)sender {
    if ([SAVideoAd hasAdAvailable:417]) {
        [SAVideoAd play:417 fromVC:self];
    }
}

@end
