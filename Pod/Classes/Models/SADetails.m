//
//  SADetails.m
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 28/09/2015.
//
//

#import "SADetails.h"
#import "SAData.h"

@implementation SADetails

- (NSString*) print {
    NSMutableString *result = [[NSMutableString alloc] init];
    [result appendFormat:@"\n\t Details:"];
    [result appendFormat:@"\n\t\t width: %ld", (long)_width];
    [result appendFormat:@"\n\t\t height: %ld", (long)_height];
    [result appendFormat:@"\n\t\t image: %@", _image];
    [result appendFormat:@"\n\t\t name: %@", _name];
    [result appendFormat:@"\n\t\t video: %@", _video];
    [result appendFormat:@"\n\t\t bitrate: %ld", (long)_bitrate];
    [result appendFormat:@"\n\t\t duration: %ld", (long)_duration];
    [result appendFormat:@"\n\t\t vast: %@", _vast];
    [result appendFormat:@"\n\t\t tag: %@", _tag];
    [result appendFormat:@"\n\t\t placementFormat: %@", _placementFormat];
    [result appendFormat:@"\n\t\t zip: %@", _zip];
    [result appendFormat:@"\n\t\t url: %@", _url];
    [result appendFormat:@"\n\t\t value: %ld", (long)_value];
    [result appendFormat:@"%@", [_data print]];
    return result;
}

@end
