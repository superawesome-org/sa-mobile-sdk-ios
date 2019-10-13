//
//  TestSAUtils_GenerateUniqueKey.m
//  SAUtils_Tests
//
//  Created by Gabriel Coman on 03/05/2018.
//  Copyright © 2018 Gabriel Coman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SAUtils.h"

@interface TestSAUtils_GenerateUniqueKey : XCTestCase
@end

@implementation TestSAUtils_GenerateUniqueKey

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void) test_SAUtils_GenerateUniqueKey {
    // given
    NSInteger bound = 100;
    NSMutableArray *uniqueKeys = [@[] mutableCopy];
    for (int i = 0; i < bound; i++) {
        [uniqueKeys addObject:[SAUtils generateUniqueKey]];
    }
    
    // when
    BOOL allUniques = true;
    for (int i = 0; i < bound; i++) {
        BOOL hasFound = false;
        
        for (int j = 0; j < bound && j != i; j++) {
            if ([uniqueKeys[i] isEqualToString:uniqueKeys[j]]) {
                hasFound = true;
                break;
            }
        }
        
        if (hasFound) {
            allUniques = false;
            break;
        }
    }
    
    // then
    XCTAssertTrue(allUniques);
}

@end
