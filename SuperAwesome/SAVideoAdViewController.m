//
//  SAVideoAdViewController.m
//  SAMobileSDK
//
//  Created by Balázs Kiss on 03/02/15.
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//

#import "SAVideoAdViewController.h"

@interface SAVideoAdViewController ()

@property (nonatomic,strong) NSString *appID;
@property (nonatomic,strong) NSString *placementID;
@property (nonatomic,strong) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation SAVideoAdViewController

- (instancetype)initWithAppID:(NSString *)appID placementID:(NSString *)placementID
{
    if(self = [super init]){
        self.appID = appID;
        self.placementID = placementID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.videoView = [[SAVideoAdView alloc] initWithFrame:self.view.bounds];
    self.videoView.parentalGateEnabled = self.parentalGateEnabled;
    self.videoView.delegate = self;
    if(self.appID && self.placementID){
        self.videoView.appID = self.appID;
        self.videoView.placementID = self.placementID;
    }else{
        self.videoView.appID = @"14";
        self.videoView.placementID = @"314228";
    }
    [self.view addSubview:self.videoView];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.activityIndicatorView startAnimating];
    [self.view addSubview:self.activityIndicatorView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.activityIndicatorView.center = self.view.center;
    self.videoView.frame = self.view.bounds;
}

- (void)appplicationDidBecomeActive:(NSNotification *)notification
{
    NSLog(@"Application Did Become Active");
    [self.videoView resume];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

#pragma mark - SAVideoAdViewDelegate

- (void)didLoadVideoAd:(SAVideoAdView *)videoAd
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.activityIndicatorView stopAnimating];
        [self.videoView play];
    });
}

- (void)didFinishPlayingVideoAd:(SAVideoAdView *)videoAd{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)didFailToLoadVideoAd:(SAVideoAdView *)videoAd
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)didFailToPlayVideoAd:(SAVideoAdView *)videoAd
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)didClickVideoAd:(SAVideoAdView *)videoAd
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appplicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    });
}

@end
