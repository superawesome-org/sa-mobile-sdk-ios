//
//  TestDataProvider.m
//  sa-mobileios-sdk-test
//
//  Created by Gabriel Coman on 09/12/2015.
//  Copyright © 2015 Gabriel Coman. All rights reserved.
//

#import "TestDataProvider.h"
#import "AdItem.h"

@implementation TestDataProvider

+ (NSArray*) createTestData {
    return @[
             CreateAdItem(@"Lego occasions test", 3051, false, interstitial_item),
             CreateAdItem(@"79", 79, false, fullscreen_video_item),
             CreateAdItem(@"1830", 1830, false, fullscreen_video_item),
             CreateAdItem(@"2548", 2548, false, fullscreen_video_item),
             CreateAdItem(@"7455", 7455, false, fullscreen_video_item),
             CreateAdItem(@"2559", 2559, false, interstitial_item),
             CreateAdItem(@"10305", 10305, false, interstitial_item),
             CreateAdItem(@"30716", 30716, false, interstitial_item),
             CreateAdItem(@"30740", 30740, false, interstitial_item),
    ];
}

@end

AdItem *getItemFromArrayByPlacement(NSArray *arr, NSInteger placementId) {
    
    for (AdItem *item in arr) {
        if (item.placementId == placementId) {
            return item;
            break;
        }
    }
    
    return NULL;
}