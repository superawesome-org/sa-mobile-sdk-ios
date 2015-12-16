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

// @brief:
// SASender is a class that contains a multitude of functions used to send
// messages to the server in case some event gets triggered regarding an Ad
// such as viewable impression, ad rating, etc
@interface SASender : NSObject

// @brief: this is just a "dumb" function that sends a GET request to the
// specified URL; it's a thing wrapper for SANetwork.sendGetToEndpoint() so that
// it's fire-and-forget
// @param: the URL to make the event request to
+ (void) sendEventToURL:(NSString*)url;

@end
