//
//  SAUnityPlayInterstitialAd.m
//  Pods
//
//  Created by Gabriel Coman on 13/05/2016.
//
//

#import "SAUnityPlayInterstitialAd.h"
// import SA header
#import "SuperAwesome.h"
#import "SAUnityExtensionContext.h"
#import "NSObject+ModelToString.h"
#import "SAParser.h"

@interface SAUnityPlayInterstitialAd () <SAAdProtocol, SAParentalGateProtocol>

@property (nonatomic, strong) NSString *unityAd;
@property (nonatomic, strong) NSString *adJson;
@property (nonatomic, assign) NSInteger placementId;
@property (nonatomic, assign) BOOL isTestingEnabled;
@property (nonatomic, assign) BOOL isParentalGateEnabled;

@end

@implementation SAUnityPlayInterstitialAd

- (void) showInterstitialAdWith:(NSInteger)placementId
                      andAdJson:(NSString *)adJson
                   andUnityName:(NSString *)unityAd
             andHasParentalGate:(BOOL)isParentalGateEnabled {
    
    // get data
    _placementId = placementId;
    _adJson = adJson;
    _unityAd = unityAd;
    _isParentalGateEnabled = isParentalGateEnabled;
    
    // form new ad
    SAParser *parser = [[SAParser alloc] init];
    SAAd *parsedAd = [parser parseAdFromExistingString:adJson];
    
    if (parsedAd != NULL) {
        // create fvad
        SAInterstitialAd *iad = [[SAInterstitialAd alloc] init];
        [iad setAd:parsedAd];
        
        // parametrize
        [iad setIsParentalGateEnabled:_isParentalGateEnabled];
        
        // set delegates
        [iad setAdDelegate:self];
        [iad setParentalGateDelegate:self];
        
        // get root vc, show fvad and then play it
        UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
        [root presentViewController:iad animated:YES completion:^{
            // add "bad" as a key in the dictionary, under the Unity Ad name
            [[SAUnityExtensionContext getInstance] setAd:iad forKey:unityAd];
            
            // play
            [iad play];
        }];
    } else {
        if (_adEvent){
            _adEvent(_unityAd, (int)placementId, @"callback_adFailedToShow");
        }
    }
}

- (void) closeInterstitialForUnityName:(NSString *)unityAd {
    NSObject * temp = [[SAUnityExtensionContext getInstance] getAdForKey:unityAd];
    if (temp != NULL) {
        if ([temp isKindOfClass:[SAInterstitialAd class]]){
            SAInterstitialAd *iad = (SAInterstitialAd*)temp;
            [iad close];
        }
    }
}

#pragma mark <SAAdProtocol Implementations>

- (void) adWasShown:(NSInteger)placementId {
    if (_adEvent){
        _adEvent(_unityAd, (int)placementId, @"callback_adWasShown");
    }
}

- (void) adFailedToShow:(NSInteger)placementId {
    
    [[SAUnityExtensionContext getInstance] removeAd:placementId];
    
    if (_adEvent){
        _adEvent(_unityAd, (int)placementId, @"callback_adFailedToShow");
    }
}

- (void) adWasClosed:(NSInteger)placementId {
    
    
    [[SAUnityExtensionContext getInstance] removeAd:placementId];
    
    if (_adEvent){
        _adEvent(_unityAd, (int)placementId, @"callback_adWasClosed");
    }
}

- (void) adWasClicked:(NSInteger)placementId{
    if (_adEvent){
        _adEvent(_unityAd, (int)placementId, @"callback_adWasClicked");
    }
}

- (void) adHasIncorrectPlacement:(NSInteger)placementId {
    if (_adEvent){
        _adEvent(_unityAd, (int)placementId, @"callback_adHasIncorrectPlacement");
    }
}

#pragma mark <SAParentalGateProtocol Implementations>

- (void) parentalGateWasCanceled:(NSInteger)placementId {
    if (_adEvent){
        _adEvent(_unityAd, (int)placementId, @"callback_parentalGateWasCanceled");
    }
}

- (void) parentalGateWasFailed:(NSInteger)placementId {
    if (_adEvent){
        _adEvent(_unityAd, (int)placementId, @"callback_parentalGateWasFailed");
    }
}

- (void) parentalGateWasSucceded:(NSInteger)placementId {
    if (_adEvent){
        _adEvent(_unityAd, (int)placementId, @"callback_parentalGateWasSucceded");
    }
}

@end
