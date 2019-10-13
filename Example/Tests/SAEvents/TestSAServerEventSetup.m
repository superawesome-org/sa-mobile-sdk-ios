//
//  TestSAServerEventSetup.m
//  SAEvents_Tests
//
//  Created by Gabriel Coman on 09/05/2018.
//  Copyright © 2018 Gabriel Coman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SAModelFactory.h"
#import "SAServerEvent.h"
#import "SASession.h"
#import "MockSession.h"

@interface TestSAServerEventSetup : XCTestCase
@end

@implementation TestSAServerEventSetup

- (void) setUp {
    [super setUp];
}

- (void) tearDown {
    [super tearDown];
}

- (void) test_Impression_Init_WithDisplayAd {
    // given
    SAAd *ad = [SAModelFactory createDisplayAd:1000];
    MockSession *session = [[MockSession alloc] init];
    
    // when
    SAServerEvent *event = [[SAServerEvent alloc] initWithAd:ad andSession:session];
    
    // then - url
    XCTAssertNotNil(event);
    
    XCTAssertNotNil([event getUrl]);
    XCTAssertEqualObjects(@"http://localhost:64000", [event getUrl]);
    XCTAssertEqualObjects([session getBaseUrl], [event getUrl]);
    
    // then - header
    XCTAssertNotNil([event getHeader]);
    
    XCTAssertEqualObjects(@"application/json", [[event getHeader] objectForKey:@"Content-Type"]);
    XCTAssertEqualObjects(@"some-user-agent", [[event getHeader] objectForKey:@"User-Agent"]);
}

@end
