//
//  SAJsonParser_Object_Serialization_Tests.m
//  SAJsonParser
//
//  Created by Gabriel Coman on 14/10/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SABaseObject.h"
#import "SAMockPositionModel.h"
#import "SAMockCompanyModel.h"
#import "SAMockEmployeeModel.h"

@interface TestSAJsonParser_WriteObject : XCTestCase
@end

@implementation TestSAJsonParser_WriteObject

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void) test_SAJsonparser_WriteObject_WithSimpleObject {
    // given
    SAMockPositionModel *given = [[SAMockPositionModel alloc] initWithName:@"CEO" andSalary:100000];
    
    // expected
    NSDictionary *expected = @{
                               @"name": @"CEO",
                               @"salary": @(100000)
                               };
    
    // result
    NSDictionary *result = [given dictionaryRepresentation];
    XCTAssertTrue([result isEqualToDictionary:expected]);
}

- (void) test_SAJsonparser_WriteObject_WithNestedObject {
    // given
    SAMockPositionModel *given1 = [[SAMockPositionModel alloc] initWithName:@"Junior Engineer" andSalary:28000];
    SAMockPositionModel *given2 = [[SAMockPositionModel alloc] initWithName:@"Engineer" andSalary:35000];
    SAMockEmployeeModel *given = [[SAMockEmployeeModel alloc] initWithName:@"Jim" andAge:23 andActive:true andCurrent:given2 andPrevious:@[given1]];
    
    // expected
    NSDictionary *expected = @{
                               @"name": @"Jim",
                               @"age": @(23),
                               @"isActive": @(true),
                               @"current": @{@"name": @"Engineer", @"salary": @(35000)},
                               @"previous": @[
                                       @{@"name": @"Junior Engineer", @"salary": @(28000)}
                                       ]
                               };
    
    // result
    NSDictionary *result = [given dictionaryRepresentation];
    XCTAssertTrue([result isEqualToDictionary:expected]);
}

- (void) test_SAJsonparser_WriteObject_WithVeryComplexObject {
    // given
    SAMockPositionModel *given00 = [[SAMockPositionModel alloc] initWithName:@"Intern" andSalary:0];
    SAMockPositionModel *given11 = [[SAMockPositionModel alloc] initWithName:@"Junior Engineer" andSalary:28000];
    SAMockPositionModel *given12 = [[SAMockPositionModel alloc] initWithName:@"Engineer" andSalary:35000];
    
    SAMockEmployeeModel *given1 = [[SAMockEmployeeModel alloc] initWithName:@"John" andAge:23 andActive:true andCurrent:given11 andPrevious:@[given00]];
    SAMockEmployeeModel *given2 = [[SAMockEmployeeModel alloc] initWithName:@"Danna" andAge:18 andActive:false andCurrent:given12 andPrevious:@[given00, given11]];
    
    SAMockCompanyModel *given = [[SAMockCompanyModel alloc] initWithName:@"John Smith Ltd." andEmployees:@[given1, given2]];
    
    // expected
    NSDictionary *expected = @{
                               @"name": @"John Smith Ltd.",
                               @"employees":@[
                                       @{
                                           @"name": @"John",
                                           @"age": @(23),
                                           @"isActive": @(true),
                                           @"current": @{@"name": @"Junior Engineer", @"salary": @(28000)},
                                           @"previous": @[
                                                   @{@"name":@"Intern", @"salary": @(0)}
                                                   ]
                                           },
                                       @{
                                           @"name": @"Danna",
                                           @"age": @(18),
                                           @"isActive": @(false),
                                           @"current": @{@"name":@"Engineer", @"salary": @(35000)},
                                           @"previous": @[
                                                   @{@"name":@"Intern", @"salary": @(0)},
                                                   @{@"name":@"Junior Engineer", @"salary": @(28000)}
                                                   ]
                                           }
                                       ]
                               };
    
    // result
    NSDictionary *result = [given dictionaryRepresentation];
    XCTAssertTrue([result isEqualToDictionary:expected]);
}

- (void) test_SAJsonparser_WriteObject_WithNulls {
    // given
    SAMockPositionModel *given1 = [[SAMockPositionModel alloc] initWithName:@"Junior Engineer" andSalary:28000];
    SAMockEmployeeModel *given = [[SAMockEmployeeModel alloc] initWithName:NULL andAge:32 andActive:false andCurrent:nil andPrevious:@[given1]];
    
    // expected
    NSDictionary *expected = @{
                               @"name": [NSNull null],
                               @"age": @(32),
                               @"isActive": @(false),
                               @"current": [NSNull null],
                               @"previous": @[
                                       @{@"name": @"Junior Engineer", @"salary": @(28000)}
                                       ]
                               };
    
    // result
    NSDictionary *result = [given dictionaryRepresentation];
    XCTAssertTrue([result isEqualToDictionary:expected]);
}

@end
