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

//
// @brief:
// class with static methods that checks to see what type of device is running
// (tablet or mobile) and returns an appropriate User Agent
@interface SAUserAgent : NSObject

//
// @brief: this functions uses the SASystem functions to determine if the app
// runs on either android, ios, desktop, if its size is mobile, tablet or desktop
// and then return the specific User Agent;
// SANetwork uses this function to send the correct User Agent so that the ad server
// knows how to split requests when counting them
+ (NSString*) getUserAgent;

@end
