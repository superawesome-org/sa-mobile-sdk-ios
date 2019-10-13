//
//  TestSAUtils_FilePathInDocuments.m
//  SAUtils_Tests
//
//  Created by Gabriel Coman on 03/05/2018.
//  Copyright © 2018 Gabriel Coman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SAUtils.h"

@interface TestSAUtils_FilePathInDocuments : XCTestCase
@end

@implementation TestSAUtils_FilePathInDocuments

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void) test_SAUtils_GetPathInDocuments {
    // given
    NSArray *documentsPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = documentsPaths.firstObject;
    
    // when
    NSString *path1 = [NSString stringWithFormat:@"%@/%@", documentPath, @"abc.txt"];
    NSString *path2 = [NSString stringWithFormat:@"%@/%@", documentPath, @"tef"];
    NSString *path3 = [NSString stringWithFormat:@"%@", documentPath];
    
    // then
    NSString *tpath1 = [SAUtils filePathInDocuments:@"abc.txt"];
    NSString *tpath2 = [SAUtils filePathInDocuments:@"tef"];
    NSString *tpath3 = [SAUtils filePathInDocuments:nil];
    
    XCTAssertEqualObjects(path1, tpath1);
    XCTAssertEqualObjects(path2, tpath2);
    XCTAssertEqualObjects(path3, tpath3);
}

@end
