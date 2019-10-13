//
//  TestSAUtils_RemoveAllButFirst.m
//  SAUtils_Tests
//
//  Created by Gabriel Coman on 03/05/2018.
//  Copyright © 2018 Gabriel Coman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SAExtensions.h"
#import "MockModel.h"

@interface TestSAUtils_RemoveAllButFirst : XCTestCase
@property (nonatomic, strong) MockModel *t1;
@property (nonatomic, strong) MockModel *t2;
@property (nonatomic, strong) MockModel *t3;
@property (nonatomic, strong) NSArray *testArray;
@end

@implementation TestSAUtils_RemoveAllButFirst

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

- (void) testRemoveAllButFirst1 {
    // when
    NSArray *expected = @[_t1];
    
    // then
    NSArray *result = [_testArray removeAllButFirstElement];
    
    XCTAssertEqual(result.count, expected.count);
    XCTAssertEqual(result.count, 1);
    for (int i = 0; i < result.count; i++) {
        XCTAssertEqualObjects(result[i], expected[i]);
    }
}

- (void) testRemoveAllButFirst2 {
    // given
    NSArray *given = nil;
    
    // when
    NSArray *expected = nil;
    
    // then
    NSArray *result = [given removeAllButFirstElement];
    
    XCTAssertNil(result);
    XCTAssertEqualObjects(result, expected);
}

@end
