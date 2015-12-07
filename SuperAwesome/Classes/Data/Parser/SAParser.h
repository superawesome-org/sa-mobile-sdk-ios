//
//  SAParser.h
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 11/10/2015.
//
//

#import <Foundation/Foundation.h>

// forward declarations
@class SAAd;
@class SACreative;
@class SADetails;

// callback for generic success with data
typedef void (^parsedad)(SAAd *parsedAd);

// @brief:
// The SAParser class acts as a repository of "static" class methods
// that deal with different aspects of parsing the JSON
// data that comes from the AA server
// @params:
// - A NSDictionary parser by ObjC from a JSON
// @return:
// - some kind of AA model object
@interface SAParser : NSObject

// function that finalises parsing of an object
+ (void) parseDictionary:(NSDictionary*)adDict withPlacementId:(NSInteger)placementId intoAd:(parsedad)parse;

@end
