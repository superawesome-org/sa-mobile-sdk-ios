//
//  SAFormatter.m
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 12/10/2015.
//
//

// import header
#import "SAHTMLParser.h"

// import modelspace
#import "SAAd.h"
#import "SACreative.h"
#import "SADetails.h"

// import juciy aux functions
#import "libSAiOSUtils.h"
#import "libSAiOSNetwork.h"

// import SA class
#import "SuperAwesome.h"

@implementation SAHTMLParser

+ (NSString*) formatCreativeDataIntoAdHTML:(SAAd*)ad {
    
    switch (ad.creative.format) {
        case image:{
            return [self formatCreativeIntoImageHTML:ad];
            break;
        }
        case video:{
            return nil;
            break;
        }
        case rich:{
            return [self formatCreativeIntoRichMediaHTML:ad];
            break;
        }
        case tag:{
            return [self formatCreativeIntoTagHTML:ad];
            break;
        }
        default:{
            return nil;
            break;
        }
    }
}

+ (NSString*) formatCreativeIntoImageHTML:(SAAd*)ad {
    // load template
    NSString *fPath = [[NSBundle mainBundle] pathForResource:@"displayImage" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:fPath encoding:NSUTF8StringEncoding error:nil];
    
    // return the parametrized template
    return [htmlString stringByReplacingOccurrencesOfString:@"imageURL" withString:ad.creative.details.image];
}

+ (NSString*) formatCreativeIntoRichMediaHTML:(SAAd*)ad {
    // load template
    NSString *fPath = [[NSBundle mainBundle] pathForResource:@"displayRichMedia" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:fPath encoding:NSUTF8StringEncoding error:nil];
    
    // format template parameters
    NSMutableString *richMediaString = [[NSMutableString alloc] init];
    [richMediaString appendString:ad.creative.details.url];
    
    NSDictionary *richMediaDict = @{
        @"placement":[NSNumber numberWithInteger:ad.placementId],
        @"line_item":[NSNumber numberWithInteger:ad.lineItemId],
        @"creative":[NSNumber numberWithInteger:ad.creative.creativeId],
        @"rnd":[NSNumber numberWithInteger:[SAURLUtils getCachebuster]]
    };
    [richMediaString appendString:@"?"];
    [richMediaString appendString:[SAURLUtils formGetQueryFromDict:richMediaDict]];
    
    
    // return the parametrized template
    NSString *richString = [htmlString stringByReplacingOccurrencesOfString:@"richMediaURL" withString:richMediaString];
    
//    CGFloat scale = 1.0f;
//    if (ad.creative.details.width < ad.creative.details.height) {
//        scale =
//    } else {
//        
//    }
    
    
//    var scale: Number = 1;
//    if (ad.creative.details.width < ad.creative.details.height) {
//        scale = newR.width / Math.min(this.stage.stageWidth, this.stage.stageHeight);
//    } else {
//        scale = newR.height / Math.max(this.stage.stageWidth, this.stage.stageHeight);
//    }
//    
//    var finalString1: String = ad.adHTML;
//    finalString1 = finalString1.replace("_PARAM_SCALE_", scale);
//    finalString1 = finalString1.replace("_PARAM_SCALE_", scale);
//    finalString1 = finalString1.replace("_PARAM_DPI_", "device-dpi");
    
    richString = [richString stringByReplacingOccurrencesOfString:@"" withString:@""];
    
    return richString;
}

+ (NSString*) formatCreativeIntoTagHTML:(SAAd*)ad {
    // get template
    NSString *fPath = [[NSBundle mainBundle] pathForResource:@"displayTag" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:fPath encoding:NSUTF8StringEncoding error:nil];
    
    // format template parameters
    NSString *tagString = ad.creative.details.tag;
    tagString = [tagString stringByReplacingOccurrencesOfString:@"[click]" withString:[NSString stringWithFormat:@"%@&redir=",ad.creative.trackingURL]];
    tagString = [tagString stringByReplacingOccurrencesOfString:@"[click_enc]" withString:[SAURLUtils encodeURI:ad.creative.trackingURL]];
    tagString = [tagString stringByReplacingOccurrencesOfString:@"[keywords]" withString:@""];
    tagString = [tagString stringByReplacingOccurrencesOfString:@"[timestamp]" withString:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]]];
    tagString = [tagString stringByReplacingOccurrencesOfString:@"target=\"_blank\"" withString:@""];
    tagString = [tagString stringByReplacingOccurrencesOfString:@"“" withString:@"\""];
    
    // return the parametrized template
    return [htmlString stringByReplacingOccurrencesOfString:@"tagdata" withString:tagString];
}

@end
