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
#import "SAMedia.h"
#import "SATracking.h"
#import "SAUtils.h"
#import "SAVideoPlayer.h"
#import "SAEvents.h"
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
@property (nonatomic, strong) NSString *destinationURL;
@property (nonatomic, strong) NSArray *trackingArray;

@property (nonatomic, strong) SAParentalGate *gate;
@property (nonatomic, strong) UIImageView *padlock;
@property (nonatomic, strong) SAVideoPlayer *player;

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
        if (_adDelegate != NULL && [_adDelegate respondsToSelector:@selector(adFailedToShow:)]){
            [_adDelegate adFailedToShow:_ad.placementId];
        }
        return;
    }
    
    // start creating the banner ad
    _gate = [[SAParentalGate alloc] initWithWeakRefToView:self];
    
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
                [SAEvents sendAllEventsFor:weakSelf.ad.creative.events withKey:@"impression"];
                [SAEvents sendAllEventsFor:weakSelf.ad.creative.events withKey:@"start"];
                [SAEvents sendAllEventsFor:weakSelf.ad.creative.events withKey:@"creativeView"];

                // send viewable impression
                weakSelf.viewabilityTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                                             target:weakSelf
                                                                           selector:@selector(viewableImpressionFunc)
                                                                           userInfo:nil
                                                                            repeats:YES];
                [weakSelf.viewabilityTimer fire];
                
                // moat
                Class class = NSClassFromString(@"SAEvents");
                SEL selector = NSSelectorFromString(@"sendVideoMoatEvent:andLayer:andView:andAdDictionary:");
                if ([class respondsToSelector:selector]) {
                    
                    NSDictionary *moatDict = @{
                                               @"advertiser":@(weakSelf.ad.advertiserId),
                                               @"campaign":@(weakSelf.ad.campaignId),
                                               @"line_item":@(weakSelf.ad.lineItemId),
                                               @"creative":@(weakSelf.ad.creative._id),
                                               @"app":@(weakSelf.ad.app),
                                               @"placement":@(weakSelf.ad.placementId),
                                               @"publisher":@(weakSelf.ad.publisherId)
                                               };
                    
                    AVPlayer *player = [weakSelf.player getPlayer];
                    AVPlayerLayer *layer = [weakSelf.player getPlayerLayer];
                    id weakSelfView = weakSelf.view;
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
                if (weakSelf.adDelegate && [weakSelf.adDelegate respondsToSelector:@selector(adWasShown:)]) {
                    [weakSelf.adDelegate adWasShown:weakSelf.ad.placementId];
                }
                
                break;
            }
            case Video_1_4: {
                [SAEvents sendAllEventsFor:weakSelf.ad.creative.events withKey:@"firstQuartile"];
                break;
            }
            case Video_1_2: {
                [SAEvents sendAllEventsFor:weakSelf.ad.creative.events withKey:@"midpoint"];
                break;
            }
            case Video_3_4: {
                [SAEvents sendAllEventsFor:weakSelf.ad.creative.events withKey:@"thirdQuartile"];
                break;
            }
            case Video_End: {
                
                // close the Pg
                [weakSelf.gate close];
                
                // send complete events
                [SAEvents sendAllEventsFor:weakSelf.ad.creative.events withKey:@"complete"];
                
                // close video
                if (weakSelf.shouldAutomaticallyCloseAtEnd) {
                    [weakSelf close];
                }
                
                break;
            }
            case Video_Error: {
                
                // send errors
                [SAEvents sendAllEventsFor:weakSelf.ad.creative.events withKey:@"error"];

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
    
    if (_ad.creative.details.media.isOnDisk) {
        NSString *finalDiskURL = [SAUtils filePathInDocuments:_ad.creative.details.media.playableDiskUrl];
        [_player playWithMediaFile:finalDiskURL];
    } else {
        NSURL *url = [NSURL URLWithString:_ad.creative.details.media.playableMediaUrl];
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
    [SAEvents sendAllEventsFor:_ad.creative.events withKey:@"click_tracking"];
    [SAEvents sendAllEventsFor:_ad.creative.events withKey:@"custom_clicks"];
    
    // setup the current click URL
    _destinationURL = _ad.creative.clickUrl;
    
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
            [SAEvents sendAllEventsFor:_ad.creative.events withKey:@"viewable_impr"];
        } else {
            NSLog(@"[AA :: Error] Did not send viewable impression");
        }
    } else {
        _ticks++;
        _viewabilityCount++;
        
        NSLog(@"[AA :: Info] Tick %ld/%d - Viewability Count %ld/%d", (long)_ticks, VIDEO_VIEWABILITY_COUNT, (long)_viewabilityCount, VIDEO_VIEWABILITY_COUNT);
    }
}

@end
