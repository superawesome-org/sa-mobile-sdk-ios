/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import "SAProcessHTML.h"

#if defined(__has_include)
#if __has_include(<SAModelSpace/SAAd.h>)
#import <SAModelSpace/SAAd.h>
#else
#import "SAAd.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAModelSpace/SACreative.h>)
#import <SAModelSpace/SACreative.h>
#else
#import "SACreative.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAModelSpace/SADetails.h>)
#import <SAModelSpace/SADetails.h>
#else
#import "SADetails.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAModelSpace/SAMedia.h>)
#import <SAModelSpace/SAMedia.h>
#else
#import "SAMedia.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAUtils/SAUtils.h>)
#import <SAUtils/SAUtils.h>
#else
#import "SAUtils.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAUtils/SAExtensions.h>)
#import <SAUtils/SAExtensions.h>
#else
#import "SAExtensions.h"
#endif
#endif

@implementation SAProcessHTML

+ (NSString*) formatCreativeIntoImageHTML:(SAAd*) ad {
    
    // the img string
    NSString *imgString = @"<a href='hrefURL'><img src='imageURL'/></a>_MOAT_";
    
    // determine the Click URL
    NSString *click = ad.creative.clickUrl;
    
    if (!click) {
        NSArray *potentialClicks = [ad.creative.events filterBy:@"event" withValue:@"sa_tracking"];
        if ([potentialClicks count] > 1) {
            click = [potentialClicks objectAtIndex:0];
        }
    }
    
    // set click
    if (click != nil) {
        imgString = [imgString stringByReplacingOccurrencesOfString:@"hrefURL" withString:click];
    }
    // set image
    if (ad.creative.details.image) {
        imgString = [imgString stringByReplacingOccurrencesOfString:@"imageURL" withString:ad.creative.details.image];
    }
    return imgString;
}

+ (NSString*) formatCreativeIntoRichMediaHTML:(SAAd*) ad {
    
    // the img string
    NSString *rmString = @"<iframe style='padding:0;margin:0;border:0;' width='100%' height='100%' src='richMediaURL'></iframe>_MOAT_";
    
    // format template parameters
    NSMutableString *richMediaString = [@"" mutableCopy];
    [richMediaString appendString:ad.creative.details.url];
    
    NSDictionary *richMediaDict = @{
        @"placement":@(ad.placementId),
        @"line_item":@(ad.lineItemId),
        @"creative":@(ad.creative._id),
        @"rnd":[NSNumber numberWithInteger:[SAUtils getCachebuster]]
    };
    [richMediaString appendString:@"?"];
    [richMediaString appendString:[SAUtils formGetQueryFromDict:richMediaDict]];
    
    // return the parametrized template
    NSString *richString = [rmString stringByReplacingOccurrencesOfString:@"richMediaURL" withString:richMediaString];
    
    richString = [richString stringByReplacingOccurrencesOfString:@"" withString:@""];
    
    return richString;
}

+ (NSString*) formatCreativeIntoTagHTML:(SAAd*) ad {
    
    // the img string
    NSString *tagHtml = @"tagdata_MOAT_";
    
    // format template parameters
    NSString *tagString = ad.creative.details.tag;
    
    NSString *click = ad.creative.clickUrl;
    
    if (!click) {
        NSArray *potentialClicks = [ad.creative.events filterBy:@"event" withValue:@"sa_tracking"];
        if ([potentialClicks count] > 1) {
            click = [potentialClicks objectAtIndex:0];
        }
    }
    
    tagString = [tagString stringByReplacingOccurrencesOfString:@"[click]" withString:[NSString stringWithFormat:@"%@&redir=", click]];
    tagString = [tagString stringByReplacingOccurrencesOfString:@"[click_enc]" withString:[SAUtils encodeURI:click]];
    tagString = [tagString stringByReplacingOccurrencesOfString:@"[keywords]" withString:@""];
    tagString = [tagString stringByReplacingOccurrencesOfString:@"[timestamp]" withString:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]]];
    tagString = [tagString stringByReplacingOccurrencesOfString:@"target=\"_blank\"" withString:@""];
    tagString = [tagString stringByReplacingOccurrencesOfString:@"\\t" withString:@""];
    tagString = [tagString stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
    tagString = [tagString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    tagString = [tagString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    tagString = [tagString stringByReplacingOccurrencesOfString:@"“" withString:@"\""];
    
    NSString *html = [tagHtml stringByReplacingOccurrencesOfString:@"tagdata" withString:tagString];
    // html = [html stringByReplacingOccurrencesOfString:@"\/" withString:@"/"];
    html = [html stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
    html = [html stringByReplacingOccurrencesOfString:@"\"" withString:@"'"];
    
    // return the parametrized template
    return html;
}

@end
