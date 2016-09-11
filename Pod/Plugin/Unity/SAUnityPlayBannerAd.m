////
////  SAUnityPlayBannerAd.m
////  Pods
////
////  Created by Gabriel Coman on 13/05/2016.
////
////
//
//#import "SAUnityPlayBannerAd.h"
//// import SA header
//#import "SuperAwesome.h"
//#import "SAUnityExtensionContext.h"
//#import "SAJsonParser.h"
//#import "SAAdParser.h"
//
//@interface SAUnityPlayBannerAd () <SAAdProtocol>
//
//@property (nonatomic, strong) NSString *unityAd;
//@property (nonatomic, strong) NSString *adJson;
//@property (nonatomic, assign) NSInteger placementId;
//@property (nonatomic, assign) BOOL isTestingEnabled;
//@property (nonatomic, assign) BOOL isParentalGateEnabled;
//@property (nonatomic, assign) NSInteger position;
//@property (nonatomic, assign) NSInteger size;
//
//@end
//
//@implementation SAUnityPlayBannerAd
//
//- (void) showBannerAdWith:(NSInteger)placementId
//                andAdJson:(NSString*)adJson
//             andUnityName:(NSString*)unityAd
//              andPosition:(NSInteger)position
//                  andSize:(NSInteger)size
//                 andColor:(NSInteger)color
//       andHasParentalGate:(BOOL)isParentalGateEnable {
//    
//    // get data
//    _placementId = placementId;
//    _adJson = adJson;
//    _unityAd = unityAd;
//    _position = position;
//    _size = size;
//    _isParentalGateEnabled = isParentalGateEnable;
//    
//    // form new ad
//    SAAd *parsedAd = [[SAAd alloc] initWithJsonString:_adJson];
//    
//    if (parsedAd != NULL) {
//        // get root vc, show fvad and then play it
//        UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
//        
//        // calculate the size of the ad
//        __block CGSize realSize = CGSizeZero;
//        if (size == 1) realSize = CGSizeMake(300, 50);
//        else if (size == 2) realSize = CGSizeMake(728, 90);
//        else if (size == 3) realSize = CGSizeMake(300, 250);
//        else realSize = CGSizeMake(320, 50);
//        
//        __block CGSize screen = [UIScreen mainScreen].bounds.size;
//        
//        if (realSize.width > screen.width) {
//            realSize.height = (screen.width * realSize.height) / realSize.width;
//            realSize.width = screen.width;
//        }
//        
//        // calculate the position of the ad
//        __block CGPoint realPos = CGPointZero;
//        if (position == 0) realPos = CGPointMake((screen.width - realSize.width) / 2.0f, 0);
//        else realPos = CGPointMake((screen.width - realSize.width) / 2.0f, screen.height - realSize.height);
//        
//        // init the banner
//        SABannerAd *bad = [[SABannerAd alloc] initWithFrame:CGRectMake(realPos.x, realPos.y, realSize.width, realSize.height)];
//        [bad setAd:parsedAd];
//        [bad setIsParentalGateEnabled:_isParentalGateEnabled];
//        [bad setAdDelegate:self];
//        
//        if (color == 0){
//            bad.backgroundColor = [UIColor clearColor];
//        } else {
//            bad.backgroundColor = [UIColor colorWithRed:191.0/255.0f green:191.0/255.0f blue:191.0/255.0f alpha:1];
//        }
//        
//        // add the banner to the topmost root
//        [root.view addSubview:bad];
//        [bad play];
//
//        // add "bad" as a key in the dictionary, under the Unity Ad name
//        [[SAUnityExtensionContext getInstance] setAd:bad forKey:unityAd];
//        
//        // add a block notification
//        [[NSNotificationCenter defaultCenter] addObserverForName:@"UIDeviceOrientationDidChangeNotification"
//                                                          object:nil
//                                                           queue:nil
//                                                      usingBlock:
//         ^(NSNotification * note) {
//             screen = [UIScreen mainScreen].bounds.size;
//             
//             if (size == 1) realSize = CGSizeMake(300, 50);
//             else if (size == 2) realSize = CGSizeMake(728, 90);
//             else if (size == 3) realSize = CGSizeMake(300, 250);
//             else realSize = CGSizeMake(320, 50);
//             
//             if (realSize.width > screen.width) {
//                 realSize.height = (screen.width * realSize.height) / realSize.width;
//                 realSize.width = screen.width;
//             }
//             
//             if (position == 0) realPos = CGPointMake((screen.width - realSize.width) / 2.0f, 0);
//             else realPos = CGPointMake((screen.width - realSize.width) / 2.0f, screen.height - realSize.height);
//             
//             [bad resizeToFrame:CGRectMake(realPos.x, realPos.y, realSize.width, realSize.height)];
//         }];
//    } else {
//        if (super.adEvent){
//            super.adEvent(_unityAd, (int)placementId, @"callback_adFailedToShow");
//        }
//    }
//}
//
//- (void) removeBannerForUnityName:(NSString *)unityAd {
//    NSObject * temp = [[SAUnityExtensionContext getInstance] getAdForKey:unityAd];
//    if (temp != NULL){
//        if ([temp isKindOfClass:[SABannerAd class]]){
//            SABannerAd *bad = (SABannerAd*)temp;
//            [bad removeFromSuperview];
//            bad = NULL;
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
//@end
