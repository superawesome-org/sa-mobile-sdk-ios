//
//  SAUnityAppWall.c
//  Pods
//
//  Created by Gabriel Coman on 05/01/2017.
//
//

#import <UIKit/UIKit.h>

#if defined(__has_include)
#if __has_include("SuperAwesomeSDKUnity.h")
#import "SuperAwesomeSDKUnity.h"
#else
#import "SuperAwesome.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SASession/SASession.h>)
#import <SASession/SASession.h>
#else
#import "SASession.h"
#endif
#endif

#import "SAUnityCallback.h"

extern "C" {
    
    /**
     *  Methid that adds a callback to the SAGameWall static method class
     */
    void SuperAwesomeUnitySAAppWallCreate () {
        [SAAppWall setCallback:^(NSInteger placementId, SAEvent event) {
            switch (event) {
                case adLoaded: sendToUnity(@"SAAppWall", placementId, @"adLoaded"); break;
                case adFailedToLoad: sendToUnity(@"SAAppWall", placementId, @"adFailedToLoad"); break;
                case adShown: sendToUnity(@"SAAppWall", placementId, @"adShown"); break;
                case adFailedToShow: sendToUnity(@"SAAppWall", placementId, @"adFailedToShow"); break;
                case adClicked: sendToUnity(@"SAAppWall", placementId, @"adClicked"); break;
                case adClosed: sendToUnity(@"SAAppWall", placementId, @"adClosed"); break;
            }
        }];
    }
    
    /**
     *  Load a gamewall ad
     *
     *  @param placementId   the placement id to try to load an ad for
     *  @param configuration production = 0 / staging = 1
     *  @param test          true / false
     */
    void SuperAwesomeUnitySAAppWallLoad (int placementId, int configuration, bool test) {
        [SAAppWall setTestMode:test];
        [SAAppWall setConfiguration:getConfigurationFromInt(configuration)];
        [SAAppWall load: placementId];
    }
    
    /**
     *  Check to see if there's an ad available for the GameWall
     *
     *  @return true / false
     */
    bool SuperAwesomeUnitySAAppWallHasAdAvailable(int placementId) {
        return [SAAppWall hasAdAvailable: placementId];
    }
    
    /**
     *  Play a GameWall Ad
     *
     *  @param isParentalGateEnabled true / false
     *  @param shouldLockOrientation true / false
     */
    void SuperAwesomeUnitySAAppWallPlay (int placementId, bool isParentalGateEnabled) {
        UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
        [SAAppWall setParentalGate:isParentalGateEnabled];
        [SAAppWall play: placementId fromVC: root];
    }
    
}
