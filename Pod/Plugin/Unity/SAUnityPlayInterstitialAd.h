//
//  SAUnityPlayInterstitialAd.h
//  Pods
//
//  Created by Gabriel Coman on 13/05/2016.
//
//

#import <Foundation/Foundation.h>
#import "SAUnityExtension.h"

@interface SAUnityPlayInterstitialAd : SAUnityExtension

// show an interstitial ad
- (void) showInterstitialAdWith:(NSInteger)placementId
                      andAdJson:(NSString*)adJson
                   andUnityName:(NSString*)unityAd
             andHasParentalGate:(BOOL)isParentalGateEnabled;

// close the interstitial
- (void) closeInterstitialForUnityName:(NSString*)unityAd;

@end
