//
//  TestSAClickEventTrigger.m
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
#import "SAMockEventsServer.h"

@interface TestSAClickEventTrigger : XCTestCase
@property (nonatomic, strong) SAMockEventsServer *server;
@end

@implementation TestSAClickEventTrigger

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

- (void) test_SAClickEvent_triggerEvent_WithDisplayAdSuccess {
    
    __block XCTestExpectation *expectation = [self expectationWithDescription:@"High Expectations"];
    
    // given
    SAAd *ad = [SAModelFactory createDisplayAd:1000];
    MockSession *session = [[MockSession alloc] init];
    SAClickEvent *event = [[SAClickEvent alloc] initWithAd:ad andSession:session];
    
    [event triggerEvent:^(BOOL success) {
        XCTAssertTrue(success);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void) test_SAClickEvent_triggerEvent_WithDisplayAdFailure {
    
    __block XCTestExpectation *expectation = [self expectationWithDescription:@"High Expectations"];
    
    // given
    SAAd *ad = [SAModelFactory createDisplayAd:1001];
    MockSession *session = [[MockSession alloc] init];
    SAClickEvent *event = [[SAClickEvent alloc] initWithAd:ad andSession:session];
    
    [event triggerEvent:^(BOOL success) {
        XCTAssertFalse(success);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void) test_SAClickEvent_triggerEvent_WithVideoAdSuccess {
    
    __block XCTestExpectation *expectation = [self expectationWithDescription:@"High Expectations"];
    
    // given
    SAAd *ad = [SAModelFactory createVideoAd:1000];
    MockSession *session = [[MockSession alloc] init];
    SAClickEvent *event = [[SAClickEvent alloc] initWithAd:ad andSession:session];
    
    [event triggerEvent:^(BOOL success) {
        XCTAssertTrue(success);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void) test_SAClickEvent_triggerEvent_WithVideoAdFailure {
    
    __block XCTestExpectation *expectation = [self expectationWithDescription:@"High Expectations"];
    
    // given
    SAAd *ad = [SAModelFactory createVideoAd:1001];
    MockSession *session = [[MockSession alloc] init];
    SAClickEvent *event = [[SAClickEvent alloc] initWithAd:ad andSession:session];
    
    [event triggerEvent:^(BOOL success) {
        XCTAssertFalse(success);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

@end
