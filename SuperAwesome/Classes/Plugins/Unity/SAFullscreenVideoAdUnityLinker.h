//
//  SAUnityLinker.h
//  Pods
//
//  Created by Gabriel Coman on 13/01/2016.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SAAd;

// callback for generic success with data
typedef void (^adEvent)(NSString *unityAd, NSString *unityCallback);

@interface SAFullscreenVideoAdUnityLinker : NSObject

- (void) startWithPlacementId:(NSInteger)placementId
                    andAdJson:(NSString*)adJson
                 andUnityName:(NSString*)unityAd
           andHasParentalGate:(BOOL)isParentalGateEnabled
            andHasCloseButton:(BOOL)shouldShowCloseButton
               andClosesAtEnd:(BOOL)shouldAutomaticallyCloseAtEnd;

@property (nonatomic, assign) adEvent genericEvent;

@end
