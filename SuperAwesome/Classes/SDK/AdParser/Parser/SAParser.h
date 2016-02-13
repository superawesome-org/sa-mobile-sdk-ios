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
// The SAParser class acts contains one static function that parses a
// network-received dictionary into an Ad
// @param - adDict: A NSDictionary parser by ObjC from a JSON
// @param - placementId - the placement id of the ad that's been requested
// @param - parse - a callback that actually returns the ad
@interface SAParser : NSObject

// parsing function
+ (SAAd*) parseAdFromDictionary:(NSDictionary*)adDict withPlacementId:(NSInteger)placementId;

@end
