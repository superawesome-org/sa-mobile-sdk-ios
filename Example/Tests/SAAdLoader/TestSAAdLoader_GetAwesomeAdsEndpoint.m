//
//  SAAdLoader_Endpoint_Tests.m
//  SAAdLoader
//
//  Created by Gabriel Coman on 18/01/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SALoader.h"
#import "SASession.h"
#import "SAUtils.h"

@interface TestSAAdLoader_GetAwesomeAdsEndpoint : XCTestCase
@end

@implementation TestSAAdLoader_GetAwesomeAdsEndpoint

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void) test_SAAdLoader_GetAwesomeAdsEndpoint_WithProductionSession {
    // given
    SASession *session = [[SASession alloc] init];
    
    // when
    SALoader *loader = [[SALoader alloc] init];
    [session setConfigurationProduction];
    
    // then
    NSString *baseUrl = [loader getAwesomeAdsEndpoint:session forPlacementId:4001];
    
    XCTAssertNotNil(baseUrl);
    XCTAssertEqualObjects(@"https://ads.superawesome.tv/v2/ad/4001", baseUrl);
    
}

- (void) test_SAAdLoader_GetAwesomeAdsEndpoint_WithStagingSession {
    // given
    SASession *session = [[SASession alloc] init];
    
    // when
    SALoader *loader = [[SALoader alloc] init];
    [session setConfigurationStaging];
    
    // then
    NSString *baseUrl = [loader getAwesomeAdsEndpoint:session forPlacementId:4001];
    
    XCTAssertNotNil(baseUrl);
    XCTAssertEqualObjects(@"https://ads.staging.superawesome.tv/v2/ad/4001", baseUrl);
    
}

- (void) test_SAAdLoader_GetAwesomeAdsEndpoint_WithNilSession {
    // given
    SASession *session = nil;
    
    // when
    SALoader *loader = [[SALoader alloc] init];
    
    // then
    NSString *baseUrl = [loader getAwesomeAdsEndpoint:session forPlacementId:4001];
    
    XCTAssertNil(baseUrl);
    
}

@end
