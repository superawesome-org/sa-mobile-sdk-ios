//
//  TestSAUtils_IsValidURL.m
//  SAUtils_Tests
//
//  Created by Gabriel Coman on 03/05/2018.
//  Copyright © 2018 Gabriel Coman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SAUtils.h"

@interface TestSAUtils_IsValidURL : XCTestCase

@end

@implementation TestSAUtils_IsValidURL

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void) test_SAUtils_IsValidURL {
    // given
    NSString *given1 = @"https://s3-eu-west-1.amazonaws.com/sb-ads-video-transcoded/x7XkGy43vim5P1OpldlOUuxk2cuKsDSn.mp4";
    NSString *given2 = @"";
    NSString *given3 = nil;
    NSString *given4 = @"jkskjasa";
    NSString *given5 = @"https://google.com";
    
    // when
    
    // then
    BOOL result1 = [SAUtils isValidURL:given1];
    BOOL result2 = [SAUtils isValidURL:given2];
    BOOL result3 = [SAUtils isValidURL:given3];
    BOOL result4 = [SAUtils isValidURL:given4];
    BOOL result5 = [SAUtils isValidURL:given5];
    
    // test
    XCTAssertTrue(result1);
    XCTAssertFalse(result2);
    XCTAssertFalse(result3);
    XCTAssertFalse(result4);
    XCTAssertTrue(result5);
}

@end
