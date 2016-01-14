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
             CreateAdItem(@"27 - AA - Mobile", 27, false, fullscreen_video_item),
             CreateAdItem(@"28 - AA - Tablet", 28, false, fullscreen_video_item),
             
             CreateAdItem(@"20 - Video for Tablet", 20, false, fullscreen_video_item),
             CreateAdItem(@"21 - Video for Mobile", 21, false, fullscreen_video_item),
             CreateAdItem(@"22 - Video for Web only", 22, false, fullscreen_video_item),
             CreateAdItem(@"23 - Video for all devices", 23, false, fullscreen_video_item),
             
             CreateAdItem(@"31 - Test", 31, false, fullscreen_video_item),
             
             CreateAdItem(@"Banner - 9549", 9549, false, interstitial_item),
             CreateAdItem(@"25 - Rich media", 25, false, interstitial_item),
             CreateAdItem(@"Interstitial - 10324", 10324, false, interstitial_item),
             CreateAdItem(@"Fullscreen Video - 21022", 21022, false, fullscreen_video_item),
             CreateAdItem(@"Fallback Tag - 10213 ", 10213, false, interstitial_item),
             CreateAdItem(@"Interstitial - 25397", 25397, false, interstitial_item),
             CreateAdItem(@"Small Banner - 25785", 25785, false, banner_item),
             CreateAdItem(@"Test 5740", 5750, true, fullscreen_video_item),
             CreateAdItem(@"Preroll 28000", 28000, false, fullscreen_video_item),
             CreateAdItem(@"10198", 10198, false, interstitial_item),
             CreateAdItem(@"Unity - 30288", 30288, false, fullscreen_video_item),
             CreateAdItem(@"Poki Test - 30210", 30210, false, fullscreen_video_item),
             CreateAdItem(@"Fungus Amungus - 30302", 30302, false, banner_item),
             CreateAdItem(@"10305", 10305, false, interstitial_item)
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