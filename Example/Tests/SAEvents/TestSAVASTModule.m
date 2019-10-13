//
//  TestSAVASTModule.m
//  SAEvents_Tests
//
//  Created by Gabriel Coman on 09/05/2018.
//  Copyright © 2018 Gabriel Coman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SAModelFactory.h"
#import "SAVASTModule.h"
#import "SASession.h"
#import "MockSession.h"
#import "SAMockEventsServer.h"

@interface TestSAVASTModule : XCTestCase
@property (nonatomic, strong) SAMockEventsServer *server;
@end

@implementation TestSAVASTModule

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

- (void) test_SAVASTModule_Success {
    
    __block XCTestExpectation *expectation1 = [self expectationWithDescription:@"High Expectations"];
    __block XCTestExpectation *expectation2 = [self expectationWithDescription:@"High Expectations"];
    __block XCTestExpectation *expectation3 = [self expectationWithDescription:@"High Expectations"];
    __block XCTestExpectation *expectation4 = [self expectationWithDescription:@"High Expectations"];
    __block XCTestExpectation *expectation5 = [self expectationWithDescription:@"High Expectations"];
    __block XCTestExpectation *expectation6 = [self expectationWithDescription:@"High Expectations"];
    __block XCTestExpectation *expectation7 = [self expectationWithDescription:@"High Expectations"];
    __block XCTestExpectation *expectation8 = [self expectationWithDescription:@"High Expectations"];
    __block XCTestExpectation *expectation9 = [self expectationWithDescription:@"High Expectations"];
    __block XCTestExpectation *expectation10 = [self expectationWithDescription:@"High Expectations"];
    
    // given
    SAAd *ad = [SAModelFactory createVideoAd:1000];
    SAVASTModule *module = [[SAVASTModule alloc] initWithAd:ad];
    
    [module triggerVASTImpressionEvent:^(BOOL success) {
        XCTAssertTrue(success);
        
        [expectation1 fulfill];
    }];
    
    [module triggerVASTStartEvent:^(BOOL success) {
        XCTAssertTrue(success);
        
        [expectation2 fulfill];
    }];
    
    [module triggerVASTCreativeViewEvent:^(BOOL success) {
        XCTAssertTrue(success);
        
        [expectation3 fulfill];
    }];
    
    [module triggerVASTErrorEvent:^(BOOL success) {
        XCTAssertTrue(success);
        
        [expectation4 fulfill];
    }];
    
    [module triggerVASTFirstQuartileEvent:^(BOOL success) {
        XCTAssertTrue(success);
        
        [expectation5 fulfill];
    }];
    
    [module triggerVASTMidpointEvent:^(BOOL success) {
        XCTAssertTrue(success);
        
        [expectation6 fulfill];
    }];
    
    [module triggerVASTThirdQuartileEvent:^(BOOL success) {
        XCTAssertTrue(success);
        
        [expectation7 fulfill];
    }];
    
    [module triggerVASTCompleteEvent:^(BOOL success) {
        XCTAssertTrue(success);
        
        [expectation8 fulfill];
    }];
    
    [module triggerVASTClickTrackingEvent:^(BOOL success) {
        XCTAssertTrue(success);
        
        [expectation9 fulfill];
    }];
    
    [module triggerVASTClickThroughEvent:^(BOOL success) {
        XCTAssertTrue(success);
        
        [expectation10 fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:nil];
}

- (void) test_SAVASTModule_Failure {
    
    __block XCTestExpectation *expectation1 = [self expectationWithDescription:@"High Expectations"];
    __block XCTestExpectation *expectation2 = [self expectationWithDescription:@"High Expectations"];
    __block XCTestExpectation *expectation3 = [self expectationWithDescription:@"High Expectations"];
    __block XCTestExpectation *expectation4 = [self expectationWithDescription:@"High Expectations"];
    __block XCTestExpectation *expectation5 = [self expectationWithDescription:@"High Expectations"];
    __block XCTestExpectation *expectation6 = [self expectationWithDescription:@"High Expectations"];
    __block XCTestExpectation *expectation7 = [self expectationWithDescription:@"High Expectations"];
    __block XCTestExpectation *expectation8 = [self expectationWithDescription:@"High Expectations"];
    __block XCTestExpectation *expectation9 = [self expectationWithDescription:@"High Expectations"];
    __block XCTestExpectation *expectation10 = [self expectationWithDescription:@"High Expectations"];
    
    // given
    SAAd *ad = [SAModelFactory createVideoAd:1001];
    SAVASTModule *module = [[SAVASTModule alloc] initWithAd:ad];
    
    [module triggerVASTImpressionEvent:^(BOOL success) {
        XCTAssertFalse(success);
        
        [expectation1 fulfill];
    }];
    
    [module triggerVASTStartEvent:^(BOOL success) {
        XCTAssertFalse(success);
        
        [expectation2 fulfill];
    }];
    
    [module triggerVASTCreativeViewEvent:^(BOOL success) {
        XCTAssertFalse(success);
        
        [expectation3 fulfill];
    }];
    
    [module triggerVASTErrorEvent:^(BOOL success) {
        XCTAssertFalse(success);
        
        [expectation4 fulfill];
    }];
    
    [module triggerVASTFirstQuartileEvent:^(BOOL success) {
        XCTAssertFalse(success);
        
        [expectation5 fulfill];
    }];
    
    [module triggerVASTMidpointEvent:^(BOOL success) {
        XCTAssertFalse(success);
        
        [expectation6 fulfill];
    }];
    
    [module triggerVASTThirdQuartileEvent:^(BOOL success) {
        XCTAssertFalse(success);
        
        [expectation7 fulfill];
    }];
    
    [module triggerVASTCompleteEvent:^(BOOL success) {
        XCTAssertFalse(success);
        
        [expectation8 fulfill];
    }];
    
    [module triggerVASTClickTrackingEvent:^(BOOL success) {
        XCTAssertFalse(success);
        
        [expectation9 fulfill];
    }];
    
    [module triggerVASTClickThroughEvent:^(BOOL success) {
        XCTAssertFalse(success);
        
        [expectation10 fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:nil];
}

@end
