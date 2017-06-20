/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#include "SAAIRAppWall.h"
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

FREObject SuperAwesomeAIRSAAppWallCreate (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    
    [SAAppWall setCallback:^(NSInteger placementId, SAEvent event) {
        switch (event) {
            case adLoaded:          sendAdCallback(ctx, @"SAAppWall", (int)placementId, @"adLoaded"); break;
            case adEmpty:           sendAdCallback(ctx, @"SAAppWall", (int)placementId, @"adEmpty"); break;
            case adFailedToLoad:    sendAdCallback(ctx, @"SAAppWall", (int)placementId, @"adFailedToLoad"); break;
            case adAlreadyLoaded:   sendAdCallback(ctx, @"SAAppWall", (int)placementId, @"adAlreadyLoaded"); break;
            case adShown:           sendAdCallback(ctx, @"SAAppWall", (int)placementId, @"adShown"); break;
            case adFailedToShow:    sendAdCallback(ctx, @"SAAppWall", (int)placementId, @"adFailedToShow"); break;
            case adClicked:         sendAdCallback(ctx, @"SAAppWall", (int)placementId, @"adClicked"); break;
            case adEnded:           sendAdCallback(ctx, @"SAAppWall", (int)placementId, @"adEnded"); break;
            case adClosed:          sendAdCallback(ctx, @"SAAppWall", (int)placementId, @"adClosed"); break;
        }
    }];
    
    return NULL;
}

FREObject SuperAwesomeAIRSAAppWallLoad (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    
    // needed paramters
    int placementId = SA_DEFAULT_PLACEMENTID;
    int configuration = SA_DEFAULT_CONFIGURATION;
    uint32_t test = SA_DEFAULT_TESTMODE; // boolean
    
    // populate fields
    FREGetObjectAsInt32(argv[0], &placementId);
    FREGetObjectAsInt32(argv[1], &configuration);
    FREGetObjectAsBool(argv[2], &test);
    
    // configure & load
    [SAAppWall setTestMode:test];
    [SAAppWall setConfiguration: getConfigurationFromInt(configuration)];
    [SAAppWall load:placementId];
    
    return NULL;
    
}

FREObject SuperAwesomeAIRSAAppWallHasAdAvailable (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    // needed paramters
    int placementId = SA_DEFAULT_PLACEMENTID;
    
    // populate fields
    FREGetObjectAsInt32(argv[0], &placementId);
    
    uint32_t hasAdAvailable = [SAAppWall hasAdAvailable:placementId];
    
    FREObject boolToReturn = nil;
    FRENewObjectFromBool(hasAdAvailable, &boolToReturn);
    
    return boolToReturn;
}

FREObject SuperAwesomeAIRSAAppWallPlay (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    
    // needed paramters
    int placementId = SA_DEFAULT_PLACEMENTID;
    uint32_t isParentalGateEnabled = SA_DEFAULT_PARENTALGATE;
    uint32_t isBackButtonEnabled = SA_DEFAULT_BACKBUTTON;
    
    // populate fields
    FREGetObjectAsInt32(argv[0], &placementId);
    FREGetObjectAsBool(argv[1], &isParentalGateEnabled);
    FREGetObjectAsBool(argv[2], &isBackButtonEnabled);
    
    // configure & play
    [SAAppWall setParentalGate:isParentalGateEnabled];
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    [SAAppWall play: placementId fromVC: root];
    
    return NULL;
    
}
