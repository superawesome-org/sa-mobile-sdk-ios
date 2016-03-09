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

// import other parsers
#import "SAVASTParser.h"
#import "SAHTMLParser.h"

// parser implementation
@implementation SAParser

// function that validates a dictionary / json field and returns true or false
// in each case
+ (BOOL) validateField:(id)object {
    
    if (object != NULL && ![object isKindOfClass:[NSNull class]]){
        return true;
    }
    
    return false;
}

+ (BOOL) isAdDataValid:(SAAd *)ad {
    if (ad == NULL) return false;
    if (ad.creative == NULL) return false;
    if (ad.creative != NULL) {
        if (ad.creative.format == invalid) return false;
        if (ad.creative.details == NULL) return false;
        if (ad.creative.details != NULL) {
            switch (ad.creative.format) {
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

// function that performs the basic integritiy check on the just-received ad
+ (BOOL) performIntegrityCheck:(NSDictionary*)dict {
    
    // 1. check if it's empty
    if(dict != NULL && [dict count] > 0){
        
        // 2. check if the dictionary has a "creative" sub-dict
        NSDictionary *creativeObj = [dict objectForKey:@"creative"];
        if ([SAParser validateField:creativeObj] && [creativeObj count] > 0){
            
            // 3. check if the "creative" sub-dict has a "details" sub-dict of
            // its own
            NSDictionary *details = [creativeObj objectForKey:@"details"];
            if ([SAParser validateField:details] && [details count] > 0){
                return true;
            }
            return false;
        }
        return false;
    }
    return false;
}

+ (SAAd*) parseAdWithDictionary:(NSDictionary*)adict {
    SAAd *ad = [[SAAd alloc] init];
    
    id errorObj = [adict objectForKey:@"error"];
    id lineItemIdObj = [adict objectForKey:@"line_item_id"];
    id campaignIdObj = [adict objectForKey:@"campaign_id"];
    id isTestObj = [adict objectForKey:@"test"];
    id isFallbackObj = [adict objectForKey:@"is_fallback"];
    id isFillObj = [adict objectForKey:@"is_fill"];
    id isHouseObj = [adict objectForKey:@"is_house"];
    
    ad.error = ([SAParser validateField:errorObj] ? [errorObj integerValue] : -1);
    ad.lineItemId = ([SAParser validateField:lineItemIdObj] ? [lineItemIdObj integerValue] : -1);
    ad.campaignId = ([SAParser validateField:campaignIdObj] ? [campaignIdObj integerValue] : -1);
    ad.isTest = ([SAParser validateField:isTestObj] ? [isTestObj boolValue] : true);
    ad.isFallback = ([SAParser validateField:isFallbackObj] ? [isFallbackObj boolValue] : true);
    ad.isFill = ([SAParser validateField:isFillObj] ? [isFillObj boolValue] : false);
    ad.isHouse = ([SAParser validateField:isHouseObj] ? [isHouseObj boolValue] : false);
    
    return ad;
}

+ (SACreative*) parseCreativeWithDictionary:(NSDictionary*)cdict {
    SACreative *creative = [[SACreative alloc] init];
    
    id creativeIdObj = [cdict objectForKey:@"id"];
    id nameObj = [cdict objectForKey:@"name"];
    id cpmObj = [cdict objectForKey:@"cpm"];
    id baseFormatObj = [cdict objectForKey:@"format"];
    id impressionUrlObj = [cdict objectForKey:@"impression_url"];
    id clickURLObj = [cdict objectForKey:@"click_url"];
    id approvedObj = [cdict objectForKey:@"approved"];
    
    creative.creativeId = ([SAParser validateField:creativeIdObj] ? [creativeIdObj integerValue] : -1);
    creative.cpm = ([SAParser validateField:cpmObj] ? [cpmObj integerValue] : 0);
    creative.name = ([SAParser validateField:nameObj] ? nameObj : NULL);
    creative.impressionURL = ([SAParser validateField:impressionUrlObj] ? impressionUrlObj : NULL);
    creative.clickURL = ([SAParser validateField:clickURLObj] ? clickURLObj : NULL);
    creative.approved = ([SAParser validateField:approvedObj] ? [approvedObj boolValue] : false);
    creative.baseFormat = ([SAParser validateField:baseFormatObj] ? baseFormatObj : NULL);
    
    return creative;
}

// function that parses the SADetails main data
+ (SADetails*) parseDetailsWithDictionary:(NSDictionary*)ddict {
    SADetails *details = [[SADetails alloc] init];
    
    // parse the info
    id widthObj = [ddict objectForKey:@"width"];
    id heightObj = [ddict objectForKey:@"height"];
    id imageObj = [ddict objectForKey:@"image"];
    id valueObj = [ddict valueForKey:@"value"];
    id nameObj = [ddict objectForKey:@"name"];
    id videoObj = [ddict objectForKey:@"video"];
    id bitrateObj = [ddict objectForKey:@"bitrate"];
    id durationObj = [ddict objectForKey:@"duration"];
    id vastObj = [ddict objectForKey:@"vast"];
    id tagObj = [ddict objectForKey:@"tag"];
    id placementFormatObj = [ddict objectForKey:@"placement_format"];
    id zipFileObj = [ddict objectForKey:@"zip_file"];
    id urlObj = [ddict objectForKey:@"url"];
    
    details.width = ([SAParser validateField:widthObj] ? [widthObj integerValue] : 0);
    details.height = ([SAParser validateField:heightObj] ? [heightObj integerValue] : 0);
    details.image = ([SAParser validateField:imageObj] ? imageObj : NULL);
    details.value = ([SAParser validateField:valueObj] ? [valueObj integerValue] : -1);
    details.name = ([SAParser validateField:nameObj] ? nameObj : NULL);
    details.video = ([SAParser validateField:videoObj] ? videoObj : NULL);
    details.bitrate = ([SAParser validateField:bitrateObj] ? [bitrateObj integerValue] : 0);
    details.duration = ([SAParser validateField:durationObj] ? [durationObj integerValue] : 0);
    details.vast = ([SAParser validateField:vastObj] ? vastObj : NULL);
    details.tag = ([SAParser validateField:tagObj] ? tagObj : NULL);
    details.zip = ([SAParser validateField:zipFileObj] ? zipFileObj : NULL);
    details.url = ([SAParser validateField:urlObj] ? urlObj : NULL);
    details.placementFormat = ([SAParser validateField:placementFormatObj] ? placementFormatObj : NULL);
    
    return details;
}

+ (SAAd*) parseAdFromDictionary:(NSDictionary*)adDict withPlacementId:(NSInteger)placementId {
    
    // perform an integrity check
    if (![self performIntegrityCheck:adDict]) {
        return nil;
    }
    
    // Adding Try block to all the parsing, in case objects are not the correct types expected
    @try{
        
        // if all ok, extract dictionaries
        NSDictionary *adict = adDict;
        NSDictionary *cdict = [adict objectForKey:@"creative"];
        NSDictionary *ddict = [cdict objectForKey:@"details"];
        
        // invoke previous functions to do the basic ad parsing
        SAAd *ad = [SAParser parseAdWithDictionary:adict];
        ad.placementId = placementId;
        ad.creative = [SAParser parseCreativeWithDictionary:cdict];
        ad.creative.details = [SAParser parseDetailsWithDictionary:ddict];
        
        // prform the next steps of the parsing
        ad.creative.format = invalid;
        // case "image_with_link"
        if ([ad.creative.baseFormat isEqualToString:@"image_with_link"])   ad.creative.format = image;
        // case "video"
        else if ([ad.creative.baseFormat isEqualToString:@"video"])        ad.creative.format = video;
        // case "rich_media" and "rich_media_resizing"
        else if ([ad.creative.baseFormat containsString:@"rich_media"])    ad.creative.format = rich;
        // case "tag" and "fallback_tag"
        else if ([ad.creative.baseFormat containsString:@"tag"])          ad.creative.format = tag;
        
        // create the tracking URL
        NSDictionary *trackingDict = @{
                                       @"placement":[NSNumber numberWithInteger:ad.placementId],
                                       @"line_item":[NSNumber numberWithInteger:ad.lineItemId],
                                       @"creative":[NSNumber numberWithInteger:ad.creative.creativeId],
                                       @"sdkVersion":[[SuperAwesome getInstance] getSdkVersion],
                                       @"rnd":[NSNumber numberWithInteger:[SAUtils getCachebuster]]
                                       };
        ad.creative.trackingURL = [NSString stringWithFormat:@"%@/%@click?%@",
                                   [[SuperAwesome getInstance] getBaseURL],
                                   (ad.creative.format == video ? @"video/" : @""),
                                   [SAUtils formGetQueryFromDict:trackingDict]];
        
        // get the viewbale impression URL
        NSDictionary *impressionDict = @{
                                         @"placement":[NSNumber numberWithInteger:ad.placementId],
                                         @"line_item":[NSNumber numberWithInteger:ad.lineItemId],
                                         @"creative":[NSNumber numberWithInteger:ad.creative.creativeId],
                                         @"type":@"viewable_impression"
                                         };
        NSDictionary *impressionDict2 = @{
                                          @"sdkVersion":[[SuperAwesome getInstance] getSdkVersion],
                                          @"rnd":[NSNumber numberWithInteger:[SAUtils getCachebuster]],
                                          @"data":[SAUtils encodeJSONDictionaryFromNSDictionary:impressionDict]
                                          };
        ad.creative.viewableImpressionURL = [NSString stringWithFormat:@"%@/event?%@",
                                             [[SuperAwesome getInstance] getBaseURL],
                                             [SAUtils formGetQueryFromDict:impressionDict2]];
        
        // get the parental gate URL
        NSDictionary *pgDict1 = @{
                                  @"placement":[NSNumber numberWithInteger:ad.placementId],
                                  @"line_item":[NSNumber numberWithInteger:ad.lineItemId],
                                  @"creative":[NSNumber numberWithInteger:ad.creative.creativeId],
                                  @"type":@"custom.parentalGateAccessed"
                                  };
        NSDictionary *pgDict2 = @{
                                  @"sdkVersion":[[SuperAwesome getInstance] getSdkVersion],
                                  @"rnd":[NSNumber numberWithInteger:[SAUtils getCachebuster]],
                                  @"data":[SAUtils encodeJSONDictionaryFromNSDictionary:pgDict1]
                                  };
        ad.creative.parentalGateClickURL = [NSString stringWithFormat:@"%@/event?%@",
                                            [[SuperAwesome getInstance] getBaseURL],
                                            [SAUtils formGetQueryFromDict:pgDict2]];
        
        // format the ad HTML, then parse Ad
        ad.adHTML = [SAHTMLParser formatCreativeDataIntoAdHTML:ad];
        
        // also check for integrity
        if (![self isAdDataValid:ad]) {
            return nil;
        }
        
        // return the ad
        return ad;
    }
    @catch (NSException *exception) {
        return nil;
    }
}

@end
