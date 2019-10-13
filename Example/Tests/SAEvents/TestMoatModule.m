//
//  TestMoatModule.m
//  SAEvents_Tests
//
//  Created by Gabriel Coman on 09/05/2018.
//  Copyright © 2018 Gabriel Coman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SAMoatModule.h"
#import "SAModelFactory.h"

@interface TestMoatModule : XCTestCase
@end

@implementation TestMoatModule

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void) test_MoatModule_IsMoatAllowed {
    // given
    SAAd *ad = [SAModelFactory createDisplayAd:1000];
    
    // when
    SAMoatModule *module = [[SAMoatModule alloc] initWithAd:ad];
    [module disableMoatLimiting];
    
    BOOL isAllowed1 = [module isMoatAllowed];
    BOOL isAllowed2 = [module isMoatAllowed];
    BOOL isAllowed3 = [module isMoatAllowed];
    BOOL isAllowed4 = [module isMoatAllowed];
    BOOL isAllowed5 = [module isMoatAllowed];
    
    // then
    XCTAssertTrue(isAllowed1);
    XCTAssertTrue(isAllowed2);
    XCTAssertTrue(isAllowed3);
    XCTAssertTrue(isAllowed4);
    XCTAssertTrue(isAllowed5);
}

@end
