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

@implementation SACreative

- (id) init {
    if (self = [super init]) {
        __id = -1;
        _cpm = 0;
        _live = true;
        _approved = true;
        
    }
    
    return self;
}

@end
