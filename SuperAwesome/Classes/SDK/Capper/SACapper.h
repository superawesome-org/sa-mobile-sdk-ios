//
//  SACapper.h
//  Pods
//
//  Created by Gabriel Coman on 16/02/2016.
//
//

#import <Foundation/Foundation.h>

@interface SACapper : NSObject

// enable the DAUId
- (void) enableDeviceAppUserId;

// function that returns the DAU Id
- (NSUInteger) getDAUId;

@end
