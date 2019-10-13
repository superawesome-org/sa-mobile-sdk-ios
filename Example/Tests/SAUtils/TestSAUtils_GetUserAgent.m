//
//  TestSAUtils_GetUserAgent.m
//  SAUtils_Tests
//
//  Created by Gabriel Coman on 03/05/2018.
//  Copyright © 2018 Gabriel Coman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SAUtils.h"

@interface TestSAUtils_GetUserAgent : XCTestCase
@end

@implementation TestSAUtils_GetUserAgent

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void) test_SAUtils_GetUserAgent {
    // can't test more than making sure the user agent is never nil, atm
    NSString *userAgent = [SAUtils getUserAgent];
    
    XCTAssertNotNil(userAgent);
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
        XCTAssertTrue([userAgent rangeOfString:@"iPad"].location > 0);
    } else {
        XCTAssertTrue([userAgent rangeOfString:@"iPhone"].location > 0);
    }
    
}

@end
