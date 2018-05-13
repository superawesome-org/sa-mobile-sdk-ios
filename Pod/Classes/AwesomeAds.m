
#import "AwesomeAds.h"
#import "SAEvents.h"
#import "SAFileDownloader.h"

static BOOL isInitialised = false;

@implementation AwesomeAds

+ (void) initSDK: (BOOL) loggingEnabled {
    if (!isInitialised) {
        [SAEvents initMoat: loggingEnabled];
        [SAFileDownloader cleanup];
        isInitialised = true;
    }
}

+ (void) triggerAgeCheck: (NSString*) age response:(GetIsMinorBlock)response {
    [[SAAgeCheck sdk] getIsMinor:age :response];
}

@end
