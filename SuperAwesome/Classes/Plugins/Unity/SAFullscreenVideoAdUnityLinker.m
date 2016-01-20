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
        NSLog(@"[iOS] Ad data not valid");
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
                NSLog(@"[iOS] Ad data not valid");
            }
        }];
    }
}

#pragma mark <Delegate Implementations>

- (void) adWasShown:(NSInteger)placementId {
    if (_adWasShownBlock){
        _adWasShownBlock(_unityAd, placementId);
    }
}

- (void) adFailedToShow:(NSInteger)placementId {
    if (_adFailedToShowBlock) {
        _adFailedToShowBlock(_unityAd, placementId);
    }
}

- (void) adWasClosed:(NSInteger)placementId {
    if (_adWasClosedBlock) {
        _adWasClosedBlock(_unityAd, placementId);
    }
}

- (void) adWasClicked:(NSInteger)placementId{
    if (_adWasClickedBlock) {
        _adWasClickedBlock(_unityAd, placementId);
    }
}

- (void) adHasIncorrectPlacement:(NSInteger)placementId {
    if (_adHasIncorrectPlacementBlock) {
        _adHasIncorrectPlacementBlock(_unityAd, placementId);
    }
}

- (void) parentalGateWasCanceled:(NSInteger)placementId {
    if (_parentalGateWasCanceledBlock) {
        _parentalGateWasCanceledBlock (_unityAd, placementId);
    }
}

- (void) parentalGateWasFailed:(NSInteger)placementId {
    if (_parentalGateWasFailedBlock) {
        _parentalGateWasFailedBlock(_unityAd, placementId);
    }
}

- (void) parentalGateWasSucceded:(NSInteger)placementId {
    if (_parentalGateWasSuccededBlock) {
        _parentalGateWasSuccededBlock(_unityAd, placementId);
    }
}

- (void) adStarted:(NSInteger)placementId {
    if (_adStartedBlock) {
        _adStartedBlock(_unityAd, placementId);
    }
}

- (void) videoStarted:(NSInteger)placementId {
    if (_videoStartedBlock) {
        _videoStartedBlock(_unityAd, placementId);
    }
}

- (void) videoReachedFirstQuartile:(NSInteger)placementId {
    if (_videoReachedFirstQuartileBlock) {
        _videoReachedFirstQuartileBlock(_unityAd, placementId);
    }
}

- (void) videoReachedMidpoint:(NSInteger)placementId {
    if (_videoReachedMidpointBlock) {
        _videoReachedMidpointBlock (_unityAd, placementId);
    }
}

- (void) videoReachedThirdQuartile:(NSInteger)placementId {
    if (_videoReachedThirdQuartileBlock) {
        _videoReachedThirdQuartileBlock(_unityAd, placementId);
    }
}

- (void) videoEnded:(NSInteger)placementId {
    if (_videoEndedBlock) {
        _videoEndedBlock(_unityAd, placementId);
    }
}

- (void) adEnded:(NSInteger)placementId {
    if (_adEndedBlock) {
        _adEndedBlock(_unityAd, placementId);
    }
}

- (void) allAdsEnded:(NSInteger)placementId {
    if (_allAdsEndedBlock) {
        _allAdsEndedBlock(_unityAd, placementId);
    }
}

@end
