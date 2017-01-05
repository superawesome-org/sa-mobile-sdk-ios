//
//  SAUnityVideoAd.c
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
     *  Add a callback to the SAVideoAd static class
     */
    void SuperAwesomeUnitySAVideoAdCreate () {
        [SAVideoAd setCallback:^(NSInteger placementId, SAEvent event) {
            switch (event) {
                case adLoaded: sendToUnity(@"SAVideoAd", placementId, @"adLoaded"); break;
                case adFailedToLoad: sendToUnity(@"SAVideoAd", placementId, @"adFailedToLoad"); break;
                case adShown: sendToUnity(@"SAVideoAd", placementId, @"adShown"); break;
                case adFailedToShow: sendToUnity(@"SAVideoAd", placementId, @"adFailedToShow"); break;
                case adClicked: sendToUnity(@"SAVideoAd", placementId, @"adClicked"); break;
                case adClosed: sendToUnity(@"SAVideoAd", placementId, @"adClosed"); break;
            }
        }];
    }
    
    /**
     *  Load a video ad
     *
     *  @param placementId   placement id
     *  @param configuration production = 0 / staging = 1
     *  @param test          true / false
     */
    void SuperAwesomeUnitySAVideoAdLoad(int placementId, int configuration, bool test) {
        [SAVideoAd setTestMode:test];
        [SAVideoAd setConfiguration:getConfigurationFromInt(configuration)];
        [SAVideoAd load: placementId];
    }
    
    /**
     *  Check to see if there is an video ad available
     *
     *  @return true / false
     */
    bool SuperAwesomeUnitySAVideoAdHasAdAvailable(int placementId) {
        return [SAVideoAd hasAdAvailable: placementId];
    }
    
    /**
     *  Play a video ad
     *
     *  @param isParentalGateEnabled         true / false
     *  @param shouldShowCloseButton         true / false
     *  @param shouldShowSmallClickButton    true / false
     *  @param shouldAutomaticallyCloseAtEnd true / false
     *  @param shouldLockOrientation         true / falsr
     *  @param lockOrientation               ANY = 0 / PORTRAIT = 1 / LANDSCAPE = 2
     */
    void SuperAwesomeUnitySAVideoAdPlay(int placementId, bool isParentalGateEnabled, bool shouldShowCloseButton, bool shouldShowSmallClickButton, bool shouldAutomaticallyCloseAtEnd, int orientation) {
        UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
        [SAVideoAd setParentalGate:isParentalGateEnabled];
        [SAVideoAd setCloseButton:shouldShowCloseButton];
        [SAVideoAd setSmallClick:shouldShowSmallClickButton];
        [SAVideoAd setCloseAtEnd:shouldAutomaticallyCloseAtEnd];
        [SAVideoAd setOrientation: getOrientationFromInt (orientation)];
        [SAVideoAd play: placementId fromVC: root];
    }
    
}
