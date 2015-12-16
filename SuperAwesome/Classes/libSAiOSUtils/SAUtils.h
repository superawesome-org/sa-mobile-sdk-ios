//
//  SAUtils.h
//  libSAiOSUtils
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 02/12/2015.
//
//

#import <UIKit/UIKit.h>

// @brief:
// A class containing a random assortment of functions for different uses
@interface SAUtils : NSObject

// Aux function that basically projects a square into another square
// @params:
// - frame: it's the parent frame to report to
// - oldframe: the old frame of the object, from which I'm trying to project from
// @return:
// - a CGRect of the position and size to which to resize the view
+ (CGRect) arrangeAdInNewFrame:(CGRect)frame fromFrame:(CGRect)oldframe;

// Aux function to calc a random number between two bounds
+ (NSInteger) randomNumberBetween:(NSInteger)min maxNumber:(NSInteger)max;

// find the substring between two other substrings
+ (NSString*) findSubstringFrom:(NSString*)source betweenStart:(NSString*)start andEnd:(NSString*)end;

@end
