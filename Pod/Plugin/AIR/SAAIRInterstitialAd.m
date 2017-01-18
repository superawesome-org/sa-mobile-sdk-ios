//
//  SAAIRInterstitialAd.c
//  Pods
//
//  Created by Gabriel Coman on 05/01/2017.
//
//

#include "SAAIRInterstitialAd.h"

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

FREObject SuperAwesomeAIRSAInterstitialAdCreate (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    
    // native interstitial code
    [SAInterstitialAd setCallback:^(NSInteger placementId, SAEvent event) {
        switch (event) {
            case adLoaded:          sendAdCallback(ctx, @"SAInterstitialAd", (int)placementId, @"adLoaded"); break;
            case adFailedToLoad:    sendAdCallback(ctx, @"SAInterstitialAd", (int)placementId, @"adFailedToLoad"); break;
            case adShown:           sendAdCallback(ctx, @"SAInterstitialAd", (int)placementId, @"adShown"); break;
            case adFailedToShow:    sendAdCallback(ctx, @"SAInterstitialAd", (int)placementId, @"adFailedToShow"); break;
            case adClicked:         sendAdCallback(ctx, @"SAInterstitialAd", (int)placementId, @"adClicked"); break;
            case adClosed:          sendAdCallback(ctx, @"SAInterstitialAd", (int)placementId, @"adClosed"); break;
        }
    }];
    
    return NULL;
    
}

FREObject SuperAwesomeAIRSAInterstitialAdLoad (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    // needed paramters
    int placementId = SA_DEFAULT_PLACEMENTID;
    int configuration = SA_DEFAULT_CONFIGURATION;
    uint32_t test = SA_DEFAULT_TESTMODE; // boolean
    
    // populate fields
    FREGetObjectAsInt32(argv[0], &placementId);
    FREGetObjectAsInt32(argv[1], &configuration);
    FREGetObjectAsBool(argv[2], &test);
    
    // setup & load
    [SAInterstitialAd setTestMode:test];
    [SAInterstitialAd setConfiguration: getConfigurationFromInt(configuration)];
    [SAInterstitialAd load:placementId];
    
    return NULL;
}

FREObject SuperAwesomeAIRSAInterstitialAdHasAdAvailable (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    // needed paramters
    int placementId = SA_DEFAULT_PLACEMENTID;
    
    // populate fields
    FREGetObjectAsInt32(argv[0], &placementId);
    
    uint32_t hasAdAvailable = [SAInterstitialAd hasAdAvailable:placementId];
    
    FREObject boolToReturn = nil;
    FRENewObjectFromBool(hasAdAvailable, &boolToReturn);
    
    return boolToReturn;
}

FREObject SuperAwesomeAIRSAInterstitialAdPlay (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    
    // needed paramters
    int placementId = SA_DEFAULT_PLACEMENTID;
    uint32_t isParentalGateEnabled = SA_DEFAULT_PARENTALGATE;
    int orientation = SA_DEFAULT_ORIENTATION;
    uint32_t isBackButtonEnabled = SA_DEFAULT_BACKBUTTON;
    
    // populate fields
    FREGetObjectAsInt32(argv[0], &placementId);
    FREGetObjectAsBool(argv[1], &isParentalGateEnabled);
    FREGetObjectAsInt32(argv[2], &orientation);
    FREGetObjectAsBool(argv[3], &isBackButtonEnabled);
    
    // configure & play
    [SAInterstitialAd setParentalGate:isParentalGateEnabled];
    [SAInterstitialAd setOrientation:getOrientationFromInt(orientation)];
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    [SAInterstitialAd play: placementId fromVC: root];
    
    return NULL;
    
}
