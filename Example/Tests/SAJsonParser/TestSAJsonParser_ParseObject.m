//
//  SAJsonParser_Object_Deserialization_Tests.m
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

@interface TestSAJsonParser_ParseObject : XCTestCase
@end

@implementation TestSAJsonParser_ParseObject

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) test_SAJsonParser_ParseObject_WithSimpleObjects {
    // given
    NSString *given0 = @"{ \"name\": \"Intern\", \"salary\": 0 }";
    NSString *given1 = @"{ \"name\": \"Junior Engineer\", \"salary\": 28000 }";
    NSString *given = [NSString stringWithFormat:@"{ \"name\": \"John\", \"age\": 32, \"isActive\": 1, \"current\":%@, \"previous\":[%@] }",
                       given1, given0];
    
    // expected
    SAMockPositionModel *expected0 = [[SAMockPositionModel alloc] initWithName:@"Intern" andSalary:0];
    SAMockPositionModel *expected1 = [[SAMockPositionModel alloc] initWithName:@"Junior Engineer" andSalary:28000];
    SAMockEmployeeModel *expected = [[SAMockEmployeeModel alloc] initWithName:@"John" andAge:32 andActive:true andCurrent:expected1 andPrevious:@[expected0]];
    
    // then
    SAMockEmployeeModel *result = [[SAMockEmployeeModel alloc] initWithJsonString:given];
    XCTAssertTrue([result.name isEqualToString:expected.name]);
    XCTAssertTrue(result.age = expected.age);
    XCTAssertTrue(result.isActive = expected.isActive);
    XCTAssertTrue([result isValid] == true);
    
}

- (void) testComplexModel {
    // given
    NSString *given1 = @"{ \"name\": \"John\", \"age\": 32, \"isActive\": 1 }";
    NSString *given2 = @"{ \"name\": \"Abe\", \"age\": 18 }";
    NSString *given = [NSString stringWithFormat:@"{ \"name\": \"James Smith Ltd\", \"employees\": [%@, %@]}", given1, given2];
    
    // expected
    SAMockEmployeeModel *expected1 = [[SAMockEmployeeModel alloc] initWithName:@"John" andAge:32 andActive:true andCurrent:nil andPrevious:nil];
    SAMockEmployeeModel *expected2 = [[SAMockEmployeeModel alloc] initWithName:@"Abe" andAge:18 andActive:false andCurrent:nil andPrevious:@[]];
    SAMockCompanyModel *expected = [[SAMockCompanyModel alloc] initWithName:@"James Smith Ltd" andEmployees:@[expected1, expected2]];
    
    // then
    SAMockCompanyModel *result = [[SAMockCompanyModel alloc] initWithJsonString:given];
    SAMockEmployeeModel *result1 = result.employees[0];
    XCTAssertTrue([result.name isEqualToString:expected.name]);
    XCTAssertTrue(result.employees.count == expected.employees.count);
    XCTAssertTrue(result1.age = expected1.age);
    XCTAssertTrue(result1.isActive = expected1.isActive);
    XCTAssertTrue([result1 isValid] == true);
}

- (void) test_SAJsonParser_ParseObject_WithNulls {
    // given
    NSDictionary *given = NULL;
    
    // expected
    NSDictionary *expected = NULL;
    
    // then
    SAMockPositionModel *result = [[SAMockPositionModel alloc] initWithJsonDictionary:given];
    NSDictionary *dresult = [result dictionaryRepresentation];
    XCTAssertTrue(dresult == expected);
}

- (void) test_SAJsonParser_ParseObject_WithNullsClasses {
    // given
    NSNull *given = [NSNull null];
    
    // expected
    SAMockPositionModel *expected = NULL;
    
    // then
    SAMockPositionModel *result = [[SAMockPositionModel alloc] initWithJsonDictionary:(NSDictionary*)given];
    NSLog(@"%@", result);
    XCTAssertTrue(result == expected);
}

- (void) test_SAJsonParser_ParseObject_WithMissingValues {
    // given
    NSString *given = @"{ \"name\": \"CEO\" }";
    
    // expected
    NSDictionary *expected = @{
                               @"name" :@"CEO",
                               @"salary": @(0)
                               };
    
    // then
    SAMockPositionModel *result = [[SAMockPositionModel alloc] initWithJsonString:given];
    NSLog(@"%@", [result dictionaryRepresentation]);
    XCTAssertTrue([[result dictionaryRepresentation] isEqualToDictionary:expected]);
}

- (void) test_SAJsonParser_ParseObject_WithNullValuesInJson {
    // given
    NSString *given = @"{\"name\": \"CEO\", \"salary\": null}";
    
    // expected
    NSDictionary *expected = @{
                               @"name": @"CEO",
                               @"salary": @(0)
                               };
    
    // then
    SAMockPositionModel *result = [[SAMockPositionModel alloc] initWithJsonString:given];
    XCTAssertTrue([[result dictionaryRepresentation] isEqualToDictionary:expected]);
}

- (void) test_SAJsonParser_ParseObject_WithBadJson {
    // given
    NSString *given1 = @"{ name : 23 }";
    NSString *given2 = @"";
    NSString *given3 = @"{ \"name: 48 ";
    NSString *given4 = @"{ \"name: 33} ";
    
    // expected
    SAMockPositionModel *expected = [[SAMockPositionModel alloc] init];
    
    // then
    SAMockPositionModel *result1 = [[SAMockPositionModel alloc] initWithJsonString:given1];
    SAMockPositionModel *result2 = [[SAMockPositionModel alloc] initWithJsonString:given2];
    SAMockPositionModel *result3 = [[SAMockPositionModel alloc] initWithJsonString:given3];
    SAMockPositionModel *result4 = [[SAMockPositionModel alloc] initWithJsonString:given4];
    
    XCTAssertNil(result1.name);
    XCTAssertNil(result2.name);
    XCTAssertNil(result3.name);
    XCTAssertNil(result4.name);
    XCTAssertEqual(result1.salary, expected.salary);
    XCTAssertEqual(result2.salary, expected.salary);
    XCTAssertEqual(result3.salary, expected.salary);
    XCTAssertEqual(result4.salary, expected.salary);
}

@end
