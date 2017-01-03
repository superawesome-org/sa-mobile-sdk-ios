#import <Foundation/Foundation.h>

#import "FlashRuntimeExtensions.h"

#if defined(__has_include)
#if __has_include(<SuperAwesomeSDK/SuperAwesomeSDK.h>)
#import <SuperAwesomeSDK/SuperAwesomeSDK.h>
#else
#import "SuperAwesome.h"
#endif
#endif

// guarded imports
#if defined(__has_include)
#if __has_include(<SASession/SASession.h>)
#import <SASession/SASession.h>
#else
#import "SASession.h"
#endif
#endif


/**
 *  A dictionary that holds Unity banners
 */
NSMutableDictionary *bannerDictionary;

////////////////////////////////////////////////////////////////////////////////
// Aux func
////////////////////////////////////////////////////////////////////////////////

void sendToAIR (FREContext context, NSString *name, int placementId, NSString *callback) {
    if (context == NULL) return;
    
    NSString *meta = [NSString stringWithFormat:@"{\"name\":\"%@\",\"placementId\":%d,\"callback\":\"%@\"}",
                      name, placementId, callback];
    const uint8_t* metaUTF8 = (const uint8_t*) [meta UTF8String];

    FREDispatchStatusEventAsync(context, metaUTF8, "");
}

////////////////////////////////////////////////////////////////////////////////
// CPI iOS func
////////////////////////////////////////////////////////////////////////////////

FREObject SuperAwesomeAIRSuperAwesomeHandleCPI (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    [[SuperAwesome getInstance] handleCPI];
    return NULL;
}

////////////////////////////////////////////////////////////////////////////////
// AIR to SABannerAd interface
////////////////////////////////////////////////////////////////////////////////

FREObject SuperAwesomeAIRSABannerAdCreate (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    
    // create banner dictionary if not available
    if (bannerDictionary == nil) {
        bannerDictionary = [@{} mutableCopy];
    }
    
    // get the key
    uint32_t airNameLength;
    const uint8_t *airName;
    FREGetObjectAsUTF8(argv[0], &airNameLength, &airName);
    
    // get the key
    __block NSString *key = [NSString stringWithUTF8String:(char*)airName];
    
    // create a new banner
    SABannerAd *banner = [[SABannerAd alloc] init];
    
    // set banner callback
    [banner setCallback:^(NSInteger placementId, SAEvent event) {
        switch (event) {
            case adLoaded:          sendToAIR(ctx, key, (int)placementId, @"adLoaded"); break;
            case adFailedToLoad:    sendToAIR(ctx, key, (int)placementId, @"adFailedToLoad"); break;
            case adShown:           sendToAIR(ctx, key, (int)placementId, @"adShown"); break;
            case adFailedToShow:    sendToAIR(ctx, key, (int)placementId, @"adFailedToShow"); break;
            case adClicked:         sendToAIR(ctx, key, (int)placementId, @"adClicked"); break;
            case adClosed:          sendToAIR(ctx, key, (int)placementId, @"adClosed"); break;
        }
    }];
    
    // save the banner
    [bannerDictionary setObject:banner forKey:key];
    
    return NULL;
    
}

FREObject SuperAwesomeAIRSABannerAdLoad (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    // needed paramters
    uint32_t airNameLength;
    const uint8_t *airName;
    
    int placementId = SA_DEFAULT_PLACEMENTID;
    int configuration = SA_DEFAULT_CONFIGURATION;
    uint32_t test = SA_DEFAULT_TESTMODE; // boolean
    
    // populate fields
    FREGetObjectAsUTF8(argv[0], &airNameLength, &airName);
    FREGetObjectAsInt32(argv[1], &placementId);
    FREGetObjectAsInt32(argv[2], &configuration);
    FREGetObjectAsBool(argv[3], &test);
    
    // get the key
    NSString *key = [NSString stringWithUTF8String:(char*)airName];
    
    if ([bannerDictionary objectForKey:key]) {
        SABannerAd *banner = [bannerDictionary objectForKey:key];
        
        [banner setTestMode:test];
        [banner setConfiguration: getConfigurationFromInt(configuration)];
        [banner load:placementId];
        
    } else {
        // handle failure
    }
    
    return NULL;
}

FREObject SuperAwesomeAIRSABannerAdHasAdAvailable (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    // needed paramters
    uint32_t airNameLength;
    const uint8_t *airName;
    
    // populate fields
    FREGetObjectAsUTF8(argv[0], &airNameLength, &airName);
    
    // get the key
    NSString *key = [NSString stringWithUTF8String:(char*)airName];
    
    uint32_t hasAdAvailable = false;
    
    if ([bannerDictionary objectForKey:key]) {
        SABannerAd *banner = [bannerDictionary objectForKey:key];
        hasAdAvailable = [banner hasAdAvailable];
    }
    
    FREObject boolToReturn = nil;
    FRENewObjectFromBool(hasAdAvailable, &boolToReturn);
    
    return boolToReturn;
}

FREObject SuperAwesomeAIRSABannerAdPlay (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    // needed paramters
    uint32_t airNameLength;
    const uint8_t *airName;
    uint32_t isParentalGateEnabled = SA_DEFAULT_PARENTALGATE;
    int width = 320;
    int height = 50;
    int position = 0;
    uint32_t color = SA_DEFAULT_BGCOLOR;
    
    // populate fields
    FREGetObjectAsUTF8(argv[0], &airNameLength, &airName);
    FREGetObjectAsBool(argv[1], &isParentalGateEnabled);
    FREGetObjectAsInt32(argv[2], &position);
    FREGetObjectAsInt32(argv[3], &width);
    FREGetObjectAsInt32(argv[4], &height);
    FREGetObjectAsBool(argv[5], &color);
    
    // get the key
    NSString *key = [NSString stringWithUTF8String:(char*)airName];
    
    if ([bannerDictionary objectForKey:key]) {
        // get the root vc
        UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
        
        // calculate the size of the ad
        __block CGSize realSize = CGSizeMake(width, height);
        
        // get the screen size
        __block CGSize screen = [UIScreen mainScreen].bounds.size;
        
        if (realSize.width > screen.width) {
            realSize.height = (screen.width * realSize.height) / realSize.width;
            realSize.width = screen.width;
        }
        
        // calculate the position of the ad
        __block CGPoint realPos = position == 0 ?
        CGPointMake((screen.width - realSize.width) / 2.0f, 0) :
        CGPointMake((screen.width - realSize.width) / 2.0f, screen.height - realSize.height);
        
        // get banner
        SABannerAd *banner = [bannerDictionary objectForKey:key];
        [banner setParentalGate:isParentalGateEnabled];
        [banner setColor:color];
        [root.view addSubview:banner];
        [banner resize:CGRectMake(realPos.x, realPos.y, realSize.width, realSize.height)];
        
        // add a block notification
        [[NSNotificationCenter defaultCenter] addObserverForName:@"UIDeviceOrientationDidChangeNotification"
                                                          object:nil
                                                           queue:nil
                                                      usingBlock:
         ^(NSNotification * note) {
             screen = [UIScreen mainScreen].bounds.size;
             
             realSize = CGSizeMake(width, height);
             
             if (realSize.width > screen.width) {
                 realSize.height = (screen.width * realSize.height) / realSize.width;
                 realSize.width = screen.width;
             }
             
             if (position == 0) realPos = CGPointMake((screen.width - realSize.width) / 2.0f, 0);
             else realPos = CGPointMake((screen.width - realSize.width) / 2.0f, screen.height - realSize.height);
             
             [banner resize:CGRectMake(realPos.x, realPos.y, realSize.width, realSize.height)];
         }];
        
        
        // finally play
        [banner play];
    }
    
    return NULL;
}

FREObject SuperAwesomeAIRSABannerAdClose (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    // needed paramters
    uint32_t airNameLength;
    const uint8_t *airName;
    
    // populate fields
    FREGetObjectAsUTF8(argv[0], &airNameLength, &airName);
    
    // get the key
    NSString *key = [NSString stringWithUTF8String:(char*)airName];
    
    if ([bannerDictionary objectForKey:key]) {
        SABannerAd *banner = [bannerDictionary objectForKey:key];
        [banner close];
        [banner removeFromSuperview];
        [bannerDictionary removeObjectForKey:key];
    } else {
        // handle failure
    }
    
    return NULL;
}

////////////////////////////////////////////////////////////////////////////////
// AIR to SAInterstitialAd interface
////////////////////////////////////////////////////////////////////////////////

FREObject SuperAwesomeAIRSAInterstitialAdCreate (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    
    // native interstitial code
    [SAInterstitialAd setCallback:^(NSInteger placementId, SAEvent event) {
        switch (event) {
            case adLoaded:          sendToAIR(ctx, @"SAInterstitialAd", (int)placementId, @"adLoaded"); break;
            case adFailedToLoad:    sendToAIR(ctx, @"SAInterstitialAd", (int)placementId, @"adFailedToLoad"); break;
            case adShown:           sendToAIR(ctx, @"SAInterstitialAd", (int)placementId, @"adShown"); break;
            case adFailedToShow:    sendToAIR(ctx, @"SAInterstitialAd", (int)placementId, @"adFailedToShow"); break;
            case adClicked:         sendToAIR(ctx, @"SAInterstitialAd", (int)placementId, @"adClicked"); break;
            case adClosed:          sendToAIR(ctx, @"SAInterstitialAd", (int)placementId, @"adClosed"); break;
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


////////////////////////////////////////////////////////////////////////////////
// AIR to SAVideoAd interface
////////////////////////////////////////////////////////////////////////////////

FREObject SuperAwesomeAIRSAVideoAdCreate (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]){

    // native video code
    [SAVideoAd setCallback:^(NSInteger placementId, SAEvent event) {
        switch (event) {
            case adLoaded:          sendToAIR(ctx, @"SAVideoAd", (int)placementId, @"adLoaded"); break;
            case adFailedToLoad:    sendToAIR(ctx, @"SAVideoAd", (int)placementId, @"adFailedToLoad"); break;
            case adShown:           sendToAIR(ctx, @"SAVideoAd", (int)placementId, @"adShown"); break;
            case adFailedToShow:    sendToAIR(ctx, @"SAVideoAd", (int)placementId, @"adFailedToShow"); break;
            case adClicked:         sendToAIR(ctx, @"SAVideoAd", (int)placementId, @"adClicked"); break;
            case adClosed:          sendToAIR(ctx, @"SAVideoAd", (int)placementId, @"adClosed"); break;
        }
    }];

    return NULL;
}

FREObject SuperAwesomeAIRSAVideoAdLoad (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    // needed paramters
    int placementId = SA_DEFAULT_PLACEMENTID;
    int configuration = SA_DEFAULT_CONFIGURATION;
    uint32_t test = SA_DEFAULT_TESTMODE; // boolean
    
    // populate fields
    FREGetObjectAsInt32(argv[0], &placementId);
    FREGetObjectAsInt32(argv[1], &configuration);
    FREGetObjectAsBool(argv[2], &test);

    // configure & load
    [SAVideoAd setTestMode:test];
    [SAVideoAd setConfiguration: getConfigurationFromInt(configuration)];
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
    uint32_t shouldShowCloseButton = SA_DEFAULT_CLOSEBUTTON;
    uint32_t shouldShowSmallClickButton = SA_DEFAULT_SMALLCLICK;
    uint32_t shouldAutomaticallyCloseAtEnd = SA_DEFAULT_CLOSEATEND;
    int orientation = SA_DEFAULT_ORIENTATION;
    uint32_t isBackButtonEnabled = SA_DEFAULT_BACKBUTTON;
    
    // populate fields
    FREGetObjectAsInt32(argv[0], &placementId);
    FREGetObjectAsBool(argv[1], &isParentalGateEnabled);
    FREGetObjectAsBool(argv[2], &shouldShowCloseButton);
    FREGetObjectAsBool(argv[3], &shouldShowSmallClickButton);
    FREGetObjectAsBool(argv[4], &shouldAutomaticallyCloseAtEnd);
    FREGetObjectAsInt32(argv[5], &orientation);
    FREGetObjectAsBool(argv[6], &isBackButtonEnabled);
    
    [SAVideoAd setParentalGate:isParentalGateEnabled];
    [SAVideoAd setCloseButton:shouldShowCloseButton];
    [SAVideoAd setSmallClick:shouldShowSmallClickButton];
    [SAVideoAd setCloseAtEnd:shouldAutomaticallyCloseAtEnd];
    [SAVideoAd setOrientation:getOrientationFromInt(orientation)];
    
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    [SAVideoAd play: placementId fromVC: root];
    
    return NULL;
}

////////////////////////////////////////////////////////////////////////////////
// AIR to SAAppWall interface
////////////////////////////////////////////////////////////////////////////////

FREObject SuperAwesomeAIRSAAppWallCreate (FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    
    [SAAppWall setCallback:^(NSInteger placementId, SAEvent event) {
        switch (event) {
            case adLoaded:          sendToAIR(ctx, @"SAAppWall", (int)placementId, @"adLoaded"); break;
            case adFailedToLoad:    sendToAIR(ctx, @"SAAppWall", (int)placementId, @"adFailedToLoad"); break;
            case adShown:           sendToAIR(ctx, @"SAAppWall", (int)placementId, @"adShown"); break;
            case adFailedToShow:    sendToAIR(ctx, @"SAAppWall", (int)placementId, @"adFailedToShow"); break;
            case adClicked:         sendToAIR(ctx, @"SAAppWall", (int)placementId, @"adClicked"); break;
            case adClosed:          sendToAIR(ctx, @"SAAppWall", (int)placementId, @"adClosed"); break;
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

////////////////////////////////////////////////////////////////////////////////
// Context methods
////////////////////////////////////////////////////////////////////////////////

void SAContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet) {
    
    *numFunctionsToTest = 18;
    
    FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * *numFunctionsToTest);
    
    func[0].name = (const uint8_t*) "SuperAwesomeAIRSAVideoAdCreate";
    func[0].functionData = NULL;
    func[0].function = &SuperAwesomeAIRSAVideoAdCreate;
    
    func[1].name = (const uint8_t*) "SuperAwesomeAIRSAVideoAdLoad";
    func[1].functionData = NULL;
    func[1].function = &SuperAwesomeAIRSAVideoAdLoad;
    
    func[2].name = (const uint8_t*) "SuperAwesomeAIRSAVideoAdHasAdAvailable";
    func[2].functionData = NULL;
    func[2].function = &SuperAwesomeAIRSAVideoAdHasAdAvailable;
    
    func[3].name = (const uint8_t*) "SuperAwesomeAIRSAVideoAdPlay";
    func[3].functionData = NULL;
    func[3].function = &SuperAwesomeAIRSAVideoAdPlay;
    
    func[4].name = (const uint8_t*) "SuperAwesomeAIRSAInterstitialAdCreate";
    func[4].functionData = NULL;
    func[4].function = &SuperAwesomeAIRSAInterstitialAdCreate;
    
    func[5].name = (const uint8_t*) "SuperAwesomeAIRSAInterstitialAdLoad";
    func[5].functionData = NULL;
    func[5].function = &SuperAwesomeAIRSAInterstitialAdLoad;
    
    func[6].name = (const uint8_t*) "SuperAwesomeAIRSAInterstitialAdHasAdAvailable";
    func[6].functionData = NULL;
    func[6].function = &SuperAwesomeAIRSAInterstitialAdHasAdAvailable;
    
    func[7].name = (const uint8_t*) "SuperAwesomeAIRSAInterstitialAdPlay";
    func[7].functionData = NULL;
    func[7].function = &SuperAwesomeAIRSAInterstitialAdPlay;
    
    func[8].name = (const uint8_t*) "SuperAwesomeAIRSAAppWallCreate";
    func[8].functionData = NULL;
    func[8].function = &SuperAwesomeAIRSAAppWallCreate;
    
    func[9].name = (const uint8_t*) "SuperAwesomeAIRSAAppWallLoad";
    func[9].functionData = NULL;
    func[9].function = &SuperAwesomeAIRSAAppWallLoad;
    
    func[10].name = (const uint8_t*) "SuperAwesomeAIRSAAppWallHasAdAvailable";
    func[10].functionData = NULL;
    func[10].function = &SuperAwesomeAIRSAAppWallHasAdAvailable;
    
    func[11].name = (const uint8_t*) "SuperAwesomeAIRSAAppWallPlay";
    func[11].functionData = NULL;
    func[11].function = &SuperAwesomeAIRSAAppWallPlay;
    
    func[12].name = (const uint8_t*) "SuperAwesomeAIRSABannerAdCreate";
    func[12].functionData = NULL;
    func[12].function = &SuperAwesomeAIRSABannerAdCreate;
    
    func[13].name = (const uint8_t*) "SuperAwesomeAIRSABannerAdLoad";
    func[13].functionData = NULL;
    func[13].function = &SuperAwesomeAIRSABannerAdLoad;
    
    func[14].name = (const uint8_t*) "SuperAwesomeAIRSABannerAdHasAdAvailable";
    func[14].functionData = NULL;
    func[14].function = &SuperAwesomeAIRSABannerAdHasAdAvailable;
    
    func[15].name = (const uint8_t*) "SuperAwesomeAIRSABannerAdPlay";
    func[15].functionData = NULL;
    func[15].function = &SuperAwesomeAIRSABannerAdPlay;
    
    func[16].name = (const uint8_t*) "SuperAwesomeAIRSABannerAdClose";
    func[16].functionData = NULL;
    func[16].function = &SuperAwesomeAIRSABannerAdClose;
    
    func[17].name = (const uint8_t*) "SuperAwesomeAIRSuperAwesomeHandleCPI";
    func[17].functionData = NULL;
    func[17].function = &SuperAwesomeAIRSuperAwesomeHandleCPI;
    
    *functionsToSet = func;
}

// this should start the Extension (and also be present in the XML file)
void SAExtensionInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet){
    *extDataToSet = NULL;
    *ctxInitializerToSet = &SAContextInitializer;
}
