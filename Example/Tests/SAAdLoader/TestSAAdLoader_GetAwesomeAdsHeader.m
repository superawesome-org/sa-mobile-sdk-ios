//
//  SAAdLoader_Header_Tests.m
//  SAAdLoader
//
//  Created by Gabriel Coman on 01/03/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SALoader.h"
#import "SASession.h"
#import "SAUtils.h"

@interface TestSAAdLoader_GetAwesomeAdsHeader : XCTestCase
@end

@implementation TestSAAdLoader_GetAwesomeAdsHeader

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) test_SAAdLoader_GetAwesomeAdsHeader_WithValidSession {
    // given
    SASession *session = [[SASession alloc] init];
    
    // when
    SALoader *loader = [[SALoader alloc] init];
    
    // then
    NSDictionary *header = [loader getAwesomeAdsHeader:session];
    
    XCTAssertNotNil(header);
    XCTAssertEqual(2, [header count]);
    
    XCTAssertNotNil(header[@"Content-Type"]);
    XCTAssertEqualObjects(@"application/json", header[@"Content-Type"]);
    
    XCTAssertNotNil(header[@"User-Agent"]);
    XCTAssertEqualObjects([session getUserAgent], header[@"User-Agent"]);
}

- (void) test_SAAdLoader_GetAwesomeAdsHeader_WithNullSession {
    // given
    SASession *session = nil;
    
    // when
    SALoader *loader = [[SALoader alloc] init];
    
    // then
    NSDictionary *header = [loader getAwesomeAdsHeader:session];
    
    XCTAssertNotNil(header);
    XCTAssertEqual(0, [header count]);
}

@end
