//
//  SAUnityLinker.m
//  Pods
//
//  Created by Gabriel Coman on 13/01/2016.
//
//

#import "SAUnityLinker.h"

#import "SuperAwesome.h"
#import "SALoader.h"
#import "SAFullscreenVideoAd.h"

@interface SAUnityLinker () <SALoaderProtocol>

// private vars
@property (nonatomic, assign) linkSuccess successBlock;
@property (nonatomic, assign) linkError errorBlock;
@property (nonatomic, assign) BOOL hasGate;

@end

@implementation SAUnityLinker

- (void) startVideoAd:(int)placementId
             withGate:(BOOL)hasGate
           inTestMode:(BOOL)testMode
          withSuccess:(linkSuccess)success
               orFail:(linkError)error
{
    
    // assign success or error blocks
    _successBlock = success;
    _errorBlock = error;
    _hasGate = hasGate;
    
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

- (void) didLoadAd:(SAAd *)ad {
    // create fvad
    SAFullscreenVideoAd *fvad = [[SAFullscreenVideoAd alloc] init];
    [fvad setAd:ad];
    [fvad setIsParentalGateEnabled:_hasGate];
    
    // get root vc
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    [root presentViewController:fvad animated:YES completion:^{
        [fvad play];
        
        if (_successBlock != NULL){
            _successBlock(ad);
        }
    }];
}

- (void) didFailToLoadAdForPlacementId:(NSInteger)placementId {
    if (_errorBlock != NULL){
        _errorBlock(placementId);
    }
}

@end
