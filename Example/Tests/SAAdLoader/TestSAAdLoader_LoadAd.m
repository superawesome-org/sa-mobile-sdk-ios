//
//  SAAdLoader_Async_Tests.m
//  SAAdLoader
//
//  Created by Gabriel Coman on 18/01/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SASession.h"
#import "SALoader.h"
#import "SAAd.h"
#import "SACreative.h"
#import "SADetails.h"
#import "SAMedia.h"
#import "SAResponse.h"
#import "SAVASTAd.h"
#import "SAVASTMedia.h"
#import "SAVASTEvent.h"
#import "SAMockAdServer.h"
#import "SAMockSession.h"

@interface TestSAAdLoader_LoadAd : XCTestCase
@property (nonatomic, strong) SAMockAdServer *server;
@property (nonatomic, strong) SAMockSession *session;
@end

@implementation TestSAAdLoader_LoadAd

- (void)setUp {
    [super setUp];
    _server = [[SAMockAdServer alloc] init];
    [_server start];
    _session = [[SAMockSession alloc] init];
}

- (void)tearDown {
    [_server shutdown];
    [super tearDown];
}

- (void) test_SAAdLoader_LoadAd_WithBannerCPMAd {
    
    __block XCTestExpectation *expectation = [self expectationWithDescription:@"High Expectations"];
    
    SALoader *loader = [[SALoader alloc] init];
    [loader loadAd:1000 withSession:_session andResult:^(SAResponse *response) {
        
        XCTAssertNotNil(response);
        XCTAssertNotNil([response ads]);
        XCTAssertEqual(1, [[response ads] count]);
        
        SAAd *ad = [[response ads] objectAtIndex:0];
        
        XCTAssertNotNil(ad);
        XCTAssertTrue([ad isValid]);
        
        // main ad
        XCTAssertEqual(4, ad.advertiserId);
        XCTAssertEqual(4, ad.publisherId);
        XCTAssertFalse(ad.isFill);
        XCTAssertFalse(ad.isFallback);
        XCTAssertEqualWithAccuracy(0.2, ad.moat, 0.05);
        XCTAssertFalse(ad.isHouse);
        XCTAssertTrue(ad.isSafeAdApproved);
        XCTAssertTrue(ad.isPadlockVisible);
        XCTAssertEqual(SA_CPM, ad.campaignType);
        XCTAssertEqual(44855, ad.lineItemId);
        XCTAssertEqual(32862, ad.campaignId);
        XCTAssertEqual(31570, ad.appId);
        XCTAssertTrue(ad.isTest);
        XCTAssertEqualObjects(@"phone", ad.device);
        
        // creative
        SACreative *creative = ad.creative;
        
        XCTAssertNotNil(creative);
        
        XCTAssertEqual(230903, creative._id);
        XCTAssertEqualObjects(@"Moat New SDK - Banner Creative", creative.name);
        XCTAssertEqual(SA_Image, creative.format);
        XCTAssertNil(creative.impressionUrl);
        XCTAssertEqualObjects(@"http://superawesome.tv", creative.clickUrl);
        
        // details
        SADetails *details = creative.details;
        
        XCTAssertEqualObjects(@"https://sa-beta-ads-uploads-superawesome.netdna-ssl.com/images/a3wKV14OSmxTAUOs7W2iXdnOHl8psm9z.jpg", details.url);
        XCTAssertEqualObjects(@"https://sa-beta-ads-uploads-superawesome.netdna-ssl.com/images/a3wKV14OSmxTAUOs7W2iXdnOHl8psm9z.jpg", details.image);
        XCTAssertNil(details.vast);
        XCTAssertEqualObjects(@"mobile_display", details.format);
        XCTAssertEqual(320, details.width);
        XCTAssertEqual(50, details.height);

        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void) test_SAAdLoader_LoadAd_WithBannerCPIAd {
    
    __block XCTestExpectation *expectation = [self expectationWithDescription:@"High Expectations"];
    
    SALoader *loader = [[SALoader alloc] init];
    [loader loadAd:1001 withSession:_session andResult:^(SAResponse *response) {
        
        XCTAssertNotNil(response);
        XCTAssertNotNil([response ads]);
        XCTAssertEqual(1, [[response ads] count]);
        
        SAAd *ad = [[response ads] objectAtIndex:0];
        
        XCTAssertNotNil(ad);
        XCTAssertTrue([ad isValid]);
        
        // main ad
        XCTAssertEqual(4, ad.advertiserId);
        XCTAssertEqual(4, ad.publisherId);
        XCTAssertFalse(ad.isFill);
        XCTAssertFalse(ad.isFallback);
        XCTAssertEqualWithAccuracy(0.2, ad.moat, 0.05);
        XCTAssertFalse(ad.isHouse);
        XCTAssertTrue(ad.isSafeAdApproved);
        XCTAssertTrue(ad.isPadlockVisible);
        XCTAssertEqual(SA_CPI, ad.campaignType);
        XCTAssertEqual(44855, ad.lineItemId);
        XCTAssertEqual(32862, ad.campaignId);
        XCTAssertEqual(31570, ad.appId);
        XCTAssertTrue(ad.isTest);
        XCTAssertEqualObjects(@"phone", ad.device);
        
        // creative
        SACreative *creative = ad.creative;
        
        XCTAssertNotNil(creative);
        
        XCTAssertEqual(230903, creative._id);
        XCTAssertEqualObjects(@"Moat New SDK - Banner Creative", creative.name);
        XCTAssertEqual(SA_Image, creative.format);
        XCTAssertNil(creative.impressionUrl);
        XCTAssertEqualObjects(@"http://superawesome.tv", creative.clickUrl);
        
        // details
        SADetails *details = creative.details;
        
        XCTAssertEqualObjects(@"https://sa-beta-ads-uploads-superawesome.netdna-ssl.com/images/a3wKV14OSmxTAUOs7W2iXdnOHl8psm9z.jpg", details.url);
        XCTAssertEqualObjects(@"https://sa-beta-ads-uploads-superawesome.netdna-ssl.com/images/a3wKV14OSmxTAUOs7W2iXdnOHl8psm9z.jpg", details.image);
        XCTAssertNil(details.vast);
        XCTAssertEqualObjects(@"mobile_display", details.format);
        XCTAssertEqual(320, details.width);
        XCTAssertEqual(50, details.height);
        
        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void) test_SAAdLoader_LoadAd_WithVideoAd {
    
    __block XCTestExpectation *expectation = [self expectationWithDescription:@"High Expectations"];
    
    SALoader *loader = [[SALoader alloc] init];
    [loader loadAd:1002 withSession:_session andResult:^(SAResponse *response) {
        
        XCTAssertNotNil(response);
        XCTAssertNotNil([response ads]);
        XCTAssertEqual(1, [[response ads] count]);
        
        SAAd *ad = [[response ads] objectAtIndex:0];
        
        XCTAssertNotNil(ad);
        XCTAssertTrue([ad isValid]);
        
        // main ad
        XCTAssertEqual(4, ad.advertiserId);
        XCTAssertEqual(4, ad.publisherId);
        XCTAssertFalse(ad.isFill);
        XCTAssertFalse(ad.isFallback);
        XCTAssertEqualWithAccuracy(0.2, ad.moat, 0.05);
        XCTAssertFalse(ad.isHouse);
        XCTAssertTrue(ad.isSafeAdApproved);
        XCTAssertTrue(ad.isPadlockVisible);
        XCTAssertEqual(SA_CPM, ad.campaignType);
        XCTAssertEqual(44855, ad.lineItemId);
        XCTAssertEqual(32862, ad.campaignId);
        XCTAssertEqual(31570, ad.appId);
        XCTAssertTrue(ad.isTest);
        XCTAssertEqualObjects(@"phone", ad.device);
        
        // creative
        SACreative *creative = ad.creative;
        
        XCTAssertNotNil(creative);
        
        XCTAssertEqual(230904, creative._id);
        XCTAssertNil(creative.name);
        XCTAssertEqual(SA_Video, creative.format);
        XCTAssertNil(creative.impressionUrl);
        XCTAssertEqualObjects(@"http://superawesome.tv", creative.clickUrl);
        
        // details
        SADetails *details = creative.details;
        
        XCTAssertEqualObjects(@"/dkopqAGR8eYBV5KNQP7wH9UQniqbG4Ga.mp4", details.url);
        XCTAssertEqualObjects(@"/dkopqAGR8eYBV5KNQP7wH9UQniqbG4Ga.mp4", details.image);
        XCTAssertEqualObjects(@"http://localhost:64000/vast/vast.xml", details.vast);
        XCTAssertEqualObjects(@"video", details.format);
        XCTAssertEqual(600, details.width);
        XCTAssertEqual(480, details.height);
        
        // more
        SAMedia *media = details.media;
        
        XCTAssertNotNil(media);
        XCTAssertEqualObjects(@"videoresource.mp4", media.path);
        XCTAssertTrue(media.isDownloaded);
        
        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void) test_SAAdLoader_LoadAd_WithVideoAdResponseButNoVASTTagResponse {
    
    __block XCTestExpectation *expectation = [self expectationWithDescription:@"High Expectations"];
    
    SALoader *loader = [[SALoader alloc] init];
    [loader loadAd:1005 withSession:_session andResult:^(SAResponse *response) {
        
        XCTAssertNotNil(response);
        XCTAssertNotNil([response ads]);
        XCTAssertEqual(1, [[response ads] count]);
        
        SAAd *ad = [[response ads] objectAtIndex:0];
        
        XCTAssertNotNil(ad);
        XCTAssertFalse([ad isValid]);
        
        SACreative *creative = ad.creative;
        
        XCTAssertNotNil(creative);
        XCTAssertEqual(SA_Video, creative.format);
        
        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void) test_SAAdLoader_LoadAd_WithVideoAdResponseAndVASTResponseButNoVideoResource {
    
    __block XCTestExpectation *expectation = [self expectationWithDescription:@"High Expectations"];
    
    SALoader *loader = [[SALoader alloc] init];
    [loader loadAd:1006 withSession:_session andResult:^(SAResponse *response) {
        
        XCTAssertNotNil(response);
        XCTAssertNotNil([response ads]);
        XCTAssertEqual(1, [[response ads] count]);
        
        SAAd *ad = [[response ads] objectAtIndex:0];
        
        XCTAssertNotNil(ad);
        XCTAssertFalse([ad isValid]);
        
        SACreative *creative = ad.creative;
        
        XCTAssertNotNil(creative);
        XCTAssertEqual(SA_Video, creative.format);
        
        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void) test_SAAdLoader_LoadAd_WithEmptyAd {
    
    __block XCTestExpectation *expectation = [self expectationWithDescription:@"High Expectations"];
    
    SALoader *loader = [[SALoader alloc] init];
    [loader loadAd:1003 withSession:_session andResult:^(SAResponse *response) {
        
        XCTAssertNotNil(response);
        XCTAssertNotNil([response ads]);
        XCTAssertEqual(1, [[response ads] count]);
        
        SAAd *ad = [[response ads] objectAtIndex:0];
        
        XCTAssertNotNil(ad);
        XCTAssertFalse([ad isValid]);
        
        SACreative *creative = ad.creative;
        
        XCTAssertNotNil(creative);
        XCTAssertEqual(SA_Invalid, creative.format);
        
        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void) test_SAAdLoader_LoadAd_WithMalformedResponse {
    
    __block XCTestExpectation *expectation = [self expectationWithDescription:@"High Expectations"];
    
    SALoader *loader = [[SALoader alloc] init];
    [loader loadAd:1004 withSession:_session andResult:^(SAResponse *response) {
        
        XCTAssertNotNil(response);
        XCTAssertNotNil([response ads]);
        XCTAssertEqual(1, [[response ads] count]);
        
        SAAd *ad = [[response ads] objectAtIndex:0];
        
        XCTAssertNotNil(ad);
        XCTAssertFalse([ad isValid]);
        
        SACreative *creative = ad.creative;
        
        XCTAssertNotNil(creative);
        XCTAssertEqual(SA_Invalid, creative.format);
        
        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void) test_SAAdLoader_LoadAd_WithTimeoutResponse {
    
    __block XCTestExpectation *expectation = [self expectationWithDescription:@"High Expectations"];
    
    SALoader *loader = [[SALoader alloc] init];
    [loader loadAd:50000 withSession:_session andResult:^(SAResponse *response) {
        
        XCTAssertNotNil(response);
        XCTAssertNotNil([response ads]);
        XCTAssertEqual(0, [[response ads] count]);
        
        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

@end
