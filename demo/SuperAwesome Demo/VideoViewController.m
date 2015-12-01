//
//  VideoViewController.m
//  SuperAwesome Demo
//
//  Created by Gabriel Coman on 16/11/2015.
//  Copyright © 2015 SuperAwesome Ltd. All rights reserved.
//

#import "VideoViewController.h"
#import "SuperAwesome.h"

@interface VideoViewController () <SALoaderProtocol>
@property (weak, nonatomic) IBOutlet SAVideoAd *video;

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SALoader setDelegate:self];
    [SALoader loadAdForPlacementId:21245];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) didLoadAd:(SAAd *)ad {
    [ad print];
    [_video setAd:ad];
    [_video setIsParentalGateEnabled:YES];
    [_video play];
}

- (void) didFailToLoadAdForPlacementId:(NSInteger)placementId {
    NSLog(@"Failed to load ad %ld", (long)placementId);
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
