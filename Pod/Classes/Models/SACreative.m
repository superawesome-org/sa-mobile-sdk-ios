//
//  SACreative.m
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 28/09/2015.
//
//

// import this model's header
#import "SACreative.h"
#import "SADetails.h"

@implementation SACreative

- (NSString*) print {
    NSMutableString *result = [[NSMutableString alloc] init];
    [result appendFormat:@"\nCreative:"];
    [result appendFormat:@"\n\t creativeId: %ld", (long)_creativeId];
    [result appendFormat:@"\n\t name: %@", _name];
    [result appendFormat:@"\n\t cpm: %ld", (long)_cpm];
    [result appendFormat:@"\n\t baseFormat: %@", _baseFormat];
    [result appendFormat:@"\n\t format: %ld", (long)_format];
    [result appendFormat:@"\n\t impressionURL: %@", _impressionURL];
    [result appendFormat:@"\n\t viewableImpressionURL: %@", _viewableImpressionURL];
    [result appendFormat:@"\n\t clickURL: %@", _clickURL];
    [result appendFormat:@"\n\t trackingURL: %@", _trackingURL];
    [result appendFormat:@"\n\t parentalGateClickURL %@", _parentalGateClickURL];
    [result appendFormat:@"\n\t approved: %d", _approved];
    [result appendFormat:@"%@", [_details print]];
    return result;
}

@end
