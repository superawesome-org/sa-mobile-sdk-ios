//
//  SAFullscreenVideoAd2.m
//  Pods
//
//  Created by Gabriel Coman on 13/02/2016.
//
//

#import "SAFullscreenVideoAd.h"
#import "SAAd.h"
#import "SAVideoAd.h"

@interface SAVideoAd () <SAVASTManagerProtocol>
@property id<SAAdProtocol> internalAdProto;
@property id<SAVideoAdProtocol> internalVideoAdProto;
@end

@interface SAFullscreenVideoAd () <SAVideoAdProtocol>
@end

@implementation SAFullscreenVideoAd

#pragma mark <ViewController> functions

- (id) init {
    if (self = [super init]) {
        _shouldAutomaticallyCloseAtEnd = YES;
        _shouldShowCloseButton = NO;
        isOKToClose = NO;
        closeBtn.hidden = YES;
    }
    
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _shouldAutomaticallyCloseAtEnd = YES;
        _shouldShowCloseButton = NO;
        isOKToClose = NO;
        closeBtn.hidden = YES;
    }
    return self;
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _shouldAutomaticallyCloseAtEnd = YES;
        _shouldShowCloseButton = NO;
        isOKToClose = NO;
        closeBtn.hidden = YES;
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    // set bg color
    self.view.backgroundColor = [UIColor blackColor];
    
    video = [[SAVideoAd alloc] initWithFrame:adviewFrame];
    [video setAd:ad];
    video.adDelegate = _adDelegate;
    video.parentalGateDelegate = _parentalGateDelegate;
    video.videoDelegate = _videoDelegate;
    video.isParentalGateEnabled = _isParentalGateEnabled;
    video.internalVideoAdProto = self;
    [self.view addSubview:video];
    
    // create close button
    closeBtn = [[UIButton alloc] initWithFrame:buttonFrame];
    [closeBtn setTitle:@"" forState:UIControlStateNormal];
    [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    [self.view bringSubviewToFront:closeBtn];
    
    // setup coordinates
    CGSize scrSize = [UIScreen mainScreen].bounds.size;
    CGSize currentSize = CGSizeZero;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGFloat bigDimension = MAX(scrSize.width, scrSize.height);
    CGFloat smallDimension = MIN(scrSize.width, scrSize.height);
    
    switch (orientation) {
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:{
            currentSize = CGSizeMake(bigDimension, smallDimension);
            break;
        }
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
        default: {
            currentSize = CGSizeMake(smallDimension, bigDimension);
            break;
        }
    }
    
    [self resizeToFrame:CGRectMake(0, 0, currentSize.width, currentSize.height)];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self resizeToFrame:CGRectMake(0, 0, size.width, size.height)];
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    CGSize scrSize = [UIScreen mainScreen].bounds.size;
    CGFloat bigDimension = MAX(scrSize.width, scrSize.height);
    CGFloat smallDimension = MIN(scrSize.width, scrSize.height);
    
    switch (toInterfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight: {
            [self resizeToFrame:CGRectMake(0, 0, bigDimension, smallDimension)];
            break;
        }
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
        case UIInterfaceOrientationUnknown:
        default: {
            [self resizeToFrame:CGRectMake(0, 0, smallDimension, bigDimension)];
            break;
        }
    }
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (BOOL) prefersStatusBarHidden {
    return true;
}

#pragma mark <SAViewProtocol> functions

- (void) setAd:(SAAd*)_ad {
    ad = _ad;
}

- (SAAd*) getAd {
    return ad;
}

- (void) play {
    [video play];
}

- (void) close {
    
    [video close];
    
    [self dismissViewControllerAnimated:YES completion:^{
        if ([video.adDelegate respondsToSelector:@selector(adWasClosed:)]) {
            [video.adDelegate adWasClosed:ad.placementId];
        }
    }];
    
}

- (void) tryToGoToURL:(NSURL*)url {
    // do nothing
}

- (void) advanceToClick {
    // do nothing
}

- (void) resizeToFrame:(CGRect)frame {
    // setup frame
    adviewFrame = frame;
    
    if (_shouldShowCloseButton){
        CGFloat cs = 40.0f;
        buttonFrame = CGRectMake(frame.size.width - cs, 0, cs, cs);
        closeBtn.hidden = NO;
        [self.view bringSubviewToFront:closeBtn];
    } else {
        closeBtn.hidden = YES;
        buttonFrame = CGRectZero;
    }
    
    closeBtn.frame = buttonFrame;
    [video resizeToFrame:adviewFrame];
}

#pragma mark <SAVideoAdProtocol> - internal

- (void) adStarted:(NSInteger)placementId {
    isOKToClose = true;
}

- (void) allAdsEnded:(NSInteger)placementId {
    if (_shouldAutomaticallyCloseAtEnd) {
        [self close];
    }
}

#pragma mark <SAAdProtocol> - internal

- (void) adFailedToShow:(NSInteger)placementId {
    [self close];
}

#pragma mark <Other> actions

- (IBAction) closeAction: (id)sender {
    if (isOKToClose) {
        [self close];
    }
}

@end
