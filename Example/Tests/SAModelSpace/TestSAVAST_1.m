//
//  SAVAST_ModelSpace_Tests.m
//  SAModelSpace
//
//  Created by Gabriel Coman on 17/01/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

@import XCTest;

#import "SATestUtils.h"
#import "SAVASTAd.h"
#import "SAVASTMedia.h"
#import "SAVASTEvent.h"

@interface TestSAVAST_1 : XCTestCase
@property (nonatomic, strong) SATestUtils *utils;
@end

@implementation TestSAVAST_1

- (void) setUp {
    [super setUp];
    _utils = [[SATestUtils alloc] init];
}

- (void)tearDown {
    [super tearDown];
}

- (void) testVASTMedia1 {
    
    // given
    NSString *given = [_utils fixtureWithName:@"mock_vast_response_1" ofType:@"json"];
    
    SAVASTMedia *media = [[SAVASTMedia alloc] initWithJsonString:given];
    XCTAssertNotNil(media);
    
    NSString *expected_type = @"video/mp4";
    NSString *expected_url = @"https://s3-eu-west-1.amazonaws.com/sb-ads-video-transcoded/c0sKSRTuPu8dDkok2HQTnLS1k3A6vL6c.mp4";
    int expected_bitrate = 720;
    int expected_width = 600;
    int expected_height = 480;
    
    XCTAssertEqualObjects(expected_type, media.type);
    XCTAssertEqualObjects(expected_url, media.url);
    XCTAssertEqual(expected_bitrate, media.bitrate);
    XCTAssertEqual(expected_width, media.width);
    XCTAssertEqual(expected_height, media.height);
    XCTAssertTrue([media isValid]);
}

- (void) testVASTMedia2 {
    
    // given
    NSString *given = [_utils fixtureWithName:@"mock_vast_response_2" ofType:@"json"];
    
    SAVASTMedia *media = [[SAVASTMedia alloc] initWithJsonString:given];
    XCTAssertNotNil(media);
    
    NSString *expected_type = @"video/mp4";
    NSString *expected_url = @"https://s3-eu-west-1.amazonaws.com/sb-ads-video-transcoded/c0sKSRTuPu8dDkok2HQTnLS1k3A6vL6c.mp4";
    int expected_bitrate = 0;
    int expected_width = 0;
    int expected_height = 480;
    
    XCTAssertEqualObjects(expected_type, media.type);
    XCTAssertEqualObjects(expected_url, media.url);
    XCTAssertEqual(expected_bitrate, media.bitrate);
    XCTAssertEqual(expected_width, media.width);
    XCTAssertEqual(expected_height, media.height);
    XCTAssertTrue([media isValid]);
}

- (void) testVASTMedia3 {
    
    // given
    NSString *given = [_utils fixtureWithName:@"mock_vast_response_3" ofType:@"json"];
    
    SAVASTMedia *media = [[SAVASTMedia alloc] initWithJsonString:given];
    XCTAssertNotNil(media);
    
    NSString *expected_type = nil;
    NSString *expected_url = nil;
    int expected_bitrate = 0;
    int expected_width = 0;
    int expected_height = 0;
    
    XCTAssertEqualObjects(expected_type, media.type);
    XCTAssertEqualObjects(expected_url, media.url);
    XCTAssertEqual(expected_bitrate, media.bitrate);
    XCTAssertEqual(expected_width, media.width);
    XCTAssertEqual(expected_height, media.height);
    XCTAssertFalse([media isValid]);
}

- (void) testVASTMedia4 {
    
    SAVASTMedia *media = [[SAVASTMedia alloc] initWithJsonString:nil];
    XCTAssertNotNil(media);
    
    NSString *expected_type = nil;
    NSString *expected_url = nil;
    int expected_bitrate = 0;
    int expected_width = 0;
    int expected_height = 0;
    
    XCTAssertEqualObjects(expected_type, media.type);
    XCTAssertEqualObjects(expected_url, media.url);
    XCTAssertEqual(expected_bitrate, media.bitrate);
    XCTAssertEqual(expected_width, media.width);
    XCTAssertEqual(expected_height, media.height);
    XCTAssertFalse([media isValid]);
}


@end
