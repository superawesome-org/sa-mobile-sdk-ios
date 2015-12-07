//
//  SAUserAgent.h
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 11/10/2015.
//
//

#import <Foundation/Foundation.h>

// class with static methods that checks to see what type of device is running
// (tablet or mobile) and returns an appropriate User Agent
@interface SAUserAgent : NSObject

// returns a valid user agent
+ (NSString*) getUserAgent;

@end
