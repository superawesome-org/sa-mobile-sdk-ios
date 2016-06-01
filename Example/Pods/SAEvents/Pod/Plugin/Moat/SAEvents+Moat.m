//
//  SAEvents+Moat.m
//  Pods
//
//  Created by Gabriel Coman on 01/06/2016.
//
//

#import "SAEvents+Moat.h"
#import <SUPMoatMobileAppKit/SUPMoatMobileAppKit.h>

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

+ (void) sendDisplayMoatEvent:(UIView*)adView andAdDictionary:(NSDictionary*)adDict {
    
    SUPMoatTracker *tracker = [SUPMoatTracker trackerWithAdView:adView partnerCode:MOAT_DISPLAY_PARTNER_CODE];
    [tracker trackAd:[self mapSADictoToMoatDict:adDict]];
    
    NSLog(@"[AA :: Info] Sending Display Event to Moat");
}

+ (void) sendVideoMoatEvent:(AVPlayer*)player andLayer:(AVPlayerLayer*)layer andView:(UIView*)adView andAdDictionary:(NSDictionary*)adDict {
    
    SUPMoatVideoTracker *tracker = [SUPMoatVideoTracker trackerWithPartnerCode:MOAT_VIDEO_PARTNER_CODE];
    [tracker trackVideoAd:[self mapSADictoToMoatDict:adDict]
       usingAVMoviePlayer:player
                withLayer:layer
       withContainingView:adView];
    
    NSLog(@"[AA :: Info] Sending Video Event to Moat");
}

@end
