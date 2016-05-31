//
//  SAUnityLoadAd.m
//  Pods
//
//  Created by Gabriel Coman on 13/05/2016.
//
//

#import "SAUnityLoadAd.h"
// import SA header
#import "SALoader.h"
#import "SAUnityExtensionContext.h"
#import "SAJsonParser.h"

@interface SAUnityLoadAd () <SALoaderProtocol>

@property (nonatomic, strong) NSString *unityAd;
@property (nonatomic, strong) NSString *adJson;
@property (nonatomic, assign) NSInteger placementId;
@property (nonatomic, assign) BOOL isTestingEnabled;

@end

@implementation SAUnityLoadAd

- (void) loadAd:(NSInteger)placementId
     forUnityAd:(NSString *)unityAd
   withTestMode:(BOOL)isTestEnabled {
    
    // get external vars
    _unityAd = unityAd;
    _isTestingEnabled = isTestEnabled;
    
    // enable or disable test mode
    [[SuperAwesome getInstance] setTesting:_isTestingEnabled];
    
    // start loading
    SALoader *loader = [[SALoader alloc] init];
    loader.delegate = self;
    [loader loadAdForPlacementId:placementId];
}

#pragma mark <SALoaderProtocol Implementations>

- (void) didLoadAd:(SAAd *)ad {
    NSLog(@"Sending didLoadAd to %@", _unityAd);
    if (super.loadingEvent) {
        super.loadingEvent(_unityAd, (int)ad.placementId, @"callback_didLoadAd", [ad jsonCompactStringRepresentation]);
    }
}

- (void) didFailToLoadAdForPlacementId:(NSInteger)placementId {
    
    NSLog(@"Sending didFailToLoadAdForPlacementId to %@", _unityAd);
    
    if (super.loadingEvent) {
        super.loadingEvent(_unityAd, (int)placementId, @"callback_didFailToLoadAd",@"");
    }
}

@end
