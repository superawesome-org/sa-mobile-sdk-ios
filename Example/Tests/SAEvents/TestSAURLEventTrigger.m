//
//  TestSAURLEventTrigger.m
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
#import "SAMockEventsServer.h"

@interface TestSAURLEventTrigger : XCTestCase
@property (nonatomic, strong) SAMockEventsServer *server;
@end

@implementation TestSAURLEventTrigger

- (void) setUp {
    [super setUp];
    _server = [[SAMockEventsServer alloc] init];
    [_server start];
}

- (void) tearDown {
    [_server shutdown];
    _server = nil;
    [super tearDown];
}

- (void) test_URLEvent_triggerEvent_WithSuccess {
    
    __block XCTestExpectation *expectation = [self expectationWithDescription:@"High Expectations"];
    
    // given
    NSString *url = @"http://localhost:64000/api/url?placement=1000";
    SAURLEvent *event = [[SAURLEvent alloc] initWithUrl:url];
    
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

- (void) test_URLEvent_triggerEvent_WithFailure {
    
    __block XCTestExpectation *expectation = [self expectationWithDescription:@"High Expectations"];
    
    // given
    NSString *url = @"http://localhost:64000/api/url?placement=1001";
    SAURLEvent *event = [[SAURLEvent alloc] initWithUrl:url];
    
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
