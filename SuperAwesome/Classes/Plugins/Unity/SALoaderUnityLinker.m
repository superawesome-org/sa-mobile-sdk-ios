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

// internal unity ad name
@property (nonatomic, strong) NSString *unityAdName;

@end

@implementation SALoaderUnityLinker

- (void) loadAd:(NSInteger)placementId
     forUnityAd:(NSString *)unityAd
   withTestMode:(BOOL)isTestEnabled {
    
    // get external vars
    _unityAdName = unityAd;
    
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
    if (_success != NULL) {
        _success(_unityAdName, ad.adJson);
    }
}

- (void) didFailToLoadAdForPlacementId:(NSInteger)placementId {
    if (_error) {
        _error(_unityAdName, placementId);
    }
}

@end
