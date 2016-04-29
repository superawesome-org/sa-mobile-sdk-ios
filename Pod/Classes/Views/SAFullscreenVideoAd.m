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
#import "SAUtils.h"

@interface SAVideoAd () <SAVASTManagerProtocol>
@property (nonatomic, weak) id<SAAdProtocol> internalAdProto;
@property (nonatomic, weak) id<SAVideoAdProtocol> internalVideoAdProto;
@end

@interface SAFullscreenVideoAd () <SAVideoAdProtocol, SAAdProtocol>

@property (nonatomic, assign) CGRect adviewFrame;
@property (nonatomic, assign) CGRect buttonFrame;
@property (nonatomic, assign) BOOL isOKToClose;

@property (nonatomic, weak) SAAd *ad;
@property (nonatomic, strong) SAVideoAd *video;
@property (nonatomic, strong) UIButton *closeBtn;

@end

@implementation SAFullscreenVideoAd

#pragma mark <ViewController> functions

- (id) init {
    if (self = [super init]) {
        _shouldAutomaticallyCloseAtEnd = YES;
        _shouldShowCloseButton = NO;
        _isOKToClose = NO;
        _closeBtn.hidden = YES;
    }
    
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _shouldAutomaticallyCloseAtEnd = YES;
        _shouldShowCloseButton = NO;
        _isOKToClose = NO;
        _closeBtn.hidden = YES;
    }
    return self;
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _shouldAutomaticallyCloseAtEnd = YES;
        _shouldShowCloseButton = NO;
        _isOKToClose = NO;
        _closeBtn.hidden = YES;
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"SAFullscreenVideoAd viewDidLoad");
    
    // set bg color
    self.view.backgroundColor = [UIColor blackColor];

    _isOKToClose = true;
    
    _video = [[SAVideoAd alloc] initWithFrame:_adviewFrame];
    [_video setAd:_ad];
    _video.adDelegate = _adDelegate;
    _video.parentalGateDelegate = _parentalGateDelegate;
    _video.videoDelegate = _videoDelegate;
    _video.isParentalGateEnabled = _isParentalGateEnabled;
    _video.internalVideoAdProto = self;
    _video.internalAdProto = self;
    [self.view addSubview:_video];
    
    // create close button
    _closeBtn = [[UIButton alloc] initWithFrame:_buttonFrame];
    [_closeBtn setTitle:@"" forState:UIControlStateNormal];
    [_closeBtn setImage:[UIImage imageWithContentsOfFile:[SAUtils filePathForName:@"close" type:@"png" andBundle:@"SuperAwesome" andClass:self.classForCoder]] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_closeBtn];
    [self.view bringSubviewToFront:_closeBtn];
    
    // setup coordinates
    CGSize scrSize = [UIScreen mainScreen].bounds.size;
    CGSize currentSize = CGSizeZero;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGFloat bigDimension = MAX(scrSize.width, scrSize.height);
    CGFloat smallDimension = MIN(scrSize.width, scrSize.height);
    
    switch (orientation) {
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:{
            currentSize = CGSizeMake(bigDimension, smallDimension);
            break;
        }
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown:{
            currentSize = CGSizeMake(smallDimension, bigDimension);
            break;
        }
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationFaceDown: {
            if (scrSize.width > scrSize.height){
                currentSize = CGSizeMake(bigDimension, smallDimension);
            }
            else {
                currentSize = CGSizeMake(smallDimension, bigDimension);
            }
            break;
        }
        default: {
            currentSize = CGSizeMake(smallDimension, bigDimension);
            break;
        }
    }
    
    [self resizeToFrame:CGRectMake(0, 0, currentSize.width, currentSize.height)];
}

- (void) viewDidUnload {
    [super viewDidUnload];
    NSLog(@"SAFullscreenVideoAd viewDidUnload");
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    NSLog(@"SAFullscreenVideoAd viewWillAppear");
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    NSLog(@"SAFullscreenVideoAd viewWillDisappear");
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
    NSLog(@"SAFullscreenVideoAd didReceiveMemoryWarning");
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (BOOL) prefersStatusBarHidden {
    return true;
}

#pragma mark <SAViewProtocol> functions

- (void) setAd:(SAAd*)__ad {
    _ad = __ad;
}

- (SAAd*) getAd {
    return _ad;
}

- (void) play {
    [_video play];
}

- (void) close {
    
    [_video close];
    
    if ([_video.adDelegate respondsToSelector:@selector(adWasClosed:)]) {
        [_video.adDelegate adWasClosed:_ad.placementId];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) advanceToClick {
    // do nothing
}

- (void) resizeToFrame:(CGRect)frame {
    // setup frame
    _adviewFrame = frame;
    
    if (_shouldShowCloseButton){
        CGFloat cs = 40.0f;
        _buttonFrame = CGRectMake(frame.size.width - cs, 0, cs, cs);
        _closeBtn.hidden = NO;
        [self.view bringSubviewToFront:_closeBtn];
    } else {
        _closeBtn.hidden = YES;
        _buttonFrame = CGRectZero;
    }
    
    _closeBtn.frame = _buttonFrame;
    [_video resizeToFrame:_adviewFrame];
}

- (void) dealloc {
    NSLog(@"SAFullscreenVideoAd dealloc");
}

#pragma mark <SAVideoAdProtocol> - internal

- (void) adStarted:(NSInteger)placementId {
    _isOKToClose = true;
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

- (void) adHasIncorrectPlacement:(NSInteger)placementId {
    [self close];
}

#pragma mark <Other> actions

- (IBAction) closeAction: (id)sender {
    if (_isOKToClose) {
        [self close];
    }
}

@end
