/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#include "SAAIRBannerAd.h"
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

// dictionary holding all current banners
NSMutableDictionary *bannerDictionary;

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
            case adLoaded:          sendAdCallback(ctx, key, (int)placementId, @"adLoaded"); break;
            case adEmpty:           sendAdCallback(ctx, key, (int)placementId, @"adEmpty"); break;
            case adFailedToLoad:    sendAdCallback(ctx, key, (int)placementId, @"adFailedToLoad"); break;
            case adAlreadyLoaded:   sendAdCallback(ctx, key, (int)placementId, @"adAlreadyLoaded"); break;
            case adShown:           sendAdCallback(ctx, key, (int)placementId, @"adShown"); break;
            case adFailedToShow:    sendAdCallback(ctx, key, (int)placementId, @"adFailedToShow"); break;
            case adClicked:         sendAdCallback(ctx, key, (int)placementId, @"adClicked"); break;
            case adEnded:           sendAdCallback(ctx, key, (int)placementId, @"adEnded"); break;
            case adClosed:          sendAdCallback(ctx, key, (int)placementId, @"adClosed"); break;
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
    uint32_t isBumperPageEnabled = SA_DEFAULT_BUMPERPAGE;
    int width = 320;
    int height = 50;
    int position = 0;
    uint32_t color = SA_DEFAULT_BGCOLOR;
    
    // populate fields
    FREGetObjectAsUTF8(argv[0], &airNameLength, &airName);
    FREGetObjectAsBool(argv[1], &isParentalGateEnabled);
    FREGetObjectAsBool(argv[2], &isBumperPageEnabled);
    FREGetObjectAsInt32(argv[3], &position);
    FREGetObjectAsInt32(argv[4], &width);
    FREGetObjectAsInt32(argv[5], &height);
    FREGetObjectAsBool(argv[6], &color);
    
    // get the key
    NSString *key = [NSString stringWithUTF8String:(char*)airName];
    
    if ([bannerDictionary objectForKey:key]  && ![[bannerDictionary objectForKey:key] isClosed]) {
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
        __block SABannerAd *banner = [bannerDictionary objectForKey:key];
        [banner setParentalGate:isParentalGateEnabled];
        [banner setBumperPage:isBumperPageEnabled];
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
        // [bannerDictionary removeObjectForKey:key];
    } else {
        // handle failure
    }
    
    return NULL;
}
