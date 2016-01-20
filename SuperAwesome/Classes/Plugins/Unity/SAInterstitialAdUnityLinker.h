//
//  SAInterstitialAdUnityLinker.h
//  Pods
//
//  Created by Gabriel Coman on 20/01/2016.
//
//

#import <Foundation/Foundation.h>
#import "SAUnityLinkerCallbacks.h"

@interface SAInterstitialAdUnityLinker : NSObject

- (void) startWithPlacementId:(NSInteger)placementId
                    andAdJson:(NSString*)adJson
                 andUnityName:(NSString*)unityAd
           andHasParentalGate:(BOOL)isParentalGateEnabled;

@property (nonatomic, assign) adEvent event;

@end
