//
//  TestSAUtils_IsRectInRect.m
//  SAUtils_Tests
//
//  Created by Gabriel Coman on 03/05/2018.
//  Copyright © 2018 Gabriel Coman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SAUtils.h"

@interface TestSAUtils_IsRectInRect : XCTestCase
@end

@implementation TestSAUtils_IsRectInRect

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void) test_SAUtils_IsRectInRect {
    // given
    CGRect given1 = CGRectMake(0, 250, 320, 45);
    CGRect given2 = CGRectMake(-23, 720, 250, 45);
    CGRect given3 = CGRectMake(0, 0, 320, 684);
    
    // when
    BOOL expected1 = true;
    BOOL expected2 = false;
    
    // then
    BOOL result1 = [SAUtils isRect:given1 inRect:given3];
    BOOL result2 = [SAUtils isRect:given2 inRect:given3];
    XCTAssertEqual(result1, expected1);
    XCTAssertEqual(result2, expected2);
}

@end
