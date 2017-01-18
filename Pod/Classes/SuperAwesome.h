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

// import views
#import "SABannerAd.h"
#import "SAInterstitialAd.h"
#import "SAVideoAd.h"
#import "SAAppWall.h"

// load callback header
#import "SACallback.h"
#import "SAOrientation.h"

// import SACPI
#import "SACPI.h"


// define constants to lock the default / initial state
#define SA_DEFAULT_PLACEMENTID 0
#define SA_DEFAULT_TESTMODE false
#define SA_DEFAULT_PARENTALGATE true
#define SA_DEFAULT_CONFIGURATION 0
#define SA_DEFAULT_ORIENTATION 0
#define SA_DEFAULT_CLOSEBUTTON false
#define SA_DEFAULT_SMALLCLICK false
#define SA_DEFAULT_CLOSEATEND true
#define SA_DEFAULT_BGCOLOR false
#define SA_DEFAULT_BACKBUTTON false

// @brief:
// This is the main SuperAwesome class that handles the Ad Session
// as a singleton (enable / disable test mode, configuration, version, etc)
@interface SuperAwesome : NSObject

// singleton instance (instead of init)
+ (instancetype) getInstance;

// get the dau id and the version
- (NSString*) getSdkVersion;
- (void) handleCPI:(didCountAnInstall)didCountAnInstall;
- (void) handleStagingCPI:(didCountAnInstall)didCountAnInstall;

// override methods
- (void) overrideVersion: (NSString*) version;
- (void) overrideSdk: (NSString*) sdk;

@end
