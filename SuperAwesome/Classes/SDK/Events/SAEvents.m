//
//  SAEvents.m
//  Pods
//
//  Created by Gabriel Coman on 26/02/2016.
//
//

#import "SAEvents.h"
#import "SANetwork.h"
#import <SUPMoatMobileAppKit/SUPMoatMobileAppKit.h>
#import "SuperAwesome.h"

@implementation SAEvents

+ (void) sendEventToURL:(NSString *)url {
    [SANetwork sendGETtoEndpoint:url withQueryDict:NULL andSuccess:NULL orFailure:NULL];
}

+ (void) sendDisplayMoatEvent:(UIView*)adView andAd:(SAAd*)ad {
    // if moat isn't enabled, don't do it!
    if (![[SuperAwesome getInstance] isMoatEnabled]) {
        return;
    }
    
    // form needed variables
    NSString *code = [[SuperAwesome getInstance] getDisplayMoatPartnerCode];
    NSDictionary *data = @{
        @"level1": @"SuperAwesome",
        @"level2": [NSString stringWithFormat:@"%ld", ad.campaignId],
        @"level3": [NSString stringWithFormat:@"%ld", ad.lineItemId],
        @"level4": [NSString stringWithFormat:@"%ld", ad.creative.creativeId],
        @"slicer1": [NSString stringWithFormat:@"%ld", ad.appId],
        @"slicer2": [NSString stringWithFormat:@"%ld", ad.placementId]
    };
    
    // get a tracker and track
    SUPMoatTracker *tracker = [SUPMoatTracker trackerWithAdView:adView partnerCode:code];
    [tracker trackAd:data];
    
    NSLog(@"[AA :: Info] Sending Display Event to Moat");
}

+ (void) sendVideoMoatEvent:(AVPlayer*)player andLayer:(AVPlayerLayer*)layer andView:(UIView*)adView andAd:(SAAd*)ad {
    // if moat isn't enabled, don't do it!
    if (![[SuperAwesome getInstance] isMoatEnabled]) {
        return;
    }
    
    // form data
    NSString *code = [[SuperAwesome getInstance] getVideoMoatPartnerCode];
    NSDictionary *data = @{
        @"level1": @"SuperAwesome",
        @"level2": [NSString stringWithFormat:@"%ld", ad.campaignId],
        @"level3": [NSString stringWithFormat:@"%ld", ad.lineItemId],
        @"level4": [NSString stringWithFormat:@"%ld", ad.creative.creativeId],
        @"slicer1": [NSString stringWithFormat:@"%ld", ad.appId],
        @"slicer2": [NSString stringWithFormat:@"%ld", ad.placementId]
    };
    
    // get a tracker and track
    SUPMoatVideoTracker *tracker = [SUPMoatVideoTracker trackerWithPartnerCode:code];
    [tracker trackVideoAd:data usingAVMoviePlayer:player withLayer:layer withContainingView:adView];
    
    NSLog(@"[AA :: Info] Sending Video Event to Moat");
}

@end
