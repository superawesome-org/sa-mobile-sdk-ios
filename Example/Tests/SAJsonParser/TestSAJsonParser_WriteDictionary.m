//
//  SAJsonParser_Dictionary_Deserialization_Tests.m
//  SAJsonParser
//
//  Created by Gabriel Coman on 14/10/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "SABaseObject.h"

@interface TestSAJsonParser_WriteDictionary : XCTestCase
@end

@implementation TestSAJsonParser_WriteDictionary

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void) test_SAJsonParser_WriteDictionary_WithSimpleObject {
    // given
    NSString *given = @"{ \"field\":23 }";
    
    // when
    NSDictionary *expected = @{ @"field": @(23) };
    
    // then
    NSDictionary *result = [[NSDictionary alloc] initWithJsonString:given];
    
    // assert
    XCTAssertTrue([result isEqualToDictionary:expected]);
}

- (void) test_SAJsonParser_WriteDictionary_WithMoreComplexObject {
    // given
    NSString *given = @"{ \"field\": 23 , \"name\": \"John\", \"isOK\": true }";
    
    // when
    NSDictionary *expected = @{
                               @"field": @(23),
                               @"name": @"John",
                               @"isOK": @(true)
                               };
    // then
    NSDictionary *result = [[NSDictionary alloc] initWithJsonString:given];
    
    // assert
    XCTAssertTrue([result isEqualToDictionary:expected]);
}

- (void) test_SAJsonParser_WriteDictionary_WithComplexObjectContainingNulls {
    // given
    NSString *given = @"{ \"field\": 23, \"name\": null, \"value\": 3.5, \"isOK\": true }";
    
    // when
    NSDictionary *expected = @{
                               @"field": @(23),
                               @"name": [NSNull null],
                               @"value": [NSNumber numberWithFloat:3.5],
                               @"isOK": @(true)
                               };
    
    // then
    NSDictionary *result = [[NSDictionary alloc] initWithJsonString:given];
    
    // assert
    XCTAssertTrue([result isEqualToDictionary:expected]);
}

- (void) test_SAJsonParser_WriteDictionary_WithNestedObjects {
    // given
    NSString *given = @"{ \"field\": 33, \"name\": \"Smith\", \"school\": { \"name\": \"St. Mary\", \"start\": 2008, \"end\": 2010 } }";
    
    // when
    NSDictionary *expected = @{
                               @"field": @(33),
                               @"name": @"Smith",
                               @"school": @{
                                       @"name": @"St. Mary",
                                       @"start": @(2008),
                                       @"end": @(2010)
                                       }
                               };
    
    // then
    NSDictionary *result = [[NSDictionary alloc] initWithJsonString:given];
    
    // assert
    XCTAssertTrue([result isEqualToDictionary:expected]);
}

- (void) test_SAJsonParser_WriteDictionary_WithNullInput {
    // given
    NSString *given1 = nil;
    NSNull *given2 = [NSNull null];
    
    // when
    NSDictionary *expected = @{};
    
    // then
    NSDictionary *result1 = [[NSDictionary alloc] initWithJsonString:given1];
    NSDictionary *result2 = [[NSDictionary alloc] initWithJsonString:(NSString*)given2];
    
    // assert
    XCTAssertEqualObjects(result1, expected);
    XCTAssertEqualObjects(result2, expected);
}

- (void) test_SAJsonParser_WriteDictionary_WithInvalidFormattedInput {
    // given
    NSString *given1 = @"{ name : 23 }";
    NSString *given2 = @"";
    NSString *given3 = @"{ \"name: 48 ";
    NSString *given4 = @"{ \"name: 33} ";
    
    // when
    NSDictionary *expected = @{};
    
    // then
    NSDictionary *result1 = [[NSDictionary alloc] initWithJsonString:given1];
    NSDictionary *result2 = [[NSDictionary alloc] initWithJsonString:given2];
    NSDictionary *result3 = [[NSDictionary alloc] initWithJsonString:given3];
    NSDictionary *result4 = [[NSDictionary alloc] initWithJsonString:given4];
    
    // assert
    XCTAssertEqualObjects(result1, expected);
    XCTAssertEqualObjects(result2, expected);
    XCTAssertEqualObjects(result3, expected);
    XCTAssertEqualObjects(result4, expected);
}

- (void) test_SAJsonParser_WriteDictionary_WithObjectContainingArray {
    // given
    NSString *given = @"{ \"name\": \"John\", \"grades\": [ 6, 7, 8, \"pass\"] }";
    
    // when
    NSDictionary *expected = @{
                               @"name": @"John",
                               @"grades": @[ @(6), @(7), @(8), @"pass"]
                               };
    
    // then
    NSDictionary *result = [[NSDictionary alloc] initWithJsonString:given];
    
    // assert
    XCTAssertEqualObjects(result, expected);
}

- (void) test_SAJsonParser_WriteDictionary_WithObjectContainingArrayWithNulls {
    // given
    NSString *given = @"{ \"name\": \"John\", \"grades\": [ 3, null, 5, \"pass\" ] }";
    
    // when
    NSDictionary *expected = @{
                               @"name": @"John",
                               @"grades": @[ @(3), [NSNull null], @(5), @"pass"]
                               };
    
    // then
    NSDictionary *result = [[NSDictionary alloc] initWithJsonString:given];
    
    // assert
    XCTAssertEqualObjects(result, expected);
}

- (void) test_SAJsonParser_WriteDictionary_WithArrayAsInput {
    // given
    NSString *given = @"[ 3, 2, 5, \"abc\" ]";
    
    // when
    NSDictionary *expected = @{};
    
    // then
    NSDictionary *result = [[NSDictionary alloc] initWithJsonString:given];
    
    // assert
    XCTAssertEqualObjects(result, expected);
}

- (void) testDictionary10 {
    // given
    NSString *given = @"{ \"field\": 33, \"name\": \"Smith\", \"school\": { \"name\": \"St. Mary\", \"start\": 2008, \"end\": 2010 }, \"grades\":[3, 2] }";
    
    // when
    NSDictionary *expected = @{
                               @"field": @(33),
                               @"name": @"Smith",
                               @"school": @{
                                       @"name": @"St. Mary",
                                       @"start": @(2008),
                                       @"end": @(2010)
                                       },
                               @"grades": @[@(3), @(2)]
                               };
    NSInteger expected1 = 33;
    NSInteger expected2 = -1;
    NSInteger expected3 = -1;
    NSString *expected4 = @"test";
    NSString *expected5 = @"Smith";
    NSString *expected6 = @"test";
    NSObject *expected7 = @(33);
    NSObject *expected8 = @"Smith";
    NSObject *expected9 = @{
                                @"name": @"St. Mary",
                                @"start": @(2008),
                                @"end": @(2010)
                                };
    NSDictionary *expected10 = @{};
    NSDictionary *expected11 = nil;
    NSDictionary *expected12 = (NSDictionary*)expected9;
    NSArray *expected13 = nil;
    NSArray *expected14 = @[@(3), @(2)];

    // then
    NSDictionary *result = [[NSDictionary alloc] initWithJsonString:given];
    NSInteger result1 = [result safeIntForKey:@"field" orDefault:-1];
    NSInteger result2 = [result safeIntForKey:@"name" orDefault:-1];
    NSInteger result3 = [result safeIntForKey:@"school" orDefault:-1];
    NSString *result4 = [result safeStringForKey:@"field" orDefault:@"test"];
    NSString *result5 = [result safeStringForKey:@"name" orDefault:nil];
    NSString *result6 = [result safeStringForKey:@"school" orDefault:@"test"];
    NSObject *result7 = [result safeObjectForKey:@"field" orDefault:@{}];
    NSObject *result8 = [result safeObjectForKey:@"name" orDefault:@{}];
    NSObject *result9 = [result safeObjectForKey:@"school" orDefault:nil];
    NSDictionary *result10 = [result safeDictionaryForKey:@"field" orDefault:@{}];
    NSDictionary *result11 = [result safeDictionaryForKey:@"name" orDefault:nil];
    NSDictionary *result12 = [result safeDictionaryForKey:@"school" orDefault:@{}];
    NSArray *result13 = [result safeArrayForKey:@"school" orDefault:nil];
    NSArray *result14 = [result safeArrayForKey:@"grades" orDefault:nil];
    
    // assert
    XCTAssertNotNil(result);
    XCTAssertEqualObjects(result, expected);
    XCTAssertEqual(result1, expected1);
    XCTAssertEqual(result2, expected2);
    XCTAssertEqual(result3, expected3);
    XCTAssertEqualObjects(result4, expected4);
    XCTAssertEqualObjects(result5, expected5);
    XCTAssertEqualObjects(result6, expected6);
    XCTAssertEqualObjects(result7, expected7);
    XCTAssertEqualObjects(result8, expected8);
    XCTAssertEqualObjects(result9, expected9);
    XCTAssertEqualObjects(result10, expected10);
    XCTAssertEqualObjects(result11, expected11);
    XCTAssertEqualObjects(result12, expected12);
    XCTAssertEqualObjects(result13, expected13);
    XCTAssertEqualObjects(result14, expected14);
}

- (void) testFields {
    // given
    NSString *given = @"{\"name\" : \"Abe\", \"age\" : 32, \"address\" : { \"geo\" : { \"lat\" : 23.55 , \"lng\" : -0.2221}, \"name\" : \"23 Flatweel road\"}}";
    
    // expected
    NSDictionary *expected = @{
                               @"name": @"Abe",
                               @"age": @(32),
                               @"address": @{
                                       @"geo": @{
                                               @"lat": @(23.55),
                                               @"lng": @(-0.2221)
                                               },
                                       @"name": @"23 Flatweel road"
                                       }
                               };
    NSString *expected_1 = [expected objectForKey:@"name"];
    NSInteger expected_2 = [[expected objectForKey:@"age"] integerValue];
    NSDictionary *expected_3 = [expected objectForKey:@"address"];
    NSDictionary *expected_4 = [expected_3 objectForKey:@"geo"];
    CGFloat expected_5 = [[expected_4 objectForKey:@"lat"] floatValue];
    CGFloat expected_6 = [[expected_4 objectForKey:@"lng"] floatValue];
    NSString *expected_7 = [expected_3 objectForKey:@"name"];
    
    // then
    NSDictionary *result = [[NSDictionary alloc] initWithJsonString:given];
    NSString *result_1 = [result objectForKey:@"name"];
    NSInteger result_2 = [[result objectForKey:@"age"] integerValue];
    NSDictionary *result_3 = [result objectForKey:@"address"];
    NSDictionary *result_4 = [result_3 objectForKey:@"geo"];
    CGFloat result_5 = [[result_4 objectForKey:@"lat"] floatValue];
    CGFloat result_6 = [[result_4 objectForKey:@"lng"] floatValue];
    NSString *result_7 = [result_3 objectForKey:@"name"];
    XCTAssertTrue([result isEqual:expected]);
    XCTAssertTrue([result_1 isEqualToString:expected_1]);
    XCTAssertTrue(result_2 == expected_2);
    XCTAssertTrue([result_3 isEqual:expected_3]);
    XCTAssertTrue([result_4 isEqual:expected_4]);
    XCTAssertTrue(result_5 == expected_5);
    XCTAssertTrue(result_6 == expected_6);
    XCTAssertTrue([result_7 isEqualToString:expected_7]);
}

@end
