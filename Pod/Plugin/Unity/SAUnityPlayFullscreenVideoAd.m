////
////  SAUnityPlayFullscreenVideoAd.m
////  Pods
////
////  Created by Gabriel Coman on 13/05/2016.
////
////
//
//#import "SAUnityPlayFullscreenVideoAd.h"
//// import SA header
//#import "SuperAwesome.h"
//#import "SAUnityExtensionContext.h"
//#import "SAJsonParser.h"
//#import "SAAdParser.h"
//
//@interface SAUnityPlayFullscreenVideoAd () <SAAdProtocol>
//
//@property (nonatomic, strong) NSString *unityAd;
//@property (nonatomic, strong) NSString *adJson;
//@property (nonatomic, assign) NSInteger placementId;
//@property (nonatomic, assign) BOOL isTestingEnabled;
//@property (nonatomic, assign) BOOL isParentalGateEnabled;
//@property (nonatomic, assign) BOOL shouldShowCloseButton;
//@property (nonatomic, assign) BOOL shouldAutomaticallyCloseAtEnd;
//@property (nonatomic, assign) BOOL shouldShowSmallClickButton;
//@property (nonatomic, assign) BOOL shouldLockOrientation;
//@property (nonatomic, assign) NSUInteger lockOrientation;
//
//@end
//
//@implementation SAUnityPlayFullscreenVideoAd
//
//
//- (void) showVideoAdWith:(NSInteger)placementId
//               andAdJson:(NSString*)adJson
//            andUnityName:(NSString*)unityAd
//      andHasParentalGate:(BOOL)isParentalGateEnabled
//       andHasCloseButton:(BOOL)shouldShowCloseButton
//          andClosesAtEnd:(BOOL)shouldAutomaticallyCloseAtEnd
// andShouldShowSmallClick:(BOOL)shouldShowSmallClickButton
//           andShouldLock:(BOOL)shouldLockOrientation
//         lockOrientation:(NSUInteger)lockOrientation {
//    
//    // get parameters
//    _placementId = placementId;
//    _adJson = adJson;
//    _unityAd = unityAd;
//    _isParentalGateEnabled = isParentalGateEnabled;
//    _shouldShowCloseButton = shouldShowCloseButton;
//    _shouldAutomaticallyCloseAtEnd = shouldAutomaticallyCloseAtEnd;
//    _shouldShowSmallClickButton = shouldShowSmallClickButton;
//    _shouldLockOrientation = shouldLockOrientation;
//    _lockOrientation = lockOrientation;
//    
//    // form the ad
//    SAAd *parsedAd = [[SAAd alloc] initWithJsonString:_adJson];
//    
//    if (parsedAd != NULL) {
//        // create fvad
//        SAVideoAd *fvad = [[SAVideoAd alloc] init];
//        [fvad setAd:parsedAd];
//        
//        // parametrize
//        [fvad setIsParentalGateEnabled:_isParentalGateEnabled];
//        [fvad setShouldAutomaticallyCloseAtEnd:_shouldAutomaticallyCloseAtEnd];
//        [fvad setShouldShowCloseButton:_shouldShowCloseButton];
//        [fvad setLockOrientation:_lockOrientation];
//        [fvad setShouldLockOrientation:_shouldLockOrientation];
//        [fvad setShouldShowSmallClickButton:_shouldShowSmallClickButton];
//        
//        // set delegates
//        [fvad setAdDelegate:self];
//        
//        // get root vc, show fvad and then play it
//        UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
//        [root presentViewController:fvad animated:YES completion:^{
//            // play
//            [fvad play];
//            
//            // add "bad" as a key in the dictionary, under the Unity Ad name
//            [[SAUnityExtensionContext getInstance] setAd:fvad forKey:unityAd];
//        }];
//    } else {
//        if (super.adEvent){
//            super.adEvent(_unityAd, (int)placementId, @"callback_adFailedToShow");
//        }
//    }
//    
//}
//
//- (void) closeFullscreenVideoForUnityName:(NSString *)unityAd {
//    NSObject * temp = [[SAUnityExtensionContext getInstance] getAdForKey:unityAd];
//    if (temp != NULL){
//        if ([temp isKindOfClass:[SAVideoAd class]]){
//            SAVideoAd *fvad = (SAVideoAd*)temp;
//            [fvad close];
//        }
//    }
//}
//
//#pragma mark <SAAdProtocol Implementations>
//
//- (void) adWasShown:(NSInteger)placementId {
//    if (super.adEvent){
//        super.adEvent(_unityAd, (int)placementId, @"callback_adWasShown");
//    }
//}
//
//- (void) adFailedToShow:(NSInteger)placementId {
//    
//    [[SAUnityExtensionContext getInstance] removeAd:placementId];
//    
//    if (super.adEvent){
//        super.adEvent(_unityAd, (int)placementId, @"callback_adFailedToShow");
//    }
//}
//
//- (void) adWasClosed:(NSInteger)placementId {
//    
//    
//    [[SAUnityExtensionContext getInstance] removeAd:placementId];
//    
//    if (super.adEvent){
//        super.adEvent(_unityAd, (int)placementId, @"callback_adWasClosed");
//    }
//}
//
//- (void) adWasClicked:(NSInteger)placementId{
//    if (super.adEvent){
//        super.adEvent(_unityAd, (int)placementId, @"callback_adWasClicked");
//    }
//}
//
//- (void) adHasIncorrectPlacement:(NSInteger)placementId {
//    if (super.adEvent){
//        super.adEvent(_unityAd, (int)placementId, @"callback_adHasIncorrectPlacement");
//    }
//}
//
//#pragma mark <SAParentalGateProtocol Implementations>
//
//- (void) parentalGateWasCanceled:(NSInteger)placementId {
//    if (super.adEvent){
//        super.adEvent(_unityAd, (int)placementId, @"callback_parentalGateWasCanceled");
//    }
//}
//
//- (void) parentalGateWasFailed:(NSInteger)placementId {
//    if (super.adEvent){
//        super.adEvent(_unityAd, (int)placementId, @"callback_parentalGateWasFailed");
//    }
//}
//
//- (void) parentalGateWasSucceded:(NSInteger)placementId {
//    if (super.adEvent){
//        super.adEvent(_unityAd, (int)placementId, @"callback_parentalGateWasSucceded");
//    }
//}
//
//#pragma mark <SAVideoAdProtocol Implementations>
//
//- (void) adStarted:(NSInteger)placementId {
//    if (super.adEvent){
//        super.adEvent(_unityAd, (int)placementId, @"callback_adStarted");
//    }
//}
//
//- (void) videoStarted:(NSInteger)placementId {
//    if (super.adEvent){
//        super.adEvent(_unityAd, (int)placementId, @"callback_videoStarted");
//    }
//}
//
//- (void) videoReachedFirstQuartile:(NSInteger)placementId {
//    if (super.adEvent){
//        super.adEvent(_unityAd, (int)placementId, @"callback_videoReachedFirstQuartile");
//    }
//}
//
//- (void) videoReachedMidpoint:(NSInteger)placementId {
//    if (super.adEvent){
//        super.adEvent(_unityAd, (int)placementId, @"callback_videoReachedMidpoint");
//    }
//}
//
//- (void) videoReachedThirdQuartile:(NSInteger)placementId {
//    if (super.adEvent){
//        super.adEvent(_unityAd, (int)placementId, @"callback_videoReachedThirdQuartile");
//    }
//}
//
//- (void) videoEnded:(NSInteger)placementId {
//    if (super.adEvent){
//        super.adEvent(_unityAd, (int)placementId, @"callback_videoEnded");
//    }
//}
//
//- (void) adEnded:(NSInteger)placementId {
//    if (super.adEvent){
//        super.adEvent(_unityAd, (int)placementId, @"callback_adEnded");
//    }
//}
//
//- (void) allAdsEnded:(NSInteger)placementId {
//    if (super.adEvent){
//        super.adEvent(_unityAd, (int)placementId, @"callback_allAdsEnded");
//    }
//}
//
//@end
