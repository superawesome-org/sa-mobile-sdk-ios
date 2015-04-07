//
//  SAInterstitialView.m
//  SAMobileSDK
//
//  Created by Balázs Kiss on 12/08/14.
//  Copyright (c) 2014 SuperAwesome Ltd. All rights reserved.
//

#import "SAInterstitialView.h"
#import "SuperAwesome.h"

@interface SAInterstitialView ()

@property (nonatomic,strong) ATInterstitialView *interstitialView;
@property (nonatomic,strong) SAParentalGate *gate;
@property (nonatomic,strong) NSURL *adURL;

@end

@implementation SAInterstitialView

- (instancetype)initWithViewController:(UIViewController *)viewController
{
    if(self = [super init]){

        self.interstitialView = [[ATInterstitialView alloc] init];
        self.interstitialView.delegate = self;
        self.interstitialView.viewController = viewController;
    }
    return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    [self.interstitialView setBackgroundColor:backgroundColor];
}

- (void)setAppID:(NSString *)appID
{
    [super setAppID:appID];
    [self tryToLoadAd];
}

- (void)setPlacementID:(NSString *)placementID
{
    [super setPlacementID:placementID];
    [self tryToLoadAd];
}

- (void)tryToLoadAd
{
    if(self.appID == nil || self.placementID == nil) return;
    
    [[SuperAwesome sharedManager] displayAdForApp:self.appID placement:self.placementID completion:^(SADisplayAd *displayAd) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(displayAd == nil){
                NSLog(@"SA: Could not find placement with the provided placement ID");
            }else{
                self.interstitialView.configuration = [self configurationWithDisplayAd:displayAd];
                [self.interstitialView load];
            }
        });
    }];
}

- (void)present
{
    [self.interstitialView present];
}

#pragma mark - ATInterstitialViewDelegate

- (void)didSuccessfullyFetchInterstitialAd:(ATInterstitialView*)view
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didSuccessfullyFetchInterstitialAd:)]){
        [self.delegate didSuccessfullyFetchInterstitialAd:self];
    }
}

- (void)didHideInterstitialAd:(ATInterstitialView *)view
{
    [self.interstitialView load];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(didHideInterstitialView:)]){
        [self.delegate didHideInterstitialView:self];
    }
}

- (BOOL)shouldOpenLandingPageForAd:(ATInterstitialView*)view withURL:(NSURL*)URL useBrowser:(ATBrowserViewController *__autoreleasing *)browserViewController;
{
    if([self isParentalGateEnabled]){
        if(self.gate == nil){
            self.gate = [[SAParentalGate alloc] init];
            self.gate.delegate = self;
        }
        [self.gate show];
        self.adURL = URL;
        
        return NO;
    }
    return YES;
}

- (void)didGetThroughParentalGate:(SAParentalGate *)parentalGate
{
    [[UIApplication sharedApplication] openURL:self.adURL];
}


@end
