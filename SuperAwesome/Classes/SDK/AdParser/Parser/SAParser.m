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
#import "libSAiOSUtils.h"
#import "libSAiOSNetwork.h"
#import "NSString+HTML.h"

// import other parsers
#import "SAVASTParser.h"
#import "SAHTMLParser.h"

// parser implementation
@implementation SAParser

// function that performs the basic integritiy check on the just-received ad
+ (BOOL) performIntegrityCheck:(NSDictionary*)dict {
    
    // 1. check if it's empty
    if(dict != NULL && [dict count] > 0){
        
        // 2. check if the dictionary has a "creative" sub-dict
        NSDictionary *creativeObj = [dict objectForKey:@"creative"];
        if (creativeObj != NULL && ![creativeObj isKindOfClass:[NSNull class]] && [creativeObj count] > 0){
            
            // 3. check if the "creative" sub-dict has a "details" sub-dict of
            // its own
            NSDictionary *details = [creativeObj objectForKey:@"details"];
            if (details != NULL  && ![details isKindOfClass:[NSNull class]] && [details count] > 0){
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
    
    ad.error = ((errorObj != NULL && ![errorObj isKindOfClass:[NSNull class]]) ? [errorObj integerValue] : -1);
    ad.lineItemId = ((lineItemIdObj != NULL && ![lineItemIdObj isKindOfClass:[NSNull class]]) ? [lineItemIdObj integerValue] : -1);
    ad.campaignId = ((campaignIdObj != NULL && ![campaignIdObj isKindOfClass:[NSNull class]]) ? [campaignIdObj integerValue] : -1);
    ad.isTest = ((isTestObj != NULL && ![isTestObj isKindOfClass:[NSNull class]]) ? [isTestObj boolValue] : true);
    ad.isFallback = ((isFallbackObj != NULL && ![isFallbackObj isKindOfClass:[NSNull class]]) ? [isFallbackObj boolValue] : true);
    ad.isFill = ((isFillObj != NULL && ![isFillObj isKindOfClass:[NSNull class]]) ? [isFillObj boolValue] : false);
    
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
       
    creative.creativeId = ( (creativeIdObj != NULL && ![creativeIdObj isKindOfClass:[NSNull class]]) ? [creativeIdObj integerValue] : -1);
    creative.cpm = ((cpmObj != NULL && ![cpmObj isKindOfClass:[NSNull class]]) ? [cpmObj integerValue] : 0);
    creative.name = ((nameObj != NULL && ![nameObj isKindOfClass:[NSNull class]]) ? nameObj : NULL);
    creative.impressionURL = ((impressionUrlObj != NULL && ![impressionUrlObj isKindOfClass:[NSNull class]]) ? impressionUrlObj : NULL);
    creative.clickURL = ((clickURLObj != NULL && ![clickURLObj isKindOfClass:[NSNull class]]) ? clickURLObj : NULL);
    creative.approved = ((approvedObj != NULL && ![approvedObj isKindOfClass:[NSNull class]]) ? [approvedObj boolValue] : false);
    creative.baseFormat = ((baseFormatObj != NULL && ![baseFormatObj isKindOfClass:[NSNull class]]) ? baseFormatObj : NULL);
    
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
    
    details.width = ((widthObj != NULL && ![widthObj isKindOfClass:[NSNull class]]) ? [widthObj integerValue] : 0);
    details.height = ((heightObj != NULL && ![heightObj isKindOfClass:[NSNull class]]) ? [heightObj integerValue] : 0);
    details.image = ((imageObj != NULL && ![imageObj isKindOfClass:[NSNull class]]) ? imageObj : NULL);
    details.value = ((valueObj != NULL && ![valueObj isKindOfClass:[NSNull class]]) ? [valueObj integerValue] : -1);
    details.name = ((nameObj != NULL && ![nameObj isKindOfClass:[NSNull class]]) ? nameObj : NULL);
    details.video = ((videoObj != NULL && ![videoObj isKindOfClass:[NSNull class]]) ? videoObj : NULL);
    details.bitrate = ((bitrateObj != NULL && ![bitrateObj isKindOfClass:[NSNull class]]) ? [bitrateObj integerValue] : 0);
    details.duration = ((durationObj != NULL && ![durationObj isKindOfClass:[NSNull class]]) ? [durationObj integerValue] : 0);
    details.vast = ((vastObj != NULL && ![vastObj isKindOfClass:[NSNull class]]) ? vastObj : NULL);
    details.tag = ((tagObj != NULL && ![tagObj isKindOfClass:[NSNull class]]) ? tagObj : NULL);
    details.zip = ((zipFileObj != NULL && ![zipFileObj isKindOfClass:[NSNull class]]) ? zipFileObj : NULL);
    details.url = ((urlObj != NULL && ![urlObj isKindOfClass:[NSNull class]]) ? urlObj : NULL);
    details.placementFormat = ((placementFormatObj != NULL && ![placementFormatObj isKindOfClass:[NSNull class]]) ? placementFormatObj : NULL);
    
    return details;
}

+ (void) parseDictionary:(NSDictionary*)adDict withPlacementId:(NSInteger)placementId intoAd:(parsedad)parse {
    
    // perform an integrity check
    if (![SAParser performIntegrityCheck:adDict]) {
        parse(NULL);
        return;
    }
    
    //Adding Try block to all the parsing, in case objects are not the correct types expected
    @try
    {
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
            @"rnd":[NSNumber numberWithInteger:[SAURLUtils getCachebuster]]
        };
        ad.creative.trackingURL = [NSString stringWithFormat:@"%@/%@click?%@",
                                   [[SuperAwesome getInstance] getBaseURL],
                                   (ad.creative.format == video ? @"video/" : @""),
                                   [SAURLUtils formGetQueryFromDict:trackingDict]];
        
        // get the viewbale impression URL
        NSDictionary *impressionDict = @{
            @"placement":[NSNumber numberWithInteger:ad.placementId],
            @"line_item":[NSNumber numberWithInteger:ad.lineItemId],
            @"creative":[NSNumber numberWithInteger:ad.creative.creativeId],
            @"type":@"viewable_impression"
        };
        NSDictionary *impressionDict2 = @{
            @"sdkVersion":[[SuperAwesome getInstance] getSdkVersion],
            @"rnd":[NSNumber numberWithInteger:[SAURLUtils getCachebuster]],
            @"data":[SAURLUtils encodeJSONDictionaryFromNSDictionary:impressionDict]
        };
        ad.creative.viewableImpressionURL = [NSString stringWithFormat:@"%@/event?%@",
                                             [[SuperAwesome getInstance] getBaseURL],
                                             [SAURLUtils formGetQueryFromDict:impressionDict2]];
        
        // create the click URL
        switch (ad.creative.format) {
            case image:{
                ad.creative.fullClickURL = [NSString stringWithFormat:@"%@&redir=%@",
                                            ad.creative.trackingURL,
                                            ad.creative.clickURL];
                ad.creative.isFullClickURLReliable = true;
                
                // format the ad HTML
                ad.adHTML = [SAHTMLParser formatCreativeDataIntoAdHTML:ad];
                
                // send back the callback
                parse(ad);
                
                break;
            }
            case video:{
                // just continue parsing the ad - the heavy lifting will be done
                // at playtime by the SAVASTManager, SAVASTPlayer and SASVASTParser
                parse(ad);
                break;
            }
            case rich:
            case tag:{
                // fist - and most fortunate case - when the clickURL is supplied by the
                // ad server
                if (ad.creative.clickURL != NULL && [SAURLUtils isValidURL:ad.creative.clickURL]) {
                    ad.creative.fullClickURL = [NSString stringWithFormat:@"%@&redir=%@",
                                                ad.creative.trackingURL,
                                                ad.creative.clickURL];
                    ad.creative.isFullClickURLReliable = true;
                }
                // second - when the URL is not supplied by the ad server or it's not
                // a really valid URL, then just set the fullClickURL param to NULL
                // and the isFullClickURLReliable set to false, so that all the
                // final stages will be handled during runtime, when the user clicks
                // on the <a href="someURL"> HTML tags of the rich media document
                else {
                    ad.creative.fullClickURL = NULL;
                    ad.creative.isFullClickURLReliable = false;
                }
                
                // format the ad HTML
                ad.adHTML = [SAHTMLParser formatCreativeDataIntoAdHTML:ad];
                
                // send back the callback
                parse(ad);
                
                break;
            }
            default:
                break;
        }
    }
    @catch (NSException *exception) {
        parse(NULL);
    }
}

@end
