#import <Foundation/Foundation.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "SAOrientation.h"
#import "SASession.h"
#import "SAPlaybackMode.h"

@interface SAAdMobVideoExtra : NSObject <GADAdNetworkExtras>

@property (nonatomic, assign) BOOL testEnabled;
@property (nonatomic, assign) SAOrientation orientation;
@property (nonatomic, assign) SAConfiguration configuration;
@property (nonatomic, assign) SAPlaybackMode playback;
@property (nonatomic, assign) BOOL parentalGateEnabled;
@property (nonatomic, assign) BOOL bumperPageEnabled;
@property (nonatomic, assign) BOOL closeButtonEnabled;
@property (nonatomic, assign) BOOL closeAtEndEnabled;
@property (nonatomic, assign) BOOL smallCLickEnabled;

@end

#define kKEY_TEST           @"SA_TEST_MODE"
#define kKEY_TRANSPARENT    @"SA_TRANSPARENT"
#define kKEY_ORIENTATION    @"SA_ORIENTATION"
#define kKEY_CONFIGURATION  @"SA_CONFIGURATION"
#define kKEY_PLAYBACK_MODE  @"SA_PLAYBACK_MODE"
#define kKEY_PARENTAL_GATE  @"SA_PG"
#define kKEY_BUMPER_PAGE    @"SA_BUMPER"
#define kKEY_BACK_BUTTON    @"SA_BACK_BUTTON"
#define kKEY_CLOSE_BUTTON   @"SA_CLOSE_BUTTON"
#define kKEY_CLOSE_AT_END   @"SA_CLOSE_AT_END"
#define kKEY_SMALL_CLICK    @"SA_SMALL_CLICK"

@interface SAAdMobCustomEventExtra : NSMutableDictionary {
    NSMutableDictionary *_dict;
}

@property (nonatomic, assign) BOOL trasparentEnabled;
@property (nonatomic, assign) BOOL testEnabled;
@property (nonatomic, assign) SAConfiguration configuration;
@property (nonatomic, assign) BOOL parentalGateEnabled;
@property (nonatomic, assign) BOOL bumperPageEnabled;
@property (nonatomic, assign) SAOrientation orientation;

@end
