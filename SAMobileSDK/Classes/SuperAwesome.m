//
//  SuperAwesome.m
//  SAMobileSDK
//
//  Created by Balázs Kiss on 29/07/14.
//  Copyright (c) 2014 SuperAwesome Ltd. All rights reserved.
//

#import "SuperAwesome.h"

@implementation SuperAwesome

- (instancetype)init
{
    if(self = [super init]){
        [ATBaseConfiguration setLoggingLevel:kATLogOff];
    }
    return self;
}

@end
