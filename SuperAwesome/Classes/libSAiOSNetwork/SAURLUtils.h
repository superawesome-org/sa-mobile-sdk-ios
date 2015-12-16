//
//  SAURLUtils.h
//  libSAiOSAdUtils
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 02/12/2015.
//
//

#import <UIKit/UIKit.h>

// @brief:
// A class containing a random assortment of functions for different uses
@interface SAURLUtils : NSObject

// get cache buster
+ (NSInteger) getCachebuster;

// returns a GET query string from a dictionary
+ (NSString*) formGetQueryFromDict:(NSDictionary*)dict;

// encode as URI
+ (NSString*) encodeURI:(NSString*)stringToEncode;

// returns an encoded JSON from a dictionary
// should be used as part of a GET query
+ (NSString*) encodeJSONDictionaryFromNSDictionary:(NSDictionary*)dict;

// function that validates URL
+ (BOOL) isValidURL:(NSObject*) urlObject;

@end
