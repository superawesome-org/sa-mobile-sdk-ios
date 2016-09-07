//
//  SAInterstitialAd2.m
//  Pods
//
//  Created by Gabriel Coman on 02/09/2016.
//
//

// load header
#import "SAInterstitialAd.h"

// load others
#import "SABannerAd.h"
#import "SALoader.h"
#import "SAAd.h"
#import "SACreative.h"
#import "SADetails.h"
#import "SATracking.h"
#import "SAMedia.h"
#import "SAEvents.h"

@interface SAInterstitialAd ()

// views
@property (nonatomic, strong) SABannerAd *banner;
@property (nonatomic, strong) UIButton *closeBtn;

// events
@property (nonatomic, strong) SAEvents *events;

@end

@implementation SAInterstitialAd

// current loaded ad
static SAAd *ad;

// other vars that need to be set statically
static id<SAProtocol> delegate;
static BOOL isParentalGateEnabled = true;
static BOOL shouldLockOrientation = false;
static NSUInteger lockOrientation = UIInterfaceOrientationMaskAll;
static BOOL isTestingEnabled = false;
static NSInteger configuration = 0;

////////////////////////////////////////////////////////////////////////////////
// MARK: VC lifecycle
////////////////////////////////////////////////////////////////////////////////

- (void) viewDidLoad {
    [super viewDidLoad];

    // get local versions of the static module vars
    id<SAProtocol> _delegateL    = [SAInterstitialAd getDelegate];
    SAAd *_adL = [SAInterstitialAd getAd];
    BOOL _isParentalGateEnabledL = [SAInterstitialAd getIsParentalGateEnabled];
    
    // set bg color
    self.view.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    
    // create close button
    _closeBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [_closeBtn setTitle:@"" forState:UIControlStateNormal];
    [_closeBtn setImage:[SAUtils closeImage] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_closeBtn];
    [self.view bringSubviewToFront:_closeBtn];
    
    // create & play banner
    _banner = [[SABannerAd alloc] initWithFrame:CGRectZero];
    [_banner setDelegate:_delegateL];
    [_banner setIsParentalGateEnabled:_isParentalGateEnabledL];
    _banner.backgroundColor = self.view.backgroundColor;
    [SAUtils invoke:@"setAd:" onTarget:_banner, _adL];
    [self.view addSubview:_banner];
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // status bar hidden
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
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
    
    // resize
    [self resize:CGRectMake(0, 0, currentSize.width, currentSize.height)];
    
    // play the ad
    [_banner play];
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
    BOOL _shouldLockOrientationL = [SAInterstitialAd getShouldLockOrientation];
    NSUInteger _lockOrientationL = [SAInterstitialAd getLockOrientation];
    return _shouldLockOrientationL ? _lockOrientationL : UIInterfaceOrientationMaskAll;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (BOOL) prefersStatusBarHidden {
    return true;
}

////////////////////////////////////////////////////////////////////////////////
// MARK: Aux Instance method
////////////////////////////////////////////////////////////////////////////////

- (void) close {
    // null ad
    [SAInterstitialAd nullAd];
    
    // close the banner
    [_banner close];
    
    // dismiss the current VC
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) resize: (CGRect) frame {
    // calc proper new frame
    CGFloat tW = frame.size.width;
    CGFloat tH = frame.size.height;
    CGFloat tX = ( frame.size.width - tW ) / 2;
    CGFloat tY = ( frame.size.height - tH) / 2;
    CGRect newR = [SAUtils mapOldFrame:CGRectMake(tX, tY, tW, tH) toNewFrame:frame];
    newR.origin.x += tX;
    newR.origin.y += tY;

    // invoke private banner method
    [_banner resize:newR];
    
    // assign new frames & resize
    [_closeBtn setFrame:CGRectMake(frame.size.width - 40.0f, 0, 40.0f, 40.0f)];
    [self.view bringSubviewToFront:_closeBtn];
}

////////////////////////////////////////////////////////////////////////////////
// MARK: Class public interface
////////////////////////////////////////////////////////////////////////////////

+ (void) load:(NSInteger) placementId {
    
    // get a weak self reference
    __weak typeof (self) weakSelf = self;
    
    // form a new session
    SASession *session = [[SASession alloc] init];
    [session setTest:isTestingEnabled];
    [session setConfiguration:configuration];
    
    // get the loader
    SALoader *loader = [[SALoader alloc] init];
    [loader loadAd:placementId withSession:session andResult:^(SAAd *saAd) {
        
        // get the ad
        ad = saAd;
        
        // call delegate
        if (ad != NULL) {
            if (delegate && [delegate respondsToSelector:@selector(SADidLoadAd:forPlacementId:)]) {
                [delegate SADidLoadAd:weakSelf forPlacementId:placementId];
            }
        } else {
            if (delegate && [delegate respondsToSelector:@selector(SADidNotLoadAd:forPlacementId:)]) {
                [delegate SADidNotLoadAd:weakSelf forPlacementId:placementId];
            }
        }
        
    }];
    
}

+ (void) play {
    if (ad && ad.creative.creativeFormat != video) {
        
        UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
        UIViewController *newVC = [[SAInterstitialAd alloc] init];
        [root presentViewController:newVC animated:YES completion:nil];
        
    } else {
        if (delegate && [delegate respondsToSelector:@selector(SADidNotShowAd:)]) {
            [delegate SADidNotShowAd:self];
        }
    }
}

+ (BOOL) hasAdAvailable {
    return ad != NULL;
}

+ (SAAd*) getAd {
    return ad;
}

+ (void) nullAd {
    ad = NULL;
}

+ (void) setTestEnabled {
    isTestingEnabled = true;
}

+ (void) setTestDisabled {
    isTestingEnabled = false;
}

+ (void) setConfigurationProduction {
    configuration = 0;
}

+ (void) setConfigurationStaging {
    configuration = 1;
}

////////////////////////////////////////////////////////////////////////////////
// MARK: Setters & getters
// Some are exposed externally (mainly setters) but some are only internally
// Main role for them is to handle working with static variables inside this
// module.
////////////////////////////////////////////////////////////////////////////////

+ (void) setDelegate:(id<SAProtocol>) del {
    delegate = del;
}

+ (void) setIsParentalGateEnabled: (BOOL) value {
    isParentalGateEnabled = value;
}

+ (void) setShouldLockOrientation: (BOOL) value {
    shouldLockOrientation = value;
}

+ (void) setLockOrientation: (NSUInteger) value {
    lockOrientation = value;
}

+ (id<SAProtocol>) getDelegate {
    return delegate;
}

+ (BOOL) getIsParentalGateEnabled {
    return isParentalGateEnabled;
}

+ (BOOL) getShouldLockOrientation {
    return shouldLockOrientation;
}

+ (NSUInteger) getLockOrientation {
    return lockOrientation;
}

@end
