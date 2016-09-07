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

@interface ViewController () <SAProtocol>
@property (weak, nonatomic) IBOutlet SABannerAd *bannerAd;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_bannerAd setConfigurationStaging];
    [_bannerAd load:257];
    [_bannerAd setTestEnabled];
    _bannerAd.tag = 0;
    _bannerAd.delegate = self;
    
    [SAVideoAd setConfigurationStaging];
    [SAVideoAd setDelegate:self];
    [SAVideoAd setTestDisabled];
    [SAVideoAd load:252];
    [SAVideoAd load:116];
    [SAInterstitialAd setConfigurationStaging];
    [SAInterstitialAd setTestDisabled];
    [SAInterstitialAd load:247];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)playBanner:(id)sender {
    [_bannerAd play];
}

- (IBAction)playInterstitial1:(id)sender {
    [SAInterstitialAd play];
}

- (IBAction)playInterstitial2:(id)sender {

}

- (IBAction)playInterstitial3:(id)sender {

}
- (IBAction)playInterstitial4:(id)sender {

}

- (IBAction)playVideo1:(id)sender {
    [SAVideoAd play];
}

- (IBAction)playVideo2:(id)sender {

}

- (void) SADidLoadAd:(id)sender forPlacementId:(NSInteger)placementId {
    NSLog(@"Did load for %@ - %ld", sender, (long) placementId);
}

- (void) SADidNotLoadAd:(id)sender forPlacementId:(NSInteger)placementId {
    NSLog(@"Did fail to load for %ld", (long) placementId);
}

- (void) SADidClickAd:(id)sender {
    NSLog(@"Did click on ad for %@", sender);
}

- (void) SADidCloseAd:(id)sender {
    NSLog(@"Did close %@", sender);
}

@end
