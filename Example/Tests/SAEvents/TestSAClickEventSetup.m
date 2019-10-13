//
//  TestSAClickEventSetup.m
//  SAEvents_Tests
//
//  Created by Gabriel Coman on 09/05/2018.
//  Copyright © 2018 Gabriel Coman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SAModelFactory.h"
#import "SAClickEvent.h"
#import "SASession.h"
#import "MockSession.h"

@interface TestSAClickEventSetup : XCTestCase
@end

@implementation TestSAClickEventSetup

- (void) setUp {
    [super setUp];
}

- (void) tearDown {
    [super tearDown];
}

- (void) test_ClickEvent_Init_WithDisplayAd {
    // given
    SAAd *ad = [SAModelFactory createDisplayAd:1000];
    MockSession *session = [[MockSession alloc] init];
    
    // when
    SAClickEvent *event = [[SAClickEvent alloc] initWithAd:ad andSession:session];
    
    // then - endpoint
    XCTAssertNotNil([event getEndpoint]);
    XCTAssertEqualObjects(@"/click", [event getEndpoint]);
    
    // then - query
    XCTAssertNotNil([event getQuery]);
    
    NSDictionary *query = [event getQuery];
    
    XCTAssertEqualObjects(@(2), query[@"ct"]);
    XCTAssertEqualObjects(@(2001), query[@"line_item"]);
    XCTAssertEqualObjects(@(123456), query[@"rnd"]);
    XCTAssertEqualObjects(@"1.0.0", query[@"sdkVersion"]);
    XCTAssertEqualObjects(@(1000), query[@"placement"]);
    XCTAssertEqualObjects(@"superawesome.tv.saadloaderdemo", query[@"bundle"]);
    XCTAssertEqualObjects(@(5001), query[@"creative"]);
}

- (void) test_ClickEvent_Init_WithVideoAd {
    
    // given
    SAAd *ad = [SAModelFactory createVideoAd:1000];
    MockSession *session = [[MockSession alloc] init];
    
    // when
    SAClickEvent *event = [[SAClickEvent alloc] initWithAd:ad andSession:session];
    
    // then - endpoint
    XCTAssertNotNil([event getEndpoint]);
    XCTAssertEqualObjects(@"/video/click", [event getEndpoint]);
    
    // then - query
    XCTAssertNotNil([event getQuery]);
    
    NSDictionary *query = [event getQuery];
    
    XCTAssertEqualObjects(@(2), query[@"ct"]);
    XCTAssertEqualObjects(@(2001), query[@"line_item"]);
    XCTAssertEqualObjects(@(123456), query[@"rnd"]);
    XCTAssertEqualObjects(@"1.0.0", query[@"sdkVersion"]);
    XCTAssertEqualObjects(@(1000), query[@"placement"]);
    XCTAssertEqualObjects(@"superawesome.tv.saadloaderdemo", query[@"bundle"]);
    XCTAssertEqualObjects(@(5001), query[@"creative"]);
}


@end
