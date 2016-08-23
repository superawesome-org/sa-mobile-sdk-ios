//
//  SAVideoAd2.m
//  Pods
//
//  Created by Gabriel Coman on 22/08/2016.
//
//

////////////////////////////////////////////////////////////////////////////////
// Imports
////////////////////////////////////////////////////////////////////////////////

// import header
#import "SAVideoAd.h"

// import other libs
#import "SAParentalGate.h"
#import "SAAd.h"
#import "SACreative.h"
#import "SADetails.h"
#import "SAData.h"
#import "SAUtils.h"
#import "SAVideoPlayer.h"
#import "SAVASTManager.h"
#import "SAEvents.h"
#import "SAVASTAd.h"
#import "SAVASTCreative.h"
#import "SuperAwesome.h"
#import "SAExtensions.h"

// try to import SAEvents+Moat
#if defined(__has_include)
#if __has_include("SAEvents+Moat.h")
#import "SAEvents+Moat.h"
#endif
#endif

#define SMALL_PAD_FRAME CGRectMake(0, 0, 67, 25)
#define VIDEO_VIEWABILITY_COUNT 2

@interface SAVideoAd ()

@property (nonatomic, assign) CGRect adviewFrame;
@property (nonatomic, assign) CGRect buttonFrame;
@property (nonatomic, assign) BOOL isOKToClose;
@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) SAAd *ad;
@property (nonatomic, strong) SAVASTAd *vastAd;
@property (nonatomic, strong) SAVASTCreative *vastCreative;
@property (nonatomic, strong) NSString *destinationURL;
@property (nonatomic, strong) NSArray *trackingArray;

@property (nonatomic, strong) SAParentalGate *gate;
@property (nonatomic, strong) UIImageView *padlock;
@property (nonatomic, strong) SAVideoPlayer *player;
@property (nonatomic, strong) SAVASTManager *manager;

@property (nonatomic, strong) NSTimer *viewabilityTimer;
@property (nonatomic, assign) NSInteger ticks;
@property (nonatomic, assign) NSInteger viewabilityCount;

@end

@implementation SAVideoAd

////////////////////////////////////////////////////////////////////////////////
// MARK: VC Lifecycle
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
    _shouldAutomaticallyCloseAtEnd = YES;
    _shouldShowCloseButton = NO;
    _shouldLockOrientation = NO;
    _lockOrientation = UIInterfaceOrientationMaskAll;
    _isOKToClose = NO;
    _closeBtn.hidden = YES;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    // set background color
    self.view.backgroundColor = [UIColor blackColor];
    
    // setup
    _viewabilityCount = _ticks = 0;
    
    // check for incorrect placement
    if (_ad.creative.creativeFormat != video || _ad == nil) {
        if (_adDelegate != NULL && [_adDelegate respondsToSelector:@selector(adHasIncorrectPlacement:)]){
            [_adDelegate adHasIncorrectPlacement:_ad.placementId];
        }
        return;
    }
    
    // start creating the banner ad
    _gate = [[SAParentalGate alloc] initWithWeakRefToView:self];
    _gate.delegate = _parentalGateDelegate;
    
    // get a weak self reference
    __weak typeof (self) weakSelf = self;
    
    // create the player
    _player = [[SAVideoPlayer alloc] initWithFrame:_adviewFrame];
    if (_shouldShowSmallClickButton) {
        [_player showSmallClickButton];
    }
    
    // set event handler for player
    [_player setEventHandler:^(SAVideoPlayerEvent event) {
        switch (event) {
            case Video_Start: {
                
                // is OK to close
                _isOKToClose = true;
                
                // send vast ad impressions
                for (NSString *impression in _vastAd.Impressions) {
                    [SAEvents sendEventToURL:impression];
                }
                
                // send other impression
                if (_ad.creative.impressionUrl && [_ad.creative.impressionUrl rangeOfString:[[SuperAwesome getInstance] getBaseURL]].location == NSNotFound) {
                    [SAEvents sendEventToURL:_ad.creative.impressionUrl];
                }
                
                // send start event
                [self sendCurrentCreativeTrackersFor:@"start"];
                
                // send creative view event
                [self sendCurrentCreativeTrackersFor:@"creativeView"];

                // send viewable impression
                _viewabilityTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(viewableImpressionFunc) userInfo:nil repeats:YES];
                [_viewabilityTimer fire];
                
                // moat
                Class class = NSClassFromString(@"SAEvents");
                SEL selector = NSSelectorFromString(@"sendVideoMoatEvent:andLayer:andView:andAdDictionary:");
                if ([class respondsToSelector:selector]) {
                    
                    NSDictionary *moatDict = @{
                                               @"advertiser":@(_ad.advertiserId),
                                               @"campaign":@(_ad.campaignId),
                                               @"line_item":@(_ad.lineItemId),
                                               @"creative":@(_ad.creative._id),
                                               @"app":@(_ad.app),
                                               @"placement":@(_ad.placementId),
                                               @"publisher":@(_ad.publisherId)
                                               };
                    
                    AVPlayer *player = [_player getPlayer];
                    AVPlayerLayer *layer = [_player getPlayerLayer];
                    id weakSelfView = self.view;
                    NSMethodSignature *signature = [class methodSignatureForSelector:selector];
                    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
                    [invocation setTarget:class];
                    [invocation setSelector:selector];
                    [invocation setArgument:&player atIndex:2];
                    [invocation setArgument:&layer atIndex:3];
                    [invocation setArgument:&weakSelfView atIndex:4];
                    [invocation setArgument:&moatDict atIndex:5];
                    [invocation retainArguments];
                    [invocation invoke];
                }
                
                // send delegate
                if (_adDelegate && [_adDelegate respondsToSelector:@selector(adWasShown:)]) {
                    [_adDelegate adWasShown:_ad.placementId];
                }
                
                // ad started
                if (_videoDelegate && [_videoDelegate respondsToSelector:@selector(videoStarted:)]) {
                    [_videoDelegate videoStarted:_ad.placementId];
                }
                
                break;
            }
            case Video_1_4: {
                
                // send 1/4 events
                [self sendCurrentCreativeTrackersFor:@"firstQuartile"];
                
                // send delegate
                if (_videoDelegate && [_videoDelegate respondsToSelector:@selector(videoReachedFirstQuartile:)]) {
                    [_videoDelegate videoReachedFirstQuartile:_ad.placementId];
                }
                
                break;
            }
            case Video_1_2: {
                
                // send 1/2 events
                [self sendCurrentCreativeTrackersFor:@"midpoint"];
                
                // send delegate
                if (_videoDelegate && [_videoDelegate respondsToSelector:@selector(videoReachedMidpoint:)]) {
                    [_videoDelegate videoReachedMidpoint:_ad.placementId];
                }
                
                break;
            }
            case Video_3_4: {
                
                // send 3/4 events
                [self sendCurrentCreativeTrackersFor:@"thirdQuartile"];
                
                // send delegate
                if (_videoDelegate && [_videoDelegate respondsToSelector:@selector(videoReachedThirdQuartile:)]) {
                    [_videoDelegate videoReachedThirdQuartile:_ad.placementId];
                }
                
                break;
            }
            case Video_End: {
                
                // close the Pg
                [_gate close];
                
                // send complete events
                [self sendCurrentCreativeTrackersFor:@"complete"];
                
                // send delegates
                if (_videoDelegate && [_videoDelegate respondsToSelector:@selector(videoEnded:)]) {
                    [_videoDelegate videoEnded:_ad.placementId];
                }
                
                if (_videoDelegate && [_videoDelegate respondsToSelector:@selector(adEnded:)]) {
                    [_videoDelegate adEnded:_ad.placementId];
                }
                
                if (_videoDelegate && [_videoDelegate respondsToSelector:@selector(allAdsEnded:)]) {
                    [_videoDelegate allAdsEnded:_ad.placementId];
                }
                
                // close video
                if (_shouldAutomaticallyCloseAtEnd) {
                    [self close];
                }
                
                break;
            }
            case Video_Error: {
                
                // send errors
                for (NSString *error in _vastAd.Errors) {
                    [SAEvents sendEventToURL:error];
                }

                break;
            }
        }
    }];
    
    // set click handler for player
    [_player setClickHandler:^{
        
        if (weakSelf.isParentalGateEnabled) {
            [weakSelf.gate show];
        } else {
            [weakSelf advanceToClick];
        }
        
    }];
    
    // add subview
    [self.view addSubview:_player];
    
    // add the padlock
    _padlock = [[UIImageView alloc] initWithFrame:SMALL_PAD_FRAME];
    _padlock.image = [SAUtils padlockImage];
    if ([self shouldShowPadlock]) {
        [self.view addSubview:_padlock];
    }
    
    // create close button
    _closeBtn = [[UIButton alloc] initWithFrame:_buttonFrame];
    [_closeBtn setTitle:@"" forState:UIControlStateNormal];
    [_closeBtn setImage:[SAUtils closeImage] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_closeBtn];
    [self.view bringSubviewToFront:_closeBtn];
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
    
    [self resizeToFrame:CGRectMake(0, 0, currentSize.width, currentSize.height)];
    
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

- (void) dealloc {
     NSLog(@"SAVideoAd2 dealloc");
}

////////////////////////////////////////////////////////////////////////////////
// MARK: View protocol implementation
////////////////////////////////////////////////////////////////////////////////

- (void) setAd:(SAAd*)ad {
    _ad = ad;
    _vastAd = _ad.creative.details.data.vastAd;
    _vastCreative = _vastAd.creative;
}

- (SAAd*) getAd {
    return _ad;
}

- (BOOL) shouldShowPadlock {
    if (_ad.creative.creativeFormat == tag) return false;
    if (_ad.isFallback) return false;
    if (_ad.isHouse && !_ad.safeAdApproved) return false;
    return true;
}

- (void) play {
    if (_vastCreative.isOnDisk) {
        NSString *finalDiskURL = [SAUtils filePathInDocuments:_vastCreative.playableDiskURL];
        NSLog(@"Playing from Disk %@", finalDiskURL);
        [_player playWithMediaFile:finalDiskURL];
    } else {
        NSURL *url = [NSURL URLWithString:_vastCreative.playableMediaURL];
        NSLog(@"Playing from Remte %@", _vastCreative.playableMediaURL);
        [_player playWithMediaURL:url];
    }
}

- (void) close {
    if (_isOKToClose) {
        
        // destroy the player
        [_player destroy];
        _player = NULL;
        _ad = NULL;
        [_padlock removeFromSuperview];
        _padlock = nil;
        _gate = nil;
        if (_viewabilityTimer != nil) {
            [_viewabilityTimer invalidate];
            _viewabilityTimer = nil;
        }
        
        // call delegate
        if ([_adDelegate respondsToSelector:@selector(adWasClosed:)]) {
            [_adDelegate adWasClosed:_ad.placementId];
        }
        
        // dismiss VC
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void) advanceToClick {
    // call delegate
    if (_adDelegate && [_adDelegate respondsToSelector:@selector(adWasClicked:)]) {
        [_adDelegate adWasClicked:_ad.placementId];
    }
    
    // call trackers
    for (NSString *ctracking in _vastCreative.ClickTracking) {
        [SAEvents sendEventToURL:ctracking];
    }
    
    // setup the current click URL
    _destinationURL = @"";
    if (_vastCreative.ClickThrough != NULL && [SAUtils isValidURL:_vastCreative.ClickThrough]) {
        _destinationURL = _vastCreative.ClickThrough;
    }
    NSURL *url = [NSURL URLWithString:_destinationURL];
    [[UIApplication sharedApplication] openURL:url];
    
    NSLog(@"[AA :: INFO] Going to %@", _destinationURL);
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
    
    CGRect playerFrame = CGRectMake(0, 0, _adviewFrame.size.width, _adviewFrame.size.height);
    [_player updateToFrame:playerFrame];
    
    // rearrange the padlock
    _padlock.frame = SMALL_PAD_FRAME;
}

- (void) pause {
    [_player pause];
}

- (void) resume {
    [_player resume];
}

////////////////////////////////////////////////////////////////////////////////
// MARK: Aux functions
////////////////////////////////////////////////////////////////////////////////

- (void) viewableImpressionFunc {
    
    if (_ticks >= VIDEO_VIEWABILITY_COUNT) {
        [_viewabilityTimer invalidate];
        _viewabilityTimer = nil;
        
        if (_viewabilityCount == VIDEO_VIEWABILITY_COUNT) {
            [SAEvents sendEventToURL:_ad.creative.viewableImpressionUrl];
        } else {
            NSLog(@"[AA :: Error] Did not send viewable impression");
        }
    } else {
        _ticks++;
        _viewabilityCount++;
        
        NSLog(@"[AA :: Info] Tick %ld/%d - Viewability Count %ld/%d", (long)_ticks, VIDEO_VIEWABILITY_COUNT, (long)_viewabilityCount, VIDEO_VIEWABILITY_COUNT);
    }
}

- (void) sendCurrentCreativeTrackersFor:(NSString*)event {
    NSArray *trackers = [_vastCreative.TrackingEvents filterBy:@"event" withValue:event];
    for (SAVASTTracking *tracker in trackers) {
        [SAEvents sendEventToURL:tracker.URL];
    }
}


@end
