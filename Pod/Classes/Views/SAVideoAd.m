//
//  SAVideoAd2.m
//  Pods
//
//  Created by Gabriel Coman on 01/09/2016.
//
//

#import "SAVideoAd.h"
#import "SALoader.h"
#import "SAAd.h"
#import "SACreative.h"
#import "SADetails.h"
#import "SAMedia.h"
#import "SAVideoPlayer.h"
#import "SAParentalGate.h"
#import "SAEvents.h"
#import "SASession.h"
#import "SuperAwesome.h"

@interface SAVideoAd ()

// aux
@property (nonatomic, assign) BOOL isOKToClose;
@property (nonatomic, strong) NSString *destinationURL;

// views
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) SAParentalGate *gate;
@property (nonatomic, strong) UIImageView *padlock;
@property (nonatomic, strong) SAVideoPlayer *player;

// events
@property (nonatomic, strong) SAEvents *events;

@end

@implementation SAVideoAd

// current loaded ad
static SAAd *ad;

// other vars that need to be set statically
static sacallback callback = ^(NSInteger placementId, SAEvent event) {};
static BOOL isParentalGateEnabled = true;
static BOOL shouldAutomaticallyCloseAtEnd = true;
static BOOL shouldShowCloseButton = true;
static BOOL shouldShowSmallClickButton = false;
static BOOL shouldLockOrientation = false;
static NSUInteger lockOrientation = UIInterfaceOrientationMaskAll;
static BOOL isTestingEnabled = false;
static NSInteger configuration = 0;

////////////////////////////////////////////////////////////////////////////////
// MARK: VC lifecycle
////////////////////////////////////////////////////////////////////////////////

- (void) viewDidLoad {
    [super viewDidLoad];
    
    // get main static vars into local ones
    __block SAAd *_adL = [SAVideoAd getAd];
    __block sacallback _callbackL = [SAVideoAd getCallback];
    __block BOOL _isParentalGateEnabledL = [SAVideoAd getIsParentalGateEnabled];
    __block BOOL _shouldAutomaticallyCloseAtEndL = [SAVideoAd getShouldAutomaticallyCloseAtEnd];
    __block BOOL _shouldShowCloseButtonL = [SAVideoAd getShouldShowCloseButton];
    __block BOOL _shouldShowSmallClickButtonL = [SAVideoAd getShouldShowSmallClickButton];
    __block BOOL _shouldShowPadlockL = [SAVideoAd shouldShowPadlock];
    
    // start events
    _events = [[SAEvents alloc] init];
    [_events setAd:_adL];
    
    // get a weak self reference
    __weak typeof (self) weakSelf = self;
    
    // start creating the banner ad
    _gate = [[SAParentalGate alloc] initWithWeakRefToView:self andAd:_adL];
    
    // create the player
    _player = [[SAVideoPlayer alloc] initWithFrame:CGRectZero];
    if (_shouldShowSmallClickButtonL) {
        [_player showSmallClickButton];
    }
    
    // set event handler for player
    [_player setEventHandler:^(SAVideoPlayerEvent event) {
        switch (event) {
            case Video_Start: {
                
                // is OK to close
                _isOKToClose = true;
                
                // send vast ad impressions
                [weakSelf.events sendAllEventsForKey:@"impression"];
                [weakSelf.events sendAllEventsForKey:@"start"];
                [weakSelf.events sendAllEventsForKey:@"creativeView"];
                
                // send viewable impression
                [weakSelf.events sendViewableForFullscreen];
                
                // moat
                [weakSelf.events moatEventForVideoPlayer:[weakSelf.player getPlayer]
                                               withLayer:[weakSelf.player getPlayerLayer]
                                                 andView:[weakSelf view]];
                
                // callback
                _callbackL(_adL.placementId, adShown);
                
                break;
            }
            case Video_1_4: {
                [weakSelf.events sendAllEventsForKey:@"firstQuartile"];
                break;
            }
            case Video_1_2: {
                [weakSelf.events sendAllEventsForKey:@"midpoint"];
                break;
            }
            case Video_3_4: {
                [weakSelf.events sendAllEventsForKey:@"thirdQuartile"];
                break;
            }
            case Video_End: {
                
                // close the Pg
                [weakSelf.gate close];
                
                // send complete events
                [weakSelf.events sendAllEventsForKey:@"complete"];
                
                // close video
                if (_shouldAutomaticallyCloseAtEndL) {
                    [weakSelf close];
                }
                
                break;
            }
            case Video_Error: {
                
                // send errors
                [weakSelf.events sendAllEventsForKey:@"error"];
                
                // close
                [weakSelf close];
                
                // send callback
                _callbackL(_adL.placementId, adFailedToShow);
                
                break;
            }
        }
    }];
    
    // set click handler for player
    [_player setClickHandler:^{
        
        if (_isParentalGateEnabledL) {
            [weakSelf.gate show];
        } else {
            [weakSelf click];
        }
        
    }];
    
    // add subview
    [self.view addSubview:_player];
    
    // add the padlock
    _padlock = [[UIImageView alloc] initWithFrame:CGRectZero];
    _padlock.image = [SAUtils padlockImage];
    if (_shouldShowPadlockL) {
        [self.view addSubview:_padlock];
    }
    
    // create close button
    _closeBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [_closeBtn setHidden:!_shouldShowCloseButtonL];
    [_closeBtn setTitle:@"" forState:UIControlStateNormal];
    [_closeBtn setImage:[SAUtils closeImage] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_closeBtn];
    [self.view bringSubviewToFront:_closeBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // get the ad from static
    SAAd *_adL = [SAVideoAd getAd];
    
    // set status bar hidden
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
    
    // apply the resize
    [self resize:CGRectMake(0, 0, currentSize.width, currentSize.height)];
    
    // actually start playing the video
    if (_adL.creative.details.media.isOnDisk) {
        NSString *finalDiskURL = [SAUtils filePathInDocuments:_adL.creative.details.media.playableDiskUrl];
        [_player playWithMediaFile:finalDiskURL];
    } else {
        NSURL *url = [NSURL URLWithString:_adL.creative.details.media.playableMediaUrl];
        [_player playWithMediaURL:url];
    }
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
    BOOL _shouldLockOrientationL = [SAVideoAd getShouldLockOrientation];
    NSUInteger _lockOrientationL = [SAVideoAd getLockOrientation];
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
    if (_isOKToClose) {
        
        // call delegate
        sacallback _callbackL = [SAVideoAd getCallback];
        SAAd *_adL = [SAVideoAd getAd];
        _callbackL(_adL.placementId, adClosed);
        
        // close
        [_events close];
        
        // null the ad
        // @warn: static
        [SAVideoAd nullAd];
        
        // destroy the player
        [_player destroy];
        _player = NULL;
        
        // destroy the padlock
        [_padlock removeFromSuperview];
        _padlock = nil;
        
        // destroy the gate
        _gate = nil;
        
        // dismiss VC
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void) resize: (CGRect) frame {
    // get locl vars from static
    BOOL _shouldShowCloseButtonL = [SAVideoAd getShouldShowCloseButton];
    
    // setup close button
    _closeBtn.frame = _shouldShowCloseButtonL ? CGRectMake(frame.size.width - 40.0f, 0, 40.0f, 40.0f) : CGRectZero;
    [self.view bringSubviewToFront:_closeBtn];
    
    // rearrange the player frame
    [_player updateToFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    
    // rearrange the padlock
    _padlock.frame = CGRectMake(0, 0, 67, 25);
}

- (void) click {
    // get delegate
    sacallback _callbackL = [SAVideoAd getCallback];
    SAAd *_adL = [SAVideoAd getAd];
    
    // call delegate
    _callbackL(_adL.placementId, adClicked);
    
    // call trackers
    [_events sendAllEventsForKey:@"click_tracking"];
    [_events sendAllEventsForKey:@"custom_clicks"];
    
    // setup the current click URL
    for (SATracking *tracking in _adL.creative.events) {
        if ([tracking.event rangeOfString:@"click_through"].location != NSNotFound) {
            _destinationURL = tracking.URL;
        }
    }
    
    // go to URL
    if (_destinationURL) {
        NSURL *url = [NSURL URLWithString:_destinationURL];
        [[UIApplication sharedApplication] openURL:url];
    }
    
    NSLog(@"[AA :: INFO] Going to %@", _destinationURL);
}

- (void) pause {
    [_player pause];
}

- (void) resume {
    [_player resume];
}

////////////////////////////////////////////////////////////////////////////////
// MARK: Class public interface
////////////////////////////////////////////////////////////////////////////////

+ (void) load:(NSInteger) placementId {
    
    // get a weak self reference
    __weak typeof (self) weakSelf = self;
    
    // form a new session
    SASession *session = [[SASession alloc] init];
    [session setConfiguration:configuration];
    [session setTest:isTestingEnabled];
    [session setDauId:[[SuperAwesome getInstance] getDAUID]];
    [session setVersion:[[SuperAwesome getInstance] getSdkVersion]];
    
    // get the loader
    SALoader *loader = [[SALoader alloc] init];
    [loader loadAd:placementId withSession:session andResult:^(SAAd *saAd) {
        
        // get the ad
        ad = saAd;
        
        // call delegate
        callback(placementId, ad != NULL ? adLoaded : adFailedToLoad);
        
    }];
}

+ (void) play:(UIViewController*)parent {
    
    if (ad && ad.creative.creativeFormat == video) {
        
        UIViewController *newVC = [[SAVideoAd alloc] init];
        [parent presentViewController:newVC animated:YES completion:nil];
        
    } else {
        // callback for failure
        callback(0, adFailedToShow);
    }
}

+ (BOOL) shouldShowPadlock {
    if (ad.creative.creativeFormat == tag) return false;
    if (ad.isFallback) return false;
    if (ad.isHouse && !ad.safeAdApproved) return false;
    return true;
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

////////////////////////////////////////////////////////////////////////////////
// MARK: Setters & getters
// Some are exposed externally (mainly setters) but some are only internally
// Main role for them is to handle working with static variables inside this
// module.
////////////////////////////////////////////////////////////////////////////////

+ (void) setCallback:(sacallback)call {
    callback = call ? call : ^(NSInteger placementId, SAEvent event) {};
}

+ (void) setIsParentalGateEnabled: (BOOL) value {
    isParentalGateEnabled = value;
}

+ (void) setShouldAutomaticallyCloseAtEnd: (BOOL) value {
    shouldAutomaticallyCloseAtEnd = value;
}

+ (void) setShouldShowCloseButton: (BOOL) value {
    shouldShowCloseButton = value;
}

+ (void) setShouldShowSmallClickButton: (BOOL) value {
    shouldShowSmallClickButton = value;
}

+ (void) setShouldLockOrientation: (BOOL) value {
    shouldLockOrientation = value;
}

+ (void) setLockOrientation: (NSUInteger) value {
    lockOrientation = value;
}

+ (sacallback) getCallback {
    return callback;
}

+ (BOOL) getIsParentalGateEnabled {
    return isParentalGateEnabled;
}

+ (BOOL) getShouldAutomaticallyCloseAtEnd {
    return shouldAutomaticallyCloseAtEnd;
}

+ (BOOL) getShouldShowCloseButton {
    return shouldShowCloseButton;
}

+ (BOOL) getShouldShowSmallClickButton {
    return shouldShowSmallClickButton;
}

+ (BOOL) getShouldLockOrientation {
    return shouldLockOrientation;
}

+ (NSUInteger) getLockOrientation {
    return lockOrientation;
}

+ (void) setTest:(BOOL) isTest {
    isTestingEnabled = isTest;
}

+ (void) setTestEnabled {
    isTestingEnabled = true;
}

+ (void) setTestDisabled {
    isTestingEnabled = false;
}

+ (void) setConfiguration: (NSInteger) config {
    configuration = config;
}

+ (void) setConfigurationProduction {
    configuration = [SASession getProductionConfigurationID];
}

+ (void) setConfigurationStaging {
    configuration = [SASession getStatingConfigurationID];
}


@end
