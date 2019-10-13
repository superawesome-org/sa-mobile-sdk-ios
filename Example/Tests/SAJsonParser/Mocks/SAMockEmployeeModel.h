//
//  SAEmployee.h
//  SAJsonParser
//
//  Created by Gabriel Coman on 27/05/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SABaseObject.h"

@class SAMockPositionModel;

@interface SAMockEmployeeModel : SABaseObject <SADeserializationProtocol, SASerializationProtocol>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, strong) SAMockPositionModel *current;
@property (nonatomic, strong) NSArray <SAMockPositionModel*> *previous;

- (id) initWithName:(NSString*)name
             andAge:(NSInteger)age
          andActive:(BOOL)isActive
         andCurrent:(SAMockPositionModel*) current
        andPrevious:(NSArray<SAMockPositionModel*>*)previous;

@end
