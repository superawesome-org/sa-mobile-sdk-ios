/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import "SAEvents+Moat.h"

#if defined(__has_include)
#if __has_include("SUPMoatMobileAppKit.h")
    #import "SUPMoatMobileAppKit.h"
    #define HAS_MOAT true
#else 
    #define HAS_MOAT false
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAUtils/SAUtils.h>)
#import <SAUtils/SAUtils.h>
#else
#import "SAUtils.h"
#endif
#endif

#define MOAT_SERVER                 @"https://z.moatads.com"
#define MOAT_URL                    @"moatad.js"
#define MOAT_DISPLAY_PARTNER_CODE   @"superawesomeinappdisplay731223424656"
#define MOAT_VIDEO_PARTNER_CODE     @"superawesomeinappvideo467548716573"

@implementation SAEvents (Moat)

/**
 * Method that takes a view and some details and starts 
 * the Moat tracking process
 *
 * @param webView the WebView to register the moat event for
 * @param adDict  ad details (placement id, campaign id, etc)
 * @return        a string containing the proper Moat javascript code to 
 *                execute in the web view, or an empty string 
 *                if there was an error
 */
- (NSString*) sendDisplayMoatEvent:(UIWebView*)webView
                   andAdDictionary:(NSDictionary*)adDict {
    
#if HAS_MOAT
    // go ahead
    [SUPMoatBootstrap injectDelegateWrapper:webView];
    
    NSMutableString *moatQuery = [[NSMutableString alloc] init];
    [moatQuery appendFormat:@"moatClientLevel1=%@", [adDict objectForKey:@"advertiser"]];
    [moatQuery appendFormat:@"&moatClientLevel2=%@", [adDict objectForKey:@"campaign"]];
    [moatQuery appendFormat:@"&moatClientLevel3=%@", [adDict objectForKey:@"line_item"]];
    [moatQuery appendFormat:@"&moatClientLevel4=%@", [adDict objectForKey:@"creative"]];
    [moatQuery appendFormat:@"&moatClientSlicer1=%@", [adDict objectForKey:@"app"]];
    [moatQuery appendFormat:@"&moatClientSlicer2=%@", [adDict objectForKey:@"placement"]];
    [moatQuery appendFormat:@"&moatClientSlicer3=%@", [adDict objectForKey:@"publisher"]];
    
    return [NSString stringWithFormat:
             @"<script src=\"%@/%@/%@?%@\" type=\"text/javascript\"></script>",
             MOAT_SERVER,
             MOAT_DISPLAY_PARTNER_CODE,
             MOAT_URL,
             moatQuery];
#else
    return @"";
#endif
}

/**
 * Method that registers a new native video tracker and 
 * starts tracking the video ad
 *
 * @param player the AVPlayer instance
 * @param layer  the AVPlayerLayer intance
 * @param view   the parent UIView
 * @param adDict ad data to send
 * @return       true or false, depending if the tracker is OK
 */
- (BOOL) registerVideoMoatEvent:(AVPlayer*)player
                       andLayer:(AVPlayerLayer*)layer
                        andView:(UIView*)view
                andAdDictionary:(NSDictionary*)adDict {
    
#if HAS_MOAT
    // go ahead
    NSDictionary *moatDictionary = @{
                                     @"level1": [adDict objectForKey:@"advertiser"],
                                     @"level2": [adDict objectForKey:@"campaign"],
                                     @"level3": [adDict objectForKey:@"line_item"],
                                     @"level4": [adDict objectForKey:@"creative"],
                                     @"slicer1": [adDict objectForKey:@"app"],
                                     @"slicer2": [adDict objectForKey:@"placement"],
                                     @"slicer3": [adDict objectForKey:@"publisher"]
                                     };
    
    // go ahead
    SUPMoatVideoTracker *tracker = [SUPMoatVideoTracker trackerWithPartnerCode:MOAT_VIDEO_PARTNER_CODE];
    return [tracker trackVideoAd:moatDictionary
              usingAVMoviePlayer:player
                       withLayer:layer
              withContainingView:view];
#else
    return false;
#endif
}

- (BOOL) unregisterVideoMoatEvent {
    
#if HAS_MOAT
    return true;
#else 
    return false;
#endif

}

@end
