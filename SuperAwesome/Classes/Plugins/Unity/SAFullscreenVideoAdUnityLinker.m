//
//  SAUnityLinker.m
//  Pods
//
//  Created by Gabriel Coman on 13/01/2016.
//
//

#import "SAFullscreenVideoAdUnityLinker.h"

// import SuperAwesome
#import "SuperAwesome.h"

// import other headers
#import "SAParser.h"
#import "SAValidator.h"
#import "SAFullscreenVideoAd.h"

@interface SAFullscreenVideoAdUnityLinker () <SAAdProtocol, SAParentalGateProtocol, SAVideoAdProtocol>

// parameters
@property (nonatomic, strong) NSString *unityAd;
@property (nonatomic, strong) NSString *adJson;
@property (nonatomic, assign) NSInteger placementId;
@property (nonatomic, assign) BOOL isParentalGateEnabled;
@property (nonatomic, assign) BOOL shouldShowCloseButton;
@property (nonatomic, assign) BOOL shouldAutomaticallyCloseAtEnd;

@end

@implementation SAFullscreenVideoAdUnityLinker

- (void) startWithPlacementId:(NSInteger)placementId
                    andAdJson:(NSString*)adJson
                 andUnityName:(NSString*)unityAd
           andHasParentalGate:(BOOL)isParentalGateEnabled
            andHasCloseButton:(BOOL)shouldShowCloseButton
               andClosesAtEnd:(BOOL)shouldAutomaticallyCloseAtEnd {
    
    _placementId = placementId;
    _adJson = adJson;
    _unityAd = unityAd;
    _isParentalGateEnabled = isParentalGateEnabled;
    _shouldShowCloseButton = shouldShowCloseButton;
    _shouldAutomaticallyCloseAtEnd = shouldAutomaticallyCloseAtEnd;
    
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
                SAFullscreenVideoAd *fvad = [[SAFullscreenVideoAd alloc] init];
                [fvad setAd:parsedAd];
                
                // parametrize
                [fvad setIsParentalGateEnabled:_isParentalGateEnabled];
                [fvad setShouldAutomaticallyCloseAtEnd:_shouldAutomaticallyCloseAtEnd];
                [fvad setShouldShowCloseButton:_shouldShowCloseButton];
                
                // set delegates
                [fvad setAdDelegate:self];
                [fvad setParentalGateDelegate:self];
                [fvad setVideoDelegate:self];
                
                // get root vc, show fvad and then play it
                UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
                [root presentViewController:fvad animated:YES completion:^{
                    [fvad play];
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

- (void) adStarted:(NSInteger)placementId {
    if (_event){
        _event(_unityAd, @"callback_adStarted");
    }
}

- (void) videoStarted:(NSInteger)placementId {
    if (_event){
        _event(_unityAd, @"callback_videoStarted");
    }
}

- (void) videoReachedFirstQuartile:(NSInteger)placementId {
    if (_event){
        _event(_unityAd, @"callback_videoReachedFirstQuartile");
    }
}

- (void) videoReachedMidpoint:(NSInteger)placementId {
    if (_event){
        _event(_unityAd, @"callback_videoReachedMidpoint");
    }
}

- (void) videoReachedThirdQuartile:(NSInteger)placementId {
    if (_event){
        _event(_unityAd, @"callback_videoReachedThirdQuartile");
    }
}

- (void) videoEnded:(NSInteger)placementId {
    if (_event){
        _event(_unityAd, @"callback_videoEnded");
    }
}

- (void) adEnded:(NSInteger)placementId {
    if (_event){
        _event(_unityAd, @"callback_adEnded");
    }
}

- (void) allAdsEnded:(NSInteger)placementId {
    if (_event){
        _event(_unityAd, @"callback_allAdsEnded");
    }
}

@end
