
#import "SuperAwesome.h"
#import "SAEvents.h"
#import "SAFileDownloader.h"

@implementation SuperAwesome

+ (void) initSDK: (BOOL) loggingEnabled {
    [SAEvents initMoat: loggingEnabled];
    [SAFileDownloader cleanup];
}

@end
