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

#define MOAT_SERVER @"https://z.moatads.com"
#define MOAT_URL @"moatad.js"
#define MOAT_DISPLAY_PARTNER_CODE @"superawesomeinappdisplay731223424656"
#define MOAT_VIDEO_PARTNER_CODE @"superawesomeinappvideo467548716573"

@implementation SAEvents (Moat)

+ (NSString*) sendDisplayMoatEvent:(UIWebView*)webView andAdDictionary:(NSDictionary*)adDict{
    
    // make only 1 in 5 moat events OK
    NSInteger rand = [SAUtils randomNumberBetween:0 maxNumber:100];
    if (rand > 20) {
        NSLog(@"[AA:: Info] Moat Display Event not triggered this time");
        return @"";
    }
    
    // go ahead
    BOOL allOK = [SUPMoatBootstrap injectDelegateWrapper:webView];
    
    NSMutableString *moatQuery = [[NSMutableString alloc] init];
    [moatQuery appendFormat:@"moatClientLevel1=%@", [adDict objectForKey:@"advertiser"]];
    [moatQuery appendFormat:@"&moatClientLevel2=%@", [adDict objectForKey:@"campaign"]];
    [moatQuery appendFormat:@"&moatClientLevel3=%@", [adDict objectForKey:@"line_item"]];
    [moatQuery appendFormat:@"&moatClientLevel4=%@", [adDict objectForKey:@"creative"]];
    [moatQuery appendFormat:@"&moatClientSlicer1=%@", [adDict objectForKey:@"app"]];
    [moatQuery appendFormat:@"&moatClientSlicer2=%@", [adDict objectForKey:@"placement"]];
    
    return [NSString stringWithFormat:@"<script src=\"%@/%@/%@?%@\" type=\"text/javascript\"></script>", MOAT_SERVER, MOAT_DISPLAY_PARTNER_CODE, MOAT_URL, moatQuery];
}

+ (void) sendVideoMoatEvent:(AVPlayer*)player andLayer:(AVPlayerLayer*)layer andView:(UIView*)adView andAdDictionary:(NSDictionary*)adDict {
    
    // make only 1 in 5 moat events OK
    NSInteger rand = [SAUtils randomNumberBetween:0 maxNumber:100];
    if (rand > 20) {
        NSLog(@"[AA:: Info] Moat Video Event not triggered this time");
        return;
    }
    
    NSDictionary *moatDictionary = @{
                                     @"level1": [adDict objectForKey:@"advertiser"],
                                     @"level2": [adDict objectForKey:@"campaign"],
                                     @"level3": [adDict objectForKey:@"line_item"],
                                     @"level4": [adDict objectForKey:@"creative"],
                                     @"slicer1": [adDict objectForKey:@"app"],
                                     @"slicer2": [adDict objectForKey:@"placement"]
                                     };
    
    // go ahead
    SUPMoatVideoTracker *tracker = [SUPMoatVideoTracker trackerWithPartnerCode:MOAT_VIDEO_PARTNER_CODE];
    [tracker trackVideoAd:moatDictionary
       usingAVMoviePlayer:player
                withLayer:layer
       withContainingView:adView];
    
    NSLog(@"[AA :: Info] Sending Video Event to Moat");
}

@end
