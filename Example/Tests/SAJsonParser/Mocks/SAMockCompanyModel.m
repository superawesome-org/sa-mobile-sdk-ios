//
//  SACompany.m
//  SAJsonParser
//
//  Created by Gabriel Coman on 27/05/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

#import "SAMockCompanyModel.h"

#import "SAMockEmployeeModel.h"

@implementation SAMockCompanyModel

- (id) initWithName:(NSString*)name andEmployees:(NSArray<SAMockEmployeeModel*>*)employees {
    if (self = [super init]) {
        _name = name;
        _employees = employees;
    }
    return self;
}

- (id) initWithJsonDictionary:(NSDictionary *)jsonDictionary {
    
    if (self = [super initWithJsonDictionary:jsonDictionary]) {
        
        _name = [jsonDictionary safeObjectForKey:@"name"];
        _employees = [[NSArray alloc] initWithJsonArray:[jsonDictionary safeObjectForKey:@"employees"] andIterator:^id(id item) {
            return [[SAMockEmployeeModel alloc] initWithJsonDictionary:(NSDictionary*)item];
        }];
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
        @"employees": nullSafe([_employees dictionaryRepresentation])
    };
}

@end
