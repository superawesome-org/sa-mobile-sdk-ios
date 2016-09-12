//
//  SAUnity.mm
//  Pods
//
//  Created by Gabriel Coman on 19/07/2016.
//
//

#import <Foundation/Foundation.h>

#if defined(__has_include)
#if __has_include("SuperAwesomeSDKUnity.h")
#import "SuperAwesomeSDKUnity.h"
#else 
#import "SuperAwesome.h"
#import "SAUnityLoadAd.h"
#import "SAUnityPlayBannerAd.h"
#import "SAUnityPlayInterstitialAd.h"
#import "SAUnityPlayFullscreenVideoAd.m"
#endif
#endif

/**
 *  Forward declaration for the UnitySendMessage function
 *
 *  @param identifier unique object identifier
 *  @param function   the name of the method to call on the object
 *  @param payload    the payload data (as JSON)
 */
void UnitySendMessage(const char *identifier, const char *function, const char *payload);

extern "C" {
    
    /**
     *  A dictionary that holds Unity banners
     */
    NSMutableDictionary *bannerDictionary = [@{} mutableCopy];
    
    /**
     *  Function that groups some common Unity functionality
     *
     *  @param unityName   unique object identifier
     *  @param placementId placement id
     *  @param callback    callback method to call
     */
    void sendToUnity (NSString *unityName,
                      NSInteger placementId,
                      NSString *callback) {
        
        NSString *payload = [NSString stringWithFormat:@"{\"placementId\":\"%d\", \"type\":\"sacallback_%@\"}", placementId, callback];
        UnitySendMessage([unityName UTF8String], "nativeCallback", [payload UTF8String]);
    }
    
    /**
     *  Function that creates a new SABannerAd instance
     *
     *  @param unityName the name of the banner in unity
     */
    void SuperAwesomeUnitySABannerAdCreate (const char *unityName) {
        
        
        // get the key
        __block NSString *key = [NSString stringWithUTF8String:unityName];
        
        // create a new banner
        SABannerAd *banner = [[SABannerAd alloc] init];
        
        // set banner callback
        [banner setCallback:^(NSInteger placementId, SAEvent event) {
            switch (event) {
                case adLoaded: sendToUnity(key, placementId, @"adLoaded"); break;
                case adFailedToLoad: sendToUnity(key, placementId, @"adFailedToLoad"); break;
                case adShown: sendToUnity(key, placementId, @"adShown"); break;
                case adFailedToShow: sendToUnity(key, placementId, @"adFailedToShow"); break;
                case adClicked: sendToUnity(key, placementId, @"adClicked"); break;
                case adClosed: sendToUnity(key, placementId, @"adClosed"); break;
            }
        }];
        
        // save the banner
        [bannerDictionary setObject:banner forKey:key];
    }
    
    /**
     *  Function that loads an ad for a banner
     *
     *  @param unityName     the unique name of the banner in unity
     *  @param placementId   placement id to load the ad for
     *  @param configuration production = 0 / staging = 1
     *  @param test          true / false
     */
    void SuperAwesomeUnitySABannerAdLoad (const char *unityName,
                                          int placementId,
                                          int configuration,
                                          bool test) {
        
        // get the key
        NSString *key = [NSString stringWithUTF8String:unityName];
        
        if ([bannerDictionary objectForKey:key]) {
            SABannerAd *banner = [bannerDictionary objectForKey:key];
            
            switch (configuration) {
                case 0: [banner setConfigurationProduction]; break;
                case 1: [banner setConfigurationStaging]; break;
                default: [banner setConfigurationStaging]; break;
            }
            [banner setTest: test];
            [banner load:placementId];
        } else {
            // handle failure
        }
    }
    
    /**
     *  Function that checks wheter a banner has a loaded ad available or not
     *
     *  @param unityName the unique name of the banner in unity
     *
     *  @return true of false
     */
    bool SuperAwesomeUnitySABannerAdHasAdAvailable (const char *unityName) {
        
        // get the key
        NSString *key = [NSString stringWithUTF8String:unityName];
        
        if ([bannerDictionary objectForKey:key]) {
            SABannerAd *banner = [bannerDictionary objectForKey:key];
            return [banner hasAdAvailable];
        }
        
        return false;
    }
    
    /**
     *  Function that plays a banner ad in unity
     *
     *  @param unityName             the unique name of the banner in unity
     *  @param isParentalGateEnabled true / false
     *  @param position              TOP = 0 / BOTTOM = 1
     *  @param size                  BANNER_320_50 = 0 / BANNER_300_50 = 1 / BANNER_728_90 = 2 / BANNER_300_250 = 3
     *  @param color                 BANNER_TRANSPARENT = 0 / BANNER_GRAY = 1
     */
    void SuperAwesomeUnitySABannerAdPlay (const char *unityName,
                                          bool isParentalGateEnabled,
                                          int position,
                                          int size,
                                          int color) {
        
        // get the key
        NSString *key = [NSString stringWithUTF8String:unityName];
        
        if ([bannerDictionary objectForKey:key]) {
            
            // get the root vc
            UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
            
            // calculate the size of the ad
            __block CGSize realSize = CGSizeZero;
            if (size == 1) realSize = CGSizeMake(300, 50);
            else if (size == 2) realSize = CGSizeMake(728, 90);
            else if (size == 3) realSize = CGSizeMake(300, 250);
            else realSize = CGSizeMake(320, 50);
            
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
            [banner setIsParentalGateEnabled:isParentalGateEnabled];
            banner.backgroundColor = color == 0 ? [UIColor clearColor] : [UIColor colorWithRed:191.0/255.0f green:191.0/255.0f blue:191.0/255.0f alpha:1];
            [root.view addSubview:banner];
            [banner resize:CGRectMake(realPos.x, realPos.y, realSize.width, realSize.height)];
            
            // add a block notification
            [[NSNotificationCenter defaultCenter] addObserverForName:@"UIDeviceOrientationDidChangeNotification"
                                                              object:nil
                                                               queue:nil
                                                          usingBlock:
             ^(NSNotification * note) {
                 screen = [UIScreen mainScreen].bounds.size;
                 
                 if (size == 1) realSize = CGSizeMake(300, 50);
                 else if (size == 2) realSize = CGSizeMake(728, 90);
                 else if (size == 3) realSize = CGSizeMake(300, 250);
                 else realSize = CGSizeMake(320, 50);
                 
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
            
        } else {
            // handle failure
        }
    }
    
    /**
     *  Function that closes and removes a banner from view
     *
     *  @param unityName the unique name of the banner in unity
     */
    void SuperAwesomeUnitySABannerAdClose (const char *unityName) {
        
        // get the key
        NSString *key = [NSString stringWithUTF8String:unityName];
        
        if ([bannerDictionary objectForKey:key]) {
            SABannerAd *banner = [bannerDictionary objectForKey:key];
            [banner close];
            [banner removeFromSuperview];
            [bannerDictionary removeObjectForKey:key];
        } else {
            // handle failure
        }
    }
    
    /**
     *  Methid that adds a callback to the SAInterstitialAd static method class
     */
    void SuperAwesomeUnitySAInterstitialAdCreate () {

        [SAInterstitialAd setCallback:^(NSInteger placementId, SAEvent event) {
            switch (event) {
                case adLoaded: sendToUnity(@"SAInterstitialAd", placementId, @"adLoaded"); break;
                case adFailedToLoad: sendToUnity(@"SAInterstitialAd", placementId, @"adFailedToLoad"); break;
                case adShown: sendToUnity(@"SAInterstitialAd", placementId, @"adShown"); break;
                case adFailedToShow: sendToUnity(@"SAInterstitialAd", placementId, @"adFailedToShow"); break;
                case adClicked: sendToUnity(@"SAInterstitialAd", placementId, @"adClicked"); break;
                case adClosed: sendToUnity(@"SAInterstitialAd", placementId, @"adClosed"); break;
            }
        }];

    }
    
    /**
     *  Load an interstitial ad
     *
     *  @param placementId   the placement id to try to load an ad for
     *  @param configuration production = 0 / staging = 1
     *  @param test          true / false
     */
    void SuperAwesomeUnitySAInterstitialAdLoad (int placementId,
                                                int configuration,
                                                bool test) {
        
        switch (configuration) {
            case 0: [SAInterstitialAd setConfigurationProduction]; break;
            case 1: [SAInterstitialAd setConfigurationStaging]; break;
            default: [SAInterstitialAd setConfigurationStaging]; break;
        }
        [SAInterstitialAd setTest:test];
        [SAInterstitialAd load: placementId];
    }
    
    /**
     *  Check to see if there's an ad available
     *
     *  @return true / false
     */
    bool SuperAwesomeUnitySAInterstitialAdHasAdAvailable() {
        return [SAVideoAd hasAdAvailable];
    }
    
    /**
     *  Play an interstitial ad
     *
     *  @param isParentalGateEnabled true / false
     *  @param shouldLockOrientation true / false
     *  @param lockOrientation       ANY = 0 / PORTRAIT = 1 / LANDSCAPE = 2
     */
    void SuperAwesomeUnitySAInterstitialAdPlay (bool isParentalGateEnabled,
                                                bool shouldLockOrientation,
                                                int lockOrientation) {
        
        [SAInterstitialAd setIsParentalGateEnabled: isParentalGateEnabled];
        [SAInterstitialAd setShouldLockOrientation: shouldLockOrientation];
        NSUInteger orientation = UIInterfaceOrientationMaskAll;
        switch (lockOrientation) {
            case 0: orientation = UIInterfaceOrientationMaskAll; break;
            case 1: orientation = UIInterfaceOrientationMaskPortrait; break;
            case 2: orientation = UIInterfaceOrientationMaskLandscape; break;
            default: orientation = UIInterfaceOrientationMaskAll; break;
        }
        [SAInterstitialAd setLockOrientation:orientation];
        
        UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
        [SAInterstitialAd play: root];
        
    }
    
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
    void SuperAwesomeUnitySAVideoAdLoad(int placementId,
                                        int configuration,
                                        bool test) {
        
        switch (configuration) {
            case 0: [SAVideoAd setConfigurationProduction]; break;
            case 1: [SAVideoAd setConfigurationStaging]; break;
            default: [SAVideoAd setConfigurationStaging]; break;
        }
        [SAVideoAd setTest:test];
        [SAVideoAd load: placementId];
        
    }
    
    /**
     *  Check to see if there is an video ad available
     *
     *  @return true / false
     */
    bool SuperAwesomeUnitySAVideoAdHasAdAvailable() {
        return [SAVideoAd hasAdAvailable];
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
    void SuperAwesomeUnitySAVideoAdPlay(bool isParentalGateEnabled,
                                        bool shouldShowCloseButton,
                                        bool shouldShowSmallClickButton,
                                        bool shouldAutomaticallyCloseAtEnd,
                                        bool shouldLockOrientation,
                                        int lockOrientation) {
        
        [SAVideoAd setIsParentalGateEnabled: isParentalGateEnabled];
        [SAVideoAd setShouldLockOrientation: shouldLockOrientation];
        [SAVideoAd setShouldShowCloseButton: shouldShowCloseButton];
        [SAVideoAd setShouldShowSmallClickButton: shouldShowSmallClickButton];
        [SAVideoAd setShouldAutomaticallyCloseAtEnd: shouldAutomaticallyCloseAtEnd];
        NSUInteger orientation = UIInterfaceOrientationMaskAll;
        switch (lockOrientation) {
            case 0: orientation = UIInterfaceOrientationMaskAll; break;
            case 1: orientation = UIInterfaceOrientationMaskPortrait; break;
            case 2: orientation = UIInterfaceOrientationMaskLandscape; break;
            default: orientation = UIInterfaceOrientationMaskAll; break;
        }
        [SAVideoAd setLockOrientation:orientation];
        
        UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
        [SAVideoAd play: root];
        
    }
}
