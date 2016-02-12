//
//  SAViewController.m
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 21/10/2015.
//
//

#import "SAViewController.h"

// import header
#import "SAView.h"
#import "SAAd.h"
#import "SABannerAd.h"
#import "libSAiOSUtils.h"

// Anon category for SAView to keep some functions private
@interface SAView ()
- (void) resizeToFrame:(CGRect)toframe;
@end

@interface SAViewController ()
@property (nonatomic, assign) BOOL isOKToClose;
@end

// Actual implementation of SAViewController
@implementation SAViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    _isOKToClose = YES;
    
    // set bg color
    self.view.backgroundColor = [UIColor colorWithRed:239.0/255.0f green:239.0f/255.0f blue:239.0f/255.0f alpha:1];
    
    // setup coordinates
    CGSize scrSize = [UIScreen mainScreen].bounds.size;
    CGSize currentSize = CGSizeZero;
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    CGFloat bigDimension = MAX(scrSize.width, scrSize.height);
    CGFloat smallDimension = MIN(scrSize.width, scrSize.height);
    
    switch (orientation) {
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:{
            currentSize = CGSizeMake(bigDimension, smallDimension);
            break;
        }
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown:
        default: {
            currentSize = CGSizeMake(smallDimension, bigDimension);
            break;
        }
    }
    
    [self setupCoordinates:currentSize];
    
    // create close button
    closeBtn = [[UIButton alloc] initWithFrame:buttonFrame];
    [closeBtn setTitle:@"" forState:UIControlStateNormal];
    [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    [self.view bringSubviewToFront:closeBtn];
}

// This private function is used to calculate X & Y positions and Width & Height
// for each subview of the Ad, for auto-rotation cases
- (void) setupCoordinates:(CGSize)size {
    CGRect frame = CGRectMake(0, 0, size.width, size.height);
    
    CGFloat tW = frame.size.width;// * 0.85;
    CGFloat tH = frame.size.height;// * 0.85;
    CGFloat tX = ( frame.size.width - tW ) / 2;
    CGFloat tY = ( frame.size.height - tH) / 2;
    CGRect newR = [SAUtils arrangeAdInNewFrame:CGRectMake(tX, tY, tW, tH) fromFrame:frame];
    newR.origin.x += tX;
    newR.origin.y += tY;
    
    CGFloat cs = 40.0f;
    
    // final frames
    adviewFrame = newR;
    buttonFrame = CGRectMake(frame.size.width - cs, 0, cs, cs);
}

// Make sure that at View Will Appear / View Will Disappear the status bar
// is hidden
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

#pragma mark iOS 8.0+

- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self setupCoordinates:size];
    
    closeBtn.frame = buttonFrame;
    [adview resizeToFrame:adviewFrame];
}

#pragma mark iOS 8.0-

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    CGSize scrSize = [UIScreen mainScreen].bounds.size;
    CGFloat bigDimension = MAX(scrSize.width, scrSize.height);
    CGFloat smallDimension = MIN(scrSize.width, scrSize.height);
    
    switch (toInterfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight: {
            [self setupCoordinates:CGSizeMake(bigDimension, smallDimension)];
            closeBtn.frame = buttonFrame;
            [adview resizeToFrame:adviewFrame];
            break;
        }
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
        case UIInterfaceOrientationUnknown:
        default: {
            [self setupCoordinates:CGSizeMake(smallDimension, bigDimension)];
            closeBtn.frame = buttonFrame;
            [adview resizeToFrame:adviewFrame];
            break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// These functions mainly are over the SAView ones

- (void) play {
    [adview play];
}

// Specific SAViewController functions and handles

- (IBAction) closeAction:(id)sender {
    if (_isOKToClose) {
        [self close];
    }
}

- (void) close {
    [self dismissViewControllerAnimated:YES completion:^{
        if ([adview.adDelegate respondsToSelector:@selector(adWasClosed:)]) {
            [adview.adDelegate adWasClosed:_ad.placementId];
        }
    }];
} 

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (BOOL) prefersStatusBarHidden {
    return true;
}

@end
