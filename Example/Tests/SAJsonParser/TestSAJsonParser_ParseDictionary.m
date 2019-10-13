//
//  SAJsonParser_Dictionary_Serialization_Tests.m
//  SAJsonParser
//
//  Created by Gabriel Coman on 14/10/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "SABaseObject.h"

@interface TestSAJsonParser_ParseDictionary : XCTestCase
@end

@implementation TestSAJsonParser_ParseDictionary

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void) test_SAJsonParser_ParseDictionary_SimpleObject {
    // given
    NSDictionary *given = @{@"field": @(23)};
    
    // expected
    NSString *expected = @"{\"field\":23}";
    
    // then
    NSString *result = [given jsonPreetyStringRepresentation];
    
    XCTAssertEqualObjects(result, expected);
}

- (void) test_SAJsonParser_ParseDictionary_WithComplexObject {
    // given
    NSDictionary *given = @{
                            @"field": @(23),
                            @"name": @"John",
                            @"isOK": @(true)
                            };
    
    // expected
    NSString *expected = @"{\"field\":23,\"name\":\"John\",\"isOK\":1}";
    
    // then
    NSString *result = [given jsonPreetyStringRepresentation];
    
    XCTAssertEqualObjects(result, expected);
}

- (void) test_SAJsonParser_ParseDictionary_WithComplexObjectWithNullField {
    // given
    NSDictionary *given = @{
                            @"field": @(23),
                            @"name": [NSNull null],
                            @"value": [NSNumber numberWithFloat:3.5],
                            @"isOK": @(true)
                            };
    
    // expected
    NSString *expected = @"{\"value\":3.5,\"isOK\":1,\"name\":null,\"field\":23}";
    
    // then
    NSString *result = [given jsonPreetyStringRepresentation];
    
    XCTAssertEqualObjects(result, expected);
}

- (void) test_SAJsonParser_ParseDictionary_WithNestedObjects {
    // given
    NSDictionary *given = @{
                            @"field": @(33),
                            @"name": @"Smith",
                            @"school": @{
                                    @"name": @"St. Mary",
                                    @"start": @(2008),
                                    @"end": @(2010)
                                    }
                            };
    
    // expected
    NSString *expected = @"{\"field\":33,\"name\":\"Smith\",\"school\":{\"name\":\"St. Mary\",\"start\":2008,\"end\":2010}}";
    
    // then
    NSString *result = [given jsonPreetyStringRepresentation];
    
    XCTAssertEqualObjects(result, expected);
}

- (void) test_SAJsonParser_ParseDictionary_WithNullInput {
    // given
    NSDictionary *given = nil;
    
    // then
    NSString *result = [given jsonPreetyStringRepresentation];
    
    XCTAssertNil(result);
}

- (void) test_SAJsonParser_ParseDictionary_WithArrayInObject {
    // given
    NSDictionary *given = @{
                            @"name": @"John",
                            @"grades": @[ @(6), @(7), @(8), @"pass"]
                            };
    
    // expected
    NSString *expected = @"{\"name\":\"John\",\"grades\":[6,7,8,\"pass\"]}";
    
    // then
    NSString *result = [given jsonPreetyStringRepresentation];
    
    XCTAssertEqualObjects(result, expected);
}

- (void) test_SAJsonParser_ParseDictionry_WithObjectContainingArrayWithNulls {
    // given
    NSDictionary *given = @{
                            @"name": @"John",
                            @"grades": @[ @(3), [NSNull null], @(5), @"pass"]
                            };
    
    // expected
    NSString *expected = @"{\"name\":\"John\",\"grades\":[3,null,5,\"pass\"]}";
    
    // then
    NSString *result = [given jsonPreetyStringRepresentation];
    XCTAssertEqualObjects(result, expected);
}

@end
