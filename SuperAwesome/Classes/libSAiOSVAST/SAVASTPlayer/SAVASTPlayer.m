//
//  SAVASTPlayer.m
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 12/15/2015.
//
//

// import header
#import "SAVASTPlayer.h"

// import AVPlayer
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

// import chrome views
#import "SABlackMask.h"
#import "SACronograph.h"
#import "SAURLClicker.h"

@interface SAVASTPlayer () <AVPlayerItemMetadataOutputPushDelegate>

// the av player
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayerItem *playerItem;

// observers
@property (nonatomic, strong) NSObject *observer;

// additional values
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, assign) NSInteger currentTime;
// time events elements
@property (nonatomic, assign) NSInteger startTime;
@property (nonatomic, assign) NSInteger firstQuartileTime;
@property (nonatomic, assign) NSInteger midpointTime;
@property (nonatomic, assign) NSInteger thirdQuartileTime;
@property (nonatomic, assign) NSInteger completeTime;

// event done booleans
@property (nonatomic, assign) BOOL isStartHandled;
@property (nonatomic, assign) BOOL isFirstQuartileHandled;
@property (nonatomic, assign) BOOL isMidpointHandled;
@property (nonatomic, assign) BOOL isThirdQuartileHandled;
@property (nonatomic, assign) BOOL isSkipHandled;
@property (nonatomic, assign) BOOL isErrorHandled;

// chrome elememnts
@property (nonatomic, strong) SABlackMask *mask;
@property (nonatomic, strong) SACronograph *chrono;
@property (nonatomic, strong) SAURLClicker *clicker;

// other aux vars
@property (nonatomic, strong) NSNotificationCenter *notif;

// the click
@property (nonatomic, strong) NSString *clickURL;

@end

@implementation SAVASTPlayer

//
// @brief: Custom init functions
- (id) init {
    if (self = [super init]) {
        [self setup];
    }
    
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    
    return self;
}

- (id) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    
    return self;
}

- (void) setup {
    self.backgroundColor = [UIColor blackColor];
    _notif = [NSNotificationCenter defaultCenter];
    [self resetChecks];
}

//
// @brief: presetup function
- (void) resetChecks {
    _isStartHandled =
    _isFirstQuartileHandled =
    _isMidpointHandled =
    _isThirdQuartileHandled =
    _isErrorHandled =
    _isSkipHandled = false;
}

//
// @brief: Main function that starts playing the VAST URl
- (void) playWithMediaURL:(NSURL *)url {
    // init the player
    _player = [AVPlayer playerWithURL:url];
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    _playerLayer.frame = self.bounds;
    [self.layer addSublayer:_playerLayer];
    [_player seekToTime:kCMTimeZero];
    [_player play];
    
    // setup current item as well
    _playerItem = _player.currentItem;
    
    // add observer for _playerItem for the status - to monitor how much
    // of the movie has played
    [_playerItem addObserver:self forKeyPath:@"status" options:0 context:nil];
    
    // add an observer for _playerItem to monitor when it actually ends
    [_notif addObserver:self
               selector:@selector(itemDidFinishPlaying:)
                   name:AVPlayerItemDidPlayToEndTimeNotification
                 object:_playerItem];
    
    // observer check if we're going to background
    [_notif addObserver:self
               selector:@selector(didEnterBackground)
                   name:UIApplicationDidEnterBackgroundNotification
                 object:nil];
    
    // observer checks if we're back from the background
    [_notif addObserver:self
               selector:@selector(willEnterForeground)
                   name:UIApplicationWillEnterForegroundNotification
                 object:nil];

    // setup mask
    _mask = [[SABlackMask alloc] init];
    [self addSubview:_mask];
    
    // setup the chronograph
    _chrono = [[SACronograph alloc] init];
    [self addSubview:_chrono];
    
    _clicker = [[SAURLClicker alloc] init];
    [_clicker addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_clicker];
}

- (void) resetPlayer {
    // reset bools
    [self resetChecks];
    
    // stop the player
    if (_player){
        [_player pause];
        [_playerLayer removeFromSuperlayer];
        _player = NULL;
    }
    
    // remove chrome
    [_chrono removeFromSuperview];
    [_clicker removeTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [_clicker removeFromSuperview];
    
    // remove _playerItem observer
    @try {
        [_playerItem removeObserver:self forKeyPath:@"status"];
    } @catch(id anException){
        // do nothing
    }
    
    // remove notif center observer
    [_notif removeObserver:self
                      name:AVPlayerItemDidPlayToEndTimeNotification
                    object:_playerItem];
    [_notif removeObserver:self
                      name:UIApplicationDidEnterBackgroundNotification
                    object:nil];
    [_notif removeObserver:self
                name:UIApplicationWillEnterForegroundNotification
                    object:nil];
}

- (void) didEnterBackground {
    [_player pause];
}

- (void) willEnterForeground {
    [_player play];
}

- (void) updateToFrame:(CGRect)frame {
    self.frame = frame;
    _playerLayer.frame = frame;
    
    // remove chrome
    [_mask removeFromSuperview];
    [_chrono removeFromSuperview];
    [_clicker removeTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [_clicker removeFromSuperview];
    
    // setup the mask
    _mask = [[SABlackMask alloc] init];
    [self addSubview:_mask];
    
    // setup the chronograph
    _chrono = [[SACronograph alloc] init];
    [self addSubview:_chrono];
    
    _clicker = [[SAURLClicker alloc] init];
    [_clicker addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_clicker];
}

//
// @brief: handle the player status - mainly to init duration and time management
- (void) observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary*)change
                        context:(void *)context {
    
    // check KVO params
    if (object == _playerItem && [keyPath isEqualToString:@"status"]) {
        
        // if the player sais it's ready, go ahead
        if (_playerItem.status == AVPlayerStatusReadyToPlay) {
            
#pragma mark SEND_AA_EVENT_READY
            if (_delegate && [_delegate respondsToSelector:@selector(didFindPlayerReady)]) {
                [_delegate didFindPlayerReady];
            }
            
            // calculate time values
            _duration = (NSInteger)(CMTimeGetSeconds(_playerItem.asset.duration));
            _startTime = 0;
            _firstQuartileTime = (NSInteger)(_duration / 4);
            _midpointTime = (NSInteger)(_duration / 2);
            _thirdQuartileTime = (NSInteger)(3 * _duration / 4);
            _completeTime = _duration;
            
            _currentTime = (NSInteger)(CMTimeGetSeconds(_playerItem.currentTime));
            
            // setup the chrono
            [_chrono setTime:_currentTime andMax:_duration];
            
            // weak self so I don't have a retain cycle in the block
            __weak typeof (self) weakSelf = self;
            
            _observer = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 2) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
                
                // update current time
                weakSelf.currentTime = CMTimeGetSeconds(time);
                
                // each tick update chrono
                [weakSelf.chrono setTime:weakSelf.currentTime andMax:weakSelf.duration];
                
#pragma mark SEND_AA_TIME_EVENTS
                if (weakSelf.currentTime >= 1 && !weakSelf.isStartHandled) {
                    weakSelf.isStartHandled = true;
                    
                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didStartPlayer)]) {
                        [weakSelf.delegate didStartPlayer];
                    }
                };
                
                if (weakSelf.currentTime >= weakSelf.firstQuartileTime && !weakSelf.isFirstQuartileHandled){
                    weakSelf.isFirstQuartileHandled = true;
                    
                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didReachFirstQuartile)]) {
                        [weakSelf.delegate didReachFirstQuartile];
                    }
                    
                }
                
                if (weakSelf.currentTime >= weakSelf.midpointTime && !weakSelf.isMidpointHandled){
                    weakSelf.isMidpointHandled = true;
                    
                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didReachMidpoint)]) {
                        [weakSelf.delegate didReachMidpoint];
                    }
                }
                
                if (weakSelf.currentTime >= weakSelf.thirdQuartileTime && !weakSelf.isThirdQuartileHandled) {
                    weakSelf.isThirdQuartileHandled = true;
                    
                    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didReachThirdQuartile)]) {
                        [weakSelf.delegate didReachThirdQuartile];
                    }
                }
            }];
            
        }
        // handle error events
        else if (_playerItem.status == AVPlayerStatusFailed || _player.status == AVPlayerStatusUnknown) {
#pragma mark SEND_AA_ERROR_EVENT
            if (_delegate && [_delegate respondsToSelector:@selector(didPlayWithError)]) {
                [_delegate didPlayWithError];
            }
        }
    }
}

//
// @brief: finished notification
- (void) itemDidFinishPlaying:(NSNotification *) notification {
#pragma mark SEND_AA_FINISH_MOVIE_EVENT
    if (_delegate && [_delegate respondsToSelector:@selector(didReachEnd)] ) {
        [_delegate didReachEnd];
    }
}

- (void) setupClickURL:(NSString *)url {
    _clickURL = url;
}

- (IBAction) onClick: (id) sender {
    // call click delegate
    if (_delegate && [_delegate respondsToSelector:@selector(didGoToURL:)]) {
        [_delegate didGoToURL:[NSURL URLWithString:_clickURL]];
    }
}

//
// @brief: in this at dealloc I have to remove the observer
- (void) dealloc {
    // remove _playerItem observer
    @try {
        [_playerItem removeObserver:self forKeyPath:@"status"];
    } @catch(id anException){
        // do nothing
    }
    
    // remove notif center observer
    [_notif removeObserver:self
                      name:AVPlayerItemDidPlayToEndTimeNotification
                    object:_playerItem];
    // remove foreground & background observers
    [_notif removeObserver:self
                      name:UIApplicationDidEnterBackgroundNotification
                    object:nil];
    [_notif removeObserver:self
                      name:UIApplicationWillEnterForegroundNotification
                    object:nil];
}

@end
