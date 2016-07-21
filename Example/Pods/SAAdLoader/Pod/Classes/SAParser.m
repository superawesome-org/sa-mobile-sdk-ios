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
 #import "SASession.h"

// import SAAux library of goodies
#import "SAUtils.h"
#import "SAJsonParser.h"

// modelspace for vast parsing
#import "SAVASTAd.h"
#import "SAVASTCreative.h"
#import "SAVASTTracking.h"

// parser implementation
@implementation SAParser

- (SAAd*) parseInitialAdFromNetwork:(NSString*)jsonString withPlacementId:(NSInteger)placementId {
    
    SAAd *ad = [[SAAd alloc] initWithJsonString:jsonString];
    ad.placementId = placementId;
    
    ad.creative.creativeFormat = invalid;
    if ([ad.creative.format isEqualToString:@"image_with_link"]) ad.creative.creativeFormat = image;
    else if ([ad.creative.format isEqualToString:@"video"]) ad.creative.creativeFormat = video;
    if ([ad.creative.format rangeOfString:@"rich_media"].location != NSNotFound) { ad.creative.creativeFormat = rich; }
    if ([ad.creative.format rangeOfString:@"tag"].location != NSNotFound) { ad.creative.creativeFormat = tag; }
    
    // create the tracking URL
    NSDictionary *trackjson = @{
        @"placement":@(ad.placementId),
        @"line_item":@(ad.lineItemId),
        @"creative":@(ad.creative._id),
        @"ct":@([SAUtils getNetworkConnectivity]),
        @"sdkVersion":[[SASession getInstance] getVersion],
        @"rnd":@([SAUtils getCachebuster])
    };
    ad.creative.trackingUrl = [NSString stringWithFormat:@"%@/%@click?%@",
                               [[SASession getInstance] getBaseUrl],
                               (ad.creative.creativeFormat == video ? @"video/" : @""),
                               [SAUtils formGetQueryFromDict:trackjson]];
    
    // get the viewbale impression URL
    NSDictionary *imprjson = @{
        @"sdkVersion":[[SASession getInstance] getVersion],
        @"rnd":@([SAUtils getCachebuster]),
        @"ct":@([SAUtils getNetworkConnectivity]),
        @"data":[SAUtils encodeURI:[@{
            @"placement":@(ad.placementId),
            @"line_item":@(ad.lineItemId),
            @"creative":@(ad.creative._id),
            @"type":@"viewable_impression"
        } jsonCompactStringRepresentation]]
    };
    ad.creative.viewableImpressionUrl = [NSString stringWithFormat:@"%@/event?%@",
                                         [[SASession getInstance] getBaseUrl],
                                         [SAUtils formGetQueryFromDict:imprjson]];
    
    // get the parental gate URL
    NSDictionary *pgjsonfail = @{
        @"sdkVersion":[[SASession getInstance] getVersion],
        @"rnd":@([SAUtils getCachebuster]),
        @"ct":@([SAUtils getNetworkConnectivity]),
        @"data":[SAUtils encodeURI:[@{
            @"placement":@(ad.placementId),
            @"line_item":@(ad.lineItemId),
            @"creative":@(ad.creative._id),
            @"type": @"parentalGateFail"
        } jsonCompactStringRepresentation]]
    };
    ad.creative.parentalGateFailUrl = [NSString stringWithFormat:@"%@/event?%@",
                                        [[SASession getInstance] getBaseUrl],
                                        [SAUtils formGetQueryFromDict:pgjsonfail]];
    
    NSDictionary *pgjsonclose = @{
                                 @"sdkVersion":[[SASession getInstance] getVersion],
                                 @"rnd":@([SAUtils getCachebuster]),
                                 @"ct":@([SAUtils getNetworkConnectivity]),
                                 @"data":[SAUtils encodeURI:[@{
                                                               @"placement":@(ad.placementId),
                                                               @"line_item":@(ad.lineItemId),
                                                               @"creative":@(ad.creative._id),
                                                               @"type": @"parentalGateClose"
                                                               } jsonCompactStringRepresentation]]
                                 };
    ad.creative.parentalGateCloseUrl = [NSString stringWithFormat:@"%@/event?%@",
                                       [[SASession getInstance] getBaseUrl],
                                       [SAUtils formGetQueryFromDict:pgjsonclose]];
    
    NSDictionary *pgjsonopen = @{
                                 @"sdkVersion":[[SASession getInstance] getVersion],
                                 @"rnd":@([SAUtils getCachebuster]),
                                 @"ct":@([SAUtils getNetworkConnectivity]),
                                 @"data":[SAUtils encodeURI:[@{
                                                               @"placement":@(ad.placementId),
                                                               @"line_item":@(ad.lineItemId),
                                                               @"creative":@(ad.creative._id),
                                                               @"type": @"parentalGateOpen"
                                                               } jsonCompactStringRepresentation]]
                                 };
    ad.creative.parentalGateOpenUrl = [NSString stringWithFormat:@"%@/event?%@",
                                       [[SASession getInstance] getBaseUrl],
                                       [SAUtils formGetQueryFromDict:pgjsonopen]];
    
    NSDictionary *pgjsonsuccess = @{
                                 @"sdkVersion":[[SASession getInstance] getVersion],
                                 @"rnd":@([SAUtils getCachebuster]),
                                 @"ct":@([SAUtils getNetworkConnectivity]),
                                 @"data":[SAUtils encodeURI:[@{
                                                               @"placement":@(ad.placementId),
                                                               @"line_item":@(ad.lineItemId),
                                                               @"creative":@(ad.creative._id),
                                                               @"type": @"parentalGateSuccess"
                                                               } jsonCompactStringRepresentation]]
                                 };
    ad.creative.parentalGateSuccessUrl = [NSString stringWithFormat:@"%@/event?%@",
                                       [[SASession getInstance] getBaseUrl],
                                       [SAUtils formGetQueryFromDict:pgjsonsuccess]];
    
    // get the cdn URL
    switch (ad.creative.creativeFormat) {
        case image: {
            ad.creative.details.cdnUrl = [SAUtils findBaseURLFromResourceURL:ad.creative.details.image];
            break;
        }
        case video: {
            ad.creative.details.cdnUrl = [SAUtils findBaseURLFromResourceURL:ad.creative.details.video];
            break;
        }
        case rich: {
            ad.creative.details.cdnUrl = [SAUtils findBaseURLFromResourceURL:ad.creative.details.url];
            break;
        }
        case invalid:
        case tag: {break;}
    }
    
    // valdate ad
    if ([ad isValid]) return ad;
    return nil;

}

@end
