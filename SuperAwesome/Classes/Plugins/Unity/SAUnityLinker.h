//
//  SAUnityLinker.h
//  Pods
//
//  Created by Gabriel Coman on 21/01/2016.
//
//

#import <Foundation/Foundation.h>

// callback for generic success with data
typedef void (^adEvent)(NSString *unityAd, NSString *unityCallback);

// callback for generic success with data
typedef void (^loadingEvent)(NSString *unityAd, NSString *unityCallback, NSString *adString);

@interface SAUnityLinker : NSObject

// singleton instance (instead of init)
+ (SAUnityLinker *)getInstance;

// main loading function for the linker
- (void) loadAd:(NSInteger)placementId
     forUnityAd:(NSString*)unityAd
   withTestMode:(BOOL)isTestEnabled;

// show a banner ad
- (void) showBannerAdWith:(NSInteger)placementId
                andAdJson:(NSString*)adJson
             andUnityName:(NSString*)unityAd
              andPosition:(NSInteger)position
                  andSize:(NSInteger)size
       andHasParentalGate:(BOOL)isParentalGateEnabled;

// remove the banner ad
- (void) removeBannerForUnityName:(NSString*)unityAd;

// show an interstitial ad
- (void) showInterstitialAdWith:(NSInteger)placementId
                      andAdJson:(NSString*)adJson
                   andUnityName:(NSString*)unityAd
             andHasParentalGate:(BOOL)isParentalGateEnabled;

// close the interstitial
- (void) closeInterstitialForUnityName:(NSString*)unityAd;

// show a video ad
- (void) showVideoAdWith:(NSInteger)placementId
               andAdJson:(NSString*)adJson
            andUnityName:(NSString*)unityAd
      andHasParentalGate:(BOOL)isParentalGateEnabled
       andHasCloseButton:(BOOL)shouldShowCloseButton
          andClosesAtEnd:(BOOL)shouldAutomaticallyCloseAtEnd;

// close the fullscreen video
- (void) closeFullscreenVideoForUnityName:(NSString*)unityAd;

// callback variables
@property (nonatomic, assign) loadingEvent loadingEvent;
@property (nonatomic, assign) adEvent adEvent;

@end
