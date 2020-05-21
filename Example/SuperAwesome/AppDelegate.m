//
//  AppDelegate.m
//  SuperAwesome
//
//  Created by Gabriel Coman on 10/03/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

#import "AppDelegate.h"
#import "AwesomeAds.h"

#if __has_include(<GoogleMobileAds/GoogleMobileAds.h>)
#import <GoogleMobileAds/GoogleMobileAds.h>
#endif

@interface AppDelegate ()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    #if __has_include(<GoogleMobileAds/GoogleMobileAds.h>)
    [[GADMobileAds sharedInstance] startWithCompletionHandler:nil];
    #endif
    
    [AwesomeAds initSDK:true];
    return YES;
}

@end
