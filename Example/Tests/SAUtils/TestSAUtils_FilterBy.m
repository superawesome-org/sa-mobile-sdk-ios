//
//  SAUtils_ArrayExt_Tests.m
//  SAUtils
//
//  Created by Gabriel Coman on 14/10/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SAExtensions.h"
#import "MockModel.h"

@interface TestSAUtils_FilterBy : XCTestCase
@property (nonatomic, strong) MockModel *t1;
@property (nonatomic, strong) MockModel *t2;
@property (nonatomic, strong) MockModel *t3;
@property (nonatomic, strong) NSArray *testArray;
@end

@implementation TestSAUtils_FilterBy

- (void)setUp {
    [super setUp];
    _t1 = [[MockModel alloc] initWithName:@"John" andIsOK:true andPay:0];
    _t2 = [[MockModel alloc] initWithName:@"Lenny" andIsOK:false andPay:32000];
    _t3 = [[MockModel alloc] initWithName:@"Johannes" andIsOK:false andPay:18000];
    _testArray = @[_t1, _t2, _t3];
}

- (void)tearDown {
    [super tearDown];
}

- (void) test_SAUtils_Array_FilterBy {
    // when
    NSArray *expected = @[_t1];
    
    // then
    NSArray *result = [_testArray filterBy:@"name" withValue:@"John"];
    
    XCTAssertEqual(result.count, expected.count);
    for (int i = 0; i < result.count; i++) {
        XCTAssertEqualObjects(result[i], expected[i]);
    }
}

- (void) test_SAUtils_Array_FilterByName {
    // given
    NSArray *given = nil;
    
    // when
    NSArray *expected = nil;
    
    // then
    NSArray *result = [given filterBy:@"name" withValue:@"John"];
    
    XCTAssertNil(result);
    XCTAssertEqualObjects(result, expected);
}

- (void) testFilterByName3 {
    // when
    NSArray *expected = @[];
    
    // then
    NSArray *result = [_testArray filterBy:@"NonExistentField" withValue:@"Johannes"];
    
    XCTAssertEqual(result.count, 0);
    XCTAssertEqualObjects(result, expected);
}

- (void) testFilterByName4 {
    // when
    NSArray *expected = @[];
    
    // then
    NSArray *result = [_testArray filterBy:@"name" withValue:@"NonExistentName"];
    
    XCTAssertEqual(result.count, 0);
    XCTAssertEqualObjects(result, expected);
}

- (void) testFilterByName5 {
    // when
    NSArray *expected = @[];
    
    // then
    NSArray *result = [_testArray filterBy:@"isOK" withValue:@"John"];
    
    XCTAssertEqual(result.count, 0);
    XCTAssertEqualObjects(result, expected);
    
}

- (void) testFilterByBool1 {
    // when
    NSArray *expected = @[_t2, _t3];
    
    // then
    NSArray *result = [_testArray filterBy:@"isOK" withBool:false];
    
    XCTAssertEqual(result.count, expected.count);
    for (int i = 0; i < result.count; i++) {
        XCTAssertEqualObjects(result[i], expected[i]);
    }
}

- (void) testFilterByBool2 {
    // given
    NSArray *given = nil;
    
    // when
    NSArray *expected = nil;
    
    // then
    NSArray *result = [given filterBy:@"isOK" withBool:false];
    
    XCTAssertNil(result);
    XCTAssertEqualObjects(result, expected);
}

- (void) testFilterByBool3 {
    // when
    NSArray *expected = @[];
    
    // then
    NSArray *result = [_testArray filterBy:@"NonExistentField" withBool:false];
    
    XCTAssertEqual(result.count, 0);
    XCTAssertEqualObjects(result, expected);
}

- (void) testFilterByBool4 {
    // when
    NSArray *expected = @[];
    
    // then
    NSArray *result = [_testArray filterBy:@"name" withBool:false];
    
    XCTAssertEqual(result.count, 0);
    XCTAssertEqualObjects(result, expected);
}

- (void) testFilterByInt1 {
    // when
    NSArray *expected = @[_t2];
    
    // then
    NSArray *result = [_testArray filterBy:@"pay" withInt:32000];
    
    //
    XCTAssertEqual(result.count, expected.count);
    XCTAssertEqualObjects(result, expected);
}

- (void) testFilterByInt2 {
    // given
    NSArray *given = nil;
    
    // when
    NSArray *expected = nil;
    
    // then
    NSArray *result = [given filterBy:@"pay" withInt:18000];
    
    XCTAssertNil(result);
    XCTAssertEqualObjects(result, expected);
}

- (void) testFilterByInt3 {
    // when
    NSArray *expected = @[];
    
    // then
    NSArray *result = [_testArray filterBy:@"NonExistentField" withInt:0];
    
    XCTAssertEqual(result.count, 0);
    XCTAssertEqualObjects(result, expected);
}

- (void) testFilterByInt4 {
    // when
    NSArray *expected = @[];
    
    // then
    NSArray *result = [_testArray filterBy:@"name" withInt:32000];
    
    XCTAssertEqual(result.count, 0);
    XCTAssertEqualObjects(result, expected);
}

@end
