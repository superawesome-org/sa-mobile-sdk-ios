//
//  SALoaderUnityLinker.m
//  Pods
//
//  Created by Gabriel Coman on 18/01/2016.
//
//

#import "SALoaderUnityLinker.h"
#import "SuperAwesome.h"
#import "SALoader.h"

@interface SALoaderUnityLinker () <SALoaderProtocol>

// internal function pointers to code-blocks
@property (nonatomic, assign) successEvent internalSuccess;
@property (nonatomic, assign) errorEvent internalError;

// internal unity ad name
@property (nonatomic, strong) NSString *unityAdName;

@end

@implementation SALoaderUnityLinker

- (void) loadAd:(NSInteger)placementId
     forUnityAd:(NSString *)unityAd
   withTestMode:(BOOL)isTestEnabled
     andSuccess:(successEvent)success
       andError:(errorEvent)error {
    
    // get external vars
    _unityAdName = unityAd;
    _internalSuccess = success;
    _internalError = error;
    
    // enable or disable test mode
    if (isTestEnabled) {
        [[SuperAwesome getInstance] enableTestMode];
    } else {
        [[SuperAwesome getInstance] disableTestMode];
    }
    
    // start loading
    [SALoader setDelegate:self];
    [SALoader loadAdForPlacementId:placementId];
}

- (void) didLoadAd:(SAAd *)ad {
    if (_internalSuccess != NULL) {
        _internalSuccess(_unityAdName, ad.adJson);
    }
}

- (void) didFailToLoadAdForPlacementId:(NSInteger)placementId {
    if (_internalError) {
        _internalError(_unityAdName, placementId);
    }
}

@end
