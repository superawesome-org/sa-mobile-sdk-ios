//
//  SASessionTests.m
//  SASessionTests
//
//  Created by Gabriel Coman on 07/15/2016.
//  Copyright (c) 2016 Gabriel Coman. All rights reserved.
//

@import XCTest;
@import AdSupport;

// import session
#import "SASession.h"
#import "SACapper.h"
#import "SAUtils.h"

// define some test constants
#define TEST_PRODUCTION_URL @"https://ads.superawesome.tv/v2"
#define TEST_STAGING_URL @"https://ads.staging.superawesome.tv/v2"

@interface SASession_Tests : XCTestCase
@property (nonatomic, strong) SASession *session;
@property (nonatomic, strong) SACapper *capper;
@end

@implementation SASession_Tests

- (void) setUp {
    [super setUp];
    
    // init the session
    _session = [[SASession alloc] init];
}

- (void) tearDown {
    [super tearDown];
}

- (void) testDefaults {
    // given
    // new default session
    
    // when
    SAConfiguration expectedConfig = PRODUCTION;
    BOOL expectedTestMode = false;
    NSString *expectedVersion = @"0.0.0";
    NSString *expectedBaseUrl = TEST_PRODUCTION_URL;
    
    // then
    SAConfiguration config = [_session getConfiguration];
    BOOL testMode = [_session getTestMode];
    NSString *version = [_session getVersion];
    NSString *baseUrl = [_session getBaseUrl];
    
    // assert
    XCTAssertEqual(config, expectedConfig);
    XCTAssertEqual(testMode, expectedTestMode);
    XCTAssertEqualObjects(version, expectedVersion);
    XCTAssertEqualObjects(baseUrl, expectedBaseUrl);
}

- (void) testConfigurationProduction1 {
    // given
    [_session setConfigurationProduction];
    
    // when
    SAConfiguration expectedConfig = PRODUCTION;
    NSString *expectedBaseUrl = TEST_PRODUCTION_URL;
    
    // then
    SAConfiguration config = [_session getConfiguration];
    NSString *baseUrl = [_session getBaseUrl];
    
    // assert
    XCTAssertEqual(config, expectedConfig);
    XCTAssertEqualObjects(baseUrl, expectedBaseUrl);
}

- (void) testConfigurationProduction2 {
    // given
    [_session setConfiguration:PRODUCTION];
    
    // when
    SAConfiguration expectedConfig = PRODUCTION;
    NSString *expectedBaseUrl = TEST_PRODUCTION_URL;
    
    // then
    SAConfiguration config = [_session getConfiguration];
    NSString *baseUrl = [_session getBaseUrl];
    
    // assert
    XCTAssertEqual(config, expectedConfig);
    XCTAssertEqualObjects(baseUrl, expectedBaseUrl);
}

- (void) testConfigurationStaging1 {
    // given
    [_session setConfigurationStaging];
    
    // when
    SAConfiguration expectedConfig = STAGING;
    NSString *expectedBaseUrl = TEST_STAGING_URL;
    
    // then
    SAConfiguration config = [_session getConfiguration];
    NSString *baseUrl = [_session getBaseUrl];
    
    // assert
    XCTAssertEqual(config, expectedConfig);
    XCTAssertEqualObjects(baseUrl, expectedBaseUrl);
}

- (void) testConfigurationStaging2 {
    // given
    [_session setConfiguration:STAGING];
    
    // when
    SAConfiguration expectedConfig = STAGING;
    NSString *expectedBaseUrl = TEST_STAGING_URL;
    
    // then
    SAConfiguration config = [_session getConfiguration];
    NSString *baseUrl = [_session getBaseUrl];
    
    // assert
    XCTAssertEqual(config, expectedConfig);
    XCTAssertEqualObjects(baseUrl, expectedBaseUrl);
}

- (void) testEnableTestMode1 {
    // given
    [_session enableTestMode];
    
    // when
    BOOL expectedTestMode = true;
    
    // then
    BOOL testMode = [_session getTestMode];
    
    // assert
    XCTAssertEqual(testMode, expectedTestMode);
}

- (void) testEnableTestMode2 {
    // given
    [_session setTestMode:true];
    
    // when
    BOOL expectedTestMode = true;
    
    // then
    BOOL testMode = [_session getTestMode];
    
    // assert
    XCTAssertEqual(testMode, expectedTestMode);
}

- (void) testDisableTestMode1 {
    // given
    [_session disableTestMode];
    
    // when
    BOOL expectedTestMode = false;
    
    // then
    BOOL testMode = [_session getTestMode];
    
    // assert
    XCTAssertEqual(testMode, expectedTestMode);
}

- (void) testDisableTestMode2 {
    // given
    [_session setTestMode:false];
    
    // when
    BOOL expectedTestMode = false;
    
    // then
    BOOL testMode = [_session getTestMode];
    
    // assert
    XCTAssertEqual(testMode, expectedTestMode);
}

- (void) testVersion {
    // given
    [_session setVersion:@"3.1.2"];
    
    // when
    NSString *expectedVersion = @"3.1.2";
    
    // then
    NSString *version = [_session getVersion];
    
    // assert
    XCTAssertEqualObjects(version, expectedVersion);
}

- (void) testValues {
    // given
    [_session setConfigurationProduction];
    [_session disableTestMode];
    [_session setVersion:@"3.2.1"];
    
    // when
    SAConfiguration expectedConfig = PRODUCTION;
    NSString *expectedBaseUrl = TEST_PRODUCTION_URL;
    BOOL expectedTestMode = false;
    NSString *expectedVersion = @"3.2.1";
    NSString *expectedBundleId = @"org.cocoapods.demo.SASession-Example";
    NSString *expectedAppName = @"SASession_Example";
    NSString *expectedLang = @"en_US";
    NSString *expectedDevice = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? @"tablet" : @"phone";
    NSInteger expectedConnectivity = [SAUtils getNetworkConnectivity]; // wifi
    
    // then
    SAConfiguration config = [_session getConfiguration];
    NSString *baseUrl = [_session getBaseUrl];
    BOOL testMode = [_session getTestMode];
    NSString *version = [_session getVersion];
    NSString *bundleId = [_session getBundleId];
    NSString *appName = [_session getAppName];
    NSString *lang = [_session getLang];
    NSString *device = [_session getDevice];
    NSInteger connectivity = [_session getConnectivityType];
    NSInteger cachebuster = [_session getCachebuster];
    NSString *userAgent = [_session getUserAgent];
    NSUInteger dauId = [_session getDauId];
    
    // assert
    XCTAssertEqual(config, expectedConfig);
    XCTAssertEqualObjects(baseUrl, expectedBaseUrl);
    XCTAssertEqual(testMode, expectedTestMode);
    XCTAssertEqualObjects(version, expectedVersion);
    XCTAssertEqualObjects(bundleId, expectedBundleId);
    XCTAssertEqualObjects(appName, expectedAppName);
    XCTAssertEqualObjects(device, expectedDevice);
    XCTAssertEqualObjects(lang, expectedLang);
    XCTAssertEqual(connectivity, expectedConnectivity);
    XCTAssertTrue(cachebuster > 0);
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
        XCTAssertTrue([userAgent rangeOfString:@"iPad"].location > 0);
    } else {
        XCTAssertTrue([userAgent rangeOfString:@"iPhone"].location > 0);
    }
    
    BOOL canTrack = [[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled];
    if (canTrack) {
        XCTAssertTrue(dauId > 0);
    }
}

@end

