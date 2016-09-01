//
//  SAEvents.m
//  Pods
//
//  Created by Gabriel Coman on 26/02/2016.
//
//

#import "SAEvents.h"
#import "SAUtils.h"
#import "SANetwork.h"
#import "SAExtensions.h"
#import "SAAd.h"
#import "SADetails.h"
#import "SACreative.h"
#import "SAMedia.h"
#import "SATracking.h"

#define MAX_TICKS 2

@interface SAEvents ()
@property (nonatomic, strong) SAAd *ad;
@property (nonatomic, strong) NSTimer *viewabilityTimer;
@end

@implementation SAEvents

- (id) init {
    if (self = [super init]) {
        
    }
    
    return self;
}

- (void) setAd:(SAAd *)ad {
    _ad = ad;
}

- (void) sendEventToURL:(NSString *)url {
    SANetwork *network = [[SANetwork alloc] init];
    [network sendGET:url
           withQuery:@{}
           andHeader:@{@"Content-Type":@"application/json",
                       @"User-Agent":[SAUtils getUserAgent]}
        withResponse:^(NSInteger status, NSString *payload, BOOL success) {
            if (success) {
                NSLog(@"Event sent OK!");
            } else {
                NSLog(@"Event sent NOK!");
            }
        }];
}

- (void) sendAllEventsForKey:(NSString*)key {
    // safety check
    if (_ad == NULL) return;
    
    
    NSArray *tracks = [_ad.creative.events filterBy:@"event" withValue:key];
    NSMutableArray *urls = [@[] mutableCopy];
    for (id track in tracks) {
        NSString *url = [track valueForKey:@"URL"];
        if (url) {
            [urls addObject:url];
        }
    }
    
    for (NSString *url in urls) {
        [self sendEventToURL:url];
    }
}

- (void) sendCustomEvent:(NSString*) baseUrl
           withPlacement:(NSInteger) placementId
            withLineItem:(NSInteger) lineItem
             andCreative:(NSInteger) creative
                andEvent:(NSString*) event
{
    
    NSDictionary *data = @{
        @"placement": @(placementId),
        @"creative": @(creative),
        @"line_item": @(lineItem),
        @"event": event
    };
    NSDictionary *cjson = @{
        @"rnd": @([SAUtils getCachebuster]),
        @"ct": @([SAUtils getNetworkConnectivity]),
        @"data": [SAUtils encodeJSONDictionaryFromNSDictionary:data]
    };
    
    NSString *url = [NSString stringWithFormat:@"%@/event?%@", baseUrl, [SAUtils formGetQueryFromDict:cjson]];
    [self sendEventToURL:url];
}

- (void) sendViewableForFullscreen {
    // safety check
    if (_ad == NULL) return;
    
    // start timer
    __block NSInteger ticks = 0;
    _viewabilityTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                         target:[NSBlockOperation blockOperationWithBlock:^{
        
        if (ticks >= MAX_TICKS) {
            [_viewabilityTimer invalidate];
            _viewabilityTimer = nil;
            [self sendAllEventsForKey:@"viewable_impr"];
        } else {
            ticks++;
            NSLog(@"[AA :: Info] Tick %ld/%d", (long)ticks, MAX_TICKS);
        }
        
    }] selector:@selector(main) userInfo:nil repeats:YES];
    
    // fire timer
    [_viewabilityTimer fire];
    
}

- (void) sendViewableForInScreen:(UIView *)view {
    
    // safety check
    if (_ad == NULL) return;
    
    // start timer
    __block NSInteger ticks = 0;
    __block NSInteger cticks = 0;
    _viewabilityTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                         target:[NSBlockOperation blockOperationWithBlock:^{
        
        if (ticks >= MAX_TICKS) {
            [_viewabilityTimer invalidate];
            _viewabilityTimer = nil;
            
            if (cticks == MAX_TICKS) {
                [self sendAllEventsForKey:@"viewable_impr"];
            } else {
                NSLog(@"[AA :: Error] Did not send viewable impression");
            }
        } else {
            ticks++;
            
            CGRect childR = view.frame;
            CGRect superR = CGRectMake(0, 0, view.superview.frame.size.width, view.superview.frame.size.height);
            CGRect screenR = [UIScreen mainScreen].bounds;
            
            if ([SAUtils isRect:childR inRect:screenR] && [SAUtils isRect:childR inRect:superR]) {
                cticks++;
            }
            
            NSLog(@"[AA :: Info] Tick %ld/%d - Viewability Count %ld/%d", (long)ticks, MAX_TICKS, (long)cticks, MAX_TICKS);
        }
        
    }] selector:@selector(main) userInfo:nil repeats:YES];
    
    // fire the timer
    [_viewabilityTimer fire];
    
}

@end
