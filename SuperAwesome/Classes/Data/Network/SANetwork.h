//
//  SANetwork.h
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 11/10/2015.
//
//

#import <Foundation/Foundation.h>

// callback for iOS's own [NSURLConnection sendAsynchronousRequest:]
typedef void (^netresponse)(NSURLResponse * response, NSData * data, NSError * error);

// callback for generic success with data
typedef void (^success)(NSData *data);

// callback for generic failure with no data
typedef void (^failure)();

//
// @brief: SANetwork is a thin wrapper around Objective-C's own
// network functions, basically resolving success and error responses
// to specific SA blocks;
// It also takes care of standardizing GET / POST requests for
// the SA servers needs
@interface SANetwork : NSObject

// @brief:
// perform POST request to server
// @params:
//  - endpoint: the URL to send the POST request to; must be full URL e.g. http://google.com
//  - POSTDict: a key-value dictionary that will get transformed to POST body
//  - success: callback function when the POST request has succedded; cannot be nil;
//  - failure: callback in case of error; can be nil;
+ (void) sendPOSTtoEndpoint:(NSString*)endpoint
               withBodyDict:(NSDictionary*)POSTDict
                 andSuccess:(success)success
                  orFailure:(failure)failure;

// @brief:
// perform GET request to server
//  - endpoint: the URL to send the POST request to; must be full URL e.g. http://google.com
//  - GETDict: a key-value dictionary that will get transformed to a query e.g. ?key1=value1&key2=value2
//  - success: callback function when the POST request has succedded; cannot be nil;
//  - failure: callback in case of error; can be nil;
+ (void) sendGETtoEndpoint:(NSString*)endpoint
             withQueryDict:(NSDictionary*)GETDict
                andSuccess:(success)success
                 orFailure:(failure)failure;

@end
