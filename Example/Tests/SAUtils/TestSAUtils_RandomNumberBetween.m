//
//  TestSAUtils_RandomNumberBetween.m
//  SAUtils_Tests
//
//  Created by Gabriel Coman on 03/05/2018.
//  Copyright © 2018 Gabriel Coman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SAUtils.h"

@interface TestSAUtils_RandomNumberBetween : XCTestCase
@end

@implementation TestSAUtils_RandomNumberBetween

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void) test_SAUtils_RandomNumber {
    // given
    NSInteger lower = 0;
    NSInteger upper = 58;
    
    // when
    BOOL expected1 = true;
    BOOL expected2 = false;
    
    // then
    NSInteger result = [SAUtils randomNumberBetween:lower maxNumber:upper];
    BOOL result1 = result <= upper;
    BOOL result2 = result >= upper;
    XCTAssertEqual(result1 ,expected1);
    XCTAssertEqual(result2 ,expected2);
}

@end
