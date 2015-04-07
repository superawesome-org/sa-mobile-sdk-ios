//
//  SAServerResponse.m
//  SAMobileSDK
//
//  Created by Balázs Kiss on 21/08/14.
//  Copyright (c) 2014 SuperAwesome Ltd. All rights reserved.
//

#import "SAServerResponse.h"

@implementation SAServerResponse

+(JSONKeyMapper*)keyMapper
{
    return [JSONKeyMapper mapperFromUnderscoreCaseToCamelCase];
}

@end
