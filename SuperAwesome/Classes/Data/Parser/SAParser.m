//
//  SAParser.m
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 11/10/2015.
//
//

#import "SAParser.h"
#import "SAAd.h"
#import "SACreative.h"
#import "SADetails.h"
#import "SuperAwesome.h"

// parser implementation
@implementation SAParser

+ (SAAd*) parseAdWithDictionary:(NSDictionary*)dict {
    SAAd *ad = [[SAAd alloc] init];
    
    id errorObj = [dict objectForKey:@"error"];
    id lineItemIdObj = [dict objectForKey:@"line_item_id"];
    id campaignIdObj = [dict objectForKey:@"campaign_id"];
    id isTestObj = [dict objectForKey:@"test"];
    id isFallbackObj = [dict objectForKey:@"is_fallback"];
    id isFillObj = [dict objectForKey:@"is_fill"];
    
    ad.error = (errorObj != NULL ? [errorObj integerValue] : -1);
    ad.lineItemId = (lineItemIdObj != NULL ? [lineItemIdObj integerValue] : -1);
    ad.campaignId = (campaignIdObj != NULL ? [campaignIdObj integerValue] : -1);
    ad.isTest = (isTestObj != NULL ? [isTestObj boolValue] : true);
    ad.isFallback = (isFallbackObj != NULL ? [isFallbackObj boolValue] : false);
    ad.isFill = (isFillObj != NULL ? [isFillObj boolValue] : false);
    
    return ad;
}

+ (SACreative*) parseCreativeWithDictionary:(NSDictionary*)maindict {
    // check for empty failure
    _Nullable id creativeObj = [maindict objectForKey:@"creative"];
    if (creativeObj == NULL) {
        return [[SACreative alloc] init];
    }
    
    NSDictionary *dict = (NSDictionary*)creativeObj;
    SACreative *creative = [[SACreative alloc] init];
    
    id creativeIdObj = [dict objectForKey:@"id"];
    id nameObj = [dict objectForKey:@"name"];
    id cpmObj = [dict objectForKey:@"cpm"];
    id baseFormatObj = [dict objectForKey:@"format"];
    id impressionUrlObj = [dict objectForKey:@"impression_url"];
    id targetUrlObj = [dict objectForKey:@"click_url"];
    id approvedObj = [dict objectForKey:@"approved"];
    
    creative.creativeId = (creativeIdObj != NULL ? [creativeIdObj integerValue] : -1);
    creative.cpm = (cpmObj != NULL ? [cpmObj integerValue] : 0);
    creative.name = (nameObj != NULL ? nameObj : NULL);
    creative.impressionURL = (impressionUrlObj != NULL ? impressionUrlObj : NULL);
    creative.targetURL = (targetUrlObj != NULL ? targetUrlObj : @"http://superawesome.tv");
    creative.approved = (approvedObj != NULL ? [approvedObj boolValue] : false);
    creative.baseFormat = (baseFormatObj != NULL ? baseFormatObj : NULL);
    
    return creative;
}

// function that parses the SADetails main data
+ (SADetails*) parseDetailsWithDictionary:(NSDictionary*)maindict {
    // check for empty failure
    _Nullable id creativeObj = [maindict objectForKey:@"creative"];
    if (creativeObj == NULL) {
        return [[SADetails alloc] init];
    }
    
    _Nullable id detailsObj = [(NSDictionary*)creativeObj objectForKey:@"details"];
    if (detailsObj == NULL) {
        return [[SADetails alloc] init];
    }
    
    NSDictionary *dict = (NSDictionary*)detailsObj;
    SADetails *details = [[SADetails alloc] init];
    
    // parse the info
    id widthObj = [dict objectForKey:@"width"];
    id heightObj = [dict objectForKey:@"height"];
    id imageObj = [dict objectForKey:@"image"];
    id valueObj = [dict valueForKey:@"value"];
    id nameObj = [dict objectForKey:@"name"];
    id videoObj = [dict objectForKey:@"video"];
    id bitrateObj = [dict objectForKey:@"bitrate"];
    id durationObj = [dict objectForKey:@"duration"];
    id vastObj = [dict objectForKey:@"vast"];
    id tagObj = [dict objectForKey:@"tag"];
    id placementFormatObj = [dict objectForKey:@"placement_format"];
    id zipFileObj = [dict objectForKey:@"zip_file"];
    id urlObj = [dict objectForKey:@"url"];
    
    details.width = (widthObj != NULL ? [widthObj integerValue] : 0);
    details.height = (heightObj != NULL ? [heightObj integerValue] : 0);
    details.image = (imageObj != NULL ? imageObj : NULL);
    details.value = (valueObj != NULL ? [valueObj integerValue] : -1);
    details.name = (nameObj != NULL ? nameObj : NULL);
    details.video = (videoObj != NULL ? videoObj : NULL);
    details.bitrate = (bitrateObj != NULL ? [bitrateObj integerValue] : 0);
    details.duration = (durationObj != NULL ? [durationObj integerValue] : 0);
    details.vast = (vastObj != NULL ? vastObj : NULL);
    details.tag = (tagObj != NULL ? tagObj : NULL);
    details.zip = (zipFileObj != NULL ? zipFileObj : NULL);
    details.url = (urlObj != NULL ? urlObj : NULL);
    details.placementFormat = (placementFormatObj != NULL ? placementFormatObj : NULL);
    
    return details;
}

+ (SAAd*) finishAdParsing:(SAAd *)_ad {
    SAAd *ad = _ad;
    
    ad.creative.format = invalid;
    // case "image_with_link"
    if ([ad.creative.baseFormat isEqualToString:@"image_with_link"])   ad.creative.format = image;
    // case "video"
    else if ([ad.creative.baseFormat isEqualToString:@"video"])        ad.creative.format = video;
    // case "rich_media" and "rich_media_resizing"
    else if ([ad.creative.baseFormat containsString:@"rich_media"])    ad.creative.format = rich;
    // case "tag" and "fallback_tag"
    else if ([ad.creative.baseFormat containsString:@"tag"])          ad.creative.format = tag;
    
    ad.creative.trackingURL = [NSString stringWithFormat:@"%@/click?placement=%ld&line_item=%ld&creative=%ld",
                               [[SuperAwesome getInstance] getBaseURL],
                               (long)ad.placementId,
                               (long)ad.lineItemId,
                               (long)ad.creative.creativeId];
    
    ad.creative.clickURL = [NSString stringWithFormat:@"%@&redir=%@",
                            ad.creative.trackingURL,
                            ad.creative.targetURL];
    
    NSString *stringJOSN = [NSString stringWithFormat:@"{\"placement\":%ld,\"creative\":%ld,\"line_item\":%ld,\"type\":\"viewable_impression\"}",
                            (long)ad.placementId,
                            (long)ad.creative.creativeId,
                            (long)ad.lineItemId];
    NSString *encodedJSON = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                      (__bridge CFStringRef)stringJOSN,
                                                                                      NULL,
                                                                                      (__bridge CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                      CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
    ad.creative.viewableImpressionURL = [NSString stringWithFormat:@"%@/event?data=%@",
                                         [[SuperAwesome getInstance] getBaseURL],
                                         encodedJSON];
    
    
    return ad;
}

@end
