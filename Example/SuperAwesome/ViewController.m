//
//  ViewController.m
//  SuperAwesome
//
//  Created by Gabriel Coman on 10/03/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

#import "ViewController.h"
#import "SuperAwesome.h"

@interface ViewController () <SALoaderProtocol, SAAdProtocol>
@property (weak, nonatomic) IBOutlet SABannerAd *bannerAd;
// @property (nonatomic, strong) SALoader *loader;
@property (nonatomic, retain) SAAd *bannerData;
@property (nonatomic, retain) SAAd *interstitial1Data;
@property (nonatomic, retain) SAAd *interstitial2Data;
@property (nonatomic, retain) SAAd *interstitial3Data;
@property (nonatomic, retain) SAAd *interstitial4Data;
@property (nonatomic, retain) SAAd *video1Data;
@property (nonatomic, retain) SAAd *video2Data;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[SuperAwesome getInstance] setConfigurationStaging];
    [[SuperAwesome getInstance] disableTestMode];
    
    SALoader *loader = [[SALoader alloc] init];
    loader.delegate = self;
//    [loader loadAdForPlacementId:30260];
    [loader loadAdForPlacementId:223];
//    [loader loadAdForPlacementId:113];
//    [loader loadAdForPlacementId:114];
//    [loader loadAdForPlacementId:115];
//    [loader loadAdForPlacementId:116];
//    [loader loadAdForPlacementId:117];
//    [loader loadAdForPlacementId:118];
//    [loader loadAdForPlacementId:233];
//    [loader loadAdForPlacementId:200];
//    [loader loadAdForPlacementId:204];
//    [loader loadAdForPlacementId:28000];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) didLoadAd:(SAAd *)ad {
    NSLog(@"Loaded Ad %ld", (long)ad.placementId);
    NSLog(@"%@", [ad jsonPreetyStringRepresentation]);
    
    switch (ad.placementId) {
        case 223: _video1Data = ad; break;
//        case 30260: _video1Data = ad; break;
        case 113: _bannerData = ad; break;
        case 114: _interstitial1Data = ad; break;
        case 115: _interstitial2Data = ad; break;
        case 118: _interstitial3Data = ad; break;
//        case 230: _video1Data = ad; break;
        case 116: _video1Data = ad; break;
        case 117: _video2Data = ad; break;
//        case 233: _interstitial3Data = ad; break;
//        case 200: _bannerData = ad; break;
//        case 30471: _bannerData = ad; break;
//        case 204: _interstitial1Data = ad; break;
//        case 28000: _video2Data = ad; break;
//        case 201: _video1Data = ad; break;
//        case 130: _interstitial4Data = ad; break;
//        case 28000: _video1Data = ad; break;
//        case 142: _bannerData = ad; break;
//        case 31513: _bannerData = ad; break;
        default:break;
    }
}

- (void) didFailToLoadAdForPlacementId:(NSInteger)placementId {
    NSLog(@"Failed to load %ld", (long)placementId);    
}

- (IBAction)playBanner:(id)sender {
    if (_bannerData != NULL){
        [_bannerAd setAd:_bannerData];
        [_bannerAd play];
    }
}

- (IBAction)playInterstitial1:(id)sender {
    if (_interstitial1Data != NULL) {
        SAInterstitialAd *fvad = [[SAInterstitialAd alloc] init];
        [fvad setAd:_interstitial1Data];
        [self presentViewController:fvad animated:YES completion:^{
            [fvad play];
        }];
    }
}

- (IBAction)playInterstitial2:(id)sender {
    if (_interstitial2Data != NULL) {
        SAInterstitialAd *fvad = [[SAInterstitialAd alloc] init];
        [fvad setAd:_interstitial2Data];
        [fvad setIsParentalGateEnabled:false];
        
        [fvad setAdDelegate:self];
        
        [self presentViewController:fvad animated:YES completion:^{
            [fvad play];
        }];
    }
}

- (IBAction)playInterstitial3:(id)sender {
    if (_interstitial3Data != NULL) {
        SAInterstitialAd *fvad = [[SAInterstitialAd alloc] init];
        [fvad setAd:_interstitial3Data];
        [fvad setShouldLockOrientation:YES];
        [fvad setLockOrientation:UIInterfaceOrientationMaskPortrait];
        [self presentViewController:fvad animated:YES completion:^{
            [fvad play];
        }];
    }
}
- (IBAction)playInterstitial4:(id)sender {
    if (_interstitial4Data != NULL){
        SAInterstitialAd *iad = [[SAInterstitialAd alloc] init];
        [iad setAd:_interstitial4Data];
        [self presentViewController:iad animated:YES completion:^{
            [iad play];
        }];
    }
}

- (IBAction)playVideo1:(id)sender {
    if (_video1Data != NULL) {
        SAFullscreenVideoAd *fvad = [[SAFullscreenVideoAd alloc] init];
        [fvad setAd:_video1Data];
        [fvad setShouldShowCloseButton:true];
        [fvad setIsParentalGateEnabled:true];
        [self presentViewController:fvad animated:YES completion:^{
            [fvad play];
        }];
    }
}

- (IBAction)playVideo2:(id)sender {
    if (_video2Data != NULL) {
        SAFullscreenVideoAd *fvad = [[SAFullscreenVideoAd alloc] init];
        [fvad setAd:_video2Data];
        [fvad setShouldShowCloseButton:true];
        [fvad setShouldLockOrientation:YES];
        [fvad setShouldShowSmallClickButton:true];
        [fvad setLockOrientation:UIInterfaceOrientationMaskLandscape];
        [self presentViewController:fvad animated:YES completion:^{
            [fvad play];
        }];
    }
}

//- (NSUInteger) supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskLandscape;
//}

@end
