//
//  SAInstallEvent.h
//  Pods
//
//  Created by Gabriel Coman on 10/01/2017.
//
//

#import <Foundation/Foundation.h>

// event
typedef void (^didCountAnInstall)(BOOL success);

// guarded imports
@class SASession;

@interface SAInstallEvent : NSObject

- (void) sendEvent:(SASession*) session
      withCallback:(didCountAnInstall) didCountAnInstall;

@end
