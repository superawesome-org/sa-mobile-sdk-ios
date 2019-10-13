//
//  TestSAUtils_EncodeURI.m
//  SAUtils_Tests
//
//  Created by Gabriel Coman on 03/05/2018.
//  Copyright © 2018 Gabriel Coman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SAUtils.h"

@interface TestSAUtils_EncodeURI : XCTestCase
@end

@implementation TestSAUtils_EncodeURI

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void) test_SAUtils_EncodeUri {
    // given
    NSString *given1 = @"https://s3-eu-west-1.amazonaws.com/sb-ads-video-transcoded/x7XkGy43vim5P1OpldlOUuxk2cuKsDSn.mp4";
    NSString *given2 = @"";
    NSString *given3 = nil;
    NSString *given4 = @"https:/klsa9922:skllsa/2100921091/saas///";
    
    // when
    NSString *expected1 = @"https%3A%2F%2Fs3-eu-west-1.amazonaws.com%2Fsb-ads-video-transcoded%2Fx7XkGy43vim5P1OpldlOUuxk2cuKsDSn.mp4";
    NSString *expected2 = @"";
    NSString *expected3 = @"";
    NSString *expected4 = @"https%3A%2Fklsa9922%3Askllsa%2F2100921091%2Fsaas%2F%2F%2F";
    
    // then
    NSString *result1 = [SAUtils encodeURI:given1];
    NSString *result2 = [SAUtils encodeURI:given2];
    NSString *result3 = [SAUtils encodeURI:given3];
    NSString *result4 = [SAUtils encodeURI:given4];
    
    XCTAssertEqualObjects(result1, expected1);
    XCTAssertEqualObjects(result2, expected2);
    XCTAssertEqualObjects(result3, expected3);
    XCTAssertEqualObjects(result4, expected4);
}

@end
