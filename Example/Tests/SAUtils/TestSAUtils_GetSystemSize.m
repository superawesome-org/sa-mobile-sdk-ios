//
//  SAUtils_System_Tests.m
//  SAUtils
//
//  Created by Gabriel Coman on 09/06/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SAUtils.h"

@interface TestSAUtils_GetSystemSize : XCTestCase
@end

@implementation TestSAUtils_GetSystemSize

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void) test_SAUtils_GetSystemSize {
    // given
    SASystemSize size = [SAUtils getSystemSize];
    
    // then
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
        XCTAssertEqual(size, size_tablet);
    } else {
        XCTAssertEqual(size, size_phone);
    }
}

@end
