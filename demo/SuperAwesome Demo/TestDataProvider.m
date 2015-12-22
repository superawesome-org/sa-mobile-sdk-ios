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
             CreateAdItem(@"Banner - 9549", 9549, false, banner_item),
             CreateAdItem(@"Interstitial - 10324", 10324, false, interstitial_item),
             CreateAdItem(@"Video - 28000", 28000, false, video_item),
             CreateAdItem(@"Fullscreen Video - 21022", 21022, false, fullscreen_video_item),
             CreateAdItem(@"Tag - 10273", 10273, false, interstitial_item),
             CreateAdItem(@"Fallback Tag - 10213 ", 10213, false, interstitial_item),
             CreateAdItem(@"Interstitial - 25397", 25397, false, interstitial_item),
             CreateAdItem(@"Small Banner - 25785", 25785, false, banner_item),
             CreateAdItem(@"Video Preroll - 25971", 25971, false, fullscreen_video_item),
             CreateAdItem(@"Tag - 25785", 25785, false, interstitial_item),
             CreateAdItem(@"Dorin VAST Tag - 30244", 30244, false, fullscreen_video_item),
             CreateAdItem(@"Dorin 3rd Party VAST Tag - 30245", 30245, false, fullscreen_video_item),
             CreateAdItem(@"Dorin 3rd Party vAST Tag with Flash - 30243", 30243, false, fullscreen_video_item),
             CreateAdItem(@"Zepto - 30016", 30016, false, interstitial_item),
             CreateAdItem(@"Test 5740", 5750, true, fullscreen_video_item)
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