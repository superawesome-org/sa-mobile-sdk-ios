//
//  SAEvents+Moat.m
//  Pods
//
//  Created by Gabriel Coman on 01/06/2016.
//
//

#import "SAEvents+Moat.h"
#import <SUPMoatMobileAppKit/SUPMoatMobileAppKit.h>
#import "SAUtils.h"

#define MOAT_DISPLAY_PARTNER_CODE @"superawesomeinappdisplay731223424656"
#define MOAT_VIDEO_PARTNER_CODE @"superawesomeinappvideo467548716573"

@implementation SAEvents (Moat)

+ (NSDictionary*) mapSADictoToMoatDict:(NSDictionary*)dict {
    return @{
             @"level1": @"SuperAwesome",
             @"level2": [dict objectForKey:@"campaign"],
             @"level3": [dict objectForKey:@"line_item"],
             @"level4": [dict objectForKey:@"creative"],
             @"slicer1": [dict objectForKey:@"app"],
             @"slider2": [dict objectForKey:@"placement"]
             };
}

+ (void) sendDisplayMoatEvent:(UIWebView*)webView andAdDictionary:(NSDictionary*)adDict{
    
    // make only 1 in 5 moat events OK
    NSInteger rand = [SAUtils randomNumberBetween:0 maxNumber:100];
    if (rand > 20) {
        NSLog(@"[AA:: Info] Moat Display Event not triggered this time");
        return;
    }
    
    // go ahead
    BOOL allOK = [SUPMoatBootstrap injectDelegateWrapper:webView];
    
    NSMutableString *moatQuery = [[NSMutableString alloc] init];
    [moatQuery appendFormat:@"moatClientLevel1=%@", @"SuperAwesome"];
    [moatQuery appendFormat:@"&moatClientLevel2=%@", [adDict objectForKey:@"campaign"]];
    [moatQuery appendFormat:@"&moatClientLevel3=%@", [adDict objectForKey:@"line_item"]];
    [moatQuery appendFormat:@"&moatClientLevel4=%@", [adDict objectForKey:@"creative"]];
    [moatQuery appendFormat:@"&moatSlicerLevel1=%@", [adDict objectForKey:@"app"]];
    [moatQuery appendFormat:@"&moatSlicerLevel2=%@", [adDict objectForKey:@"placement"]];
    NSMutableString *moatString = [[NSMutableString alloc] init];
    [moatString appendFormat:@"<script src=\"https://z.moatads.com/superawesomeinappdisplay731223424656/moatad.js?%@\" type=\"text/javascript\"></script>", moatQuery];
    [webView stringByEvaluatingJavaScriptFromString:moatString];
    
    NSLog(@"[AA :: Info] Sending Display Event to Moat with Script %@", moatString);
}

+ (void) sendVideoMoatEvent:(AVPlayer*)player andLayer:(AVPlayerLayer*)layer andView:(UIView*)adView andAdDictionary:(NSDictionary*)adDict {
    
    // make only 1 in 5 moat events OK
    NSInteger rand = [SAUtils randomNumberBetween:0 maxNumber:100];
    if (rand > 20) {
        NSLog(@"[AA:: Info] Moat Video Event not triggered this time");
        return;
    }
    
    // go ahead
    SUPMoatVideoTracker *tracker = [SUPMoatVideoTracker trackerWithPartnerCode:MOAT_VIDEO_PARTNER_CODE];
    [tracker trackVideoAd:[self mapSADictoToMoatDict:adDict]
       usingAVMoviePlayer:player
                withLayer:layer
       withContainingView:adView];
    
    NSLog(@"[AA :: Info] Sending Video Event to Moat");
}

@end
