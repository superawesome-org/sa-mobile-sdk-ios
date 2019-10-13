//
//  SAUtils_Aux_Tests.m
//  SAUtils
//
//  Created by Gabriel Coman on 09/06/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SAUtils.h"

@interface TestSAUtils_FindSubstring : XCTestCase

@end

@implementation TestSAUtils_FindSubstring

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void) test_SAutils_SubstringIn1 {
    // given
    NSString *source = @"New test string with a number of words in it";
    NSString *start = @"string";
    NSString *end = @"words";
    
    // when
    NSString *expected = @" with a number of ";
    
    // then
    NSString *result = [SAUtils substringIn:source from:start to:end];
    XCTAssertTrue([result isEqualToString:expected]);
}

- (void) test_SAUtils_SubstringIn2 {
    // given
    NSString *source = @"New test string with a number of words in it";
    NSString *start = nil;
    NSString *end = @"words";
    
    // when
    NSString *expected = nil;
    
    // then
    NSString *result = [SAUtils substringIn:source from:start to:end];
    XCTAssertNil(result);
    XCTAssertEqual(result, expected);
}

- (void) test_SAUtils_SubstringIn3 {
    // given
    NSString *source = @"New test string with a number of words in it";
    NSString *start = @"alfalfa";
    NSString *end = @"words";
    
    // when
    NSString *expected = nil;
    
    // then
    NSString *result = [SAUtils substringIn:source from:start to:end];
    XCTAssertNil(result);
    XCTAssertEqual(result, expected);
}

- (void) test_SAUtils_SubstringIn4 {
    // given
    NSString *source = nil;
    NSString *start = @"alfalfa";
    NSString *end = @"words";
    
    // when
    NSString *expected = nil;
    
    // then
    NSString *result = [SAUtils substringIn:source from:start to:end];
    XCTAssertNil(result);
    XCTAssertEqual(result, expected);
}


@end
