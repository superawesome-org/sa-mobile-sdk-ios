//
//  ViewController.m
//  SuperAwesome Demo
//
//  Created by Balázs Kiss on 02/04/15.
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//

#import "ViewController.h"
#import "SuperAwesome.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    SABannerView *bannerView = [[SABannerView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    [bannerView setAppID:@"14"];
    [bannerView setPlacementID:@"5247930"];
    [self.view addSubview:bannerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
