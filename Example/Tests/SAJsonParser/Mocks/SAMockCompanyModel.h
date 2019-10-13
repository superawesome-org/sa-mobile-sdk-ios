//
//  SACompany.h
//  SAJsonParser
//
//  Created by Gabriel Coman on 27/05/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SABaseObject.h"

@class SAMockEmployeeModel;

@interface SAMockCompanyModel : SABaseObject <SADeserializationProtocol, SASerializationProtocol>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray <SAMockEmployeeModel*> *employees;

- (id) initWithName:(NSString*)name andEmployees:(NSArray<SAMockEmployeeModel*>*)employees;

@end
