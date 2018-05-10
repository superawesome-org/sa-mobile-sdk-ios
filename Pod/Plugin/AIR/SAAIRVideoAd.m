/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#include "SAAIRVideoAd.h"
#import "SAAIRCallback.h"

#if defined(__has_include)
#if __has_include(<SuperAwesomeSDK/SuperAwesomeSDK.h>)
#import <SuperAwesomeSDK/SuperAwesomeSDK.h>
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

#if defined(__has_include)
#if __has_include(<SASession/SASession.h>)
#import <SASession/SASessionDefines.h>
#else
#import "SASessionDefines.h"
#endif
#endif

FREObject SuperAwesomeAIRSAVideoAdCreate (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    
    // native video code
    [SAVideoAd setCallback:^(NSInteger placementId, SAEvent event) {
        switch (event) {
            case adLoaded:          sendAdCallback(ctx, @"SAVideoAd", (int)placementId, @"adLoaded"); break;
            case adEmpty:           sendAdCallback(ctx, @"SAVideoAd", (int)placementId, @"adEmpty"); break;
            case adFailedToLoad:    sendAdCallback(ctx, @"SAVideoAd", (int)placementId, @"adFailedToLoad"); break;
            case adAlreadyLoaded:   sendAdCallback(ctx, @"SAVideoAd", (int)placementId, @"adAlreadyLoaded"); break;
            case adShown:           sendAdCallback(ctx, @"SAVideoAd", (int)placementId, @"adShown"); break;
            case adFailedToShow:    sendAdCallback(ctx, @"SAVideoAd", (int)placementId, @"adFailedToShow"); break;
            case adClicked:         sendAdCallback(ctx, @"SAVideoAd", (int)placementId, @"adClicked"); break;
            case adEnded:           sendAdCallback(ctx, @"SAVideoAd", (int)placementId, @"adEnded"); break;
            case adClosed:          sendAdCallback(ctx, @"SAVideoAd", (int)placementId, @"adClosed"); break;
        }
    }];
    
    return NULL;
}

FREObject SuperAwesomeAIRSAVideoAdLoad (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    // needed paramters
    int placementId = SA_DEFAULT_PLACEMENTID;
    int configuration = SA_DEFAULT_CONFIGURATION;
    uint32_t test = SA_DEFAULT_TESTMODE; // boolean
    int playback = SA_DEFAULT_PLAYBACK_MODE;
    
    // populate fields
    FREGetObjectAsInt32(argv[0], &placementId);
    FREGetObjectAsInt32(argv[1], &configuration);
    FREGetObjectAsBool(argv[2], &test);
    FREGetObjectAsInt32(argv[3], &playback);
    
    // configure & load
    [SAVideoAd setTestMode:test];
    [SAVideoAd setConfiguration: getConfigurationFromInt(configuration)];
    [SAVideoAd setPlaybackMode:getRTBStartDelayFromInt(playback)];
    [SAVideoAd load:placementId];
    
    return NULL;
}

FREObject SuperAwesomeAIRSAVideoAdHasAdAvailable (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    // needed paramters
    int placementId = SA_DEFAULT_PLACEMENTID;
    
    // populate fields
    FREGetObjectAsInt32(argv[0], &placementId);
    
    uint32_t hasAdAvailable = [SAVideoAd hasAdAvailable:placementId];
    
    FREObject boolToReturn = nil;
    FRENewObjectFromBool(hasAdAvailable, &boolToReturn);
    
    return boolToReturn;
    
}

FREObject SuperAwesomeAIRSAVideoAdPlay (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    
    // needed paramters
    int placementId = SA_DEFAULT_PLACEMENTID;
    uint32_t isParentalGateEnabled = SA_DEFAULT_PARENTALGATE;
    uint32_t isBumperPageEnabled = SA_DEFAULT_BUMPERPAGE;
    uint32_t shouldShowCloseButton = SA_DEFAULT_CLOSEBUTTON;
    uint32_t shouldShowSmallClickButton = SA_DEFAULT_SMALLCLICK;
    uint32_t shouldAutomaticallyCloseAtEnd = SA_DEFAULT_CLOSEATEND;
    int orientation = SA_DEFAULT_ORIENTATION;
    uint32_t isBackButtonEnabled = SA_DEFAULT_BACKBUTTON;
    
    // populate fields
    FREGetObjectAsInt32(argv[0], &placementId);
    FREGetObjectAsBool(argv[1], &isParentalGateEnabled);
    FREGetObjectAsBool(argv[2], &isBumperPageEnabled);
    FREGetObjectAsBool(argv[3], &shouldShowCloseButton);
    FREGetObjectAsBool(argv[4], &shouldShowSmallClickButton);
    FREGetObjectAsBool(argv[5], &shouldAutomaticallyCloseAtEnd);
    FREGetObjectAsInt32(argv[6], &orientation);
    FREGetObjectAsBool(argv[7], &isBackButtonEnabled);
    
    [SAVideoAd setParentalGate:isParentalGateEnabled];
    [SAVideoAd setBumperPage:isBumperPageEnabled];
    [SAVideoAd setCloseButton:shouldShowCloseButton];
    [SAVideoAd setSmallClick:shouldShowSmallClickButton];
    [SAVideoAd setCloseAtEnd:shouldAutomaticallyCloseAtEnd];
    [SAVideoAd setOrientation:getOrientationFromInt(orientation)];
    
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    [SAVideoAd play: placementId fromVC: root];
    
    return NULL;
}
