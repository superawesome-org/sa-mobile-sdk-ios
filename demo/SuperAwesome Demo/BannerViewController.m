//
//  BannerViewController.m
//  SuperAwesome Demo
//
//  Created by Gabriel Coman on 16/11/2015.
//  Copyright © 2015 SuperAwesome Ltd. All rights reserved.
//

#import "BannerViewController.h"
#import "SuperAwesome.h"

@interface BannerViewController () <SALoaderProtocol>
@property (weak, nonatomic) IBOutlet SABannerAd *banner;
@end

@implementation BannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[SuperAwesome getInstance] enableTestMode];
    
    [SALoader setDelegate:self];
    [SALoader loadAdForPlacementId:10277];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) didLoadAd:(SAAd *)ad {
    [_banner setAd:ad];
    [_banner setIsParentalGateEnabled:YES];
    [_banner play];
}

- (void) didFailToLoadAdForPlacementId:(NSInteger)placementId {
    NSLog(@"Failed to load %ld", (long)placementId);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
