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
typedef void (^adEvent)(NSString *unityAd);

@interface SAFullscreenVideoAdUnityLinker : NSObject

// static function that starts a unity video
- (id) initWithVideoAd:(int)placementId
          andUnityName:(NSString*)unityAdName
              withGate:(BOOL)hasGate
            inTestMode:(BOOL)testMode
        hasCloseButton:(BOOL)hasClose
        andClosesAtEnd:(BOOL)closesAtEnd;
- (void) start;

// add blocks
- (void) addLoadVideoBlock:(adEvent)block;
- (void) addFailToLoadVideoBlock:(adEvent)block;
- (void) addStartVideoBlock:(adEvent)block;
- (void) addStopVideoBlock:(adEvent)block;
- (void) addFailToPlayVideoBlock:(adEvent)block;
- (void) addClickVideoBlock:(adEvent)block;

@end
