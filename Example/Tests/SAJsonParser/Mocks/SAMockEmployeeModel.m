//
//  SAEmployee.m
//  SAJsonParser
//
//  Created by Gabriel Coman on 27/05/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

#import "SAMockEmployeeModel.h"
#import "SAMockPositionModel.h"

@implementation SAMockEmployeeModel

- (id) initWithJsonDictionary:(NSDictionary *)jsonDictionary {
    if (self = [super initWithJsonDictionary:jsonDictionary]) {
        
        _name = [jsonDictionary safeObjectForKey:@"name"];
        _age = [[jsonDictionary safeObjectForKey:@"age"] integerValue];
        _isActive = [[jsonDictionary safeObjectForKey:@"isActive"] boolValue];
        _current = [[SAMockPositionModel alloc] initWithJsonDictionary:[jsonDictionary safeObjectForKey:@"current"]];
        _previous = [[NSArray alloc] initWithJsonArray:[jsonDictionary safeObjectForKey:@"previous"] andIterator:^id(id item) {
            return [[SAMockPositionModel alloc] initWithJsonDictionary:(NSDictionary *)item];
        }];
    }
    return self;
}

- (id) initWithName:(NSString*)name
             andAge:(NSInteger)age
          andActive:(BOOL)isActive
         andCurrent:(SAMockPositionModel *)current
        andPrevious:(NSArray<SAMockPositionModel *> *)previous {
    
    if (self = [super init]) {
        _name = name;
        _age = age;
        _isActive = isActive;
        _current = current;
        _previous = previous;
    }
    
    return self;
}

- (BOOL) isValid {
    if (!_name) return false;
    return true;
}

- (NSDictionary*) dictionaryRepresentation {
    return @{
        @"name": nullSafe(_name),
        @"age": @(_age),
        @"isActive": @(_isActive),
        @"current": nullSafe([_current dictionaryRepresentation]),
        @"previous": nullSafe([_previous dictionaryRepresentation])
    };
}

@end
