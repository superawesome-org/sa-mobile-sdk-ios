//
//  SAValidator.h
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 11/10/2015.
//
//

#import <Foundation/Foundation.h>

@class SAAd;

// @brief:
// Important class that acts as validator for an Ad. Each time an ad is loaded
// from the network, this function makes sure that
// a) It's loaded metadata OK
// b) based on specific types of ads, some fields are mandatory
// If these conditions are not met, the ad is not valid and should not
// be displayed
@interface SAValidator : NSObject

// function that validates an Ad
+ (BOOL) isAdDataValid:(SAAd*)ad;

@end
