//
//  SAParser.m
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 11/10/2015.
//
//

// import header file
#import "SAParser.h"

// import modelspace
#import "SAAd.h"
#import "SACreative.h"
#import "SADetails.h"

// import SuperAwesome main header
#import "SuperAwesome.h"

// import SAAux library of goodies
#import "SAUtils.h"

// import nsobject categories for parsing
#import "NSObject+StringToModel.h"
#import "NSObject+ModelToString.h"

// modelspace for vast parsing
#import "SAVASTAd.h"
#import "SAVASTCreative.h"
#import "SAVASTTracking.h"

// parser implementation
@implementation SAParser

- (BOOL) isAdDataValid:(SAAd *)ad {
    if (ad == NULL) return false;
    if (ad.creative == NULL) return false;
    if (ad.creative != NULL) {
        if (ad.creative.creativeFormat == invalid) return false;
        if (ad.creative.details == NULL) return false;
        if (ad.creative.details != NULL) {
            switch (ad.creative.creativeFormat) {
                case image:{
                    if (ad.creative.details.image == NULL) return false;
                    break;
                }
                case video:{
                    if (ad.creative.details.vast == NULL) return false;
                    break;
                }
                case rich:{
                    if (ad.creative.details.url == NULL) return false;
                    break;
                }
                case tag:{
                    if (ad.creative.details.tag == NULL) return false;
                    break;
                }
                case invalid: return false;
            }
        }
    }
    
    return true;
}

- (SAAd*) parseInitialAdFromNetwork:(NSData*)jsonData withPlacementId:(NSInteger)placementId {
    SAAd *ad = [[SAAd alloc] initModelFromJsonData:jsonData andOptions:CapitalizeKeysThatHaveUnderscores];
    ad.placementId = placementId;
    
    ad.creative.creativeFormat = invalid;
    if ([ad.creative.format isEqualToString:@"image_with_link"]) ad.creative.creativeFormat = image;
    else if ([ad.creative.format isEqualToString:@"video"]) ad.creative.creativeFormat = video;
    else if ([ad.creative.format containsString:@"rich_media"]) ad.creative.creativeFormat = rich;
    else if ([ad.creative.format containsString:@"tag"]) ad.creative.creativeFormat = tag;
    
    // create the tracking URL
    NSDictionary *trackjson = @{
        @"placement":@(ad.placementId),
        @"line_item":@(ad.lineItemId),
        @"creative":@(ad.creative._id),
        @"sdkVersion":[[SuperAwesome getInstance] getSdkVersion],
        @"rnd":@([SAUtils getCachebuster])
    };
    ad.creative.trackingUrl = [NSString stringWithFormat:@"%@/%@click?%@",
                               [[SuperAwesome getInstance] getBaseURL],
                               (ad.creative.creativeFormat == video ? @"video/" : @""),
                               [SAUtils formGetQueryFromDict:trackjson]];
    
    // get the viewbale impression URL
    NSDictionary *imprjson = @{
        @"sdkVersion":[[SuperAwesome getInstance] getSdkVersion],
        @"rnd":@([SAUtils getCachebuster]),
        @"data":[SAUtils encodeURI:[@{
            @"placement":@(ad.placementId),
            @"line_item":@(ad.lineItemId),
            @"creative":@(ad.creative._id),
            @"type":@"viewable_impression"
        } jsonStringCompactRepresentation]]
    };
    ad.creative.viewableImpressionUrl = [NSString stringWithFormat:@"%@/event?%@",
                                         [[SuperAwesome getInstance] getBaseURL],
                                         [SAUtils formGetQueryFromDict:imprjson]];
    
    // get the parental gate URL
    NSDictionary *pgjson = @{
        @"sdkVersion":[[SuperAwesome getInstance] getSdkVersion],
        @"rnd":@([SAUtils getCachebuster]),
        @"data":[SAUtils encodeURI:[@{
            @"placement":@(ad.placementId),
            @"line_item":@(ad.lineItemId),
            @"creative":@(ad.creative._id),
            @"type":@"custom.parentalGateAccessed"
        } jsonStringCompactRepresentation]]
    };
    ad.creative.parentalGateClickUrl = [NSString stringWithFormat:@"%@/event?%@",
                                        [[SuperAwesome getInstance] getBaseURL],
                                        [SAUtils formGetQueryFromDict:pgjson]];
    
    // valdate ad
     if ([self isAdDataValid:ad]) return ad;
    return nil;
}

- (SAAd*) parseAdFromExistingString:(NSString *)jsonString {
    // parse the main ad
    SAAd *ad = [[SAAd alloc] initModelFromJsonString:jsonString andOptions:CapitalizeKeysThatHaveUnderscores];
    
    for (short i = 0; i < ad.creative.details.data.vastAd.creative.TrackingEvents.count; i++){
        NSDictionary *d = ad.creative.details.data.vastAd.creative.TrackingEvents[i];
        SAVASTTracking *tracking = [[SAVASTTracking alloc] initModelFromJsonDictionary:d andOptions:CapitalizeKeysThatHaveUnderscores];
        [ad.creative.details.data.vastAd.creative.TrackingEvents replaceObjectAtIndex:i withObject:tracking];
    }
    
    return ad;
}

@end
