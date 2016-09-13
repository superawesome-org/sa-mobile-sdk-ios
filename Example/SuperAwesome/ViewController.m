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
    
//    [_bannerAd setConfigurationStaging];
//    [_bannerAd load:113];
//    [_bannerAd setTestDisabled];
//    [_bannerAd setCallback:^(NSInteger placementId, SAEvent event) {
//        switch (event) {
//            case adLoaded: {
//                NSLog(@"==> %ld - %@", (long) placementId, @"adLoaded");
//                break;
//            }
//            case adFailedToLoad: {
//                NSLog(@"==> %ld - %@", (long) placementId, @"adFailedToLoad");
//                break;
//            }
//            case adShown: {
//                NSLog(@"==> %ld - %@", (long) placementId, @"adShown");
//                break;
//            }
//            case adFailedToShow: {
//                NSLog(@"==> %ld - %@", (long) placementId, @"adFailedToShow");
//                break;
//            }
//            case adClicked: {
//                NSLog(@"==> %ld - %@", (long) placementId, @"adClicked");
//                break;
//            }
//            case adClosed: {
//                NSLog(@"==> %ld - %@", (long) placementId, @"adClosed");
//                break;
//            }
//        }
//    }];
    
    [SAVideoAd setConfigurationStaging];
    [SAVideoAd setTestDisabled];
    [SAVideoAd load:252];
    [SAVideoAd load:116];
    [SAVideoAd load:224];
    [SAVideoAd setCallback:^(NSInteger placementId, SAEvent event) {
        switch (event) {
            case adLoaded: {
                NSLog(@"==> %ld - %@", (long) placementId, @"adLoaded");
                break;
            }
            case adFailedToLoad: {
                NSLog(@"==> %ld - %@", (long) placementId, @"adFailedToLoad");
                break;
            }
            case adShown: {
                NSLog(@"==> %ld - %@", (long) placementId, @"adShown");
                break;
            }
            case adFailedToShow: {
                NSLog(@"==> %ld - %@", (long) placementId, @"adFailedToShow");
                break;
            }
            case adClicked: {
                NSLog(@"==> %ld - %@", (long) placementId, @"adClicked");
                break;
            }
            case adClosed: {
                NSLog(@"==> %ld - %@", (long) placementId, @"adClosed");
                break;
            }
        }
    }];
    
    
//    [SAInterstitialAd setConfigurationStaging];
//    [SAInterstitialAd setTestDisabled];
//    [SAInterstitialAd setCallback:^(NSInteger placementId, SAEvent event) {
//        switch (event) {
//            case adLoaded: {
//                NSLog(@"==> %ld - %@", (long) placementId, @"adLoaded");
//                break;
//            }
//            case adFailedToLoad: {
//                NSLog(@"==> %ld - %@", (long) placementId, @"adFailedToLoad");
//                break;
//            }
//            case adShown: {
//                NSLog(@"==> %ld - %@", (long) placementId, @"adShown");
//                break;
//            }
//            case adFailedToShow: {
//                NSLog(@"==> %ld - %@", (long) placementId, @"adFailedToShow");
//                break;
//            }
//            case adClicked: {
//                NSLog(@"==> %ld - %@", (long) placementId, @"adClicked");
//                break;
//            }
//            case adClosed: {
//                NSLog(@"==> %ld - %@", (long) placementId, @"adClosed");
//                break;
//            }
//        }
//    }];
//    [SAInterstitialAd load:247];
//    [SAInterstitialAd load:113];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)playBanner:(id)sender {
    [_bannerAd play];
}

- (IBAction)playInterstitial1:(id)sender {
    [SAInterstitialAd play: 247 fromVC:self];
}

- (IBAction)playInterstitial2:(id)sender {
    [SAInterstitialAd play: 113 fromVC:self];
}

- (IBAction)playInterstitial3:(id)sender {

}
- (IBAction)playInterstitial4:(id)sender {
    [SAVideoAd play: 28000 fromVC:self];
}

- (IBAction)playVideo1:(id)sender {
    [SAVideoAd play: 252 fromVC:self];
}

- (IBAction)playVideo2:(id)sender {
    [SAVideoAd play:224 fromVC:self];
}

@end
