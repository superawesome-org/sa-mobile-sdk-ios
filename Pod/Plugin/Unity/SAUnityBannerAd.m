/**
 * @Copyright:  SuperAwesome Trading Limited 2022
 * @Author:     Gabriel Coman (gabriel.coman@superawesome.com), Gunhan Sancar (gunhan.sancar@superawesome.com)
 */

#import "SAUnityCallback.h"
#import <SuperAwesome/SuperAwesome-Swift.h>

// A dictionary that holds Unity banners
NSMutableDictionary *bannerDictionary = nil;

/**
 * Native method called from Unity.
 * Function that creates a new SABannerAd instance
 *
 * @param unityName the name of the banner in unity
 */
void SuperAwesomeUnitySABannerAdCreate (const char *unityName) {
    // get the key
    __block NSString *key = [NSString stringWithUTF8String:unityName];
    
    // create a new banner
    SABannerAd *banner = [[SABannerAd alloc] init];

    // set banner callback
    [banner setCallback:^(NSInteger placementId, SAEvent event) {
        switch (event) {
            case SAEventAdLoaded: unitySendAdCallback(key, placementId, @"adLoaded"); break;
            case SAEventAdEmpty: unitySendAdCallback(key, placementId, @"adEmpty"); break;
            case SAEventAdFailedToLoad: unitySendAdCallback(key, placementId, @"adFailedToLoad"); break;
            case SAEventAdAlreadyLoaded: unitySendAdCallback(key, placementId, @"adAlreadyLoaded"); break;
            case SAEventAdShown: unitySendAdCallback(key, placementId, @"adShown"); break;
            case SAEventAdFailedToShow: unitySendAdCallback(key, placementId, @"adFailedToShow"); break;
            case SAEventAdClicked: unitySendAdCallback(key, placementId, @"adClicked"); break;
            case SAEventAdEnded: unitySendAdCallback(key, placementId, @"adEnded"); break;
            case SAEventAdClosed: unitySendAdCallback(key, placementId, @"adClosed"); break;
        }
    }];

    if (bannerDictionary == nil) {
        bannerDictionary = [[NSMutableDictionary alloc] init];
    }

    // save the banner
    [bannerDictionary setObject:banner forKey:key];
}

/**
 * Native method called from Unity.
 * Function that loads an ad for a banner
 *
 * @param unityName     the unique name of the banner in unity
 * @param placementId   placement id to load the ad for
 * @param configuration production = 0 / staging = 1 --- deprecated
 * @param test          true / false
 */
void SuperAwesomeUnitySABannerAdLoad (const char *unityName, int placementId, int configuration, bool test) {
    // get the key
    NSString *key = [NSString stringWithUTF8String:unityName];

    if (bannerDictionary == nil) {
        bannerDictionary = [[NSMutableDictionary alloc] init];
    }

    if ([bannerDictionary objectForKey:key]) {
        
        SABannerAd *banner = [bannerDictionary objectForKey:key];
        [banner setTestMode:test];
        [banner load:placementId];
        
    } else {
        // handle failure
    }
}

/**
 * Native method called from Unity.
 * Function that checks wheter a banner has a loaded ad available or not
 *
 * @param unityName the unique name of the banner in unity
 *
 * @return          true of false
 */
bool SuperAwesomeUnitySABannerAdHasAdAvailable (const char *unityName) {
    // get the key
    NSString *key = [NSString stringWithUTF8String:unityName];

    if (bannerDictionary == nil) {
        bannerDictionary = [[NSMutableDictionary alloc] init];
    }

    if ([bannerDictionary objectForKey:key]) {
        SABannerAd *banner = [bannerDictionary objectForKey:key];
        return [banner hasAdAvailable];
    }

    return false;
}

/**
 * Native method called from Unity.
 * Function that plays a banner ad in unity
 *
 * @param unityName             the unique name of the banner in unity
 * @param isParentalGateEnabled true / false
 * @param isBumperPageEnabled   true / false
 * @param position              TOP = 0 / BOTTOM = 1
 * @param color                 true = transparent / false = gray
 */
void SuperAwesomeUnitySABannerAdPlay (const char *unityName, bool isParentalGateEnabled, bool isBumperPageEnabled, int position, int width, int height, bool color)
{
    // get the key
    NSString *key = [NSString stringWithUTF8String:unityName];

    if (bannerDictionary == nil) {
        bannerDictionary = [[NSMutableDictionary alloc] init];
    }
    
    if ([bannerDictionary objectForKey:key] && ![[bannerDictionary objectForKey:key] isClosed]) {

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

        // get banner
        __block SABannerAd *banner = [bannerDictionary objectForKey:key];
        [banner setParentalGate:isParentalGateEnabled];
        [banner setBumperPage:isBumperPageEnabled];
        [banner setColor:color];
        [root.view addSubview:banner];

        // setup constraints
        banner.translatesAutoresizingMaskIntoConstraints = false;
        [root.view removeConstraints:[banner constraints]];

        if (position == 0) {
            // Align to the top
            [banner.topAnchor constraintEqualToAnchor:root.topLayoutGuide.bottomAnchor].active = YES;
        } else {
            // Align to the bottom
            [banner.bottomAnchor constraintEqualToAnchor:root.bottomLayoutGuide.topAnchor].active = YES;
        }
        [banner.widthAnchor constraintEqualToConstant:realSize.width].active = YES;
        [banner.heightAnchor constraintEqualToConstant:realSize.height].active = YES;
        [banner.centerXAnchor constraintEqualToAnchor:root.view.centerXAnchor].active = YES;

        // finally play
        [banner play];
    } else {
        // handle failure
    }
}

/**
 * Native method called from Unity.
 * Function that closes and removes a banner from view
 *
 * @param unityName the unique name of the banner in unity
 */
void SuperAwesomeUnitySABannerAdClose (const char *unityName) {
    // get the key
    NSString *key = [NSString stringWithUTF8String:unityName];

    if (bannerDictionary == nil) {
        bannerDictionary = [[NSMutableDictionary alloc] init];
    }
    
    if ([bannerDictionary objectForKey:key]) {
        SABannerAd *banner = [bannerDictionary objectForKey:key];
        [banner close];
        [banner removeFromSuperview];
    } else {
        // handle failure
    }
}
