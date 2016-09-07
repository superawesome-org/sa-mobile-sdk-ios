//
//  SAInterstitialAd2.h
//  Pods
//
//  Created by Gabriel Coman on 02/09/2016.
//
//

#import <UIKit/UIKit.h>

// helper headers
#import "SAProtocol.h"
#import "SASession.h"

@interface SAInterstitialAd : UIViewController

// static "action" methods
+ (void) load:(NSInteger) placementId;
+ (void) play;
+ (BOOL) hasAdAvailable;

// static "state" methods
+ (void) setDelegate:(id<SAProtocol>) del;
+ (void) setIsParentalGateEnabled: (BOOL) value;
+ (void) setShouldLockOrientation: (BOOL) value;
+ (void) setLockOrientation: (NSUInteger) value;
+ (void) setTestEnabled;
+ (void) setTestDisabled;
+ (void) setConfigurationProduction;
+ (void) setConfigurationStaging;

@end
