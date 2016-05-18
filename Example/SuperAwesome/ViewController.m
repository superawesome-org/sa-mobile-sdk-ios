//
//  ViewController.m
//  SuperAwesome
//
//  Created by Gabriel Coman on 10/03/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

#import "ViewController.h"
#import "SuperAwesome.h"
#import "NSObject+ModelToString.h"

@interface ViewController () <SALoaderProtocol>
@property (weak, nonatomic) IBOutlet SABannerAd *bannerAd;
// @property (nonatomic, strong) SALoader *loader;
@property (nonatomic, retain) SAAd *bannerData;
@property (nonatomic, retain) SAAd *interstitial1Data;
@property (nonatomic, retain) SAAd *interstitial2Data;
@property (nonatomic, retain) SAAd *interstitial3Data;
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
    [loader loadAdForPlacementId:113];
    [loader loadAdForPlacementId:114];
    [loader loadAdForPlacementId:115];
    [loader loadAdForPlacementId:116];
    [loader loadAdForPlacementId:117];
    [loader loadAdForPlacementId:118];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) didLoadAd:(SAAd *)ad {
    NSLog(@"Loaded Ad %ld", (long)ad.placementId);
    NSLog(@"%@", [ad jsonStringPreetyRepresentation]);
    
    switch (ad.placementId) {
        case 113: _bannerData = ad; break;
        case 114: _interstitial1Data = ad; break;
        case 115: _interstitial2Data = ad; break;
        case 118: _interstitial3Data = ad; break;
        case 116: _video1Data = ad; break;
        case 117: _video2Data = ad; break;
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

- (IBAction)playVideo1:(id)sender {
    if (_video1Data != NULL) {
        SAFullscreenVideoAd *fvad = [[SAFullscreenVideoAd alloc] init];
        [fvad setAd:_video1Data];
        [fvad setShouldShowCloseButton:true];
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

- (NSUInteger) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

@end
