//
//  SuperAwesome.h
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 28/09/2015.
//
//

#import <Foundation/Foundation.h>

// import system
#import "SAUtils.h"

// import model header files
#import "SAAd.h"
#import "SACreative.h"
#import "SADetails.h"
#import "SAMedia.h"
#import "SATracking.h"

// import load
#import "SALoader.h"

// import views
#import "SABannerAd.h"
#import "SAInterstitialAd.h"
#import "SAVideoAd.h"

// load protocols
#import "SAProtocols.h"

// @brief:
// This is the main SuperAwesome class that handles the Ad Session
// as a singleton (enable / disable test mode, configuration, version, etc)
@interface SuperAwesome : NSObject

// singleton instance (instead of init)
+ (instancetype)getInstance;

// setters
- (void) setConfiguration:(NSInteger)configuration;
- (void) setConfigurationProduction;
- (void) setConfigurationStaging;
- (void) setTesting:(BOOL)enabled;
- (void) disableTestMode;
- (void) enableTestMode;

// getters
- (NSString*) getSdkVersion;
- (NSString*) getBaseURL;
- (BOOL) isTestingEnabled;
- (NSInteger) getConfiguration;
- (NSUInteger) getDAUID;

// load ad function
- (void) loadAd:(NSInteger) placementId;
- (BOOL) hasAdForPlacement: (NSInteger) placementId;
- (SAAd*) getAdForPlacement:(NSInteger) placementId;

@end
