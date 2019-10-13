//
//  TestSAUtils_FormGetQueryFromDict.m
//  SAUtils_Tests
//
//  Created by Gabriel Coman on 03/05/2018.
//  Copyright © 2018 Gabriel Coman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SAUtils.h"

@interface TestSAUtils_FormGetQueryFromDict : XCTestCase
@end

@implementation TestSAUtils_FormGetQueryFromDict

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void) test_SAUtils_FormGetQueryFromDict_WithValidDict {
    // given
    NSDictionary *dict = @{
                           @"client_id": @"client-111",
                           @"user_id": @(321)
                           };
    
    
    // when
    NSString *result = [SAUtils formGetQueryFromDict:dict];
    
    // then
    XCTAssertEqualObjects(@"client_id=client-111&user_id=321", result);
    
}

- (void) test_SAUtils_FormGetQueryFromDict_WithEmptyDict {
    // given
    NSDictionary *dict = @{};
    
    // when
    NSString *result = [SAUtils formGetQueryFromDict:dict];
    
    // then
    XCTAssertEqualObjects(@"", result);
}

- (void) test_SAUtils_FormGetQueryFromDict_WithNullDict {
    // given
    NSDictionary *dict = nil;
    
    // when
    NSString *result = [SAUtils formGetQueryFromDict:dict];
    
    // then
    XCTAssertEqualObjects(@"", result);
}

@end
