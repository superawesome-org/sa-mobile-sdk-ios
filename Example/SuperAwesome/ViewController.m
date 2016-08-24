//
//  ViewController.m
//  SuperAwesome
//
//  Created by Gabriel Coman on 10/03/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

#import "ViewController.h"
#import "SuperAwesome.h"

@interface ViewController () <SAAdProtocol>
@property (weak, nonatomic) IBOutlet SABannerAd *bannerAd;
@property (nonatomic, strong) SAVideoAd *fvad;
@property (nonatomic, strong) SAInterstitialAd *iad;
// @property (nonatomic, strong) SALoader *loader;
//@property (nonatomic, retain) SAAd *bannerData;
//@property (nonatomic, retain) SAAd *interstitial1Data;
//@property (nonatomic, retain) SAAd *interstitial2Data;
//@property (nonatomic, retain) SAAd *interstitial3Data;
//@property (nonatomic, retain) SAAd *interstitial4Data;
//@property (nonatomic, retain) SAAd *video1Data;
//@property (nonatomic, retain) SAAd *video2Data;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[SuperAwesome getInstance] setConfigurationStaging];
    [[SuperAwesome getInstance] disableTestMode];
    
    [_bannerAd load:250];
    
    _fvad = [[SAVideoAd alloc] init];
    [_fvad setShouldShowCloseButton:YES];
    [_fvad load:252];
    
    _iad = [[SAInterstitialAd alloc] init];
    [_iad load:251];
    
//    SALoader *loader = [[SALoader alloc] init];
//    loader.delegate = self;
//    [loader loadAdForPlacementId:251];
//    [loader loadAdForPlacementId:30260];
//    [loader loadAdForPlacementId:30260];
//    [loader loadAdForPlacementId:223];
//    [loader loadAdForPlacementId:113];
//    [loader loadAdForPlacementId:114];
//    [loader loadAdForPlacementId:115];
//    [loader loadAdForPlacementId:249];
//    [loader loadAdForPlacementId:116];
//    [loader loadAdForPlacementId:117];
//    [loader loadAdForPlacementId:118];
//    [loader loadAdForPlacementId:247];
//    [loader loadAdForPlacementId:233];
//    [loader loadAdForPlacementId:200];
//    [loader loadAdForPlacementId:204];
//    [loader loadAdForPlacementId:28000];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)playBanner:(id)sender {
    [_bannerAd play];
}

- (IBAction)playInterstitial1:(id)sender {
    [_iad play];
}

- (IBAction)playInterstitial2:(id)sender {

}

- (IBAction)playInterstitial3:(id)sender {

}
- (IBAction)playInterstitial4:(id)sender {

}

- (IBAction)playVideo1:(id)sender {
    [_fvad play];
}

- (IBAction)playVideo2:(id)sender {

}

@end
