//
//  SAAppConfig.m
//  SAMobileSDK
//
//  Created by Balázs Kiss on 04/12/14.
//  Copyright (c) 2014 SuperAwesome Ltd. All rights reserved.
//

#import "SAAppConfig.h"

@implementation SAAppConfig

- (SADisplayAd *)displayAdByPlacementID:(NSString *)placementID
{
    if(self.displayAds == nil) return nil;
    for(SADisplayAd *displayAd in self.displayAds){
        if([[displayAd valueForKey:@"id"] isEqualToString:placementID]){
            return displayAd;
        }
    }
    return nil;
}

- (SAVideoAd *)videoAdByPlacementID:(NSString *)placementID
{
    if(self.videoAds == nil) return nil;
    for(SAVideoAd *videoAd in self.videoAds){
        if([[videoAd valueForKey:@"id"] isEqualToString:placementID]){
            return videoAd;
        }
    }
    return nil;
}

- (void)dumpPlacements
{
    for(SADisplayAd *displayAd in self.displayAds){
        NSLog(@"DisplayAd: %@ %@x%@", [displayAd valueForKey:@"id"], displayAd.width, displayAd.height);
    }
    for(SAVideoAd *videoAd in self.videoAds){
        NSLog(@"VideoAd: %@", [videoAd valueForKey:@"id"]);
    }
}

@end
