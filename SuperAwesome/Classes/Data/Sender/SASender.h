//
//  SASender.h
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 11/10/2015.
//
//

#import <Foundation/Foundation.h>

// forward declaration
@class SAAd;

// @brief:
// SASender is a class that contains a multitude of functions used to send
// messages to the server in case some event gets triggered regarding an Ad
// such as viewable impression, ad rating, etc
@interface SASender : NSObject

// just send an event to a URL
+ (void) sendEventToURL:(NSString*)url;

@end
