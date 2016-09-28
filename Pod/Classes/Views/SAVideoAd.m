//
//  SAVideoAd2.m
//  Pods
//
//  Created by Gabriel Coman on 01/09/2016.
//
//

#import "SAVideoAd.h"
#import "SALoader.h"
#import "SAResponse.h"
#import "SAAd.h"
#import "SACreative.h"
#import "SADetails.h"
#import "SAMedia.h"
#import "SAVideoPlayer.h"
#import "SAParentalGate.h"
#import "SAEvents.h"
#import "SASession.h"
#import "SAImageUtils.h"
#import "SuperAwesome.h"
#import "SAOrientation.h"

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

// the ad
@property (nonatomic, strong) SAAd *ad;

@end

@implementation SAVideoAd

// dictionary of ads
static NSMutableDictionary *ads;

// other static vars needed for state 
static sacallback callback = ^(NSInteger placementId, SAEvent event) {};
static BOOL isParentalGateEnabled = true;
static BOOL shouldAutomaticallyCloseAtEnd = true;
static BOOL shouldShowCloseButton = true;
static BOOL shouldShowSmallClickButton = false;
static BOOL isTestingEnabled = false;
static SAOrientation orientation = ANY;
static SAConfiguration configuration = PRODUCTION;

////////////////////////////////////////////////////////////////////////////////
// MARK: VC lifecycle
////////////////////////////////////////////////////////////////////////////////

- (void) viewDidLoad {
    [super viewDidLoad];
    
    // get main static vars into local ones
    __block sacallback _callbackL = [SAVideoAd getCallback];
    __block BOOL _isParentalGateEnabledL = [SAVideoAd getIsParentalGateEnabled];
    __block BOOL _shouldAutomaticallyCloseAtEndL = [SAVideoAd getShouldAutomaticallyCloseAtEnd];
    __block BOOL _shouldShowCloseButtonL = [SAVideoAd getShouldShowCloseButton];
    __block BOOL _shouldShowSmallClickButtonL = [SAVideoAd getShouldShowSmallClickButton];
    __block BOOL _shouldShowPadlockL = [self shouldShowPadlock];
    
    // start events
    _events = [[SAEvents alloc] init];
    [_events setAd:_ad];
    
    // get a weak self reference
    __weak typeof (self) weakSelf = self;
    
    // start creating the banner ad
    _gate = [[SAParentalGate alloc] initWithWeakRefToView:self andAd:_ad];
    
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
                weakSelf.isOKToClose = true;
                
                // send vast ad impressions
                [weakSelf.events sendAllEventsForKey:@"impression"];
                [weakSelf.events sendAllEventsForKey:@"start"];
                [weakSelf.events sendAllEventsForKey:@"creativeView"];
                
                // send viewable impression
                [weakSelf.events sendViewableImpressionForVideo:weakSelf.player];
                
                // moat
                [weakSelf.events moatEventForVideoPlayer:[weakSelf.player getPlayer]
                                               withLayer:[weakSelf.player getPlayerLayer]
                                                 andView:[weakSelf view]];
                
                // callback
                _callbackL(weakSelf.ad.placementId, adShown);
                
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
                _callbackL(weakSelf.ad.placementId, adFailedToShow);
                
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
    _padlock.image = [SAImageUtils padlockImage];
    if (_shouldShowPadlockL) {
        [self.view addSubview:_padlock];
    }
    
    // create close button
    _closeBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [_closeBtn setHidden:!_shouldShowCloseButtonL];
    [_closeBtn setTitle:@"" forState:UIControlStateNormal];
    [_closeBtn setImage:[SAImageUtils closeImage] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_closeBtn];
    [self.view bringSubviewToFront:_closeBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // set status bar hidden
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    // setup coordinates
    CGSize scrSize = [UIScreen mainScreen].bounds.size;
    CGSize currentSize = CGSizeZero;
    UIDeviceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
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
    if (_ad.creative.details.media.isOnDisk) {
        NSString *finalDiskURL = [SAUtils filePathInDocuments:_ad.creative.details.media.playableDiskUrl];
        [_player playWithMediaFile:finalDiskURL];
    } else {
        NSURL *url = [NSURL URLWithString:_ad.creative.details.media.playableMediaUrl];
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
    SAOrientation orientationL = [SAVideoAd getOrientation];
    switch (orientationL) {
        case ANY: return UIInterfaceOrientationMaskAll;
        case PORTRAIT: return UIInterfaceOrientationMaskPortrait;
        case LANDSCAPE: return UIInterfaceOrientationMaskLandscape;
    }
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
        _callbackL(_ad.placementId, adClosed);
        
        // close
        [_events close];
        
        // null the ad
        // @warn: static
        [SAVideoAd removeAdFromLoadedAds:_ad];
        
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
    
    // call delegate
    _callbackL(_ad.placementId, adClicked);
    
    // call trackers
    [_events sendAllEventsForKey:@"click_tracking"];
    [_events sendAllEventsForKey:@"custom_clicks"];
    [_events sendAllEventsForKey:@"install"];
    
    // setup the current click URL
    for (SATracking *tracking in _ad.creative.events) {
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

- (BOOL) shouldShowPadlock {
    if (_ad.creative.creativeFormat == tag) return false;
    if (_ad.isFallback) return false;
    if (_ad.isHouse && !_ad.safeAdApproved) return false;
    return true;
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
    
    // create dictionary
    if (ads == NULL) {
        ads = [@{} mutableCopy];
    }
    
    // if  there's no object around
    if ([ads objectForKey:@(placementId)] == NULL) {
        
        // set a placeholder
        [ads setObject:@(true) forKey:@(placementId)];
        
        // form a new session
        SASession *session = [[SASession alloc] init];
        [session setTestMode:isTestingEnabled];
        [session setConfiguration:configuration];
        [session setVersion:[[SuperAwesome getInstance] getSdkVersion]];
        
        // get the loader
        SALoader *loader = [[SALoader alloc] init];
        [loader loadAd:placementId withSession:session andResult:^(SAResponse *response) {
            
            // add to the array queue
            if ([response isValid]) {
                [ads setObject:[response.ads objectAtIndex:0] forKey:@(placementId)];
            }
            // remove
            else {
                [ads removeObjectForKey:@(placementId)];
            }
            
            // callback
            callback(placementId, [response isValid] ? adLoaded : adFailedToLoad);
        }];
        
    } else {
        callback (placementId, adFailedToLoad);
    }
}

+ (void) play:(NSInteger) placementId fromVC:(UIViewController*)parent {
    
    // find out if the ad is loaded
    SAAd *adL = [ads objectForKey:@(placementId)];
    
    // try to start the view controller (if there is one ad that's OK)
    if (adL && adL.creative.creativeFormat == video) {
        
        SAVideoAd *newVC = [[SAVideoAd alloc] init];
        newVC.ad = adL;
        [parent presentViewController:newVC animated:YES completion:nil];
        
    } else {
        callback(placementId, adFailedToShow);
    }
}

+ (BOOL) hasAdAvailable: (NSInteger) placementId {
    id object = [ads objectForKey:@(placementId)];
    return object != NULL && [object isKindOfClass:[SAAd class]];
}

+ (void) removeAdFromLoadedAds:(SAAd*)ad {
    [ads removeObjectForKey:@(ad.placementId)];
}

////////////////////////////////////////////////////////////////////////////////
// MARK: Setters & getters
// Some are exposed externally (mainly setters) but some are only internally
// Main role for them is to handle working with static variables inside this
// module.
////////////////////////////////////////////////////////////////////////////////

+ (void) setCallback:(sacallback)call {
    callback = call ? call : callback;
}

+ (void) enableTestMode {
    isTestingEnabled = true;
}

+ (void) disableTestMode {
    isTestingEnabled = false;
}

+ (void) enableParentalGate {
    isParentalGateEnabled = true;
}

+ (void) disableParentalGate {
    isParentalGateEnabled = false;
}

+ (void) setConfigurationProduction {
    configuration = PRODUCTION;
}

+ (void) setConfigurationStaging {
    configuration = STAGING;
}

+ (void) setOrientationAny {
    orientation = ANY;
}

+ (void) setOrientationPortrait {
    orientation = PORTRAIT;
}

+ (void) setOrientationLandscape {
    orientation = LANDSCAPE;
}

+ (void) enableCloseButton {
    shouldShowCloseButton = true;
}

+ (void) disableCloseButton {
    shouldShowCloseButton = false;
}

+ (void) enableSmallClickButton {
    shouldShowSmallClickButton = true;
}

+ (void) disableSmallClickButton {
    shouldShowSmallClickButton = false;
}

+ (void) enableCloseAtEnd {
    shouldAutomaticallyCloseAtEnd = true;
}

+ (void) disableCloseAtEnd {
    shouldAutomaticallyCloseAtEnd = false;
}

// private static getters

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

+ (SAOrientation) getOrientation {
    return orientation;
}

@end
