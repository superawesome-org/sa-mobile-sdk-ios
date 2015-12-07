//
//  SASystem.h
//  Pods
//
//  Created by Gabriel Coman on 01/12/2015.
//
//

#import <Foundation/Foundation.h>

// other imports
#import "SASystemSize.h"
#import "SASystemType.h"

@interface SASystem : NSObject

+ (SASystemType) getSystemType;
+ (SASystemSize) getSystemSize;
+ (NSString*) getVerboseSystemDetails;

@end
