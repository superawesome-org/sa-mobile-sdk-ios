//
//  TestSAUtils_IsEmailValid.m
//  SAUtils_Tests
//
//  Created by Gabriel Coman on 03/05/2018.
//  Copyright © 2018 Gabriel Coman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SAUtils.h"

@interface TestSAUtils_IsEmailValid : XCTestCase
@end

@implementation TestSAUtils_IsEmailValid

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void) test_SAUtils_IsValidEmail {
    // given
    NSString *given1 = @"dev.gabriel.coman@gmail.com";
    NSString *given2 = @"jsksls////";
    NSString *given3 = nil;
    NSString *given4 = @"";
    NSString *given5 = @"test@test.com";
    
    // then
    
    // test
    BOOL result1 = [SAUtils isEmailValid:given1];
    BOOL result2 = [SAUtils isEmailValid:given2];
    BOOL result3 = [SAUtils isEmailValid:given3];
    BOOL result4 = [SAUtils isEmailValid:given4];
    BOOL result5 = [SAUtils isEmailValid:given5];
    
    // test
    XCTAssertTrue(result1);
    XCTAssertFalse(result2);
    XCTAssertFalse(result3);
    XCTAssertFalse(result4);
    XCTAssertTrue(result5);
}

@end
