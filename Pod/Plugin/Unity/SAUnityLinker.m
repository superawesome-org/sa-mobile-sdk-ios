//
//  SAUnityLinker.m
//  Pods
//
//  Created by Gabriel Coman on 21/01/2016.
//
//

#import "SAUnityLinker.h"

// import SA header
#import "SuperAwesome.h"
#import "SAUnityLinkerManager.h"

// import other needed headers
#import "SALoader.h"
#import "SAParser.h"
#import "SAFullscreenVideoAd.h"
#import "SAInterstitialAd.h"
#import "SABannerAd.h"

@interface SAUnityLinker () <SALoaderProtocol, SAAdProtocol, SAVideoAdProtocol, SAParentalGateProtocol>

@property (nonatomic, strong) NSString *unityAd;
@property (nonatomic, strong) NSString *adJson;
@property (nonatomic, assign) NSInteger placementId;
@property (nonatomic, assign) BOOL isTestingEnabled;
@property (nonatomic, assign) BOOL isParentalGateEnabled;
@property (nonatomic, assign) BOOL shouldShowCloseButton;
@property (nonatomic, assign) BOOL shouldAutomaticallyCloseAtEnd;
@property (nonatomic, assign) NSInteger position;
@property (nonatomic, assign) NSInteger size;

@end

@implementation SAUnityLinker

#pragma mark <Functions>

////////////////////////////////////////////////////////////
// This function does the loading of an Ad
////////////////////////////////////////////////////////////

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

////////////////////////////////////////////////////////////
// This function shows a Banner Ad
////////////////////////////////////////////////////////////
- (void) showBannerAdWith:(NSInteger)placementId
                andAdJson:(NSString*)adJson
             andUnityName:(NSString*)unityAd
              andPosition:(NSInteger)position
                  andSize:(NSInteger)size
                 andColor:(NSInteger)color
       andHasParentalGate:(BOOL)isParentalGateEnable {

    _placementId = placementId;
    _adJson = adJson;
    _unityAd = unityAd;
    _position = position;
    _size = size;
    _isParentalGateEnabled = isParentalGateEnable;

    // We're assuming the NSData is actually a JSON in string format,
    // so the next step is to parse it
    NSError *jsonError;
    NSData *data = [_adJson dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];

    // check to see if the json Unity send is still OK
    if (jsonError) {
        if (_adEvent){
            _adEvent(_unityAd, placementId, @"callback_adFailedToShow");
        }
    } else {
        // parse ad
        SAAd *parsedAd = [SAParser parseAdFromDictionary:json withPlacementId:_placementId];

        if (parsedAd) {

            // get root vc, show fvad and then play it
            UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;

            // calculate the size of the ad
            __block CGSize realSize = CGSizeZero;
            if (size == 1) realSize = CGSizeMake(300, 50);
            else if (size == 2) realSize = CGSizeMake(728, 90);
            else if (size == 3) realSize = CGSizeMake(300, 250);
            else realSize = CGSizeMake(320, 50);

            __block CGSize screen = [UIScreen mainScreen].bounds.size;

            if (realSize.width > screen.width) {
                realSize.height = (screen.width * realSize.height) / realSize.width;
                realSize.width = screen.width;
            }

            // calculate the position of the ad
            __block CGPoint realPos = CGPointZero;
            if (position == 0) realPos = CGPointMake((screen.width - realSize.width) / 2.0f, 0);
            else realPos = CGPointMake((screen.width - realSize.width) / 2.0f, screen.height - realSize.height);

            // init the banner
            SABannerAd *bad = [[SABannerAd alloc] initWithFrame:CGRectMake(realPos.x, realPos.y, realSize.width, realSize.height)];
            [bad setAd:parsedAd];
            [bad setIsParentalGateEnabled:_isParentalGateEnabled];
            [bad setParentalGateDelegate:self];
            [bad setAdDelegate:self];

            if (color == 0){
                bad.backgroundColor = [UIColor clearColor];
            } else {
                bad.backgroundColor = [UIColor colorWithRed:191.0/255.0f green:191.0/255.0f blue:191.0/255.0f alpha:1];
            }

            // add the banner to the topmost root
            [root.view addSubview:bad];
            [bad play];

            // add "bad" as a key in the dictionary, under the Unity Ad name
            [[SAUnityLinkerManager getInstance] setAd:bad forKey:unityAd];

            // add a block notification
            [[NSNotificationCenter defaultCenter] addObserverForName:@"UIDeviceOrientationDidChangeNotification"
                                                              object:nil
                                                               queue:nil
                                                          usingBlock:
             ^(NSNotification * note) {
                 screen = [UIScreen mainScreen].bounds.size;

                 if (size == 1) realSize = CGSizeMake(300, 50);
                 else if (size == 2) realSize = CGSizeMake(728, 90);
                 else if (size == 3) realSize = CGSizeMake(300, 250);
                 else realSize = CGSizeMake(320, 50);

                 if (realSize.width > screen.width) {
                     realSize.height = (screen.width * realSize.height) / realSize.width;
                     realSize.width = screen.width;
                 }

                 if (position == 0) realPos = CGPointMake((screen.width - realSize.width) / 2.0f, 0);
                 else realPos = CGPointMake((screen.width - realSize.width) / 2.0f, screen.height - realSize.height);

                 [bad resizeToFrame:CGRectMake(realPos.x, realPos.y, realSize.width, realSize.height)];
             }];
        }
        // if data is not valid
        else {
            if (_adEvent){
                _adEvent(_unityAd, placementId, @"callback_adFailedToShow");
            }
        }
    }
}

- (void) removeBannerForUnityName:(NSString *)unityAd {
    NSObject * temp = [[SAUnityLinkerManager getInstance] getAdForKey:unityAd];
    if (temp != NULL){
        if ([temp isKindOfClass:[SABannerAd class]]){
            SABannerAd *bad = (SABannerAd*)temp;
            [bad removeFromSuperview];
            bad = NULL;
        }
    }
}

////////////////////////////////////////////////////////////
// This function shows an Interstitial Ad
////////////////////////////////////////////////////////////
- (void) showInterstitialAdWith:(NSInteger)placementId
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
        if (_adEvent){
            _adEvent(_unityAd, placementId, @"callback_adFailedToShow");
        }
    } else {
        // parse ad
        SAAd *parsedAd = [SAParser parseAdFromDictionary:json withPlacementId:_placementId];

        if (parsedAd) {

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
                // play
                [iad play];

                // add "bad" as a key in the dictionary, under the Unity Ad name
                [[SAUnityLinkerManager getInstance] setAd:iad forKey:unityAd];
            }];
        }
        // if data is not valid
        else {
            if (_adEvent){
                _adEvent(_unityAd, placementId, @"callback_adFailedToShow");
            }
        }
    }
}

- (void) closeInterstitialForUnityName:(NSString *)unityAd {
     NSObject * temp = [[SAUnityLinkerManager getInstance] getAdForKey:unityAd];
    if (temp != NULL) {
        if ([temp isKindOfClass:[SAInterstitialAd class]]){
            SAInterstitialAd *iad = (SAInterstitialAd*)temp;
            [iad close];
        }
    }
}

////////////////////////////////////////////////////////////
// This function shows a video ad
////////////////////////////////////////////////////////////
- (void) showVideoAdWith:(NSInteger)placementId
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
        if (_adEvent){
            _adEvent(_unityAd, placementId, @"callback_adFailedToShow");
        }
    } else {
        // parse ad
        SAAd *parsedAd = [SAParser parseAdFromDictionary:json withPlacementId:_placementId];

        if (parsedAd) {

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
                // play
                [fvad play];

                // add "bad" as a key in the dictionary, under the Unity Ad name
                [[SAUnityLinkerManager getInstance] setAd:fvad forKey:unityAd];
            }];
        }
        // if data is not valid
        else {
            if (_adEvent){
                _adEvent(_unityAd, placementId, @"callback_adFailedToShow");
            }
        }
    }
}

- (void) closeFullscreenVideoForUnityName:(NSString *)unityAd {
    NSObject * temp = [[SAUnityLinkerManager getInstance] getAdForKey:unityAd];
    if (temp != NULL){
        if ([temp isKindOfClass:[SAFullscreenVideoAd class]]){
            SAFullscreenVideoAd *fvad = (SAFullscreenVideoAd*)temp;
            [fvad close];
        }
    }
}

#pragma mark <Delegate Implementations>

- (void) didLoadAd:(SAAd *)ad {
    NSLog(@"Sending didLoadAd to %@", _unityAd);
    if (_loadingEvent) {
        _loadingEvent(_unityAd, ad.placementId, @"callback_didLoadAd", ad.adJson);
    }
}

- (void) didFailToLoadAdForPlacementId:(NSInteger)placementId {

    NSLog(@"Sending didFailToLoadAdForPlacementId to %@", _unityAd);

    if (_loadingEvent) {
        _loadingEvent(_unityAd, placementId, @"callback_didFailToLoadAd",@"");
    }
}


- (void) adWasShown:(NSInteger)placementId {
    if (_adEvent){
        _adEvent(_unityAd, placementId, @"callback_adWasShown");
    }
}

- (void) adFailedToShow:(NSInteger)placementId {

    [[SAUnityLinkerManager getInstance] removeAd:placementId];

    if (_adEvent){
        _adEvent(_unityAd, placementId, @"callback_adFailedToShow");
    }
}

- (void) adWasClosed:(NSInteger)placementId {


    [[SAUnityLinkerManager getInstance] removeAd:placementId];

    if (_adEvent){
        _adEvent(_unityAd, placementId, @"callback_adWasClosed");
    }
}

- (void) adWasClicked:(NSInteger)placementId{
    if (_adEvent){
        _adEvent(_unityAd, placementId, @"callback_adWasClicked");
    }
}

- (void) adHasIncorrectPlacement:(NSInteger)placementId {
    if (_adEvent){
        _adEvent(_unityAd, placementId, @"callback_adHasIncorrectPlacement");
    }
}

- (void) parentalGateWasCanceled:(NSInteger)placementId {
    if (_adEvent){
        _adEvent(_unityAd, placementId, @"callback_parentalGateWasCanceled");
    }
}

- (void) parentalGateWasFailed:(NSInteger)placementId {
    if (_adEvent){
        _adEvent(_unityAd, placementId, @"callback_parentalGateWasFailed");
    }
}

- (void) parentalGateWasSucceded:(NSInteger)placementId {
    if (_adEvent){
        _adEvent(_unityAd, placementId, @"callback_parentalGateWasSucceded");
    }
}

- (void) adStarted:(NSInteger)placementId {
    if (_adEvent){
        _adEvent(_unityAd, placementId, @"callback_adStarted");
    }
}

- (void) videoStarted:(NSInteger)placementId {
    if (_adEvent){
        _adEvent(_unityAd, placementId, @"callback_videoStarted");
    }
}

- (void) videoReachedFirstQuartile:(NSInteger)placementId {
    if (_adEvent){
        _adEvent(_unityAd, placementId, @"callback_videoReachedFirstQuartile");
    }
}

- (void) videoReachedMidpoint:(NSInteger)placementId {
    if (_adEvent){
        _adEvent(_unityAd, placementId, @"callback_videoReachedMidpoint");
    }
}

- (void) videoReachedThirdQuartile:(NSInteger)placementId {
    if (_adEvent){
        _adEvent(_unityAd, placementId, @"callback_videoReachedThirdQuartile");
    }
}

- (void) videoEnded:(NSInteger)placementId {
    if (_adEvent){
        _adEvent(_unityAd, placementId, @"callback_videoEnded");
    }
}

- (void) adEnded:(NSInteger)placementId {
    if (_adEvent){
        _adEvent(_unityAd, placementId, @"callback_adEnded");
    }
}

- (void) allAdsEnded:(NSInteger)placementId {
    if (_adEvent){
        _adEvent(_unityAd, placementId, @"callback_allAdsEnded");
    }
}

@end
