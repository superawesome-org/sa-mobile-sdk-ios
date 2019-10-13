//
//  SAPosition.m
//  SAJsonParser
//
//  Created by Gabriel Coman on 31/05/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

#import "SAMockPositionModel.h"

@implementation SAMockPositionModel

- (id) initWithJsonDictionary:(NSDictionary *)jsonDictionary {
    if (self = [super initWithJsonDictionary:jsonDictionary]){
        
        _name = [jsonDictionary safeObjectForKey:@"name"];
        _salary = [[jsonDictionary safeObjectForKey:@"salary"] integerValue];
    }
    return self;
}

- (id) initWithName:(NSString*)name andSalary:(NSInteger)salary {
    if (self = [super init]){
        _name = name;
        _salary = salary;
    }
    return self;
}

- (NSDictionary*) dictionaryRepresentation {
    return @{
        @"name": nullSafe(_name),
        @"salary": @(_salary)
    };
}

@end
