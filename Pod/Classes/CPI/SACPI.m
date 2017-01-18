//
//  SACPI.m
//  Pods
//
//  Created by Gabriel Coman on 25/08/2016.
//
//

#import "SACPI.h"

// guarded imports
#if defined(__has_include)
#if __has_include(<SASession/SASession.h>)
#import <SASession/SASession.h>
#else
#import "SASession.h"
#endif
#endif

@interface SACPI ()
@end

@implementation SACPI

- (void) sendInstallEvent: (SASession*) session
             withCallback: (didCountAnInstall) didCountAnInstall {
    
    SAInstallEvent *installEvent = [[SAInstallEvent alloc] init];
    [installEvent sendEvent:session withCallback:didCountAnInstall];
    
}

@end
