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

- (void) print {
    NSLog(@"Creative:");
    NSLog(@"\t creativeId: %ld", (long)_creativeId);
    NSLog(@"\t name: %@", _name);
    NSLog(@"\t cpm: %ld", (long)_cpm);
    NSLog(@"\t baseFormat: %@", _baseFormat);
    NSLog(@"\t format: %ld", (long)_format);
    NSLog(@"\t impressionURL: %@", _impressionURL);
    NSLog(@"\t clickURL: %@", _clickURL);
    NSLog(@"\t trackingURL: %@", _trackingURL);
    NSLog(@"\t fullClickURL: %@", _fullClickURL);
    NSLog(@"\t isFullClickURLReliable: %d", _isFullClickURLReliable);
    NSLog(@"\t viewableImpressionURL: %@", _viewableImpressionURL);
    NSLog(@"\t approved: %d", _approved);
    [_details print];
}

@end
