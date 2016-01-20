//
//  SAUnityLinker.h
//  Pods
//
//  Created by Gabriel Coman on 13/01/2016.
//
//

#import <Foundation/Foundation.h>
#import "SAUnityLinkerCallbacks.h"

@class SAAd;

@interface SAFullscreenVideoAdUnityLinker : NSObject

- (void) startWithPlacementId:(NSInteger)placementId
                    andAdJson:(NSString*)adJson
                 andUnityName:(NSString*)unityAd
           andHasParentalGate:(BOOL)isParentalGateEnabled
            andHasCloseButton:(BOOL)shouldShowCloseButton
               andClosesAtEnd:(BOOL)shouldAutomaticallyCloseAtEnd;

@property (nonatomic, assign) adEvent event;

@end
