//
//  SATokenResponse.m
//  SAMobileSDK
//
//  Created by Balázs Kiss on 07/08/14.
//  Copyright (c) 2014 SuperAwesome Ltd. All rights reserved.
//

#import "SATokenResponse.h"

@implementation SATokenResponse

+(JSONKeyMapper*)keyMapper
{
    return [JSONKeyMapper mapperFromUnderscoreCaseToCamelCase];
}

@end
