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

@implementation SADetails

- (void) print {
    NSLog(@"\t Details:");
    NSLog(@"\t\t width: %ld", (long)_width);
    NSLog(@"\t\t height: %ld", (long)_height);
    NSLog(@"\t\t image: %@", _image);
    NSLog(@"\t\t name: %@", _name);
    NSLog(@"\t\t video: %@", _video);
    NSLog(@"\t\t bitrate: %ld", (long)_bitrate);
    NSLog(@"\t\t duration: %ld", (long)_duration);
    NSLog(@"\t\t vast: %@", _vast);
    NSLog(@"\t\t tag: %@", _tag);
    NSLog(@"\t\t placementFormat: %@", _placementFormat);
    NSLog(@"\t\t zip: %@", _zip);
    NSLog(@"\t\t url: %@", _url);
    NSLog(@"\t\t value: %ld", (long)_value);
}

@end
