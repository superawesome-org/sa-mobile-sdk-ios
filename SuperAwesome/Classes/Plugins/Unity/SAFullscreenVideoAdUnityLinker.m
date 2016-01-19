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

@interface SAFullscreenVideoAdUnityLinker () <SAAdProtocol, SAVideoAdProtocol>

// block vars
//@property (nonatomic, assign) adEvent adLoadBlock;
//@property (nonatomic, assign) adEvent adFailBlock;
//@property (nonatomic, assign) adEvent adStartBlock;
//@property (nonatomic, assign) adEvent adStopBlock;
//@property (nonatomic, assign) adEvent adFailBlockToPlayBlock;
//@property (nonatomic, assign) adEvent adClickBlock;

// parameters
@property (nonatomic, strong) NSString *unityAd;
@property (nonatomic, strong) NSString *adJson;
@property (nonatomic, assign) NSInteger placementId;
@property (nonatomic, assign) BOOL isParentalGateEnabled;
@property (nonatomic, assign) BOOL shouldShowCloseButton;
@property (nonatomic, assign) BOOL shouldAutomaticallyCloseAtEnd;

@end

@implementation SAFullscreenVideoAdUnityLinker

- (id) initWithPlacementId:(NSInteger)placementId
                 andAdJson:(NSString*)adJson
              andUnityName:(NSString*)unityAd
        andHasParentalGate:(BOOL)isParentalGateEnabled
         andHasCloseButton:(BOOL)shouldShowCloseButton
            andClosesAtEnd:(BOOL)shouldAutomaticallyCloseAtEnd {
    
    if (self = [super init]) {
        _placementId = placementId;
        _adJson = adJson;
        _unityAd = unityAd;
        _isParentalGateEnabled = isParentalGateEnabled;
        _shouldShowCloseButton = shouldShowCloseButton;
        _shouldAutomaticallyCloseAtEnd = shouldAutomaticallyCloseAtEnd;
    }
    
    return self;
}

- (void) start {
    
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
                [fvad setAdDelegate:self];
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

//- (void) addLoadVideoBlock:(adEvent)block {
//    _adLoadBlock = block;
//}
//
//- (void) addFailToLoadVideoBlock:(adEvent)block {
//    _adFailBlock = block;
//}
//
//- (void) addStartVideoBlock:(adEvent)block {
//    _adStartBlock = block;
//}
//
//- (void) addStopVideoBlock:(adEvent)block {
//    _adStopBlock = block;
//}
//
//- (void) addFailToPlayVideoBlock:(adEvent)block {
//    _adFailBlock = block;
//}
//
//- (void) addClickVideoBlock:(adEvent)block {
//    _adClickBlock = block;
//}

//- (void) didLoadAd:(SAAd *)ad {
//    // create fvad
//    SAFullscreenVideoAd *fvad = [[SAFullscreenVideoAd alloc] init];
//    [fvad setAd:ad];
//    
//    // parametrize
//    [fvad setIsParentalGateEnabled:_hasGate];
//    [fvad setShouldAutomaticallyCloseAtEnd:_closesAtEnd];
//    [fvad setShouldShowCloseButton:_hasCloseBtn];
//    [fvad setAdDelegate:self];
//    [fvad setVideoDelegate:self];
//    
//    // get root vc
//    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
//    [root presentViewController:fvad animated:YES completion:^{
//        [fvad play];
//    }];
////
////    // call block
////    if (_adLoadBlock){
////        _adLoadBlock(_unityAdName);
////    }
//}
//
//- (void) didFailToLoadAdForPlacementId:(NSInteger)placementId {
////    if (_adFailBlock){
////        _adFailBlock(_unityAdName);
////    }
//}

@end
