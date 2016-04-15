//
//  SAAd.m
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 28/09/2015.
//
//

// import this model's header
#import "SAAd.h"
#import "SACreative.h"

@implementation SAAd

- (void) print {
    NSMutableString *result = [[NSMutableString alloc] init];
    [result appendFormat:@"\nAd:"];
    [result appendFormat:@"\nerror: %ld", (long)_error];
    [result appendFormat:@"\nappId: %ld", (long)_appId];
    [result appendFormat:@"\nplacementId: %ld", (long)_placementId];
    [result appendFormat:@"\nlineItemId: %ld", (long)_lineItemId];
    [result appendFormat:@"\ncampaignId: %ld", (long)_campaignId];
    [result appendFormat:@"\nisTest: %d", _isTest];
    [result appendFormat:@"\nisFallback: %d", _isFallback];
    [result appendFormat:@"\nisFill: %d", _isFill];
    [result appendFormat:[_creative print]];
    NSLog(@"%@", result);
}

@end
