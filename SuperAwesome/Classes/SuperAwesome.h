//
//  SuperAwesome.h
//  SAMobileSDK
//
//  Created by Balázs Kiss on 29/07/14.
//  Copyright (c) 2014 SuperAwesome Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SAAdManager.h"

// import parental gate
#import "SAParentalGate.h"
#import "SAPadlockView.h"

//Advertising Classes
#import "SABannerView.h"
#import "SAInterstitialView.h"
#import "SAAdResponse.h"
#import "SAAdCreative.h"
#import "SAEventManager.h"
#import "SAVideoAdView.h"
#import "SAVideoAdViewController.h"

typedef NS_ENUM(NSUInteger, SAClientConfiguration) {
    SAClientConfigurationDevelopment,
    SAClientConfigurationStaging,
    SAClientConfigurationProduction
};

typedef NS_ENUM(NSUInteger, SALoggingLevel) {
    SALoggingLevelNone,
    SALoggingLevelError,
    SALoggingLevelWarning,
    SALoggingLevelInfo,
    SALoggingLevelDebug
};

/**
 *  SuperAwesome Mobile SDK Main Class
 */
@interface SuperAwesome : NSObject

/**
 *  SDK client configuration
 */
@property (nonatomic,assign) SAClientConfiguration clientConfiguration;

@property (nonatomic,assign,getter=isTestModeEnabled) BOOL testModeEnabled;

@property (nonatomic,strong) SAAdManager *adManager;

@property (nonatomic,assign) SALoggingLevel loggingLevel;

- (NSString*) version;
- (NSString*) platform;
- (NSString*) sdkVersion;

/**
 *  Returns singleton instance
 *
 *  @return singleton instance
 */
+ (SuperAwesome *)sharedManager;

@end
