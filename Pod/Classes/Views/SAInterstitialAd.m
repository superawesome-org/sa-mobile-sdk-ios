//
//  SAInterstitialAd2.m
//  Pods
//
//  Created by Gabriel Coman on 13/02/2016.
//
//

#import "SAInterstitialAd.h"
#import "SABannerAd.h"
#import "SAUtils.h"
#import "SAAd.h"
#import "SACreative.h"
#import "SuperAwesome.h"

// defines
#define INTER_BG_COLOR [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1]

@interface SAInterstitialAd ()
@property (nonatomic, assign) CGRect adviewFrame;
@property (nonatomic, assign) CGRect buttonFrame;
@property (nonatomic, assign) NSInteger placementId;
@property (nonatomic, strong) SABannerAd *banner;
@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) SAAd *ad;
@property (nonatomic, strong) SALoader *loader;

@end

@implementation SAInterstitialAd

////////////////////////////////////////////////////////////////////////////////
// MARK: View Controller functions
////////////////////////////////////////////////////////////////////////////////

- (id) init {
    if (self = [super init]) {
        [self initialize];
    }
    
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self initialize];
    }
    return self;
}

- (void) initialize {
    _loader = [[SALoader alloc] init];
    _shouldLockOrientation = NO;
    _lockOrientation = UIInterfaceOrientationMaskAll;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = INTER_BG_COLOR;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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
    
    [self resize:CGRectMake(0, 0, currentSize.width, currentSize.height)];

    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self resize:CGRectMake(0, 0, size.width, size.height)];
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    CGSize scrSize = [UIScreen mainScreen].bounds.size;
    CGFloat bigDimension = MAX(scrSize.width, scrSize.height);
    CGFloat smallDimension = MIN(scrSize.width, scrSize.height);
    
    switch (toInterfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight: {
            [self resize:CGRectMake(0, 0, bigDimension, smallDimension)];
            break;
        }
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
        case UIInterfaceOrientationUnknown:
        default: {
            [self resize:CGRectMake(0, 0, smallDimension, bigDimension)];
            break;
        }
    }
}

- (UIInterfaceOrientationMask) supportedInterfaceOrientations {
    return _shouldLockOrientation ? _lockOrientation : UIInterfaceOrientationMaskAll;
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

////////////////////////////////////////////////////////////////////////////////
// MARK: View protocol implementation
////////////////////////////////////////////////////////////////////////////////

- (void) load:(NSInteger)placementId {
    
    // get a weak self reference
    __weak typeof (self) weakSelf = self;
    
    // load ad
    [_loader loadAd:placementId withResult:^(SAAd *ad) {
        
        // get the ad
        weakSelf.ad = ad;
        
        // call delegate
        if (ad != NULL) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(SADidLoadAd:forPlacementId:)]) {
                [weakSelf.delegate SADidLoadAd:weakSelf forPlacementId:placementId];
            }
        } else {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(SADidNotLoadAd:forPlacementId:)]) {
                [weakSelf.delegate SADidNotLoadAd:weakSelf forPlacementId:placementId];
            }
        }
    }];
}

- (void) play {
    
    if (_ad && _ad.creative.creativeFormat != video) {
        
        // get a weak self reference
        __weak typeof (self) weakSelf = self;
        
        // create banner
        _banner = [[SABannerAd alloc] initWithFrame:_adviewFrame];
        _banner.delegate = _delegate;
        _banner.isParentalGateEnabled = _isParentalGateEnabled;
        _banner.backgroundColor = INTER_BG_COLOR;
        [_banner setAd:_ad];
        [self.view addSubview:_banner];
        
        // create close button
        _closeBtn = [[UIButton alloc] initWithFrame:_buttonFrame];
        [_closeBtn setTitle:@"" forState:UIControlStateNormal];
        [_closeBtn setImage:[SAUtils closeImage] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_closeBtn];
        [self.view bringSubviewToFront:_closeBtn];
        
        UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
        [root presentViewController:self animated:YES completion:^{
            [weakSelf.banner play];
        }];
    } else {
        if (_delegate && [_delegate respondsToSelector:@selector(SADidNotShowAd:)]) {
            [_delegate SADidNotShowAd:self];
        }
    }
}

- (void) setAd:(SAAd *)ad {
    _ad = ad;
}

- (SAAd*) getAd {
    return [_banner getAd];
}

- (BOOL) shouldShowPadlock {
    return [_banner shouldShowPadlock];
}

- (void) close {
    
    // null ad
    _ad = NULL;
    
    // close the banner
    [_banner close];
    
    // dismiss the current VC
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) click {
    // do nothing
}

- (void) resize:(CGRect)frame {
    CGFloat tW = frame.size.width;
    CGFloat tH = frame.size.height;
    CGFloat tX = ( frame.size.width - tW ) / 2;
    CGFloat tY = ( frame.size.height - tH) / 2;
    CGRect newR = [SAUtils mapOldFrame:CGRectMake(tX, tY, tW, tH) toNewFrame:frame];
    newR.origin.x += tX;
    newR.origin.y += tY;
    
    CGFloat cs = 40.0f;
    
    // final frames
    _adviewFrame = newR;
    _buttonFrame = CGRectMake(frame.size.width - cs, 0, cs, cs);
    
    // actually resize stuff
    _closeBtn.frame = _buttonFrame;
    [_banner resize:_adviewFrame];
}


@end
