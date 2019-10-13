//
//  TestSAUtils_EncodeJSONDictionaryFromNSDictionary.m
//  SAUtils_Tests
//
//  Created by Gabriel Coman on 03/05/2018.
//  Copyright © 2018 Gabriel Coman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SAUtils.h"

@interface TestSAUtils_EncodeJSONDictionaryFromNSDictionary: XCTestCase
@end

@implementation TestSAUtils_EncodeJSONDictionaryFromNSDictionary

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void) test_SAUTils_EncodeJSONDictionary {
    
    // given
    NSDictionary *dict = @{
                           @"client_id": @"client-111",
                           @"user_id": @(321)
                           };
    NSDictionary *dict2 = @{};
    NSDictionary *dict3 = nil;
    
    // when
    NSString *expected = @"%7B%22client_id%22%3A%22client-111%22%2C%22user_id%22%3A321%7D";
    NSString *expected2 = @"%7B%7D";
    NSString *expected3 = @"%7B%7D";
    
    // then
    NSString *result = [SAUtils encodeJSONDictionaryFromNSDictionary:dict];
    NSString *result2 = [SAUtils encodeJSONDictionaryFromNSDictionary:dict2];
    NSString *result3 = [SAUtils encodeJSONDictionaryFromNSDictionary:dict3];
    
    // test
    XCTAssertEqualObjects(result, expected);
    XCTAssertEqualObjects(result2, expected2);
    XCTAssertEqualObjects(result3, expected3);
    
}

@end
