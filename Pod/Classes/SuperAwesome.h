/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import <UIKit/UIKit.h>
#import "SABannerAd.h"
#import "SAInterstitialAd.h"
#import "SAVideoAd.h"
#import "SAAppWall.h"
#import "SACallback.h"
#import "SAOrientation.h"
#import "SACPI.h"

// define constants to lock the default / initial state
#define SA_DEFAULT_PLACEMENTID      0
#define SA_DEFAULT_TESTMODE         false
#define SA_DEFAULT_PARENTALGATE     true
#define SA_DEFAULT_CONFIGURATION    0
#define SA_DEFAULT_ORIENTATION      0
#define SA_DEFAULT_CLOSEBUTTON      false
#define SA_DEFAULT_SMALLCLICK       false
#define SA_DEFAULT_CLOSEATEND       true
#define SA_DEFAULT_BGCOLOR          false
#define SA_DEFAULT_BACKBUTTON       false

/**
 * This is a Singleton class through which SDK users setup their AwesomeAds instance
 */
@interface SuperAwesome : NSObject

/**
 * Singleton method to get the only existing instance
 *
 * @return an instance of the SuperAwesome class
 */
+ (instancetype) getInstance;

/**
 * Getter for a string comprising of SDK & version bundled
 *
 * @return  a string
 */
- (NSString*) getSdkVersion;

/**
 * SuperAwesome SDK method handling CPI
 *
 * @param response  callback block
 */
- (void) handleCPI:(saDidCountAnInstall) response;

/**
 * Method that overrides the current version string. 
 * It's used by the AIR & Unity SDKs
 *
 * @param version the new version
 */
- (void) overrideVersion: (NSString*) version;

/**
 * Method that overrides the current sdk string. 
 * It's used by the AIR & Unity SDKs
 *
 * @param sdk the new sdk
 */
- (void) overrideSdk: (NSString*) sdk;

@end
