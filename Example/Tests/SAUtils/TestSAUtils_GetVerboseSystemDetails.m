//
//  TestSAUtils_GetVerboseSystemDetails.m
//  SAUtils_Tests
//
//  Created by Gabriel Coman on 03/05/2018.
//  Copyright © 2018 Gabriel Coman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SAUtils.h"

@interface TestSAUtils_GetVerboseSystemDetails : XCTestCase

@end

@implementation TestSAUtils_GetVerboseSystemDetails

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void) test_SAUtils_GetVerboseSystemDetails {
    // given
    NSString *details = [SAUtils getVerboseSystemDetails];
    
    // then
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
        XCTAssertEqualObjects(details, @"ios_tablet");
    } else {
        XCTAssertEqualObjects(details, @"ios_mobile");
    }
}

@end
