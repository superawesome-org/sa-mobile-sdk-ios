//
//  MainViewController.m
//  SuperAwesome Demo
//
//  Created by Balázs Kiss on 20/04/15.
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//

#import "MainViewController.h"
#import "SuperAwesome.h"

@interface MainViewController ()
<SALoaderProtocol,
 SAAdProtocol,
 SAParentalGateProtocol,
 SAVideoAdProtocol>
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[SuperAwesome getInstance] disableTestMode];
    
    [SALoader setDelegate:self];
    [SALoader loadAdForPlacementId:7455];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <SALoaderProtocol>

- (void) didLoadAd:(SAAd *)ad {
    SAFullscreenVideoAd *fvad = [[SAFullscreenVideoAd alloc] init];
    [fvad setAd:ad];
    [fvad setAdDelegate:self];
    [fvad setParentalGateDelegate:self];
    [fvad setVideoDelegate:self];
    [fvad setIsParentalGateEnabled:YES];
    [self presentViewController:fvad animated:YES completion:^{
        [fvad play];
    }];
}

- (void) didFailToLoadAdForPlacementId:(NSInteger)placementId {
    NSLog(@"Failed to load Ad %ld", placementId);
}

#pragma mark <SAAdProtocol>

- (void) adWasShown:(NSInteger)placementId {
    NSLog(@"%ld - adWasShown", placementId);
}

- (void) adFailedToShow:(NSInteger)placementId {
    NSLog(@"%ld - adFailedToShow", placementId);
}

- (void) adWasClosed:(NSInteger)placementId {
    NSLog(@"%ld - adWasClosed", placementId);
}

- (void) adWasClicked:(NSInteger)placementId {
    NSLog(@"%ld - adWasClicked", placementId);
}

- (void) adHasIncorrectPlacement:(NSInteger)placementId {
    NSLog(@"%ld - ad has incorrect placement", placementId);
}

#pragma mark <SAParentalGateProtocol>

- (void) parentalGateWasCanceled:(NSInteger)placementId {
    NSLog(@"%ld - parentalGateWasCanceled", placementId);
}

- (void) parentalGateWasFailed:(NSInteger)placementId {
    NSLog(@"%ld - parentalGateWasFailed", placementId);
}

- (void) parentalGateWasSucceded:(NSInteger)placementId {
    NSLog(@"%ld - parentalGateWasSucceded", placementId);
}

#pragma mark <SAVideoAdProtocol>

- (void) videoStarted:(NSInteger)placementId {
    NSLog(@"%ld - videoStarted", placementId);
}

- (void) videoReachedFirstQuartile:(NSInteger)placementId {
    NSLog(@"%ld - videoReachedFirstQuartile", placementId);
}

- (void) videoReachedMidpoint:(NSInteger)placementId {
    NSLog(@"%ld - videoReachedMidpoint", placementId);
}

- (void) videoReachedThirdQuartile:(NSInteger)placementId {
    NSLog(@"%ld - videoReachedThirdQuartile", placementId);
}

- (void) videoEnded:(NSInteger)placementId {
    NSLog(@"%ld - videoEnded", placementId);
}

@end
