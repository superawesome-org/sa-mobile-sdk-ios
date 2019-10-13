//
//  TestViewableImpressionEventSetup.m
//  SAEvents_Tests
//
//  Created by Gabriel Coman on 09/05/2018.
//  Copyright © 2018 Gabriel Coman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SAModelFactory.h"
#import "SAViewableImpressionEvent.h"
#import "SASession.h"
#import "MockSession.h"

@interface TestViewableImpressionEventSetup : XCTestCase
@end

@implementation TestViewableImpressionEventSetup

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void) test_ViewableImpression_Init {
    // given
    SAAd *ad = [SAModelFactory createDisplayAd:1000];
    MockSession *session = [[MockSession alloc] init];
    
    // when
    SAViewableImpressionEvent *event = [[SAViewableImpressionEvent alloc] initWithAd:ad  andSession:session];
    
    // then - endpoint
    XCTAssertNotNil([event getEndpoint]);
    XCTAssertEqualObjects(@"/event", [event getEndpoint]);
    
    // then - query
    XCTAssertNotNil([event getQuery]);
    
    NSDictionary *query = [event getQuery];
    
    XCTAssertEqualObjects(@(2), query[@"ct"]);
    XCTAssertEqualObjects(@(123456), query[@"rnd"]);
    XCTAssertEqualObjects(@"1.0.0", query[@"sdkVersion"]);
    XCTAssertEqualObjects(@"superawesome.tv.saadloaderdemo", query[@"bundle"]);
}

@end
