//
//  SAJsonParser_Array_Serialization_Tests.m
//  SAJsonParser
//
//  Created by Gabriel Coman on 14/10/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "SABaseObject.h"

@interface TestSAJsonParser_WriteArray : XCTestCase

@end

@implementation TestSAJsonParser_WriteArray

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void) test_SAJsonParser_WriteArray_WithSimpleData {
    // given
    NSArray *given = @[ @(3), @(2), @"name", [NSNull null] ];
    
    // when
    NSString *expected = @"[3,2,\"name\",null]";
    
    // then
    NSString *result = [given jsonCompactStringRepresentation];
    XCTAssertEqualObjects(result, expected);
    
}

- (void) test_SAJsonParser_WriteArray_WithCompleData {
    // given
    NSArray *given = @[@(3),
                       @"name",
                       @{
                           @"name": @"john",
                           @"age": @(32)
                        },
                       @{
                           @"name": @"mary",
                           @"age": [NSNull null]
                        }];
    // when
    NSString *expected = @"[3,\"name\",{\"name\":\"john\",\"age\":32},{\"name\":\"mary\",\"age\":null}]";
    
    // then
    NSString *result = [given jsonCompactStringRepresentation];
    XCTAssertEqualObjects(result, expected);
    
}

- (void) test_SAJsonParser_WriteArray_WithNullString {
    // given
    NSArray *given = nil;
    
    // then
    NSString *result = [given jsonCompactStringRepresentation];
    
    XCTAssertNil(result);
}

@end
