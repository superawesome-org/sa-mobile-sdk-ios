//
//  SAUnityLinker.m
//  Pods
//
//  Created by Gabriel Coman on 13/01/2016.
//
//

#import "SAFullscreenVideoAdUnityLinker.h"

#import "SuperAwesome.h"
#import "SALoader.h"
#import "SAFullscreenVideoAd.h"

@interface SAFullscreenVideoAdUnityLinker () <SALoaderProtocol, SAAdProtocol, SAVideoAdProtocol>

// block vars
@property (nonatomic, assign) adEvent adLoadBlock;
@property (nonatomic, assign) adEvent adFailBlock;
@property (nonatomic, assign) adEvent adStartBlock;
@property (nonatomic, assign) adEvent adStopBlock;
@property (nonatomic, assign) adEvent adFailBlockToPlayBlock;
@property (nonatomic, assign) adEvent adClickBlock;

// unity ad name
@property (nonatomic, assign) NSString *unityAdName;

// parametrizers
@property (nonatomic, assign) BOOL hasGate;
@property (nonatomic, assign) BOOL hasCloseBtn;
@property (nonatomic, assign) BOOL closesAtEnd;

@end

@implementation SAFullscreenVideoAdUnityLinker

- (void) startVideoAd:(int)placementId
         andUnityName:(NSString*)unityAdName
             withGate:(BOOL)hasGate
           inTestMode:(BOOL)testMode
       hasCloseButton:(BOOL)hasClose
       andClosesAtEnd:(BOOL)closesAtEnd
{
    
    // assign success or error blocks
    _unityAdName = unityAdName;
    _hasGate = hasGate;
    _hasCloseBtn = hasClose;
    _closesAtEnd = closesAtEnd;
    
    // enable or disable test mode
    if (testMode) {
        [[SuperAwesome getInstance] enableTestMode];
    } else {
        [[SuperAwesome getInstance] disableTestMode];
    }
    
    // start loading Ad
    [SALoader setDelegate:self];
    [SALoader loadAdForPlacementId:placementId];
}

- (void) addLoadVideoBlock:(adEvent)block {
    _adLoadBlock = block;
}

- (void) addFailToLoadVideoBlock:(adEvent)block {
    _adFailBlock = block;
}

- (void) addStartVideoBlock:(adEvent)block {
    _adStartBlock = block;
}

- (void) addStopVideoBlock:(adEvent)block {
    _adStopBlock = block;
}

- (void) addFailToPlayVideoBlock:(adEvent)block {
    _adFailBlock = block;
}

- (void) addClickVideoBlock:(adEvent)block {
    _adClickBlock = block;
}

- (void) didLoadAd:(SAAd *)ad {
    // create fvad
    SAFullscreenVideoAd *fvad = [[SAFullscreenVideoAd alloc] init];
    [fvad setAd:ad];
    
    // parametrize
    [fvad setIsParentalGateEnabled:_hasGate];
    [fvad setShouldAutomaticallyCloseAtEnd:_closesAtEnd];
    [fvad setShouldShowCloseButton:_hasCloseBtn];
    [fvad setAdDelegate:self];
    [fvad setVideoDelegate:self];
    
    // get root vc
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    [root presentViewController:fvad animated:YES completion:^{
        [fvad play];
    }];
    
    // call block
    if (_adLoadBlock){
        _adLoadBlock(_unityAdName);
    }
}

- (void) didFailToLoadAdForPlacementId:(NSInteger)placementId {
    if (_adFailBlock){
        _adFailBlock(_unityAdName);
    }
}

#pragma mark <SAAdProtocol>

- (void) adWasShown:(NSInteger)placementId {
    if (_adStartBlock){
        _adStartBlock(_unityAdName);
    }
}

- (void) adFailedToShow:(NSInteger)placementId {
    if (_adFailBlock){
        _adFailBlock(_unityAdName);
    }
}

- (void) adWasClosed:(NSInteger)placementId {
    if (_adStopBlock){
        _adStopBlock(_unityAdName);
    }
}

- (void) adWasClicked:(NSInteger)placementId {
    if (_adClickBlock){
        _adClickBlock(_unityAdName);
    }
}

- (void) adHasIncorrectPlacement:(NSInteger)placementId {
    if (_adFailBlock){
        _adFailBlock(_unityAdName);
    }
}

#pragma mark <SAVideoAdProtocol>

- (void) videoStarted:(NSInteger)placementId {
}

- (void) videoReachedFirstQuartile:(NSInteger)placementId {
}

- (void) videoReachedMidpoint:(NSInteger)placementId {
}

- (void) videoReachedThirdQuartile:(NSInteger)placementId {
}

- (void) videoEnded:(NSInteger)placementId {
}

@end
