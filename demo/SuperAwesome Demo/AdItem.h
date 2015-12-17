//
//  AdItem.h
//  sa-mobileios-sdk-test
//
//  Created by Gabriel Coman on 09/12/2015.
//  Copyright © 2015 Gabriel Coman. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum AdItemType {
    banner_item = 0,
    video_item = 1,
    interstitial_item = 2,
    fullscreen_video_item = 3
} AdItemType;


@interface AdItem : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSInteger placementId;
@property (nonatomic, assign) BOOL testEnabled;
@property (nonatomic, assign) AdItemType type;

@end

// creator
AdItem *CreateAdItem(NSString *title, NSInteger placementId, BOOL testEnabled, AdItemType type);
