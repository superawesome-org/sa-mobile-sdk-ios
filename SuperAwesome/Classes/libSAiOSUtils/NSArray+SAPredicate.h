//
//  NSArray+SAPredicate
//  libSAiOSUtils
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 16/12/2015.
//
//

#import <UIKit/UIKit.h>

//
// @brief: Category over NSArray that adds useful array functions
@interface NSArray (SAPredicate)

// function used to quickly search through an array, using a predicate,
// and return a filtered function based on member = value
- (NSArray*) filterBy:(NSString*) member withValue:(NSString*) value;

//
// the same function as before, only searching for a bool value to compare
// the current array elements to
- (NSArray*) filterBy:(NSString*) member withBool:(BOOL)value;

@end
