//
//  SAAdLoader_Query_Tests.m
//  SAAdLoader
//
//  Created by Gabriel Coman on 01/03/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SALoader.h"
#import "SASession.h"
#import "SAUtils.h"

@interface TestSAAdLoader_GetAwesomeAdsQuery : XCTestCase
@end

@implementation TestSAAdLoader_GetAwesomeAdsQuery

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testGetAwesomeAdsQuery1 {
    // given
    SASession *sesstion = [[SASession alloc] init];
    
    // when
    SALoader *loader = [[SALoader alloc] init];
    
    [sesstion enableTestMode];
    
    // then
    NSDictionary *query = [loader getAwesomeAdsQuery:sesstion];
    
    XCTAssertNotNil(query);
    XCTAssertEqual(16, [query count]);
    
    XCTAssertNotNil(query[@"test"]);
    XCTAssertEqual(true, [query[@"test"] boolValue]);
    
    XCTAssertNotNil(query[@"dauid"]);
    
    XCTAssertNotNil(query[@"sdkVersion"]);
    XCTAssertEqualObjects(@"0.0.0", query[@"sdkVersion"]);
    
    XCTAssertNotNil(query[@"rnd"]);
    
    XCTAssertNotNil(query[@"bundle"]);
    XCTAssertEqualObjects(@"org.cocoapods.demo.SAAdLoader-Example", query[@"bundle"]);
    
    XCTAssertNotNil(query[@"name"]);
    XCTAssertEqualObjects(@"SAAdLoader_Example", query[@"name"]);
    
    XCTAssertNotNil(query[@"ct"]);
    XCTAssertEqual(wifi, [query[@"ct"] intValue]);
    
    XCTAssertNotNil(query[@"lang"]);
    
    XCTAssertNotNil(query[@"device"]);

    XCTAssertNotNil(query[@"instl"]);
    XCTAssertEqualObjects(@(IN_FULLSCREEN), query[@"instl"]);
    
    XCTAssertNotNil(query[@"playbackmethod"]);
    XCTAssertEqualObjects(@(PB_WITH_SOUND_ON_SCREEN), query[@"playbackmethod"]);
    
    XCTAssertNotNil(query[@"pos"]);
    XCTAssertEqualObjects(@(POS_FULLSCREEN), query[@"pos"]);
    
    XCTAssertNotNil(query[@"skip"]);
    XCTAssertEqualObjects(@(SK_NO_SKIP), query[@"skip"]);
    
    XCTAssertNotNil(query[@"startdelay"]);
    XCTAssertEqualObjects(@(DL_PRE_ROLL), query[@"startdelay"]);
    
    XCTAssertNotNil(query[@"w"]);
    XCTAssertEqualObjects(@(0), query[@"w"]);
    
    XCTAssertNotNil(query[@"h"]);
    XCTAssertEqualObjects(@(0), query[@"h"]);
}

- (void) testGetAwesomeAdsQuery3 {
    // given
    SASession *session = nil;
    
    // when
    SALoader *loader = [[SALoader alloc] init];
    
    // then
    NSDictionary *query = [loader getAwesomeAdsQuery:session];
    
    XCTAssertNotNil(query);
    XCTAssertEqual(0, [query count]);
}

@end
