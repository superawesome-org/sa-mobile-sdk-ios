//
//  SAUnityLinker.h
//  Pods
//
//  Created by Gabriel Coman on 13/01/2016.
//
//

#import <Foundation/Foundation.h>

@class SAAd;

// callback for generic success with data
typedef void (^linkSuccess)(SAAd *ad);
typedef void (^linkError)(NSInteger placementId);

@interface SAUnityLinker : NSObject

// static function that starts a unity video
- (void) startVideoAd:(int)placementId
             withGate:(BOOL)hasGate
           inTestMode:(BOOL)testMode
          withSuccess:(linkSuccess)success
               orFail:(linkError)error;

@end
