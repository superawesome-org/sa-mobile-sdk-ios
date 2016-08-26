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
#import "SAAdParser.h"

// import modelspace
#import "SAAd.h"
#import "SACreative.h"
#import "SADetails.h"
#import "SAMedia.h"
#import "SATracking.h"

// import SuperAwesome main header
 #import "SASession.h"

// import SAAux library of goodies
#import "SAUtils.h"
#import "SAJsonParser.h"

// parser implementation
@implementation SAAdParser

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
    SATracking *trackingEvt = [[SATracking alloc] init];
    trackingEvt.event = @"sa_tracking";
    trackingEvt.URL = [NSString stringWithFormat:@"%@/%@click?%@",
                       [[SASession getInstance] getBaseUrl],
                       (ad.creative.creativeFormat == video ? @"video/" : @""),
                       [SAUtils formGetQueryFromDict:trackjson]];
    
    // get the impression
    SATracking *impr = [[SATracking alloc] init];
    if (ad.creative.impressionUrl) {
        impr.URL = ad.creative.impressionUrl;
        impr.event = @"impression";
    }
    
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
    SATracking *viewableImpression = [[SATracking alloc] init];
    viewableImpression.event = @"viewable_impr";
    viewableImpression.URL = [NSString stringWithFormat:@"%@/event?%@",
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
    SATracking *parentalGateFail = [[SATracking alloc] init];
    parentalGateFail.event = @"pg_fail";
    parentalGateFail.URL = [NSString stringWithFormat:@"%@/event?%@",
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
    SATracking *parentalGateClose = [[SATracking alloc] init];
    parentalGateClose.event = @"pg_close";
    parentalGateClose.URL = [NSString stringWithFormat:@"%@/event?%@",
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
    SATracking *parentalGateOpen = [[SATracking alloc] init];
    parentalGateOpen.event = @"pg_open";
    parentalGateOpen.URL = [NSString stringWithFormat:@"%@/event?%@",
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
    SATracking *parentalGateSuccess = [[SATracking alloc] init];
    parentalGateSuccess.event = @"pg_success";
    parentalGateSuccess.URL = [NSString stringWithFormat:@"%@/event?%@",
                                       [[SASession getInstance] getBaseUrl],
                                       [SAUtils formGetQueryFromDict:pgjsonsuccess]];
    
    [ad.creative.events addObject:trackingEvt];
    [ad.creative.events addObject:viewableImpression];
    [ad.creative.events addObject:parentalGateSuccess];
    [ad.creative.events addObject:parentalGateOpen];
    [ad.creative.events addObject:parentalGateClose];
    [ad.creative.events addObject:parentalGateFail];
    if (ad.creative.impressionUrl) {
        [ad.creative.events addObject:impr];
    }

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
