
#import "AwesomeAds.h"
#import "SAEvents.h"
#import "SAFileDownloader.h"
#import <SuperAwesome/SuperAwesome-Swift.h>

static BOOL isInitialised = false;

@implementation AwesomeAds

+ (void) initSDK: (BOOL) loggingEnabled {
    if (!isInitialised) {
        NSLog(@"Initialising AwesomeAds");
        [SAEvents initMoat: loggingEnabled];
        [SAFileDownloader cleanup];
        [SADependencyContainer initModules: SAModuleContainer.new];
        isInitialised = true;
    } else {
        NSLog(@"Already initialised AwesomeAds");
    }
}

+ (void) triggerAgeCheck: (NSString*) age response:(GetIsMinorBlock)response {
    [[SAAgeCheck sdk] getIsMinor:age :response];
}

@end
