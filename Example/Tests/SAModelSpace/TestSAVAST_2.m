//
//  SAVAST_ModelSpace_Tests2.m
//  SAModelSpace
//
//  Created by Gabriel Coman on 28/02/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SATestUtils.h"
#import "SAVASTAd.h"
#import "SAVASTMedia.h"
#import "SAVASTEvent.h"

@interface TestSAVAST_2 : XCTestCase
@property (nonatomic, strong) SATestUtils *utils;
@end

@implementation TestSAVAST_2

- (void) setUp {
    [super setUp];
    _utils = [[SATestUtils alloc] init];
}

- (void) tearDown {
    [super tearDown];
}

- (void) testVASTAd1 {
    
    // given
    NSString *given = [_utils fixtureWithName:@"mock_vast_response_4" ofType:@"json"];
    
    SAVASTAd *ad = [[SAVASTAd alloc] initWithJsonString:given];
    XCTAssertNotNil(ad);
    XCTAssertFalse([ad isValid]);
    
    NSString *expected_redirect = nil;
    SAVASTAdType expected_type = SA_Invalid_VAST;
    NSString *expected_url = nil;
    int expected_medias = 0;
    int expected_events = 0;
    
    XCTAssertEqualObjects(expected_redirect, ad.redirect);
    XCTAssertEqual(expected_type, ad.type);
    XCTAssertEqualObjects(expected_url, ad.url);
    XCTAssertNotNil([ad media]);
    XCTAssertEqual(expected_medias, [[ad media] count]);
    XCTAssertNotNil([ad events]);
    XCTAssertEqual(expected_events, [[ad events] count]);
}


- (void) testVASTAd2 {
    
    // given
    NSString *given = [_utils fixtureWithName:@"mock_vast_response_5" ofType:@"json"];
    
    SAVASTAd *ad = [[SAVASTAd alloc] initWithJsonString:given];
    XCTAssertNotNil(ad);
    XCTAssertTrue([ad isValid]);
    
    NSString *expected_redirect = nil;
    SAVASTAdType expected_type = SA_InLine_VAST;
    NSString *expected_url = @"https://ads.superawesome.tv/v2/demo_images/video.mp4";
    int expected_medias = 1;
    int expected_events = 2;
    
    XCTAssertEqualObjects(expected_redirect, ad.redirect);
    XCTAssertEqual(expected_type, ad.type);
    XCTAssertEqualObjects(expected_url, ad.url);
    XCTAssertNotNil([ad media]);
    XCTAssertEqual(expected_medias, [[ad media] count]);
    XCTAssertNotNil([ad events]);
    XCTAssertEqual(expected_events, [[ad events] count]);
    
    for (SAVASTEvent *evt in [ad events]) {
        XCTAssertTrue([evt isValid]);
    }
    
    for (SAVASTMedia *media in [ad media]) {
        XCTAssertTrue([media isValid]);
    }
}

- (void) testVASTAd3 {
    
    // given
    NSString *given = [_utils fixtureWithName:@"mock_vast_response_6" ofType:@"json"];
    
    SAVASTAd *ad = [[SAVASTAd alloc] initWithJsonString:given];
    XCTAssertNotNil(ad);
    XCTAssertTrue([ad isValid]);
    
    NSString *expected_redirect = nil;
    SAVASTAdType expected_type = SA_Wrapper_VAST;
    NSString *expected_url = @"https://ads.superawesome.tv/v2/demo_images/video.mp4";
    int expected_medias = 2;
    int expected_events = 3;
    
    XCTAssertEqualObjects(expected_redirect, ad.redirect);
    XCTAssertEqual(expected_type, ad.type);
    XCTAssertEqualObjects(expected_url, ad.url);
    XCTAssertNotNil([ad media]);
    XCTAssertEqual(expected_medias, [[ad media] count]);
    XCTAssertNotNil([ad events]);
    XCTAssertEqual(expected_events, [[ad events] count]);
    
    for (SAVASTEvent *evt in [ad events]) {
        XCTAssertTrue([evt isValid]);
    }
    
    for (SAVASTMedia *media in [ad media]) {
        XCTAssertTrue([media isValid]);
    }
}

- (void) testVASTAd4 {
    
    // given
    NSString *given = [_utils fixtureWithName:@"mock_vast_response_7" ofType:@"json"];
    
    SAVASTAd *ad = [[SAVASTAd alloc] initWithJsonString:given];
    XCTAssertNotNil(ad);
    XCTAssertFalse([ad isValid]);
    
    NSString *expected_redirect = nil;
    SAVASTAdType expected_type = SA_Invalid_VAST;
    NSString *expected_url = nil;
    int expected_medias = 0;
    int expected_events = 0;
    
    XCTAssertEqualObjects(expected_redirect, ad.redirect);
    XCTAssertEqual(expected_type, ad.type);
    XCTAssertEqualObjects(expected_url, ad.url);
    XCTAssertNotNil([ad media]);
    XCTAssertEqual(expected_medias, [[ad media] count]);
    XCTAssertNotNil([ad events]);
    XCTAssertEqual(expected_events, [[ad events] count]);
}

@end
