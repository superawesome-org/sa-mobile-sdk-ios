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
@implementation SAAd

- (id) init {
    if (self = [super init]){
        _error = _app = _lineItemId = _campaignId = -1;
        _placementId = 0;
        _test = false;
        _isHouse = false;
        _isFill = true;
        _isFallback = false;
    }
    return self;
}

@end
