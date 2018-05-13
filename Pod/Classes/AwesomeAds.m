
#import "AwesomeAds.h"
#import "SAEvents.h"
#import "SAFileDownloader.h"

@implementation AwesomeAds

+ (void) initSDK: (BOOL) loggingEnabled {
    [SAEvents initMoat: loggingEnabled];
    [SAFileDownloader cleanup];
}

+ (void) triggerAgeCheck: (NSString*) age response:(GetIsMinorBlock)response {
    [[SAAgeCheck sdk] getIsMinor:age :response];
}

@end
