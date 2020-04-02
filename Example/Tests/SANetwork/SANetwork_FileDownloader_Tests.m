//
//  SANetwork_FileDownloader_Tests.m
//  SANetwork
//
//  Created by Gabriel Coman on 19/10/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "SAFileDownloader.h"
#import "SAFileItem.h"
#import "SATestUtils.h"
@import OHHTTPStubs;

@interface SANetwork_FileDownloader_Tests : XCTestCase
@property (nonatomic, strong) SATestUtils *utils;
@property (nonatomic, strong) NSUserDefaults *defaults;
@end

@implementation SANetwork_FileDownloader_Tests

- (void)setUp {
    [super setUp];
    _utils = [[SATestUtils alloc] init];
    _defaults = [NSUserDefaults standardUserDefaults];
}

- (void)tearDown {
    _utils = nil;
    [HTTPStubs removeAllStubs];
    [super tearDown];
}

- (void) testExtension {
    
}


- (void) test_SAFileDownloader_DownloadFile_WithMP4File {

    NSString *url = @"https://my.mock.api/resource/videoresource.mp4";
    
    [HTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest * _Nonnull request) {
        return true;
    } withStubResponse:^HTTPStubsResponse * _Nonnull(NSURLRequest * _Nonnull request) {
        NSData* data = [self->_utils dataFixtureWithName:@"videoresource" ofType:@"mp4"];
        return [HTTPStubsResponse responseWithData:data
                                        statusCode:200
                                           headers:@{@"Content-Type":@"application/json"}];
    }];
    
    __block XCTestExpectation *expectation = [self expectationWithDescription:@"High Expectations"];
    
    SAFileDownloader *downloader = [[SAFileDownloader alloc] init];
    
    [downloader downloadFileFrom:url andResponse:^(BOOL success, NSString *key, NSString *diskPath) {
        
        XCTAssertEqual(success, true);
        
        XCTAssertNotNil(key);
        XCTAssertEqualObjects(@"sasdkkey_videoresource.mp4", key);
        
        XCTAssertNotNil(diskPath);
        XCTAssertEqualObjects(@"videoresource.mp4", diskPath);
        
        NSString *value = [self->_defaults objectForKey:key];
        
        XCTAssertEqualObjects(value, diskPath);
        
        [SAFileDownloader cleanup];
    
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void) test_SAFileDownloader_DownloadFile_WithPNGFile {
    
    NSString *url = @"https://my.mock.api/resource/pngresource.png";
    
    [HTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest * _Nonnull request) {
        return true;
    } withStubResponse:^HTTPStubsResponse * _Nonnull(NSURLRequest * _Nonnull request) {
        NSData* data = [self->_utils dataFixtureWithName:@"pngresource" ofType:@"png"];
        return [HTTPStubsResponse responseWithData:data
                                        statusCode:200
                                           headers:@{@"Content-Type":@"application/json"}];
    }];
    
    __block XCTestExpectation *expectation = [self expectationWithDescription:@"High Expectations"];
    
    SAFileDownloader *downloader = [[SAFileDownloader alloc] init];
    
    [downloader downloadFileFrom:url andResponse:^(BOOL success, NSString *key, NSString *diskPath) {
        
        XCTAssertEqual(success, true);
        
        XCTAssertNotNil(key);
        XCTAssertEqualObjects(@"sasdkkey_pngresource.png", key);
        
        XCTAssertNotNil(diskPath);
        XCTAssertEqualObjects(@"pngresource.png", diskPath);
        
        NSString *value = [self->_defaults objectForKey:key];
        
        XCTAssertEqualObjects(value, diskPath);
        
        [SAFileDownloader cleanup];
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void) test_SAFileDownloader_DownloadFile_WithNetworkError {
    
    NSString *url = @"https://my.mock.api/resource/pngresource.png";
    
    [HTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest * _Nonnull request) {
        return true;
    } withStubResponse:^HTTPStubsResponse * _Nonnull(NSURLRequest * _Nonnull request) {
        NSError* notConnectedError = [NSError errorWithDomain:NSURLErrorDomain code:kCFURLErrorNotConnectedToInternet userInfo:nil];
        return [HTTPStubsResponse responseWithError:notConnectedError];
    }];
    
    __block XCTestExpectation *expectation = [self expectationWithDescription:@"High Expectations"];
    
    SAFileDownloader *downloader = [[SAFileDownloader alloc] init];
    
    [downloader downloadFileFrom:url andResponse:^(BOOL success, NSString *key, NSString *diskPath) {
        
        XCTAssertFalse(success);
        XCTAssertNil(key);
        XCTAssertNil(diskPath);
        
        [SAFileDownloader cleanup];
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void) test_SAFileDownloader_DownloadFile_WithNullUrl {
    
    NSString *url = nil;
    
    __block XCTestExpectation *expectation = [self expectationWithDescription:@"High Expectations"];
    
    SAFileDownloader *downloader = [[SAFileDownloader alloc] init];
    
    [downloader downloadFileFrom:url andResponse:^(BOOL success, NSString *key, NSString *diskPath) {
        
        XCTAssertEqual(success, false);
        XCTAssertNil(diskPath);
        XCTAssertNil(key);
        
        [SAFileDownloader cleanup];
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
    
}

- (void) test_SAFileDownloader_DownloadFile_WithMalformedUrl {
    
    NSString *url = @"90sa?/:SAjsako91lk/_21klj21.txt";
    
    __block XCTestExpectation *expectation = [self expectationWithDescription:@"High Expectations"];
    
    SAFileDownloader *downloader = [[SAFileDownloader alloc] init];
    
    [downloader downloadFileFrom:url andResponse:^(BOOL success, NSString *key, NSString *diskPath) {
        
        XCTAssertEqual(success, false);
        XCTAssertNil(diskPath);
        XCTAssertNil(key);
        
        [SAFileDownloader cleanup];
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void) test_SAFileDownloader_DownloadFile_WithEmptyUrl {
    
    NSString *url = @"";
    
    __block XCTestExpectation *expectation = [self expectationWithDescription:@"High Expectations"];
    
    SAFileDownloader *downloader = [[SAFileDownloader alloc] init];
    
    [downloader downloadFileFrom:url andResponse:^(BOOL success, NSString *key, NSString *diskPath) {
        
        XCTAssertEqual(success, false);
        XCTAssertNil(diskPath);
        XCTAssertNil(key);
        
        [SAFileDownloader cleanup];
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

- (void) test_SAFileDownloader_DownloadFile_WithNullClassUrl {
    
    NSString *url = (NSString*)[NSNull null];
    
    __block XCTestExpectation *expectation = [self expectationWithDescription:@"High Expectations"];
    
    SAFileDownloader *downloader = [[SAFileDownloader alloc] init];
    
    [downloader downloadFileFrom:url andResponse:^(BOOL success, NSString *key, NSString *diskPath) {
        
        XCTAssertEqual(success, false);
        XCTAssertNil(diskPath);
        XCTAssertNil(key);
        
        [SAFileDownloader cleanup];
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

@end
