//
//  TestSAServerModule.m
//  SAEvents_Tests
//
//  Created by Gabriel Coman on 09/05/2018.
//  Copyright © 2018 Gabriel Coman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SAModelFactory.h"
#import "SAServerModule.h"
#import "SASession.h"
#import "MockSession.h"
#import "SAMockEventsServer.h"

@interface TestSAServerModule : XCTestCase
@property (nonatomic, strong) SAMockEventsServer *server;
@end

@implementation TestSAServerModule

- (void)setUp {
    [super setUp];
    _server = [[SAMockEventsServer alloc] init];
    [_server start];
}

- (void)tearDown {
    [_server shutdown];
    _server = nil;
    [super tearDown];
}

- (void) test_SAServerModule_WithDisplayAd_Success {
    
    __block XCTestExpectation *expectation1 = [self expectationWithDescription:@"High Expectations"];
    __block XCTestExpectation *expectation2 = [self expectationWithDescription:@"High Expectations"];
    __block XCTestExpectation *expectation3 = [self expectationWithDescription:@"High Expectations"];
    
    // given
    SAAd *ad = [SAModelFactory createDisplayAd:1000];
    MockSession *session = [[MockSession alloc] init];
    SAServerModule *module = [[SAServerModule alloc] initWithAd:ad andSession:session];
    
    // when
    [module triggerClickEvent:^(BOOL success) {
        XCTAssertTrue(success);
        
        [expectation1 fulfill];
    }];
    
    [module triggerImpressionEvent:^(BOOL success) {
        XCTAssertTrue(success);
        
        [expectation2 fulfill];
    }];
    
    
    [module triggeViewableImpressionEvent:^(BOOL success) {
        XCTAssertTrue(success);
        
        [expectation3 fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:nil];
}

- (void) test_SAServerModule_WithDisplayAd_Failure {
    
    __block XCTestExpectation *expectation1 = [self expectationWithDescription:@"High Expectations"];
    __block XCTestExpectation *expectation2 = [self expectationWithDescription:@"High Expectations"];
    __block XCTestExpectation *expectation3 = [self expectationWithDescription:@"High Expectations"];
    
    // given
    SAAd *ad = [SAModelFactory createDisplayAd:1001];
    MockSession *session = [[MockSession alloc] init];
    SAServerModule *module = [[SAServerModule alloc] initWithAd:ad andSession:session];
    
    // when
    [module triggerClickEvent:^(BOOL success) {
        XCTAssertFalse(success);
        
        [expectation1 fulfill];
    }];
    
    [module triggerImpressionEvent:^(BOOL success) {
        XCTAssertFalse(success);
        
        [expectation2 fulfill];
    }];
    
    
    [module triggeViewableImpressionEvent:^(BOOL success) {
        XCTAssertFalse(success);
        
        [expectation3 fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:nil];
}

- (void) test_SAServerModule_WithVideoAd_Success {
    
    __block XCTestExpectation *expectation1 = [self expectationWithDescription:@"High Expectations"];
    __block XCTestExpectation *expectation2 = [self expectationWithDescription:@"High Expectations"];
    __block XCTestExpectation *expectation3 = [self expectationWithDescription:@"High Expectations"];
    
    // given
    SAAd *ad = [SAModelFactory createVideoAd:1000];
    MockSession *session = [[MockSession alloc] init];
    SAServerModule *module = [[SAServerModule alloc] initWithAd:ad andSession:session];
    
    // when
    [module triggerClickEvent:^(BOOL success) {
        XCTAssertTrue(success);
        
        [expectation1 fulfill];
    }];
    
    [module triggerImpressionEvent:^(BOOL success) {
        XCTAssertTrue(success);
        
        [expectation2 fulfill];
    }];
    
    
    [module triggeViewableImpressionEvent:^(BOOL success) {
        XCTAssertTrue(success);
        
        [expectation3 fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:nil];
}

- (void) test_SAServerModule_WithVideoAd_Failure {
    
    __block XCTestExpectation *expectation1 = [self expectationWithDescription:@"High Expectations"];
    __block XCTestExpectation *expectation2 = [self expectationWithDescription:@"High Expectations"];
    __block XCTestExpectation *expectation3 = [self expectationWithDescription:@"High Expectations"];
    
    // given
    SAAd *ad = [SAModelFactory createVideoAd:1001];
    MockSession *session = [[MockSession alloc] init];
    SAServerModule *module = [[SAServerModule alloc] initWithAd:ad andSession:session];
    
    // when
    [module triggerClickEvent:^(BOOL success) {
        XCTAssertFalse(success);
        
        [expectation1 fulfill];
    }];
    
    [module triggerImpressionEvent:^(BOOL success) {
        XCTAssertFalse(success);
        
        [expectation2 fulfill];
    }];
    
    
    [module triggeViewableImpressionEvent:^(BOOL success) {
        XCTAssertFalse(success);
        
        [expectation3 fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:nil];
}

@end
