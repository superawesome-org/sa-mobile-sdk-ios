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
    
    [[SuperAwesome getInstance] loadAd:250];
    [[SuperAwesome getInstance] loadAd:250];
    [[SuperAwesome getInstance] loadAd:251];
    [[SuperAwesome getInstance] loadAd:252];
    
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
    // Dispose of any resources that can be recreated.
}

- (IBAction)playBanner:(id)sender {
    [_bannerAd play:250];
//    if (_bannerData != NULL){
//        [_bannerAd setAd:_bannerData];
//        [_bannerAd play];
//    }
}

- (IBAction)playInterstitial1:(id)sender {
    SAInterstitialAd *fvad = [[SAInterstitialAd alloc] init];
    [fvad play:251];
//    if (_interstitial1Data != NULL) {
//        SAInterstitialAd *fvad = [[SAInterstitialAd alloc] init];
//        [fvad setAd:_interstitial1Data];
//        [self presentViewController:fvad animated:YES completion:^{
//            [fvad play];
//        }];
//    }
}

- (IBAction)playInterstitial2:(id)sender {
//    if (_interstitial2Data != NULL) {
//        SAInterstitialAd *fvad = [[SAInterstitialAd alloc] init];
//        [fvad setAd:_interstitial2Data];
//        [fvad setIsParentalGateEnabled:false];
//        
//        [fvad setAdDelegate:self];
//        
//        [self presentViewController:fvad animated:YES completion:^{
//            [fvad play];
//        }];
//    }
}

- (IBAction)playInterstitial3:(id)sender {
//    if (_interstitial3Data != NULL) {
//        SAInterstitialAd *fvad = [[SAInterstitialAd alloc] init];
//        [fvad setAd:_interstitial3Data];
//        [fvad setShouldLockOrientation:YES];
//        [fvad setLockOrientation:UIInterfaceOrientationMaskPortrait];
//        [self presentViewController:fvad animated:YES completion:^{
//            [fvad play];
//        }];
//    }
}
- (IBAction)playInterstitial4:(id)sender {
//    if (_interstitial4Data != NULL){
//        SAInterstitialAd *iad = [[SAInterstitialAd alloc] init];
//        [iad setAd:_interstitial4Data];
//        [self presentViewController:iad animated:YES completion:^{
//            [iad play];
//        }];
//    }
}

- (IBAction)playVideo1:(id)sender {
    
    SAVideoAd *fvad = [[SAVideoAd alloc] init];
    [fvad setShouldShowCloseButton:true];
    [fvad play:252];
    
//    if (_video1Data != NULL) {
//        
//        SAVideoAd *fvad = [[SAVideoAd alloc] init];
//        [fvad setAd:_video1Data];
//        [fvad setShouldShowCloseButton:true];
//        [fvad setIsParentalGateEnabled:true];
//        [self presentViewController:fvad animated:YES completion:^{
//            [fvad play];
//        }];
//    }
}

- (IBAction)playVideo2:(id)sender {
//    if (_video2Data != NULL) {
//        SAVideoAd *fvad = [[SAVideoAd alloc] init];
//        [fvad setAd:_video2Data];
//        [fvad setShouldShowCloseButton:true];
//        [fvad setShouldLockOrientation:YES];
//        [fvad setShouldShowSmallClickButton:true];
//        [fvad setLockOrientation:UIInterfaceOrientationMaskLandscape];
//        [self presentViewController:fvad animated:YES completion:^{
//            [fvad play];
//        }];
//    }
}

//- (NSUInteger) supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskLandscape;
//}

@end
