//
//  TestSAURLEventSetup.m
//  SAEvents_Tests
//
//  Created by Gabriel Coman on 09/05/2018.
//  Copyright © 2018 Gabriel Coman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SAModelFactory.h"
#import "SAURLEvent.h"
#import "SASession.h"
#import "MockSession.h"

@interface TestSAURLEventSetup : XCTestCase
@end

@implementation TestSAURLEventSetup

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void) test_SAURLEvent_Init {
    // given
    NSString *url = @"https://api.url/abc";
    
    // when
    SAURLEvent *event = [[SAURLEvent alloc] initWithUrl:url];
    
    // then - endpoint
    XCTAssertNotNil([event getEndpoint]);
    XCTAssertEqualObjects(@"", [event getEndpoint]);
    
    // then - url
    XCTAssertNotNil([event getUrl]);
    XCTAssertEqualObjects(@"https://api.url/abc", [event getUrl]);
}

@end
