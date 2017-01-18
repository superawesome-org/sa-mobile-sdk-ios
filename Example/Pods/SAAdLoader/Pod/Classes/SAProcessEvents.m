/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import "SAProcessEvents.h"

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
#if __has_include(<SAModelSpace/SATracking.h>)
#import <SAModelSpace/SATracking.h>
#else
#import "SATracking.h"
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
#if __has_include(<SASession/SASession.h>)
#import <SASession/SASession.h>
#else
#import "SASession.h"
#endif
#endif

#if defined(__has_include)
#if __has_include(<SAJsonParser/SAJsonParser.h>)
#import <SAJsonParser/SAJsonParser.h>
#else
#import "SAJsonParser.h"
#endif
#endif

// parser implementation
@implementation SAProcessEvents

+ (void) addAdEvents:(SAAd*) ad
          forSession:(SASession*) session {
    
    // create a new tracking event (click event), to be used if the ad's
    // click will not contain a SuperAwesome url at all
    SATracking *clickEvt = [[SATracking alloc] init];
    clickEvt.event = @"sa_tracking";
    clickEvt.URL = [NSString stringWithFormat:@"%@/%@click?%@",
                    [session getBaseUrl],
                    (ad.creative.format == SA_Video ? @"video/" : @""),
                    [SAUtils formGetQueryFromDict:@{
                                                    @"placement":@(ad.placementId),
                                                    @"line_item":@(ad.lineItemId),
                                                    @"creative":@(ad.creative._id),
                                                    @"sdkVersion":[session getVersion],
                                                    @"sourceBundle":[session getBundleId],
                                                    @"rnd":@([session getCachebuster]),
                                                    @"ct":@([session getConnectivityType])
                                                    }
                    ]];
    
    // create an impression event; this should be used by video ads
    // (for the moment), and sometime in the future by display ads
    SATracking *saImpressionEvt = [[SATracking alloc] init];
    saImpressionEvt.event = @"sa_impr";
    saImpressionEvt.URL = [NSString stringWithFormat:@"%@/impression?%@",
                           [session getBaseUrl],
                           [SAUtils formGetQueryFromDict:@{
                                                           @"placement": @(ad.placementId),
                                                           @"creative": @(ad.creative._id),
                                                           @"line_item": @(ad.lineItemId),
                                                           @"sdkVersion": [session getVersion],
                                                           @"sourceBundle":[session getBundleId],
                                                           @"rnd": @([session getCachebuster]),
                                                           @"no_image": @(true)
                                                           }
                            ]];
    
    // create a viewable impression event; this is triggered when the ad
    // first shown on screen
    SATracking *viewableImpression = [[SATracking alloc] init];
    viewableImpression.event = @"viewable_impr";
    viewableImpression.URL = [NSString stringWithFormat:@"%@/event?%@",
                                [session getBaseUrl],
                              [SAUtils formGetQueryFromDict:@{
                                                              @"sdkVersion":[session getVersion],
                                                              @"rnd":@([session getCachebuster]),
                                                              @"ct":@([session getConnectivityType]),
                                                              @"sourceBundle":[session getBundleId],
                                                              @"data":[SAUtils encodeURI:[@{
                                                                                            @"placement":@(ad.placementId),
                                                                                            @"line_item":@(ad.lineItemId),
                                                                                            @"creative":@(ad.creative._id),
                                                                                            @"type":@"viewable_impression"
                                                                                            } jsonCompactStringRepresentation]]
                                                              }]];
    
    // create a parental gate fail event
    SATracking *parentalGateFail = [[SATracking alloc] init];
    parentalGateFail.event = @"pg_fail";
    parentalGateFail.URL = [NSString stringWithFormat:@"%@/event?%@",
                                        [session getBaseUrl],
                            [SAUtils formGetQueryFromDict:@{
                                                            @"sdkVersion":[session getVersion],
                                                            @"rnd":@([session getCachebuster]),
                                                            @"ct":@([session getConnectivityType]),
                                                            @"sourceBundle":[session getBundleId],
                                                            @"data":[SAUtils encodeURI:[@{
                                                                                          @"placement":@(ad.placementId),
                                                                                          @"line_item":@(ad.lineItemId),
                                                                                          @"creative":@(ad.creative._id),
                                                                                          @"type": @"parentalGateFail"
                                                                                          } jsonCompactStringRepresentation]]
                                                            }]];
    
    // create a parental gate close event;
    SATracking *parentalGateClose = [[SATracking alloc] init];
    parentalGateClose.event = @"pg_close";
    parentalGateClose.URL = [NSString stringWithFormat:@"%@/event?%@",
                                       [session getBaseUrl],
                             [SAUtils formGetQueryFromDict:@{
                                                             @"sdkVersion":[session getVersion],
                                                             @"rnd":@([session getCachebuster]),
                                                             @"ct":@([session getConnectivityType]),
                                                             @"sourceBundle":[session getBundleId],
                                                             @"data":[SAUtils encodeURI:[@{
                                                                                           @"placement":@(ad.placementId),
                                                                                           @"line_item":@(ad.lineItemId),
                                                                                           @"creative":@(ad.creative._id),
                                                                                           @"type": @"parentalGateClose"
                                                                                           } jsonCompactStringRepresentation]]
                                                             }]];
    
    // create a parental gate open event
    SATracking *parentalGateOpen = [[SATracking alloc] init];
    parentalGateOpen.event = @"pg_open";
    parentalGateOpen.URL = [NSString stringWithFormat:@"%@/event?%@",
                                       [session getBaseUrl],
                            [SAUtils formGetQueryFromDict:@{
                                                            @"sdkVersion":[session getVersion],
                                                            @"rnd":@([session getCachebuster]),
                                                            @"ct":@([session getConnectivityType]),
                                                            @"sourceBundle":[session getBundleId],
                                                            @"data":[SAUtils encodeURI:[@{
                                                                                          @"placement":@(ad.placementId),
                                                                                          @"line_item":@(ad.lineItemId),
                                                                                          @"creative":@(ad.creative._id),
                                                                                          @"type": @"parentalGateOpen"
                                                                                          } jsonCompactStringRepresentation]]
                                                            }]];
    
    // create a parentla gate success event
    SATracking *parentalGateSuccess = [[SATracking alloc] init];
    parentalGateSuccess.event = @"pg_success";
    parentalGateSuccess.URL = [NSString stringWithFormat:@"%@/event?%@",
                                       [session getBaseUrl],
                               [SAUtils formGetQueryFromDict:@{
                                                               @"sdkVersion":[session getVersion],
                                                               @"rnd":@([session getCachebuster]),
                                                               @"ct":@([session getConnectivityType]),
                                                               @"sourceBundle":[session getBundleId],
                                                               @"data":[SAUtils encodeURI:[@{
                                                                                             @"placement":@(ad.placementId),
                                                                                             @"line_item":@(ad.lineItemId),
                                                                                             @"creative":@(ad.creative._id),
                                                                                             @"type": @"parentalGateSuccess"
                                                                                             } jsonCompactStringRepresentation]]
                                                               }]];
    
    // create the external impression
    SATracking *impression = [[SATracking alloc] init];
    impression.URL = ad.creative.impressionUrl;
    impression.event = @"impression";
    
    SATracking *install = [[SATracking alloc] init];
    install.URL = ad.creative.installUrl;
    install.event = @"install";
    
    // add events to the ads events array
    [ad.creative.events addObject:clickEvt];
    [ad.creative.events addObject:viewableImpression];
    [ad.creative.events addObject:parentalGateSuccess];
    [ad.creative.events addObject:parentalGateOpen];
    [ad.creative.events addObject:parentalGateClose];
    [ad.creative.events addObject:parentalGateFail];
    [ad.creative.events addObject:saImpressionEvt];
    [ad.creative.events addObject:impression];
    [ad.creative.events addObject:install];
}

@end
