//
//  MainViewController.m
//  SuperAwesome Demo
//
//  Created by Balázs Kiss on 20/04/15.
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//

#import "MainViewController.h"
#import "SuperAwesome.h"
#import "AppDelegate.h"
#import "TestDataProvider.h"
#import "AdItem.h"
#import "PresentViewController.h"

#import "SAVAST2Parser.h"

@interface MainViewController ()
<UITableViewDelegate,
 UITableViewDataSource,
 SALoaderProtocol,
 SAAdProtocol,
 SAParentalGateProtocol,
 SAVideoAdProtocol>

// data & table
@property (nonatomic, strong) NSArray *data;
@property (strong, nonatomic) IBOutlet UITableView *table;

// app
@property (nonatomic, weak) AppDelegate *del;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set title
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont systemFontOfSize:14];
    title.text = @"SA SDK";
    UILabel *subtitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 24, self.view.bounds.size.width, 14)];
    subtitle.text = [NSString stringWithFormat:@"(%@ - %@)",
                     [[SuperAwesome getInstance] getSdkVersion],
                     [SASystem getVerboseSystemDetails]];
    subtitle.textColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1];
    subtitle.backgroundColor = [UIColor clearColor];
    subtitle.textAlignment = NSTextAlignmentCenter;
    subtitle.font = [UIFont systemFontOfSize:9];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    v.backgroundColor = [UIColor clearColor];
    [v addSubview:title];
    [v addSubview:subtitle];
    self.navigationItem.titleView = v;
    
    // get delegate
    _del = [[UIApplication sharedApplication] delegate];
    
    // assign delegate
    [SALoader setDelegate:self];
    
    // create test data
    _data = [TestDataProvider createTestData];
    
    //
//    SAVAST2Parser *parser = [[SAVAST2Parser alloc] init];
//    [parser parseVASTURL:@"https://ads.superawesome.tv/v2/video/vast/30244/30369/30222/?sdkVersion=unknown&rnd=736470781"];
//    [parser parseVASTURL:@"https://ads.superawesome.tv/v2/video/vast/30245/30370/30223/?sdkVersion=unknown&rnd=819836586"];
//    NSLog(@"Abc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UITableViewDelegate>

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_data count];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
    }
    
    AdItem *item = _data[indexPath.row];
    
    [cell textLabel].text = item.title;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AdItem *item = _data[indexPath.row];
    
    // setup testing
    if (item.testEnabled) {
        [[SuperAwesome getInstance] enableTestMode];
    } else {
        [[SuperAwesome getInstance] disableTestMode];
    }
    
    // load the ad
    [SALoader loadAdForPlacementId:item.placementId];
}

#pragma mark <SALoaderProtocol>

- (void) didLoadAd:(SAAd *)ad {
    AdItem *item = getItemFromArrayByPlacement(_data, ad.placementId);
    
    // print the ad
    [ad print];
    
    switch (item.type) {
        case banner_item:{
            PresentViewController *vc = [[PresentViewController alloc] init];
            [self presentViewController:vc animated:YES completion:^{
                SABannerAd *bad = [[SABannerAd alloc] initWithFrame:CGRectMake(0, 100, 320, 250)];
                [bad setAd:ad];
                [vc.view addSubview:bad];
                [bad play];
                
                [bad setAdDelegate:self];
                [bad setParentalGateDelegate:self];
            }];
            break;
        }
        case video_item:{
            PresentViewController *vc = [[PresentViewController alloc] init];
            [self presentViewController:vc animated:YES completion:^{
                SAVideoAd *vad = [[SAVideoAd alloc] initWithFrame:CGRectMake(0, 100, 320, 240)];
                [vad setAd:ad];
                [vc.view addSubview:vad];
                [vad play];
                
                [vad setAdDelegate:self];
                [vad setVideoDelegate:self];
                [vad setParentalGateDelegate:self];
            }];
            break;
        }
        case interstitial_item:{
            SAInterstitialAd *iad = [[SAInterstitialAd alloc] init];
            [iad setAd:ad];
            [iad setAdDelegate:self];
            [iad setParentalGateDelegate:self];
            [iad setIsParentalGateEnabled:true];
            [self presentViewController:iad animated:YES completion:^{
                [iad play];
            }];
            break;
        }
        case fullscreen_video_item:{
            SAFullscreenVideoAd *fvad = [[SAFullscreenVideoAd alloc] init];
            [fvad setAd:ad];
            [fvad setAdDelegate:self];
            [fvad setVideoDelegate:self];
            [fvad setParentalGateDelegate:self];
//            [fvad setIsParentalGateEnabled:true];
            [self presentViewController:fvad animated:YES completion:^{
                [fvad play];
            }];
            break;
        }
        default:
            break;
    }
}

- (void) didFailToLoadAdForPlacementId:(NSInteger)placementId {
    NSLog(@"[AA :: INFO] %ld didFailToLoadAdForPlacementId", placementId);
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
