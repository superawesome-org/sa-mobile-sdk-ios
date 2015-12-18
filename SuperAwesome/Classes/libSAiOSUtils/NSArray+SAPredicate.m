//
//  NSArray+SAPredicate.m
//  libSAiOSUtils
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 16/12/2015.
//
//

#import "NSArray+SAPredicate.h"

@implementation NSArray (SAPredicate)

- (NSArray*) filterBy:(NSString*) member withValue:(NSString*) value {
    // get a mutable copy of self
    NSMutableArray *_mutableSelf = [self mutableCopy];
    
    // form the simple predicate
    NSPredicate *searchPred = [NSPredicate predicateWithFormat:@"%K CONTAINS[c] %@", member, value];
    
    // return it filtered
    return [_mutableSelf filteredArrayUsingPredicate:searchPred];
}

- (NSArray*) filterBy:(NSString *)member withBool:(BOOL)value {
    // get a mutable copy of self
    NSMutableArray *_mutableSelf = [self mutableCopy];
    
    // form the simple predicate
    NSPredicate *searchPref = [NSPredicate predicateWithFormat:@"%K == %d", member, value];
    
    // return filter
    return [_mutableSelf filteredArrayUsingPredicate:searchPref];
}

- (NSArray*) removeAllButFirstElement {
    NSMutableArray *_mutableSelf = [self mutableCopy];
    
    if (_mutableSelf.count >= 1) {
        return [[NSMutableArray alloc] initWithObjects:[_mutableSelf firstObject], nil];
    } else {
        return _mutableSelf;
    }
}

@end
