/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import <UIKit/UIKit.h>
#import "SABannerAd.h"
#import "SAInterstitialAd.h"
#import "SAVideoAd.h"
#import "SACallback.h"
#import "SAOrientation.h"
#import "SADefines.h"
#import "SAAgeCheck.h"

@interface SuperAwesome: NSObject
+ (void) initSDK: (BOOL) loggingEnabled;
+ (void) triggerAgeCheck: (NSString*) age response:(GetIsMinorBlock)response;
@end
