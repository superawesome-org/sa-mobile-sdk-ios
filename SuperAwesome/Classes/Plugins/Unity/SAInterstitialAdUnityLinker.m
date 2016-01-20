//
//  SAInterstitialAdUnityLinker.m
//  Pods
//
//  Created by Gabriel Coman on 20/01/2016.
//
//

#import "SAInterstitialAdUnityLinker.h"

// import SuperAwesome
#import "SuperAwesome.h"

// import other headers
#import "SAParser.h"
#import "SAValidator.h"
#import "SAFullscreenVideoAd.h"

@interface SAInterstitialAdUnityLinker () <SAAdProtocol, SAParentalGateProtocol>

// parameters
@property (nonatomic, strong) NSString *unityAd;
@property (nonatomic, strong) NSString *adJson;
@property (nonatomic, assign) NSInteger placementId;
@property (nonatomic, assign) BOOL isParentalGateEnabled;

@end

@implementation SAInterstitialAdUnityLinker

- (void) startWithPlacementId:(NSInteger)placementId
                    andAdJson:(NSString *)adJson
                 andUnityName:(NSString *)unityAd
           andHasParentalGate:(BOOL)isParentalGateEnabled {
    
    _placementId = placementId;
    _adJson = adJson;
    _unityAd = unityAd;
    _isParentalGateEnabled = isParentalGateEnabled;
    
    // We're assuming the NSData is actually a JSON in string format,
    // so the next step is to parse it
    NSError *jsonError;
    NSData *data = [_adJson dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
    
    // check to see if the json Unity send is still OK
    if (jsonError) {
        if (_event){
            _event(_unityAd, @"callback_adFailedToShow");
        }
    } else {
        [SAParser parseDictionary:json withPlacementId:_placementId intoAd:^(SAAd *parsedAd) {
            
            BOOL isValid = [SAValidator isAdDataValid:parsedAd];
            
            if (isValid) {
                
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
                    [iad play];
                }];
            }
            // if data is not valid
            else {
                if (_event){
                    _event(_unityAd, @"callback_adFailedToShow");
                }
            }
        }];
    }
}

#pragma mark <Delegate Implementations>

- (void) adWasShown:(NSInteger)placementId {
    if (_event){
        _event(_unityAd, @"callback_adWasShown");
    }
}

- (void) adFailedToShow:(NSInteger)placementId {
    if (_event){
        _event(_unityAd, @"callback_adFailedToShow");
    }
}

- (void) adWasClosed:(NSInteger)placementId {
    if (_event){
        _event(_unityAd, @"callback_adWasClosed");
    }
}

- (void) adWasClicked:(NSInteger)placementId{
    if (_event){
        _event(_unityAd, @"callback_adWasClicked");
    }
}

- (void) adHasIncorrectPlacement:(NSInteger)placementId {
    if (_event){
        _event(_unityAd, @"callback_adHasIncorrectPlacement");
    }
}

- (void) parentalGateWasCanceled:(NSInteger)placementId {
    if (_event){
        _event(_unityAd, @"callback_parentalGateWasCanceled");
    }
}

- (void) parentalGateWasFailed:(NSInteger)placementId {
    if (_event){
        _event(_unityAd, @"callback_parentalGateWasFailed");
    }
}

- (void) parentalGateWasSucceded:(NSInteger)placementId {
    if (_event){
        _event(_unityAd, @"callback_parentalGateWasSucceded");
    }
}

@end
