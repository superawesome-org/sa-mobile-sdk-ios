//
//  TestSAUtils_MapInto.m
//  SAUtils_Tests
//
//  Created by Gabriel Coman on 03/05/2018.
//  Copyright © 2018 Gabriel Coman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SAUtils.h"

@interface TestSAUtils_MapInto : XCTestCase
@end

@implementation TestSAUtils_MapInto

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void) test_SAUtils_MapInto {
    // given
    CGRect oldframe = CGRectMake(0, 30, 280, 45);
    CGRect newframe = CGRectMake(0, 0, 200, 100);
    
    // when
    CGRect expected = CGRectMake(0, 33, 200, 32);
    // then
    CGRect result = [SAUtils map:oldframe into:newframe];
    XCTAssert(CGRectEqualToRect(result, expected));
}

@end
