//
//  SAAds_ModelSpace_Tests5.m
//  SAModelSpace
//
//  Created by Gabriel Coman on 28/02/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "SATestUtils.h"
#import "SAAd.h"
#import "SACreative.h"
#import "SADetails.h"
#import "SAMedia.h"
#import "SAResponse.h"
#import "SAVASTAd.h"
#import "SAVASTEvent.h"

@interface TestSAAd_5 : XCTestCase
@property (nonatomic, strong) SATestUtils *utils;
@property (nonatomic, strong) SAAd *result;
@end

@implementation TestSAAd_5

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    _utils = [[SATestUtils alloc] init];
    NSString *given = [_utils fixtureWithName:@"mock_ad_response_4" ofType:@"json"];
    _result = [[SAAd alloc] initWithJsonString:given];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) test_SAAd {
    
    NSInteger expected_error = 0;
    NSInteger expected_advertiserId = 1;
    NSInteger expected_publisherId = 1;
    NSInteger expected_appId = 105;
    NSInteger expected_lineItemId = 140;
    NSInteger expected_campaignId = 117;
    NSInteger expected_placementId = 0;
    CGFloat expected_moat = 0.75;
    SACampaignType expected_campaignType = SA_CPM;
    NSString *expected_device = @"web";
    BOOL expected_isTest = false;
    BOOL expected_isFallback = false;
    BOOL expected_isFill = false;
    BOOL expected_isHouse = false;
    BOOL expected_isSafeAdApproved = true;
    BOOL expected_isPadlockVisible = true;
    
    XCTAssertNotNil(_result);
    XCTAssertEqual(_result.error, expected_error);
    XCTAssertEqual(_result.advertiserId, expected_advertiserId);
    XCTAssertEqual(_result.publisherId, expected_publisherId);
    XCTAssertEqual(_result.appId, expected_appId);
    XCTAssertEqual(_result.lineItemId, expected_lineItemId);
    XCTAssertEqualWithAccuracy(_result.moat, expected_moat, 0.01);
    XCTAssertEqual(_result.campaignId, expected_campaignId);
    XCTAssertEqual(_result.placementId, expected_placementId);
    XCTAssertEqual(_result.campaignType, expected_campaignType);
    XCTAssertEqualObjects(_result.device, expected_device);
    XCTAssertEqual(_result.isTest, expected_isTest);
    XCTAssertEqual(_result.isFallback, expected_isFallback);
    XCTAssertEqual(_result.isFill, expected_isFill);
    XCTAssertEqual(_result.isHouse, expected_isHouse);
    XCTAssertEqual(_result.isSafeAdApproved, expected_isSafeAdApproved);
    XCTAssertEqual(_result.isPadlockVisible, expected_isPadlockVisible);
    
}

- (void) test_SACreative {
    
    NSInteger expected_creative_id = 116;
    NSString *expected_creative_name = @"Interstitial 2";
    NSInteger expected_creative_cpm = 0;
    SACreativeFormat expected_creative_format = SA_Rich;
    BOOL expected_creative_live = true;
    BOOL expected_creative_approved = true;
    NSString *expected_creative_payload = nil;
    NSString *expected_creative_clickUrl = @"http://superawesome.tv";
    NSString *expected_creative_installUrl = nil;
    NSString *expected_creative_impressionUrl = @"http://superawesome.tv";
    NSString *expected_creative_clickCounterUrl = @"https://superawesome.tv/click_counter";
    NSString *expected_creative_bundle = nil;
    NSArray *expected_creative_osTarget = @[];
    
    XCTAssertNotNil(_result.creative);
    XCTAssertEqual(_result.creative._id, expected_creative_id);
    XCTAssertEqualObjects(_result.creative.name, expected_creative_name);
    XCTAssertEqual(_result.creative.cpm, expected_creative_cpm);
    XCTAssertEqual(_result.creative.format, expected_creative_format);
    XCTAssertEqual(_result.creative.live, expected_creative_live);
    XCTAssertEqual(_result.creative.approved, expected_creative_approved);
    XCTAssertEqualObjects(_result.creative.payload, expected_creative_payload);
    XCTAssertEqualObjects(_result.creative.clickUrl, expected_creative_clickUrl);
    XCTAssertEqualObjects(_result.creative.installUrl, expected_creative_installUrl);
    XCTAssertEqualObjects(_result.creative.clickCounterUrl, expected_creative_clickCounterUrl);
    XCTAssertEqualObjects(_result.creative.impressionUrl, expected_creative_impressionUrl);
    XCTAssertEqualObjects(_result.creative.bundle, expected_creative_bundle);
    XCTAssertEqualObjects(_result.creative.osTarget, expected_creative_osTarget);
    
}

- (void) test_SADetails {
    
    NSInteger expected_details_width = 320;
    NSInteger expected_details_height = 480;
    NSString *expected_details_name = nil;
    NSString *expected_details_format = @"mobile_display";
    NSInteger expected_details_bitrate = 0;
    NSInteger expected_details_duration = 0;
    NSInteger expected_details_value = 0;
    NSString *expected_details_image = @"https://s3-eu-west-1.amazonaws.com/sb-ads-uploads/rich-media/tNmFLJ7kGQWBbyORkIqTJ4oqykaGPU9w/rich-media/index.html";
    NSString *expected_details_video = @"https://s3-eu-west-1.amazonaws.com/sb-ads-uploads/rich-media/tNmFLJ7kGQWBbyORkIqTJ4oqykaGPU9w/rich-media/index.html";
    NSString *expected_details_tag = nil;
    NSString *expected_details_zip = nil;
    NSString *expected_details_url = @"https://s3-eu-west-1.amazonaws.com/sb-ads-uploads/rich-media/tNmFLJ7kGQWBbyORkIqTJ4oqykaGPU9w/rich-media/index.html";
    NSString *expected_details_cdn = @"https://s3-eu-west-1.amazonaws.com/sb-ads-uploads/rich-media/tNmFLJ7kGQWBbyORkIqTJ4oqykaGPU9w/rich-media/";
    NSString *expected_details_base = @"https://s3-eu-west-1.amazonaws.com";
    NSString *expected_details_vast = nil;
    
    XCTAssertNotNil(_result.creative.details);
    XCTAssertEqual(_result.creative.details.width, expected_details_width);
    XCTAssertEqual(_result.creative.details.height, expected_details_height);
    XCTAssertEqualObjects(_result.creative.details.name, expected_details_name);
    XCTAssertEqualObjects(_result.creative.details.format, expected_details_format);
    XCTAssertEqual(_result.creative.details.bitrate, expected_details_bitrate);
    XCTAssertEqual(_result.creative.details.duration, expected_details_duration);
    XCTAssertEqual(_result.creative.details.value, expected_details_value);
    XCTAssertEqualObjects(_result.creative.details.image, expected_details_image);
    XCTAssertEqualObjects(_result.creative.details.video, expected_details_video);
    XCTAssertEqualObjects(_result.creative.details.tag, expected_details_tag);
    XCTAssertEqualObjects(_result.creative.details.zip, expected_details_zip);
    XCTAssertEqualObjects(_result.creative.details.url, expected_details_url);
    XCTAssertEqualObjects(_result.creative.details.cdn, expected_details_cdn);
    XCTAssertEqualObjects(_result.creative.details.base, expected_details_base);
    XCTAssertEqualObjects(_result.creative.details.vast, expected_details_vast);
    
}

- (void) test_SAMedia {
    
    NSString *expected_media_html = nil;
    NSString *expected_media_path = nil;
    NSString *expected_media_url = nil;
    NSString *expected_media_type = nil;
    NSInteger expected_media_bitrate = 0;
    BOOL expected_media_isDownloaded = false;
    
    XCTAssertNotNil(_result.creative.details.media);
    XCTAssertEqualObjects(_result.creative.details.media.html, expected_media_html);
    XCTAssertEqualObjects(_result.creative.details.media.path, expected_media_path);
    XCTAssertEqualObjects(_result.creative.details.media.url, expected_media_url);
    XCTAssertEqualObjects(_result.creative.details.media.type, expected_media_type);
    XCTAssertEqual(_result.creative.details.media.bitrate, expected_media_bitrate);
    XCTAssertEqual(_result.creative.details.media.isDownloaded, expected_media_isDownloaded);
    
}

- (void) test_SAVASTAd {
    
    NSString *expected_vastad_redirect = nil;
    NSString *exprected_vastad_url = nil;
    SAVASTAdType expected_vastad_type = SA_Invalid_VAST;
    NSMutableArray* expected_vastad_media = [@[] mutableCopy];
    NSMutableArray* expected_vastad_events = [@[] mutableCopy];
    
    XCTAssertNotNil(_result.creative.details.media.vastAd);
    XCTAssertEqualObjects(_result.creative.details.media.vastAd.redirect, expected_vastad_redirect);
    XCTAssertEqualObjects(_result.creative.details.media.vastAd.url, exprected_vastad_url);
    XCTAssertEqual(_result.creative.details.media.vastAd.type, expected_vastad_type);
    XCTAssertNotNil(_result.creative.details.media.vastAd.media);
    XCTAssertNotNil(_result.creative.details.media.vastAd.events);
    XCTAssertEqual([_result.creative.details.media.vastAd.media count], [expected_vastad_media count]);
    XCTAssertEqual([_result.creative.details.media.vastAd.events count], [expected_vastad_events count]);
    
}

@end
