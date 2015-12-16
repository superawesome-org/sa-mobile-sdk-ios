//
//  SASystem.h
//  libSAiOSAdUtils
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 11/10/2015.
//
//

#import <UIKit/UIKit.h>

// imports for enums
#import "SASystemSize.h"
#import "SASystemType.h"

//
// @brief: this is a class that is used to get system information
@interface SASystem : NSObject

//
// @brief:
// function that gets the system type - because it's iOS - it will only
// return "ios"
// @return: constant - ios
+ (SASystemType) getSystemType;

//
// @brief:
// function that gets the system size
// @return: either mobile or tablet
+ (SASystemSize) getSystemSize;

//
// @brief:
// aux function that prints system information
+ (NSString*) getVerboseSystemDetails;

@end
