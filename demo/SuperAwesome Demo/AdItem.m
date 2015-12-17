//
//  AdItem.m
//  sa-mobileios-sdk-test
//
//  Created by Gabriel Coman on 09/12/2015.
//  Copyright © 2015 Gabriel Coman. All rights reserved.
//

#import "AdItem.h"

@implementation AdItem
@end

AdItem *CreateAdItem(NSString *title, NSInteger placementId, BOOL testEnabled, AdItemType type) {
    AdItem *ad = [[AdItem alloc] init];
    ad.title = title;
    ad.placementId = placementId;
    ad.testEnabled = testEnabled;
    ad.type = type;
    return ad;
}