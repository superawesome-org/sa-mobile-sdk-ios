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

// show an interstitial ad
- (void) showInterstitialAdWith:(NSInteger)placementId
                      andAdJson:(NSString*)adJson
                   andUnityName:(NSString*)unityAd
             andHasParentalGate:(BOOL)isParentalGateEnabled;

// show a video ad
- (void) showVideoAdWith:(NSInteger)placementId
               andAdJson:(NSString*)adJson
            andUnityName:(NSString*)unityAd
      andHasParentalGate:(BOOL)isParentalGateEnabled
       andHasCloseButton:(BOOL)shouldShowCloseButton
          andClosesAtEnd:(BOOL)shouldAutomaticallyCloseAtEnd;

// callback variables
@property (nonatomic, assign) loadingEvent loadingEvent;
@property (nonatomic, assign) adEvent adEvent;

@end
