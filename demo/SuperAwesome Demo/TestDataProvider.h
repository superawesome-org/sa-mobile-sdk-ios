//
//  TestDataProvider.h
//  sa-mobileios-sdk-test
//
//  Created by Gabriel Coman on 09/12/2015.
//  Copyright © 2015 Gabriel Coman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdItem.h"

@interface TestDataProvider : NSObject

+ (NSArray*) createTestData;

@end

AdItem* getItemFromArrayByPlacement(NSArray *arr, NSInteger placementId);
