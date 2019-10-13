//
//  SAJsonParser_Array_Deserialization_Tests.m
//  SAJsonParser
//
//  Created by Gabriel Coman on 14/10/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SABaseObject.h"

@interface TestSAJsonParser_ParseArray : XCTestCase
@end

@implementation TestSAJsonParser_ParseArray

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void) test_SAJsonParser_ParseArray_WithJsonStringOfArrayOfNumbers {
    // given
    NSString *given = @"[ 23, 5, 2, 8 ]";
    
    // when
    NSArray *result = [[NSArray alloc] initWithJsonString:given andIterator:^id(id item) {
        return item;
    }];
    
    // then
    NSArray *expected = @[@(23), @(5), @(2), @(8)];
    XCTAssertEqualObjects(result, expected);
}

- (void) test_SAJsonParser_ParseArray_WithJsonStringofArrayOfDifferentObjects {
    // given
    NSString *given = @"[ 23, 5, \"papa\", null ]";
    
    // when
    NSArray *result = [[NSArray alloc] initWithJsonString:given andIterator:^id(id item) {
        return item;
    }];
    
    // then
    NSArray *expected = @[ @(23), @(5), @"papa", [NSNull null]];
    XCTAssertEqualObjects(result, expected);
}

- (void) test_SAJsonParser_ParseArray_WithJsonStringOfComplexObjects {
    // given
    NSString *given = @"[ 23, \"papa\", { \"name\": \"john\", \"age\": 23 }, { \"name\": \"theresa\" } ]";
    
    // when
    NSArray *result = [[NSArray alloc] initWithJsonString:given andIterator:^id(id item) {
        return item;
    }];
    
    // then
    NSArray *expected = @[
                          @(23),
                          @"papa",
                          @{@"name": @"john", @"age": @(23) },
                          @{@"name": @"theresa"}];
    XCTAssertEqualObjects(result, expected);
}

- (void) test_SAJsonParser_ParseArray_WithNullJsonString {
    // given
    NSString *given = nil;
    
    // when
    NSArray *result = [[NSArray alloc] initWithJsonString:given andIterator:^id(id item) {
        return item;
    }];
 
    // then
    XCTAssertEqualObjects(@[], result);
}

- (void) test_SAJsonParser_ParseArray_WithNullClassJsonString {
    // given
    NSNull *given = [NSNull null];
    
    // when
    NSArray *result = [[NSArray alloc] initWithJsonString:(NSString*)given andIterator:^id(id item) {
        return item;
    }];
    
    // then
    XCTAssertEqualObjects(@[], result);
}

- (void) test_SAJsonParser_ParseArray_WithInvalidJsonString {
    // given
    NSString *given1 = @"[ 3, 3, \" abc ";
    NSString *given2 = @"[ 3, 3, \" abc ";
    NSString *given3 = @" 3, 3";
    NSString *given4 = @"";
    
    // when
    NSArray *result1 = [[NSArray alloc] initWithJsonString:given1 andIterator:^id(id item) {
        return item;
    }];
    NSArray *result2 = [[NSArray alloc] initWithJsonString:given2 andIterator:^id(id item) {
        return item;
    }];
    NSArray *result3 = [[NSArray alloc] initWithJsonString:given3 andIterator:^id(id item) {
        return item;
    }];
    NSArray *result4 = [[NSArray alloc] initWithJsonString:given4 andIterator:^id(id item) {
        return item;
    }];
    
    // then
    XCTAssertEqualObjects(@[], result1);
    XCTAssertEqualObjects(@[], result2);
    XCTAssertEqualObjects(@[], result3);
    XCTAssertEqualObjects(@[], result4);
}

- (void) test_SAJsonParser_ParseArray_WithJsonStringOfObjectInsteadOfArray  {
    // given
    NSString *given = @"{ \"name\": \"John\", \"age\": 35 }";
    
    // when
    NSArray *result = [[NSArray alloc] initWithJsonString:given andIterator:^id(id item) {
        return item;
    }];
    
    // then
    XCTAssertEqualObjects(@[] ,result);
}

@end
