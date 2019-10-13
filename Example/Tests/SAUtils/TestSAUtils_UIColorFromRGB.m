//
//  TestSAUtils_UIColorFromRGB.m
//  SAUtils_Tests
//
//  Created by Gabriel Coman on 03/05/2018.
//  Copyright © 2018 Gabriel Coman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SAUtils.h"

@interface TestSAUtils_UIColorFromRGB : XCTestCase
@end

@implementation TestSAUtils_UIColorFromRGB

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void) test_SAUtils_ColorFromRGB {
    // given
    int red = 51, green = 255, blue = 0;
    
    // when
    UIColor *expected1 = [UIColor colorWithRed:51.0f/255.0f green:1 blue:0 alpha:1];
    CGFloat exp_red = 0.0f, exp_green = 0.0f, exp_blue = 0.0f, exp_alpha = 0.0f;
    [expected1 getRed:&exp_red green:&exp_green blue:&exp_blue alpha:&exp_alpha];
    
    // then
    UIColor *result1 = UIColorFromRGB(red, green, blue);
    CGFloat res_red = 0.0, res_green = 0.0, res_blue = 0.0, res_alpha =0.0;
    [result1 getRed:&res_red green:&res_green blue:&res_blue alpha:&res_alpha];
    
    res_red = trunc(100. * res_red);
    res_green = trunc(100. * res_green);
    res_blue = trunc(100. * res_blue);
    res_alpha = trunc(100. * res_alpha);
    exp_red = trunc(100. * exp_red);
    exp_green = trunc(100. * exp_green);
    exp_blue = trunc(100. * exp_blue);
    exp_alpha = trunc(100. * exp_alpha);
    
    XCTAssertEqual(res_red, exp_red);
    XCTAssertEqual(res_green, exp_green);
    XCTAssertEqual(res_blue, exp_blue);
    XCTAssertEqual(res_alpha, exp_alpha);
}

@end
