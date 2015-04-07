//
//  SAAppConfig.h
//  SAMobileSDK
//
//  Created by Balázs Kiss on 04/12/14.
//  Copyright (c) 2014 SuperAwesome Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SADisplayAd.h"
#import "SAVideoAd.h"

@interface SAAppConfig : NSObject

@property (nonatomic,strong) NSString *appID;
@property (nonatomic,strong) NSArray *displayAds;
@property (nonatomic,strong) NSArray *videoAds;
@property (nonatomic,assign,getter = isLoading) BOOL loading;

- (SADisplayAd *)displayAdByPlacementID:(NSString *)placementID;
- (SAVideoAd *)videoAdByPlacementID:(NSString *)placementID;
- (void)dumpPlacements;

@end
