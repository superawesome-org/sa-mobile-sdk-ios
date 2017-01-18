//
//  SACPI.h
//  Pods
//
//  Created by Gabriel Coman on 25/08/2016.
//
//

#import <Foundation/Foundation.h>

// import local files
#import "SAInstallEvent.h"

@interface SACPI : NSObject

- (void) sendInstallEvent: (SASession*) session
             withCallback: (didCountAnInstall) didCountAnInstall;

@end
