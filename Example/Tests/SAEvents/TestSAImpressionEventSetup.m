//
//  TestSAImpressionEventSetup.m
//  SAEvents_Tests
//
//  Created by Gabriel Coman on 09/05/2018.
//  Copyright © 2018 Gabriel Coman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SAModelFactory.h"
#import "SAImpressionEvent.h"
#import "SASession.h"
#import "MockSession.h"

@interface TestSAImpressionEventSetup : XCTestCase
@end

@implementation TestSAImpressionEventSetup

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void) test_Impression_Init_WithDisplayAd {
    // given
    SAAd *ad = [SAModelFactory createDisplayAd:1000];
    MockSession *session = [[MockSession alloc] init];
    
    // when
    SAImpressionEvent *event = [[SAImpressionEvent alloc] initWithAd:ad andSession:session];
    
    // then - endpoint
    XCTAssertNotNil([event getEndpoint]);
    XCTAssertEqualObjects(@"/impression", [event getEndpoint]);
    
    // then - query
    XCTAssertNotNil([event getQuery]);
    
    NSDictionary *query = [event getQuery];
    
    XCTAssertEqual(9, query.count);
    XCTAssertEqualObjects(@(2), query[@"ct"]);
    XCTAssertEqualObjects(@(2001), query[@"line_item"]);
    XCTAssertEqualObjects(@(123456), query[@"rnd"]);
    XCTAssertEqualObjects(@"1.0.0", query[@"sdkVersion"]);
    XCTAssertEqualObjects(@(1000), query[@"placement"]);
    XCTAssertEqualObjects(@"superawesome.tv.saadloaderdemo", query[@"bundle"]);
    XCTAssertEqualObjects(@(5001), query[@"creative"]);
    XCTAssertEqualObjects(@"impressionDownloaded", query[@"type"]);
}

@end
