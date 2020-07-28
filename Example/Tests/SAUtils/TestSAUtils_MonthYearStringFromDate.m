//
//  SASAUtils_Colors_Tests.m
//  SAUtils
//
//  Created by Gabriel Coman on 13/10/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SAUtils.h"

@interface TestSAUtils_MonthYearStringFromDate : XCTestCase
@end

@implementation TestSAUtils_MonthYearStringFromDate

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void) test_SAUtils_MonthYearStringFromDate {
    // given
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *given1 = [dateFormat dateFromString:@"2020-07-27"];
    
    // when
    NSString* result1 = MonthYearStringFromDate(given1);
    
    // then
    XCTAssertTrue([result1 isEqualToString: @"07/2020"]);
}

@end
