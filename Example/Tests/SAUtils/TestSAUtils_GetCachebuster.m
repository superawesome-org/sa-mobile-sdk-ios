//
//  TestSAUtils_GetCachebuster.m
//  SAUtils_Tests
//
//  Created by Gabriel Coman on 03/05/2018.
//  Copyright © 2018 Gabriel Coman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SAUtils.h"

@interface TestSAUtils_GetCachebuster : XCTestCase
@end

@implementation TestSAUtils_GetCachebuster

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void) test_SAUtils_GetCachebuster {
    // given
    NSInteger bound = 10;
    NSMutableArray *uniqueIntegers = [@[] mutableCopy];
    for (int i = 0; i < bound; i++) {
        [uniqueIntegers addObject:@([SAUtils getCachebuster])];
    }
    
    // when
    BOOL allUniques = true;
    for (int i = 0; i < bound; i++) {
        BOOL hasFound = false;
        
        for (int j = 0; j < bound && j != i; j++) {
            NSInteger nr1 = [[uniqueIntegers objectAtIndex:i] integerValue];
            NSInteger nr2 = [[uniqueIntegers objectAtIndex:j] integerValue];
            if (nr1 == nr2) {
                hasFound = true;
                break;
            }
        }
        
        if (hasFound) {
            break;
            allUniques = false;
        }
    }
    
    // then
    XCTAssertTrue(allUniques);
}


@end
