//
//  SAUnityPlayFullscreenVideoAd.h
//  Pods
//
//  Created by Gabriel Coman on 13/05/2016.
//
//

#import <Foundation/Foundation.h>
#import "SAUnityExtension.h"

@interface SAUnityPlayFullscreenVideoAd : SAUnityExtension

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
