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
    NSLog(@"Ad:");
    NSLog(@"error: %ld", (long)_error);
    NSLog(@"placementId: %ld", (long)_placementId);
    NSLog(@"lineItemId: %ld", (long)_lineItemId);
    NSLog(@"campaignId: %ld", (long)_campaignId);
    NSLog(@"isTest: %d", _isTest);
    NSLog(@"isFallback: %d", _isFallback);
    NSLog(@"isFill: %d", _isFill);
    [_creative print];
    NSLog(@"adHTML: %@", _adHTML);
}

@end
