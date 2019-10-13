//
//  SANetwork_DownloadItem_Tests.m
//  SANetwork
//
//  Created by Gabriel Coman on 19/10/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SAFileItem.h"
#import "SAFileDownloader.h"

@interface SANetwork_FileItem_Tests : XCTestCase
@end

@implementation SANetwork_FileItem_Tests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void) testSimple {
    // given
    SAFileItem *item = [[SAFileItem alloc] init];
    
    // assert
    XCTAssertNotNil(item);
    XCTAssertNil(item.key);
    XCTAssertNil(item.url);
    XCTAssertNil(item.fileName);
    XCTAssertNil(item.filePath);
    XCTAssertFalse([item isValid]);
}

- (void) test_SAFileItem_WithValidUrl {
    // given
    NSString *url1 = @"https://sa-beta-ads-video-transcoded-superawesome.netdna-ssl.com/5E827ejOz2QYaRWqyJpn15r1NyvInPy9.mp4";
    NSString *diskPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    
    // when
    SAFileItem *item = [[SAFileItem alloc] initWithUrl:url1];
    
    XCTAssertNotNil(item);
    
    XCTAssertNotNil(item.key);
    XCTAssertEqualObjects(@"sasdkkey_5E827ejOz2QYaRWqyJpn15r1NyvInPy9.mp4", item.key);
    
    XCTAssertNotNil(item.url);
    XCTAssertEqualObjects(@"https://sa-beta-ads-video-transcoded-superawesome.netdna-ssl.com/5E827ejOz2QYaRWqyJpn15r1NyvInPy9.mp4", item.url.absoluteString);
    
    XCTAssertNotNil(item.fileName);
    XCTAssertEqualObjects(@"5E827ejOz2QYaRWqyJpn15r1NyvInPy9.mp4", item.fileName);
    
    XCTAssertNotNil(item.filePath);
    NSString *expected = [NSString stringWithFormat:@"%@/5E827ejOz2QYaRWqyJpn15r1NyvInPy9.mp4", diskPath];
    XCTAssertEqualObjects(expected, item.filePath);
    
    XCTAssertTrue([item isValid]);
}

- (void) test_SAFileItem_WithInvalidUrl {
    // given
    NSString *url = @"jsjksalaslksalk";
    
    // when
    SAFileItem *item = [[SAFileItem alloc] initWithUrl:url];
    
    // then
    XCTAssertNotNil(item);
    XCTAssertNotNil(item.key);
    XCTAssertNotNil(item.url);
    XCTAssertNotNil(item.fileName);
    XCTAssertNotNil(item.filePath);
    XCTAssertTrue([item isValid]);
}

- (void) test_SAFileItem_WithMalformedUrl {
    // given
    NSString *url = @"90sa?/:SAjsako91lk/_21klj21.txt";
    
    // when
    SAFileItem *item = [[SAFileItem alloc] initWithUrl:url];
    
    // then
    XCTAssertNotNil(item);
    XCTAssertNotNil(item.key);
    XCTAssertNotNil(item.url);
    XCTAssertNotNil(item.fileName);
    XCTAssertNotNil(item.filePath);
    XCTAssertTrue([item isValid]);
}

- (void) test_SAFileItem_WithNullUrl {
    // given
    NSString *url = nil;
    
    // when
    SAFileItem *item = [[SAFileItem alloc] initWithUrl:url];
    
    // then
    XCTAssertNotNil(item);
    XCTAssertNil(item.key);
    XCTAssertNil(item.url);
    XCTAssertNil(item.fileName);
    XCTAssertNil(item.filePath);
    XCTAssertFalse([item isValid]);
}

- (void) test_SAFileItem_WithEmptyUrl {
    // given
    NSString *url = @"";
    
    // when
    SAFileItem *item = [[SAFileItem alloc] initWithUrl:url];
    
    // then
    XCTAssertNotNil(item);
    XCTAssertNil(item.key);
    XCTAssertNil(item.url);
    XCTAssertNil(item.fileName);
    XCTAssertNil(item.filePath);
    XCTAssertFalse([item isValid]);
}

- (void) test_SAFileItem_WithNullClassUrl {
    // given
    NSString *url = (NSString*)[NSNull null];
    
    // when
    SAFileItem *item = [[SAFileItem alloc] initWithUrl:url];
    
    // then
    XCTAssertNotNil(item);
    XCTAssertNil(item.key);
    XCTAssertNil(item.url);
    XCTAssertNil(item.fileName);
    XCTAssertNil(item.filePath);
    XCTAssertFalse([item isValid]);
}

@end
