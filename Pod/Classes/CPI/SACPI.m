/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import "SACPI.h"

#if defined(__has_include)
#if __has_include(<SASession/SASession.h>)
#import <SASession/SASession.h>
#else
#import "SASession.h"
#endif
#endif

@implementation SACPI

- (void) sendInstallEvent: (SASession*) session
             withCallback: (saDidCountAnInstall) response {
    
    // create a new instance of the install event class
    SAInstallEvent *installEvent = [[SAInstallEvent alloc] init];
    
    // send the event
    [installEvent sendEvent:session withCallback:response];
    
}

@end
